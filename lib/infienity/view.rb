module Infienity
  module View
    def dropdown(dropdown_options:, current_option:, assign:, options: {})
      html_class = options[:class]
      html_id = options[:id]

      html_content =
        "<div class='dropdown'>" \
        "<button class='#{html_class}' type='button' data-toggle='dropdown'> #{current_option}" \
        "<span class='caret'></span></button>" \
        "<ul class='dropdown-menu'>" \

      dropdown_options.each do |key, val|
        html_content << "<li fie-click='sort_#{assign.to_s}' fie-parameters= '#{ { sort: {key => val} }.to_json }'> #{key} </li>"
      end

      html_content << "</ul></div>"

      html_content.html_safe
    end
  end
end