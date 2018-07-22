class Api < ApplicationRecord
  validates :name, presence: true
  validates :api_type, presence: true
  validates :api_key, presence: true
  validates :secret_key, presence: true

  def self.get_client
    keys = Api.all[0]
    return Binance::Client::REST.new api_key: keys["api_key"],
      secret_key: keys["secret_key"]
  end

  def self.get_symbols
    client = self.get_client

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
    client = self.get_client

    assets = {}
    assets_raw = client.account_info["balances"]

    total = 0.0
    symbols.each do |key, value|
      b = assets_raw.find {|asset| asset["asset"] == value["baseAsset"]}
      usd = b["free"].to_f*value["price"].to_f
      assets[b["asset"]] = {"amount"=>b["free"],
        "usd"=>"#{'%.2f' % usd}"}
      if usd > 5
        total += usd
      end
    end
    assets["total"] = total

    return assets
  end

end
