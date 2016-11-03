# frozen_string_literal: true
module Jb
  class Railtie < ::Rails::Railtie
    initializer 'jb' do
      ActiveSupport.on_load :action_view do
        require 'jb/action_view_monkeys'
        require 'jb/handler'
        ::ActionView::Template.register_template_handler :jb, Jb::Handler
      end
    end

    generators do |app|
      Rails::Generators.configure! app.config.generators
      Rails::Generators.hidden_namespaces.uniq!
      require_relative '../generators/rails/scaffold_controller_generator'
    end
  end
end
