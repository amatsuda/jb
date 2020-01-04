# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'

module Rails
  module Generators
    class ScaffoldControllerGenerator
      hook_for :jb, type: :boolean, default: true
    end
  end
end
