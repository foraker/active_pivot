module ActivePivot
  module Api
    class Response < Struct.new(:response)
      delegate :parsed_response, :headers, to: :response
      delegate :each, to: :parsed_response

      def next_page?
        (offset * limit + returned) < total
      end

      def total_pages
        (total / limit.to_f).ceil rescue 1
      end

      def success?
        [200, 201].include?(response.code)
      end

      def limit
        headers["X-Tracker-Pagination-Limit"].to_i
      end

      private

      def offset
        headers["X-Tracker-Pagination-Offset"].to_i
      end

      def total
        headers["X-Tracker-Pagination-Total"].to_i
      end

      def returned
        headers["X-Tracker-Pagination-Returned"].to_i
      end
    end
  end
end
