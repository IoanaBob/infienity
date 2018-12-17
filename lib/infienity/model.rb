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
  end
end