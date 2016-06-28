module Jb
  class Handler
    def call(template)
      "#{template.source}.to_json"
    end
  end
end
