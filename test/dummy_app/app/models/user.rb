# frozen_string_literal: true
User = Struct.new :id, :name do
  @all = [new(1, 'user 1')]

  class << self
    attr_reader :all

    def find(id)
      @all.detect {|u| u.id == id.to_i}
    end
  end
end
