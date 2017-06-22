require "spec_helper"

describe YFi::QuoteCollection, vcr: true do
  context "with an array of valid tickers" do
    let(:quote_collection) { described_class.new(['AAPL', 'VOO'])}

    context "#find" do
      subject { quote_collection.find('aapl') }

      it "returns a Quote object" do
        expect(subject).to be_a(YFi::Quote)
      end

      it "retrieves the price" do
        expect(subject.price).to be > 0
      end

      it "retrieves the issuer name" do
        expect(subject.issuer_name).to eq("Apple Inc.")
      end

      it "retrieves the last trade date" do
        expect(subject.updated_at).to be_a(Date)
      end
    end

    context "#to_a" do
      subject { quote_collection.to_a }

      it "returns an array of quotes" do
        expect(subject.map(&:class)).to eq(Array.new(2, YFi::Quote))
      end
    end

    it "responds to each" do
      expect(quote_collection).to respond_to(:each)
    end
  end

  context "with bad arguments" do
    subject { described_class.new({a: 1}) }

    it "raises an error" do
      expect {subject}.to raise_error(ArgumentError)
    end
  end
end