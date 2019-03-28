# frozen_string_literal: true

require 'multi_json'

module Jb
  module AbstractRenderer
    module RenderedCollectionExtension
      def body
        @rendered_templates.map(&:body)
      end
    end
  end

  module PartialRenderer
    module JbTemplateDetector
      # A monkey-patch to inject StrongArray module to Jb partial renderer
      private def find_partial(*args)
        template = super(*args)
        extend RenderCollectionExtension if template && (template.handler == Jb::Handler)
        template
      end
    end

    # A horrible monkey-patch to prevent rendered collection from being converted to String
    module StrongArray
      def join(*)
        self
      end

      def html_safe
        self
      end
    end

    # A monkey-patch strengthening rendered collection
    module RenderCollectionExtension
      private def collection_with_template
        super.extend StrongArray
      end

      private def collection_without_template
        super.extend StrongArray
      end

      private def render_collection
        return [] if @collection.blank?
        super
      end
    end
  end

  # A monkey-patch that converts non-partial result to a JSON String
  module TemplateRenderer
    module JSONizer
      if ::ActionView::TemplateRenderer.instance_method(:render_template).arity == 4  # Action View 6
        def render_template(_view, template, *)
          super.tap do |rendered_template|
            rendered_template.instance_variable_set :@body, MultiJson.dump(rendered_template.body) if template.respond_to?(:handler) && (template.handler == Jb::Handler)
          end
        end
      else
        def render_template(template, *)
          template.respond_to?(:handler) && (template.handler == Jb::Handler) ? MultiJson.dump(super) : super
        end
      end
    end
  end
end

if defined?(::ActionView::AbstractRenderer::RenderedCollection)  # Action View 6
  ::ActionView::AbstractRenderer::RenderedCollection.prepend ::Jb::PartialRenderer::JbTemplateDetector
else
  ::ActionView::PartialRenderer.prepend ::Jb::PartialRenderer::JbTemplateDetector
end
::ActionView::TemplateRenderer.prepend ::Jb::TemplateRenderer::JSONizer
