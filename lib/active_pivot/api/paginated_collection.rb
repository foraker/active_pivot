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
          send_request(params.merge(offset: offset))
        end
      end

      def multiple_pages?
        total_pages > 1
      end

      def first_page
        @first_page ||= send_request(params)
      end

      def send_request(params = {})
        Request.get(endpoint, params).tap do |response|
          print_request_error unless response.success?
        end
      end

      def print_request_error
        puts "Pivotal request failed. Endpoint #{endpoint} invalid with params: #{params}"
      end
    end

    class InvalidRequestError < StandardError; end
  end
end
