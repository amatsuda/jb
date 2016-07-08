Post = Struct.new :id, :user, :title, :comments do
  user = User.find 1
  @all = [new(1, user, 'post 1')]

  class << self
    attr_reader :all

    def find(id)
      @all.detect {|p| p.id == id.to_i}
    end
  end

  def comments
    Comment.all.select {|c| c.post == self}
  end
end
