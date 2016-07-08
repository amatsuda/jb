Comment = Struct.new :id, :post, :body do
  post = Post.find 1
  @all = [new(1, post, 'comment 1'), new(2, post, 'comment 2'), new(3, post, 'comment 3')]

  class << self
    attr_reader :all

    def find(id)
      @all.detect {|c| c.id == id.to_i}
    end
  end
end
