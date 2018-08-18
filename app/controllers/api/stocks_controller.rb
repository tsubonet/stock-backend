class Api::StocksController < ApplicationController
  
  # GET /stocks
  def index

    require 'open-uri'

    url = "https://stocks.finance.yahoo.co.jp/stocks/chart/?code=#{params[:id]}.T&ct=b"
    charset = nil
    stock_info = {}

    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)

    doc.xpath('//div[@id="main"]').each do |node|
      if node.css('div[@class="selectFinTitle yjL"]').inner_text === ' 一致する銘柄は見つかりませんでした'
        return render json: ['銘柄が見つかりません'], status: :unprocessable_entity
      end
    end
    
    doc.xpath('//div[@id="stockinf"]').each do |node|
      stock_info[:company] = node.css('h1').inner_text
      stock_info[:time] = node.css('dd[@class="yjSb real"]').css('span').inner_text
      stock_info[:price] = node.css('td[@class="stoksPrice"]').inner_text
      stock_info[:change] = node.css('table[@class="stocksTable"]').css('span[2]').inner_text
    end

    doc.xpath('//div[@class="padT12 centerFi marB10"]').each do |node|
      stock_info[:chartUrl] = node.css('img').attribute('src').value
    end

    render json: stock_info

  end

end
