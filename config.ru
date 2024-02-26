# frozen_string_literal: true

require "hanami/middleware/body_parser"

use Hanami::Middleware::BodyParser, :json

require_relative "orders_api"

run OrdersApi.new
