module YFi
  class Quote
    attr_accessor :price, 
      :updated_at,
      :issuer_name,
      :ticker

    def initialize(args)
      args.each do |key, val|
        self.public_send("#{key}=", val)
      end
      self.ticker = self.ticker.to_s.upcase
    end

    # @param ticker [String]
    # @example Api::ExternalFund.find_by_ticker('AAPL')
    # @return [Api::ExternalFund]
    def self.find_by_ticker(ticker)
      QuoteCollection.new([ticker]).first
    end
  end
end