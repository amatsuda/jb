# frozen_string_literal: true
# Monkey-patches for Action View 6+

module Jb
  # A monkey-patch that converts non-partial result to a JSON String
  module TemplateRenderer
    module JSONizer
      def render_template(_view, template, *)
        rendered_template = super
        rendered_template.instance_variable_set :@body, rendered_template.body.to_json if template.respond_to?(:handler) && (template.handler == Jb::Handler)
        rendered_template
      end
    end
  end

  # A wrapper class for template result that makes `to_s` method do nothing. So far only used for the Rails 7.1 monkey-patch below.
  class TemplateResult < SimpleDelegator
    def to_s
      __getobj__
    end
  end

  # Rails 7.1 (to be precise, needed only for 7.1.0..7.1.3): A monkey-patch not to stringify rendered object from JB templates
  module TemplateResultCaster
    def _run(method, template, *, **)
      val = super
      val = Jb::TemplateResult.new val if template.respond_to?(:handler) && (template.handler == Jb::Handler)
      val
    end
  end

  # Rendered collection result for jb templates, whose `body` returns not a String but an Array
  class RenderedCollection < ActionView::AbstractRenderer::RenderedCollection
    def body
      @rendered_templates.map(&:body)
    end

    class EmptyCollection < ActionView::AbstractRenderer::RenderedCollection::EmptyCollection
      def body
        []
      end
    end

    # Replaces the given rendered collection with the jb version of it if it's rendered via jb template(s)
    def self.from(obj, template)
      if ActionView::AbstractRenderer::RenderedCollection::EmptyCollection === obj
        template.respond_to?(:handler) && (template.handler == Jb::Handler) ? EmptyCollection.new(obj.format) : obj
      # `template` is nil for a collection of different kinds of objects, so check each rendered template's handler
      elsif obj.rendered_templates.any? {|rt| rt.template.respond_to?(:handler) && (rt.template.handler == Jb::Handler) }
        new obj.rendered_templates, nil
      else
        obj
      end
    end
  end

  # Rails 6.1+: A monkey-patch for jb template collection result's `body` not to return a String but an Array
  module CollectionRendererExtension
    private def render_collection(_collection, _view, _path, template, _layout, _block)
      Jb::RenderedCollection.from super, template
    end
  end

  # Rails 6.0: A monkey-patch for jb template collection result's `body` not to return a String but an Array
  module PartialRendererExtension
    private def render_collection(_view, template)
      Jb::RenderedCollection.from super, template
    end
  end
end

::ActionView::TemplateRenderer.prepend ::Jb::TemplateRenderer::JSONizer
::ActionView::Base.prepend ::Jb::TemplateResultCaster if (ActionView::VERSION::MAJOR == 7) && (ActionView::VERSION::MINOR == 1) && (ActionView::VERSION::TINY < 4)
begin
  # ActionView::CollectionRenderer is a newly added class since 6.1
  ::ActionView::CollectionRenderer.prepend ::Jb::CollectionRendererExtension
rescue NameError
  ::ActionView::PartialRenderer.prepend ::Jb::PartialRendererExtension
end
