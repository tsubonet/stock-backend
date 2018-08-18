class Api::StocksController < ApplicationController
  
  require 'open-uri'

  # GET /stocks?code=xxx
  def index

    charset = nil
    stock_info = {}
    url = "https://stocks.finance.yahoo.co.jp/stocks/chart/?code=#{params[:code]}.T&ct=b"

    begin
      raise if params[:code].empty?

      html = open(url) do |f|
        charset = f.charset
        f.read
      end

      doc = Nokogiri::HTML.parse(html, nil, charset)

      doc.xpath('//div[@id="main"]').each do |node|
        raise if node.css('div[@class="selectFinTitle yjL"]').inner_text == ' 一致する銘柄は見つかりませんでした'
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

    rescue => e
      render json: { error: '銘柄が見つかりません'}, status: :unprocessable_entity
    end

  end
end
