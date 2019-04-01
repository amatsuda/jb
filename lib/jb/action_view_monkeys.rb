# frozen_string_literal: true
# Mokey-patches for Action View 6+

module Jb
  module AbstractRenderer
    module RenderedCollectionExtension
      def body
        @rendered_templates.map(&:body)
      end
    end
  end

  # A monkey-patch that converts non-partial result to a JSON String
  module TemplateRenderer
    module JSONizer
      def render_template(_view, template, *)
        rendered_template = super
        rendered_template.instance_variable_set :@body, MultiJson.dump(rendered_template.body) if template.respond_to?(:handler) && (template.handler == Jb::Handler)
        rendered_template
      end
    end
  end

  module PartialRendererExtension
    private def render_collection(_view, template)
      obj = super
      def obj.body; []; end if obj.is_a?(ActionView::AbstractRenderer::RenderedCollection::EmptyCollection) && template.respond_to?(:handler) && (template.handler == Jb::Handler)
      obj
    end
  end
end

::ActionView::AbstractRenderer::RenderedCollection.prepend ::Jb::AbstractRenderer::RenderedCollectionExtension
::ActionView::TemplateRenderer.prepend ::Jb::TemplateRenderer::JSONizer
::ActionView::PartialRenderer.prepend ::Jb::PartialRendererExtension
