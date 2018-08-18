class Api::StocksController < ApplicationController
  before_action :set_stock, only: [:show, :update, :destroy]

  # GET /api/stocks
  def index
    @stocks = stock.all
    render json: @stocks
  end

  # GET /api/stocks/1
  def show
    render json: @stock
  end

  # POST /api/stocks
  def create
    @stock = stock.new(stock_params)

    if @stock.save
      render json: @stock, status: :created, location: @stock
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/stocks/1
  def update
    if @stock.update(stock_params)
      render json: @stock
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/stocks/1
  def destroy
    @stock.destroy
  end

  # GET /api/stocks/search?code=xxx
  def search

    require 'open-uri'

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = stock.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def stock_params
      params.require(:stock).permit(:name)
    end

end
