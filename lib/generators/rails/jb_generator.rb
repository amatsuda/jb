# frozen_string_literal: true

require 'rails/generators/named_base'
require 'rails/generators/resource_helpers'

module Rails
  module Generators
    class JbGenerator < NamedBase # :nodoc:
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      argument :attributes, type: :array, default: [], banner: 'field:type field:type'

      def create_root_folder
        path = File.join('app/views', controller_file_path)
        empty_directory path unless File.directory?(path)
      end

      def copy_view_files
        template 'index.json.jb', File.join('app/views', controller_file_path, 'index.json.jb')
        template 'show.json.jb', File.join('app/views', controller_file_path, 'show.json.jb')
      end


      private
      def attributes_names
        [:id] + super
      end

      def attributes_names_with_timestamps
        attributes_names + %w(created_at updated_at)
      end
    end
  end
end
