module Jb
  class Engine < ::Rails::Engine
    initializer 'jb' do
      ActiveSupport.on_load :action_view do
        require 'jb/handler'
        ::ActionView::Template.register_template_handler :jb, Jb::Handler.new
      end
    end
  end
end
