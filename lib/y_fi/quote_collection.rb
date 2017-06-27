# Uses YAHOO's API service for fetching fund prices.
# Example: 
#   YFi::QuoteCollection.new(['vbtlx', 'vigrx']) #http://finance.yahoo.com/webservice/v1/symbols/VBTLX,VIGRX/quote?format=json&view=detail
require "httparty"

module YFi
  class QuoteCollection
    include Enumerable
    include HTTParty
    attr_accessor :tickers, :raw_quotes

    base_uri 'http://query.yahooapis.com/v1/public/yql'

    logger begin
      YFi.configuration.logger
    end
    debug_output YFi.configuration.logger

    # @param [Array<String>] - An array of tickers, such as ['AAPL']
    # @return [YFi::Quote, #to_a, #find, #each] - an array of Api::ExteralFunds
    def initialize(tickers)
      validate_ticker_format(tickers)
      self.tickers = tickers
      self.raw_quotes = self.class.get("", url_query_options)
    end

    # @return [Array] - an array of YFi::Quote
    def to_a
      response_array.each_with_object([]) do |raw_quote, arr|
        next unless valid_quote?(raw_quote)
        arr << Quote.new(
          ticker: raw_quote.fetch("symbol"),
          price: raw_quote["LastTradePriceOnly"].to_f,
          updated_at: parse_updated_at(raw_quote.fetch("LastTradeDate")),
          issuer_name: raw_quote.fetch("Name")
        )
      end
    end

    # @return [YFi::Quote]
    def find(ticker)
      to_a.find{|ef| ef.ticker == ticker.to_s.upcase}
    end
    
    def each(&block)
      to_a.each(&block)
    end

    private
    def yql_query_string
      funds = self.tickers.map{|f| "\"#{f}\""}.join(',')
      "select * from yahoo.finance.quotes where symbol in(#{funds})"
    end

    def response_array
      arr = raw_quotes.fetch("query", {}).fetch("results", {}).fetch("quote", {})
      arr = [arr] unless arr.is_a?(Array)
      arr
    end

    def parse_updated_at(updated_at)
      Date.strptime(updated_at, '%m/%d/%Y')
    rescue
      YFi.configuration.logger("Unable to parse date: #{updated_at}")
      Date.new(1976,1,1)
    end

    def validate_ticker_format(tickers)
      unless tickers.is_a?(Array) && tickers.all?{|f| f.is_a?(String)} && tickers.size
        raise(ArgumentError, "Please provide an array of tickers") 
      end
    end

    def url_query_options
      { 
        query: {
          format: 'json', 
          q: yql_query_string, 
          env: "store://datatables.org/alltableswithkeys"
        }
      }
    end

    def valid_quote?(raw_quote)
      unless raw_quote.is_a?(Hash)
        YFi.configuration.logger.error("Expected a hash but got: #{raw_quote}")
        return false
      end
      unless raw_quote["LastTradePriceOnly"]
        YFi.configuration.logger.error("Unable to fetch a price from #{raw_quote}")
        return false
      end
      true
    end
  end
end
