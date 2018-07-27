class DashboardController < ApplicationController
  before_action :auth_me
  before_action :has_api

  def index
  end

  def get_data
    symbols = Api.get_symbols
    assets = Api.get_assets(symbols, current_user)
    amount_invested = Transaction.sum(:amount)

    profit = assets["total"]-amount_invested
    if profit >= 0
      profit = "$#{'%.2f' % profit}"
    else
      profit = "-$#{'%.2f' % (profit*-1)}"
    end
    current_total = "$#{'%.2f' % assets["total"]}"
    amount_invested = "$#{'%.2f' % amount_invested}"

    invested_coins = []
    symbols.each do |key, symbol|
      asset = assets[symbol["baseAsset"]]
      if asset["usd"].to_f > 5.0
        invested_coins.push({
          :baseAsset => symbol["baseAsset"],
          :price => "#{'%.8f' % symbol["price"]}",
          :amount => "#{'%.8f' % asset["amount"]}",
          :usd => "$#{'%.2f' % asset["usd"]}",
        })
      end
    end

    render :json => { 
      :amount_invested => amount_invested,
      :current_total => current_total,
      :profit => profit,
      :invested_coins => invested_coins,
    }
  end

  def get_klines
    render :json => Api.get_klines(params[:frame], params[:baseAsset])
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
