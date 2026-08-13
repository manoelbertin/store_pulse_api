module Paginatable
  extend ActiveSupport::Concern

  MAX_PER_PAGE = 100
  DEFAULT_PER_PAGE = 10

  included do
    scope :paginate, ->(page, length) {
      page_number = page.to_i.positive? ? page.to_i : 1
      per_page = length.to_i.positive? ? [length.to_i, MAX_PER_PAGE].min : DEFAULT_PER_PAGE
      page(page_number).per(per_page)
    }
  end
end
