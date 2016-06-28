module Jb
  # A monkey-patch for `render` method to convert rendered partial JSON String back to a Ruby Object.
  module TemplateRenderer
    def render(*)
      JSON.parse(super)
    end
  end

  class Handler
    def call(template)
      "extend Jb::TemplateRenderer; #{template.source}.to_json"
    end
  end
end
