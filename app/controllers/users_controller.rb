class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index

    # url = ['https://yahoo.co.jp']
    #解析した画像url入れておく配列を作成する
    array = []
    #取得したい画像のあるページのurlを配列に入れておく
    # urls = %w(url)
    urls = ['https://yahoo.co.jp']
    #そしてurlを展開する。展開したurlはNokogiriによって分解され、xpathなりcssで要素を指定できるようになる
    urls.each do |url|
      doc = Nokogiri::HTML(open(url))
    #今回は欲しい画像がimgタグのなかのｓｒｃにあったのでこのようになった。取得したurlを配列に格納しviewで表示するための処理を書いていく。
      doc.css('img').each do |photo|
        array << photo[:src]
      end
    end


    @users = User.all

    render json: [@users, array]
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
