require "spec_helper"

describe YFi do
  describe "#configure" do
    before do
      YFi.configure do |config|
        config.logger = nil
      end
    end

    it "responds to logger" do
      expect(YFi.configuration).to respond_to(:logger)
    end
  end
end