source "https://rubygems.org"
ruby "3.3.0"

gem "hanami-api", "~> 0.3.0"
gem "puma", "~> 6.4.2"
gem "stripe", "~> 10.6.0"
gem "sequel", "~> 5.76.0"
gem "pg", "~> 1.5.4"
gem "pry", "~> 0.14.2", require: false
gem "dotenv", "~> 3.0.2", group: [:development, :test], require: "dotenv/load"
gem "base64", "~> 0.2.0"
gem "json", "~> 2.7.1"
gem "oj", "~> 3.16.3"

group :development do
  gem "standard", "~> 1.33.0"
  gem "faraday", "~> 2.9.0"
end

group :test do
  gem "rspec", "~> 3.12.0"
  gem "rack-test", "~> 2.1.0"
  gem "webmock", "~> 3.22.0"
  gem "vcr", "~> 6.2.0"
  gem "faker", "~> 3.2.3"
end
