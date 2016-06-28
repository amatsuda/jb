module Jb
  class Engine < ::Rails::Engine
    initializer 'jb' do
      ActiveSupport.on_load :action_view do
        require 'jb/action_view_monkeys'
        require 'jb/handler'
        ::ActionView::Template.register_template_handler :jb, Jb::Handler
      end
    end
  end
end
