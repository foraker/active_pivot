module ActivePivot
  module Api
    class PaginatedCollection
      include Enumerable

      attr_reader :endpoint, :params

      delegate :total_pages, :limit, to: :first_page
      delegate :each, to: :all

      def initialize(endpoint, params = {})
        @endpoint = endpoint
        @params   = params
      end

      def all
        pages.flat_map(&:parsed_response)
      end

      def pages
        [first_page] + subsequent_pages
      end

      private

      def subsequent_pages
        return [] unless multiple_pages?

        (2..total_pages).map do |page|
          offset = limit * (page - 1)
          Request.get(endpoint, params.merge(offset: offset))
        end
      end

      def multiple_pages?
        total_pages > 1
      end

      def first_page
        @first_page ||= Request.get(endpoint, params)
      end
    end
  end
end
