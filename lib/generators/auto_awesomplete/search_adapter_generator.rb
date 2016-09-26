module AutoAwesomplete
  module Generators
    class SearchAdapterGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      class_option :destination_path,
                   type: :string,
                   default: 'app/awesomplete_search_adapters',
                   desc: 'Path for storing SearchAdapter classes',
                   banner: 'lib/search_adapters'
      class_option :text_columns,
                   type: :array,
                   desc: 'Column for searching by',
                   banner: 'lastname firstname',
                   required: true
      class_option :label_method,
                   type: :string,
                   desc: 'Instance method of model for converting into Hash for transporting into awesomplete',
                   banner: 'to_awesomplete'
      class_option :case_sensitive,
                   type: :boolean,
                   desc: 'Is adapter request case sensitive or not',
                   banner: 'case_sensitive'

      desc 'Creates SearchAdapter classes for your models'
      def create_search_adapter
        template 'search_adapter.rb.erb',
                 "#{options[:destination_path]}/#{class_path.push(file_name).join('/')}_search_adapter.rb"
      end

      private

      def text_columns
        options[:text_columns].map do |c|
          if c.underscore == c
            ":#{c}"
          else
            "\"#{c}\""
          end
        end
      end

      def label_method
        options[:label_method]
      end

      def case_sensitive
        options[:case_sensitive]
      end
    end
  end
end