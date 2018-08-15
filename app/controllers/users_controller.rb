class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index

    # # url = ['https://yahoo.co.jp']
    # #解析した画像url入れておく配列を作成する
    # array = []
    # #取得したい画像のあるページのurlを配列に入れておく
    # # urls = %w(url)
    # urls = ['https://yahoo.co.jp']
    # #そしてurlを展開する。展開したurlはNokogiriによって分解され、xpathなりcssで要素を指定できるようになる
    # urls.each do |url|
    #   doc = Nokogiri::HTML(open(url))
    # #今回は欲しい画像がimgタグのなかのｓｒｃにあったのでこのようになった。取得したurlを配列に格納しviewで表示するための処理を書いていく。
    #   doc.css('img').each do |photo|
    #     array << photo[:src]
    #   end
    # end

    # url = 'https://qiita.com/search?q=ruby'

    # charset = nil

    # array = []

    # html = open(url) do |f|
    #     charset = f.charset
    #     f.read
    # end

    # doc = Nokogiri::HTML.parse(html, nil, charset)
    # doc.xpath('//h1[@class="searchResult_itemTitle"]').each do |node|
    #   array << node.css('a').inner_text
    # end
    
    # require 'open-uri'

    url = 'https://stocks.finance.yahoo.co.jp/stocks/chart/?code=3092.T&ct=b'

    charset = nil

    stock_info = {
      time: '',
      price: '',
      company: '',
      change: '',
      chartUrl: '',
    }

    html = open('https://mail.google.com/') do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)
    doc.xpath('//div[@id="stockinf"]').each do |node|
      stock_info[:time] = node.css('dd[@class="yjSb real"]').css('span').inner_text
      stock_info[:company] = node.css('h1').inner_text
      stock_info[:price] = node.css('td[@class="stoksPrice"]').inner_text
      stock_info[:change] = node.css('span[@class="icoUpGreen yjMSt"]').inner_text
    end

    doc.xpath('//div[@class="padT12 centerFi marB10"]').each do |node|
      stock_info[:chartUrl] = node.css('img').attribute('src').value
    end


    @users = User.all

    render json: [@users, stock_info]
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name)
    end
end
