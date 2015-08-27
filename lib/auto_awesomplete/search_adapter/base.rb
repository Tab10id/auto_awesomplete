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
          columns = options[:column].present? ? options[:column] : 'name'
          conditions = default_search_conditions(term, options[:basic_conditions], columns)

          if term.nil?
            [ searched_class.where(options[:basic_conditions]) ]
          else
            result_limit = options[:limit] || limit
            query = searched_class.where( conditions ).limit( result_limit ).order(columns)
            query = query.select(options[:select]) if options[:select].present?
            options[:uniq] ? query.uniq : query
          end
        end

        def default_search_conditions(term, basic_conditions, columns)
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
                term_filter +=  "#{column} LIKE ?"
                conditions << "%#{word}%"
              end
            end

            term_filter = term_filter.empty? ? nil : "(#{term_filter})"
            basic_conditions_part = basic_conditions.present? ? "(#{basic_conditions }) " : nil
            conditions.unshift([term_filter, basic_conditions_part].compact.join(' AND '))
          end
        end

        def get_awesomplete_label(item, label_method)
          if label_method.present? && item.respond_to?(label_method)
            item.public_send(label_method)
          else
            if item.respond_to?(:to_awesomplete)
              item.to_awesomplete
            else
              item.to_s
            end
          end
        end
      end
    end
  end
end
