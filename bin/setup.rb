#!/usr/bin/env ruby
# frozen_string_literal: true
require "fileutils"

# path to your application root.
APP_ROOT = File.expand_path("..", __dir__)

FileUtils.chdir APP_ROOT do
  # This script is a way to set up or update your development environment automatically.
  # This script is idempotent, so that you can run it at any time and get an expectable outcome.
  # Add necessary setup steps to this file.

  puts "== Installing dependencies =="
  system("gem install bundler --conservative", exception: true)
  system("bundle check") || system("bundle install", exception: true)

  puts "\n== Copying sample files =="
  unless File.exist?(".env")
    FileUtils.cp ".env.example", ".env"
  end
  puts "Edit development settings in .env file"

  unless File.exist?(".env.test")
    FileUtils.cp ".env.test.example", ".env.test"
  end
  puts "Edit test DB name in .env.test file"
end
