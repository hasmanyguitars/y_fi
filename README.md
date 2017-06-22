[![CircleCI](https://circleci.com/gh/hasmanyguitars/y_fi.svg?style=svg)](https://circleci.com/gh/hasmanyguitars/y_fi)

# YFi
This is a Ruby implementation for fetching stock/fund prices from the Yahoo Finance API with YQL: https://developer.yahoo.com/yql/faq/

## Usage
To get a collection of quotes (Enumerable object):
```
YFi::QuoteCollection.new(['vbtlx', 'vigrx'])
```

To get an individual quote:
```
quote = YFi::Quote.find_by_ticker('aapl')
puts quote.price
puts quote.updated_at
puts quote.issuer_name
puts quote.ticker
```

## Installation
```gem install y_fi```

```ruby
gem 'y_fi'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install y_fi
```

Set up the logger:
```
YFi.configure do |config|
  config.logger = ::Logger.new("#{Rails.root}/log/yahoo_finance.log")
end
```

## Contributing
Feel free to create a pull request on a feature branch.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
