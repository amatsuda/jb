# frozen_string_literal: true
# Mokey-patches for Action View 6+

module Jb
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

  # A monkey-patch for jb template collection result's `body` not to return a String but an Array
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
::ActionView::PartialRenderer.prepend ::Jb::PartialRendererExtension
