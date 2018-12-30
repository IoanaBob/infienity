module Infienity
  module Commander
    def commander_assigns(*fields)
      fields.each do |field|
        current_class = field.to_s.singularize.classify.constantize

        define_method "paginate_#{field}" do |pagination_params:, is_first_load: false|
          sorting_dropdown_options = state.try(:sorting_dropdown_options)
          selected_dropdown_option = state.try(:selected_dropdown_option)
          search_attribute = state.try(:search_attribute)
          search_string = state.try(:search_string)
          per_page = state.try(:per_page) || 10

          search_opts = { attribute: search_attribute, search_string: search_string } if search_string.present?
          sort_opts = sorting_dropdown_options&.fetch(selected_dropdown_option)

          return if (per_page * state.index) > current_class.paginate_count(search: search_opts)

          state.index = state.index + 1
          state.send("#{field.to_sym}=", state.send(field.to_sym) + current_class.paginate(per_page: per_page, start: state.index, search: search_opts, sort: sort_opts))

          execute_js_function('Infienity.fieResponded', is_first_load)
        end

        define_method "filter_#{field}" do
          sorting_dropdown_options = state.try(:sorting_dropdown_options)
          selected_dropdown_option = state.try(:selected_dropdown_option)
          search_attribute = state.try(:search_attribute)
          search_string = state.try(:search_string)
          per_page = state.try(:per_page) || 10

          search_opts = { attribute: search_attribute, search_string: search_string } if search_string.present?
          sort_opts = sorting_dropdown_options&.fetch(selected_dropdown_option)
          state.index = 0

          state.send("#{field.to_s}=", current_class.paginate(per_page: per_page, start: 0, search: search_opts, sort: sort_opts))

          execute_js_function('Infienity.fieResponded', true)
        end

        define_method "sort_#{field}" do |sort:|
          selected_dropdown_option = state.try(:selected_dropdown_option)
          search_attribute = state.try(:search_attribute)
          search_string = state.try(:search_string)
          per_page = state.try(:per_page) || 10

          unless state.sorting_dropdown_options.key?(selected_dropdown_option)
            raise StandardError("dropdown option not provided in the correct format")
          end

          state.selected_dropdown_option = sort.keys.first

          search_opts = { attribute: search_attribute, search_string: search_string } if search_string.present?
          sort_opts = sort.values.first
          state.index = 0

          state.send("#{field.to_s}=", current_class.paginate(per_page: per_page, start: 0, search: search_opts, sort: sort_opts))

          execute_js_function('Infienity.fieResponded', true)
        end

        define_method "sort_select_#{field}" do
          selected_dropdown_option = state.try(:selected_dropdown_option)
          search_attribute = state.try(:search_attribute)
          search_string = state.try(:search_string)
          per_page = state.try(:per_page) || 10

          unless state.sorting_dropdown_options.key?(selected_dropdown_option)
            raise StandardError("dropdown option not provided in the correct format")
          end

          sort = JSON.parse(@caller[:value])
          state.selected_dropdown_option = sort.keys.first

          search_opts = { attribute: search_attribute, search_string: search_string } if search_string.present?
          sort_opts = sort.values.first
          state.index = 0

          state.send("#{field.to_s}=", current_class.paginate(per_page: per_page, start: 0, search: search_opts, sort: sort_opts))

          execute_js_function('Infienity.fieResponded', true)
        end
      end
    end
  end
end