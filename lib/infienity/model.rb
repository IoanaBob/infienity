module Infienity
  module Model
    def paginate(per_page: 10, start: 0, search: nil, sort: nil)
      entry_assign = self
      if search.present? && search.key?(:attribute) && search.key?(:search_string)
        entry_assign = entry_assign.search(attribute: search[:attribute], search_string: search[:search_string])
      end
      if sort.present?
        entry_assign = entry_assign.order(sort[0] => sort[1])
      end
      #paginate
      entry_assign.limit(per_page.to_i).offset(start.to_i * per_page.to_i)
    end

    def paginate_count(search: nil)
      entry_assign = self
      if search.present?
        if search.key?(:attribute) && search.key?(:search_string)
          entry_assign = entry_assign.search(attribute: search[:attribute], search_string: search[:search_string])
        end
      end
      entry_assign.count
    end

    # case sensitive or no?
    def search(attribute: , search_string:)
      where("#{attribute} ILIKE ?", "%#{search_string}%")
    end

    def dropdown_field(dropdown_options:, current_option:, options: {})
      entry_assign = self.name.downcase.pluralize
      html_class = options[:class]
      html_id = options[:id]
      html_name = options[:name]

      html_content =
        "<div class='dropdown'>" \
        "<button class='#{html_class}' id=#{html_id} name='#{html_name}' " \
        "type='button' data-toggle='dropdown'> #{current_option}" \
        "<span class='caret'></span></button>" \
        "<ul class='dropdown-menu'>" \

      dropdown_options.each do |key, val|
        html_content << "<li fie-click='sort_#{entry_assign}' fie-parameters= '#{ { sort: {key => val} }.to_json }'> #{key} </li>"
      end

      html_content << "</ul></div>"

      html_content.html_safe
    end

    def search_field(search_string: ,options: {})
      entry_assign = self.name.downcase.pluralize
      html_class = options[:class]
      html_id = options[:id]
      html_name = options[:name]

      html_content = "<input type='text' "
      html_content << "class='#{html_class}'" if html_class
      html_content << "id='#{html_id}'" if html_id
      html_content << "name='search_string #{html_name}' value='#{search_string}' "
      html_content << "fie-keyup='filter_#{entry_assign}'> </input>"

      html_content.html_safe
    end
  end
end