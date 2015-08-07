require "active_support"
require "active_support/core_ext"
require "active_pivot/api/paginated_collection"

module ActivePivot
  module Api
    describe PaginatedCollection do
      describe "#all" do
        let(:request) { double }

        before do
          stub_const("ActivePivot::Api::Request", request)
        end

        it "returns the first pages" do
          response = double(total_pages: 1, parsed_response: "page 1")

          expect(request).to receive(:get).once
            .with("url", {active: true})
            .and_return(response)

          pages = described_class.new("url", {active: true}).all

          expect(pages).to eq ["page 1"]
        end

        it "returns subsequent pages when available" do
          response_1 = double(total_pages: 2, limit: 100, parsed_response: "page 1")
          response_2 = double(total_pages: 2, limit: 100, parsed_response: "page 2")

          expect(request).to receive(:get).once
            .with("url", {active: true})
            .and_return(response_1).once

          expect(request).to receive(:get).once
            .with("url", {active: true, offset: 100})
            .and_return(response_2).once

          pages = described_class.new("url", {active: true}).all

          expect(pages).to eq ["page 1", "page 2"]
        end
      end
    end
  end
end
