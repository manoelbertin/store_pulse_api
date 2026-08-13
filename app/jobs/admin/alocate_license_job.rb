module Admin
  class AlocateLicenseJob < ApplicationJob
    queue_as :default

    def perform(line_item)
    end
  end
end
