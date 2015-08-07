require "active_support"
require "active_support/core_ext"
require "active_pivot/api/response"

module ActivePivot
  module Api
    describe Response do
      describe "#next_page?" do
        it "is true if the total items exceed the items on the current page" do
          response = Response.new(double({
            headers: {
              "X-Tracker-Pagination-Limit"    => "100",
              "X-Tracker-Pagination-Offset"   => "1",
              "X-Tracker-Pagination-Total"    => "450",
              "X-Tracker-Pagination-Returned" => "100"
            }
          }))

          expect(response.next_page?).to be true
        end

        it "is false if the current page is the last page" do
          response = Response.new(double({
            headers: {
              "X-Tracker-Pagination-Limit"    => "100",
              "X-Tracker-Pagination-Offset"   => "4",
              "X-Tracker-Pagination-Total"    => "450",
              "X-Tracker-Pagination-Returned" => "50"
            }
          }))

          expect(response.next_page?).to be false
        end

        it "is handles missing params" do
          response = Response.new(double({
            headers: {}
          }))

          expect(response.next_page?).to be false
        end
      end

      describe "#total_pages" do
        it "calculates the total number of pages from the limit per-page and total" do
          response = Response.new(double({
            headers: {
              "X-Tracker-Pagination-Limit" => "100",
              "X-Tracker-Pagination-Total" => "950"
            }
          }))

          expect(response.total_pages).to eq(10)
        end
      end
    end
  end
end
