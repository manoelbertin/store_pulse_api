module Searchable
  extend ActiveSupport::Concern

  included do
    scope :like, ->(key, value) { where("LOWER(#{key}) LIKE ?",
       "%#{value.downcase}%") }
  end
end
