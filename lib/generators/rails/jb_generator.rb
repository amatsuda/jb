# frozen_string_literal: true

require 'rails/generators/named_base'
require 'rails/generators/resource_helpers'

module Rails
  module Generators
    class JbGenerator < NamedBase # :nodoc:
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      argument :attributes, type: :array, default: [], banner: 'field:type field:type'

      class_option :timestamps, type: :boolean, default: true

      def create_root_folder
        path = File.join('app/views', controller_file_path)
        empty_directory path unless File.directory?(path)
      end

      def copy_view_files
        template 'index.json.jb', File.join('app/views', controller_file_path, 'index.json.jb')
        template 'show.json.jb', File.join('app/views', controller_file_path, 'show.json.jb')
      end

      private
      # Pairs of the JSON key and the Ruby expression that renders the value, for each attribute of the given record
      def json_attributes(record)
        names = [:id] + attributes_names
        names -= %w(password password_confirmation) if attributes.any? {|a| (a.name == 'password') && (a.type == :digest) }
        names += %w(created_at updated_at) if options[:timestamps]

        names.map do |name|
          attribute = attributes.detect {|a| a.name == name.to_s }
          value = "#{record}.#{name}"

          case attribute && attribute.type
          when :attachment
            [name, "(url_for(#{value}) if #{value}.attached?)"]
          when :attachments
            item = name.to_s.singularize
            [name, "#{value}.map {|#{item}| {id: #{item}.id, url: url_for(#{item})} }"]
          when :rich_text
            [name, "#{value}.to_s"]
          else
            [name, value]
          end
        end
      end
    end
  end
end
