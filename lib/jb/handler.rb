module Jb
  module PartialRenderer
    module JbTemplateDetector
      # A monkey-patch to inject StrongArray module to Jb partial renderer
      private def find_partial
        template = super
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
    end
  end

  module TemplateRenderer
    # A monkey-patch that converts non-partial result to a JSON String
    module JSONizer
      def render_template(template, *)
        template.handler == Jb::Handler ? super.to_json : super
      end
    end
  end

  class Handler
    class_attribute :default_format
    self.default_format = :json

    def self.call(template)
      template.source
    end
  end
end

::ActionView::PartialRenderer.prepend ::Jb::PartialRenderer::JbTemplateDetector
::ActionView::TemplateRenderer.prepend ::Jb::TemplateRenderer::JSONizer
