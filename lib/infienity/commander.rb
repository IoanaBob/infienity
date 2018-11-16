module Infienity
  module Commander
    def commander_assigns(*fields)
      fields.each do |field|
        current_class = field.to_s.singularize.classify.constantize

        define_method "paginate_#{field}" do |pagination_params:, is_first_load: false|
          search_opts = { attribute: state.search_attribute, search_string: state.search_string }

          return if (state.per_page * state.index) > current_class.paginate_count(search: search_opts)

          state.index = state.index + 1
          state.users = state.users + current_class.paginate(per_page: state.per_page, start: state.index, search: search_opts)

          execute_js_function('infienity.fieResponded', is_first_load)
        end

        define_method "filter_#{field}" do
          search_opts = { attribute: state.search_attribute, search_string: state.search_string }
          sort_opts = state.sorting_dropdown_options.fetch(state.selected_dropdown_option)
          state.index = 0

          state.users = current_class.paginate(per_page: state.per_page, start: 0, search: search_opts, sort: sort_opts)

          execute_js_function('infienity.fieResponded', true)
        end

        define_method "sort_#{field}" do |sort:|
          unless state.sorting_dropdown_options.key?(state.selected_dropdown_option)
            raise StandardError("dropdown option not provided in the correct format")
          end
          state.selected_dropdown_option = sort[:sort].keys[0]

          search_opts = { attribute: state.search_attribute, search_string: state.search_string }
          sort_opts = sort[:sort].values[0]
          state.index = 0

          state.users = current_class.paginate(per_page: state.per_page, start: 0, search: search_opts, sort: sort_opts)

          execute_js_function('infienity.fieResponded', true)
        end
      end
    end
  end
end