# frozen_string_literal: true

module Jb
  class Handler
    class_attribute :default_format
    self.default_format = :json

    def self.call(template, source=nil)
      source || template.source
    end

    def self.handles_encoding?
      true
    end
  end
end
