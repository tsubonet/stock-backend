class Api::StocksController < ApplicationController
  before_action :set_stock, only: [:show, :update, :destroy]

  # GET /api/stocks
  def index
<<<<<<< HEAD
    @stocks = Stock.all
    render json: @stocks
  end
=======
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
>>>>>>> 4152801b53f89e3ab1043c7c074a154530b67809

  # GET /api/stocks/1
  def show
    res_data = scraing_chart(@stock[:code])
    if res_data.has_key?(:error)
      render json: res_data, status: :unprocessable_entity
      return
    end

    res_news = scraing_news(@stock[:code])
    if res_news.has_key?(:error)
      render json: res_news, status: :unprocessable_entity
      return
    end

    render json: res_data.merge(res_news)

  end

  # POST /api/stocks
  def create
    @stock = Stock.new(stock_params)

    if @stock.save
      render json: @stock, status: :created
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

    if params[:code].empty?
      render json: {error: '入力必須です'}, status: :unprocessable_entity
      return
    end
    
    res_data = scraing_chart(params[:code])

    if res_data.has_key?(:error)
      render json: res_data, status: :unprocessable_entity
      return
    end

    render json: res_data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
<<<<<<< HEAD
      @stock = Stock.find(params[:id])
=======
      @stock = stock.find(params[:id])
>>>>>>> 4152801b53f89e3ab1043c7c074a154530b67809
    end

    # Only allow a trusted parameter "white list" through.
    def stock_params
<<<<<<< HEAD
      params.require(:stock).permit(:code, :name)
    end

    def scraing_chart(code)

      require 'open-uri'

      charset = nil
      stock_info = {}
      url = "https://stocks.finance.yahoo.co.jp/stocks/chart/?code=#{code}.T&ct=b"
  
      begin
        html = open(url) do |f|
          charset = f.charset
          f.read
        end
  
        doc = Nokogiri::HTML.parse(html, nil, charset)
  
        doc.xpath('//div[@id="main"]').each do |node|
          if node.css('div[@class="selectFinTitle yjL"]').inner_text == ' 一致する銘柄は見つかりませんでした'
            raise
          else
            stock_info[:code] = code
          end
        end
        
        doc.xpath('//div[@id="stockinf"]').each do |node|
          stock_info[:name] = node.css('h1').inner_text
          stock_info[:time] = node.css('dd[@class="yjSb real"]').css('span').inner_text
          stock_info[:price] = node.css('td[@class="stoksPrice"]').inner_text
          stock_info[:change] = node.css('table[@class="stocksTable"]').css('span[2]').inner_text
        end
  
        doc.xpath('//div[@class="padT12 centerFi marB10"]').each do |node|
          stock_info[:chartUrl] = node.css('img').attribute('src').value
        end
  
        return stock_info
  
      rescue => e
        return { error: '銘柄が見つかりません'}
      end
    end

    def scraing_news(code)

      charset = nil
      scrap_data = []
      url = "https://stocks.finance.yahoo.co.jp/stocks/news/?code=#{code}.T"
  
      begin
        html = open(url) do |f|
          charset = f.charset
          f.read
        end
  
        doc = Nokogiri::HTML.parse(html, nil, charset)
        
        doc.css('ul.ymuiList.yjMSt.ymuiDotLine li.ymuiArrow1').each do |node|
          news_item = {
            text: node.css('a').inner_text,
            href: node.css('a').attribute('href').value,
            date: node.css('span[@class="ymuiDate yjS"]').inner_text,
          }
          scrap_data.push(news_item)
        end
        
        return { news: scrap_data }
  
      rescue => e
        return { error: 'エラー発生しました'}
      end
=======
      params.require(:stock).permit(:name)
>>>>>>> 4152801b53f89e3ab1043c7c074a154530b67809
    end

end
