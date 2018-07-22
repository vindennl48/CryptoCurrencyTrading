require 'net/http'
require 'binance'

class DashboardController < ApplicationController
  before_action :authenticate_me

  def index
    @symbols = Api.get_symbols
    @assets = Api.get_assets(@symbols)
    @investment = Transaction.sum(:amount)

    @debug = "None"
  end

  private
    def authenticate_me
      if not current_user
        redirect_to user_google_oauth2_omniauth_authorize_path
      end
    end

end
