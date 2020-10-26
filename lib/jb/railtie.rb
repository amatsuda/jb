# frozen_string_literal: true

module Jb
  class Railtie < ::Rails::Railtie
    initializer 'jb' do
      ActiveSupport.on_load :action_view do
        if Rails::VERSION::MAJOR >= 6
          require 'jb/action_view_monkeys'
        else
          require 'jb/action_view_legacy_monkeys'
        end
        require 'jb/handler'
        ::ActionView::Template.register_template_handler :jb, Jb::Handler
      end
    end

    if Rails::VERSION::MAJOR >= 5
      module ::ActionController
        module ApiRendering
          include ActionView::Rendering
        end
      end

      ActiveSupport.on_load :action_controller do
        if self == ActionController::API
          include ActionController::Helpers
          include ActionController::ImplicitRender
        end
      end
    end

    generators do |app|
      Rails::Generators.configure! app.config.generators
      Rails::Generators.hidden_namespaces.uniq!
      require_relative '../generators/rails/scaffold_controller_generator'
    end
  end
end
