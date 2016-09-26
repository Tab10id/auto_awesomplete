module AutoAwesomplete
  module SearchAdapter
    class Default < Base
      class << self
        def search_default(term, page, options)
          if !@searchable || @text_columns.blank?
            raise_not_implemented
          end

          default_values =
              default_finder(
                  @searchable,
                  term,
                  page: page,
                  columns: @text_columns,
                  case_sensitive: @case_sensitive.nil? ? options[:case_sensitive] : @case_sensitive
              )
          default_values.map do |default_value|
            get_awesomplete_label(
                default_value,
                default_text_columns: @text_columns,
                label_method: @label_method
            )
          end
        end

        private

        def searchable(class_or_relation)
          @searchable = class_or_relation
        end

        def text_columns(*column_names)
          @text_columns = column_names
        end

        def label_method(method_sym)
          @label_method = method_sym
        end

        def case_sensitive(casi)
          @case_sensitive = casi
        end

        def raise_not_implemented
          raise NotImplementedError,
                'You should implement your own SearchAdapter. Use: `rails generate auto_awesomplete:search_adapter`'
        end
      end
    end
  end
end

