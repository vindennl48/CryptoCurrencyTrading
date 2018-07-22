require 'net/http'
require 'binance'

class DashboardController < ApplicationController
  def index
    @symbols = Api.get_symbols
    @assets = Api.get_assets(@symbols)
    @investment = Transaction.sum(:amount)

    @debug = "None"
  end
end
