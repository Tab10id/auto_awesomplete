module AutoAwesomplete
  module SearchAdapter
    class Base
      class << self
        def limit
          10
        end

        def search_from_autocomplete(term, page, search_method, options)
          if search_method.nil?
            search_default(term, page, options)
          else
            self.public_send("search_#{search_method}", term, page, options)
          end
        end

      private

        def default_finder(searched_class, term, options)
          columns = options[:columns].present? ? options[:columns] : 'name'
          conditions =
              default_search_conditions(
                  term,
                  options[:basic_conditions],
                  columns,
                  options.slice(:case_sensitive)
              )

          if term.nil?
            [ searched_class.where(options[:basic_conditions]) ]
          else
            result_limit = options[:limit] || limit
            query = searched_class.where( conditions ).limit( result_limit ).order(columns)
            query = query.select(options[:select]) if options[:select].present?
            options[:uniq] ? query.uniq : query
          end
        end

        def default_search_conditions(term, basic_conditions, columns, options = {})
          term_filter = ''
          conditions = []

          unless columns.is_a?(Array)
            columns = columns.split(/[\s,]+/)
          end

          unless term.nil?
            words = term.split(' ')
            words.each_with_index do |word, index|
              term_filter += ' AND ' if index > 0

              columns.each_with_index do |column, idx|
                term_filter += ' OR ' if idx > 0

                if options[:case_sensitive]
                  term_filter += "#{column} LIKE ?"
                else
                  term_filter += "LOWER(#{column}) LIKE LOWER(?)"
                end

                conditions << "%#{word}%"
              end
            end

            term_filter = term_filter.empty? ? nil : "(#{term_filter})"
            basic_conditions_part = basic_conditions.present? ? "(#{basic_conditions }) " : nil
            term_and_basic_conditions = [term_filter, basic_conditions_part].compact.join(' AND ')
            conditions.unshift(term_and_basic_conditions) if term_and_basic_conditions.present?
          end
        end

        def get_awesomplete_label(item, options)
          label_method = options[:label_method]
          text_columns = options[:default_text_columns]
          if text_columns.is_a?(String)
            text_columns = text_columns.split(',').map(&:squish)
          end

          if label_method.present? && item.respond_to?(label_method)
            item.public_send(label_method)
          elsif text_columns.present?
            text_columns.map { |attr| item.attributes[attr.to_s] }.join(' ')
          else
            item.to_s
          end
        end
      end
    end
  end
end
