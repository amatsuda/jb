# frozen_string_literal: true

require 'multi_json'

module Jb
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

  # An alternative OutputFlow that holds each content in Hash/Array as-is
  class RawOutputFlow
    attr_reader :content

    def initialize
      @content = Hash.new
    end

    def get(key)
      @content[key]
    end

    def set(key, value)
      @content[key] = value.extend(Jb::PartialRenderer::StrongArray)
    end

    def append(key, value)
      if @content[key].nil?
        set(key, value)
      elsif @content[key].respond_to?(:merge)
        @content[key].merge(value)
      else
        @content[key].concat(value)
      end
    end
    alias_method :append!, :append
  end

  # A monkey-patch that converts non-partial result to a JSON String
  module TemplateRenderer
    module JSONizer
      def render_template(template, *)
        if template.respond_to?(:handler) && template.handler == Jb::Handler
          @view.view_flow = RawOutputFlow.new unless @view.view_flow.is_a?(RawOutputFlow)
          MultiJson.dump(super)
        else
          super
        end
      end
    end
  end
end

::ActionView::PartialRenderer.prepend ::Jb::PartialRenderer::JbTemplateDetector
::ActionView::TemplateRenderer.prepend ::Jb::TemplateRenderer::JSONizer
