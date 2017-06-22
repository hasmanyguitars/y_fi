require "spec_helper"

describe YFi::Quote do
  subject { described_class.new(ticker: 'foo') }

  it "upcases the ticker" do
    expect(subject.ticker).to eq('FOO')
  end

  it { is_expected.to respond_to(:updated_at) }
  it { is_expected.to respond_to(:price) }
  it { is_expected.to respond_to(:issuer_name) }

  describe "#find_by_ticker", vcr: true do
    subject { YFi::Quote.find_by_ticker('AAPL') }

    it "returns a quote object" do
      expect(subject).to be_a(YFi::Quote)
    end
  end
end