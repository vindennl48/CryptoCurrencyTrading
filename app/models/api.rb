require "coinbase/wallet"

class Api < ApplicationRecord
  validates :name, presence: true
  validates :api_type, presence: true
  validates :api_key, presence: true
  validates :secret_key, presence: true

  def self.get_client(k)
    if k == "public"
      return Binance::Client::REST.new
    elsif k["api_type"] == "binance_data"
      return Binance::Client::REST.new api_key: k["api_key"],
        secret_key: k["secret_key"]
    elsif k["api_type"] == "coinbase_data"
      return Coinbase::Wallet::Client.new api_key: k["api_key"],
        api_secret: k["secret_key"]
    end
  end

  def self.get_symbols
    client = self.get_client("public")

    symbols = {}
    symbols_raw = client.exchange_info["symbols"]
    symbols_raw.each do |symbol|
      if symbol["quoteAsset"] == "USDT"
        symbols[symbol["symbol"]] = symbol
      end
    end

    client.price.each do |t|
      if symbols.key?(t["symbol"])
        symbols[t["symbol"]]["price"] = t["price"]
      end
    end

    return symbols
  end

  def self.get_assets(symbols)

    assets = {}
    total = 0.0

    Api.all.each do |k|
      if k["api_type"] == "binance_data"
        client = self.get_client(k)
        assets_raw = client.account_info["balances"]

        symbols.each do |key, value|
          b = assets_raw.find {|asset| asset["asset"] == value["baseAsset"]}
          if b
            usd = b["free"].to_f*value["price"].to_f

            if assets.key? b["asset"]
              assets[b["asset"]]["amount"] += b["free"].to_f
              assets[b["asset"]]["usd"] += usd
            else
              assets[b["asset"]] = {"amount"=>b["free"].to_f, "usd"=>usd}
            end
            if usd > 5
              total += usd
            end
          end
        end

      elsif k["api_type"] == "coinbase_data"
        client = self.get_client(k)
        assets_raw = client.accounts
        symbols.each do |key, value|
          b = assets_raw.find {|asset| asset["currency"] == value["baseAsset"]}
          if b
            balance = b["balance"]["amount"].to_f
            usd = balance * value["price"].to_f

            if assets.key? b["currency"]
              assets[b["currency"]]["amount"] += balance
              assets[b["currency"]]["usd"] += usd
            else
              assets[b["currency"]] = {"amount"=>balance, "usd"=>usd}
            end
            if usd > 5
              total += usd
            end
          end
        end
      end
    end

    assets["total"] = total
    return assets
  end

end
