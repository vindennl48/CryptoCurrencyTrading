require 'net/http'
require 'binance'

class DashboardController < ApplicationController
  before_action :auth_me
  before_action :has_api

  def index
    @symbols = Api.get_symbols
    @assets = Api.get_assets(@symbols)
    @investment = Transaction.sum(:amount)

    @debug = User.find(current_user.id).inspect
  end

  private
    def auth_me
      if not current_user
        redirect_to user_google_oauth2_omniauth_authorize_path
      end
    end

    def has_api
      if not Api.all
        redirect_to apis_path
      end
    end

end
