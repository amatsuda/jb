# frozen_string_literal: true
# Monkey-patches for Action View 4 and 5

module Jb
  module PartialRenderer
    module JbTemplateDetector
      # A monkey-patch to inject StrongArray module to Jb partial renderer
      private def find_partial(*)
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

      private def render_collection
        return [] if @collection.blank?
        super
      end
    end

    # A monkey-patch strengthening rendered collection of different kinds of objects, where the partial is found per object
    module MixedCollectionExtension
      private def find_template(*)
        template = super
        @jb_template_found = true if template.handler == Jb::Handler
        template
      end

      private def collection_without_template
        @jb_template_found = false
        result = super
        @jb_template_found ? result.extend(StrongArray) : result
      end
    end
  end

  # A monkey-patch that converts non-partial result to a JSON String, unless it's rendered from another jb template
  module TemplateRenderer
    module JSONizer
      def render_template(template, *)
        from_jb = @view.instance_variable_get :@_jb_rendering_jb
        # render_with_layout doesn't take the template in Action View 4 and 5
        @_jb_template = jb_template?(template)
        result = super
        @_jb_template && !from_jb && !@_jb_yielded_to_layout ? result.to_json : result
      end

      # Marks the view while rendering a jb template's body, and makes a non-jb layout yield a JSON String
      private def render_with_layout(*)
        view, jb = @view, @_jb_template
        super do |layout|
          from_jb = view.instance_variable_get :@_jb_rendering_jb
          view.instance_variable_set :@_jb_rendering_jb, jb
          begin
            content = yield layout
          ensure
            view.instance_variable_set :@_jb_rendering_jb, from_jb
          end

          if jb && layout && !jb_template?(layout)
            @_jb_yielded_to_layout = true
            content.to_json
          else
            content
          end
        end
      end

      private def jb_template?(template)
        template.respond_to?(:handler) && (template.handler == Jb::Handler)
      end
    end
  end
end

::ActionView::PartialRenderer.prepend ::Jb::PartialRenderer::JbTemplateDetector
::ActionView::PartialRenderer.prepend ::Jb::PartialRenderer::MixedCollectionExtension
::ActionView::TemplateRenderer.prepend ::Jb::TemplateRenderer::JSONizer
