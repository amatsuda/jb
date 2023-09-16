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

  # Rails 7.1+: A monkey-patch not to stringify rendered object from JB templates
  module BaseToSCanceller
    def _run(method, template, *, **)
      val = super
      if template.respond_to?(:handler) && (template.handler == Jb::Handler)
        def val.to_s
          self
        end
      end
      val
    end
  end

  # Rails 6.1+: A monkey-patch for jb template collection result's `body` not to return a String but an Array
  module CollectionRendererExtension
    private def render_collection(_collection, _view, _path, template, _layout, _block)
      obj = super
      if template.respond_to?(:handler) && (template.handler == Jb::Handler)
        if ActionView::AbstractRenderer::RenderedCollection::EmptyCollection === obj
          def obj.body; []; end
        else
          def obj.body; @rendered_templates.map(&:body); end
        end
      end
      obj
    end
  end

  # Rails 6.0: A monkey-patch for jb template collection result's `body` not to return a String but an Array
  module PartialRendererExtension
    private def render_collection(_view, template)
      obj = super
      if template.respond_to?(:handler) && (template.handler == Jb::Handler)
        if ActionView::AbstractRenderer::RenderedCollection::EmptyCollection === obj
          def obj.body; []; end
        else
          def obj.body; @rendered_templates.map(&:body); end
        end
      end
      obj
    end
  end
end

::ActionView::TemplateRenderer.prepend ::Jb::TemplateRenderer::JSONizer
::ActionView::Base.prepend ::Jb::BaseToSCanceller if (ActionView::VERSION::MAJOR >= 7) && (ActionView::VERSION::MINOR >= 1)
begin
  # ActionView::CollectionRenderer is a newly added class since 6.1
  ::ActionView::CollectionRenderer.prepend ::Jb::CollectionRendererExtension
rescue NameError
  ::ActionView::PartialRenderer.prepend ::Jb::PartialRendererExtension
end
