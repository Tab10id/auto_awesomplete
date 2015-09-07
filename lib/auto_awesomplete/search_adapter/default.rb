module AutoAwesomplete
  module SearchAdapter
    class Default < Base
      class << self
        def search_default(term, page, options)
          begin
            default_arel = options[:default_class_name].camelize.constantize
          rescue NameError
            return {error: "not found class '#{options[:default_class_name]}'"}
          end

          default_values = default_finder(default_arel, term, page: page, column: options[:default_text_column])
          default_values.map do |default_value|
            get_awesomplete_label(default_value, options[:label_method])
          end
        end
      end
    end
  end
end

