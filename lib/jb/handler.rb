module Jb
  class Handler
    class_attribute :default_format
    self.default_format = :json

    def self.call(template)
      template.source
    end
  end
end
