module Jb
  module PartialRenderer
    # A monkey-patch for `render` method to always return a valid JSON String.
    # render partial + non collection  =>  expect super to return a valid JSON
    # render partial + collection      =>  transform the collection to an Array-ish notation with a spacer comma and []
    def render(_context, options)
      if options.has_key? :collection
        options[:spacer_template] = 'jb/comma'
        "[#{super}]"
      else
        super
      end
    end

#     private def render_partial(*)
#       super.to_json
#     end
  end

  # A monkey-patch for `render` method to convert rendered partial JSON String back to a Ruby Object.
  module TemplateRenderer
    def render(*)
      JSON.parse(super)
    end
  end

  class Handler
    class_attribute :default_format
    self.default_format = :json

    def call(template)
      "extend Jb::TemplateRenderer; view_renderer.extend Jb::PartialRenderer; String === (_jb_object = (#{template.source})) ? _jb_object : _jb_object.to_json"
    end
  end
end
