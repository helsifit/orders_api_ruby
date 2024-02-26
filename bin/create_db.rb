#!/usr/bin/env ruby
# frozen_string_literal: true

# bin/create_db.rb -h127.0.0.1 -ualex -dhelsifit_orders_dev
# bin/create_db.rb -h127.0.0.1 -ualex -dhelsifit_orders_test

require "optparse"
require "pg"
require "sequel"

OPTIONS = {adapter: "postgresql"}
orders_database = "orders_dev"
OptionParser.new do |opts|
  opts.banner = "Usage: ruby scripts/create_db.rb [OPTIONS]"
  opts.on("-hHOST", "--host HOST", "Database host") { |host| OPTIONS[:host] = host }
  opts.on("-uUSER", "--user USER", "Database username") { |user| OPTIONS[:user] = user }
  opts.on("-pPASSWORD", "--password PASSWORD", "Database password") { |password| OPTIONS[:password] = password }
  opts.on("-PPORT", "--port PORT", "Database port") { |port| OPTIONS[:port] = port }
  opts.on("-dDATABASE", "--database DATABASE", "Database name") { |db_name| orders_database = db_name }
end.parse!

Sequel.connect(OPTIONS) do |db|
  db.execute "CREATE DATABASE #{orders_database}"
end
