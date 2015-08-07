module ActivePivot
  module Api
    class Filter
      def initialize(params = {})
        @params = params
      end

      def to_params
        {filter: filter_string}
      end

      def merge(new_params)
        @params = @params.merge(new_params)
        self
      end

      private

      def filter_string
        @params.map do |key, value|
          [key, sanitize_value(value)].join(":")
        end.join(" ")
      end

      def sanitize_value(value)
        case value
        when Date, Time then value.iso8601
        when Array then value.join(",")
        else value
        end
      end
    end
  end
end
