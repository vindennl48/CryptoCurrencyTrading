require 'net/http'
require 'binance'

class DashboardController < ApplicationController
  before_action :auth_me
  before_action :has_api

  def index
    @symbols = Api.get_symbols
    @assets = Api.get_assets(@symbols, current_user)
    @investment = Transaction.sum(:amount)
  end

  private
    def auth_me
      if not current_user
        redirect_to user_google_oauth2_omniauth_authorize_path
      end
    end

    def has_api
      if not Api.has_api(current_user)
        redirect_to apis_path
      end
    end

end
