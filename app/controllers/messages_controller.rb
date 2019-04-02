class MessagesController < ApplicationController
  def index
    @messages = Message.where(is_public: true).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  # 記事の詳細
  def show
    @message = Message.find_by(url_token: params[:url_token])
  end

  # 新規登録フォーム
  def new
    @message = Message.new
  end

  # 編集
  def edit
    @message = Message.find_by(url_token: params[:url_token])
  end

  def create
    @message = Message.new(message_params)

    # ハッシュを保存
    @message.url_token = SecureRandom.hex(10)

    # if Message.last.present?
    #   next_id = Message.last.id + 1
    # else
    #   next_id = 1
    # end
    # make_picture(next_id)

    if @message.save
      redirect_to controller: :messages, action: :index, notice: '作成しました。'
    else
      render 'new'
    end
  end

  def update
    @message = Message.find_by(url_token: params[:url_token])
    @message.assign_attributes(message_params)

    if @message.save
      redirect_to controller: :messages, action: :index, notice: '更新しました。'
    else
      render 'edit'
    end
  end

  def destroy
    @message = Message.find_by(url_token: params[:url_token])
    @message.destroy
    redirect_to :messages, notice: '記事を削除しました。'
  end

  private

  def message_params
    params.require(:message).permit(:url_token, :text, :image, :is_public)
  end

  # ⑨メソッド追加（画像生成）
  def make_picture(id)
    sentense = ""
    # ⑨-1 改行を消去
    content = @message.message_text.gsub(/\r\n|\r|\n/," ")

    # ⑨-2 contentの文字数に応じて条件分岐
    if content.length <= 28 then
      # ⑨-3 28文字以下の場合は7文字毎に改行
      n = (content.length / 7).floor + 1
      n.times do |i|
        s_num = i * 7
        f_num = s_num + 6
        range =  Range.new(s_num,f_num)
        sentense += content.slice(range)
        sentense += "\n" if n != i+1
      end
      # ⑨-4 文字サイズの指定
      pointsize = 90
    elsif content.length <= 50 then
      n = (content.length / 10).floor + 1
      n.times do |i|
        s_num = i * 10
        f_num = s_num + 9
        range =  Range.new(s_num,f_num)
        sentense += content.slice(range)
        sentense += "\n" if n != i+1
      end
      pointsize = 60
    else
      n = (content.length / 15).floor + 1
      n.times do |i|
        s_num = i * 15
        f_num = s_num + 14
        range =  Range.new(s_num,f_num)
        sentense += content.slice(range)
        sentense += "\n" if n != i+1
      end
      pointsize = 45
    end

    # ⑨-5 文字色の指定
    color = "black"
    # ⑨-6 文字を入れる場所の調整（0,0を変えると文字の位置が変わります）
    draw = "text 0,0 '#{sentense}'"
    # ⑨-7 フォントの指定
    font = "./app/assets/fonts/geneinugothic-eb.ttf"
    # ⑨-8 ↑これらの項目も文字サイズのように背景画像や文字数によって変えることができます
    # ⑨-9 選択された背景画像の設定
    # case @post.kind
    # when "black" then
    #   base = "./app/assets/images/bg_image.png"
    #   # ⑨-10 今回は選択されていない場合は"red"となるようにしている
    # else
    #   base = "app/assets/images/red.jpg"
    # end
    base = "./app/assets/images/bg_image.png"
    # ⑨-11 minimagickを使って選択した画像を開き、作成した文字を指定した条件通りに挿入している
    image = MiniMagick::Image.open(base)
    image.combine_options do |i|
      i.font font
      i.fill color
      i.gravity 'center'
      i.pointsize pointsize
      i.draw draw
    end
    # ⑨-12 保存先のストレージの指定。Amazon S3を指定する。
    storage = Fog::Storage.new(
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION']
    )
    # ⑨-13 開発環境or本番環境でS3のバケット（フォルダのようなもの）を分ける
    case Rails.env
    when 'production'
      # ⑨-14 バケットの指定・URLの設定
      bucket = storage.directories.get(ENV['AWS_S3_BUCKET'])
      # ⑨-15 保存するディレクトリ、ファイル名の指定（ファイル名は投稿id.pngとしています）
      image_name = SecureRandom.hex(10)
      png_path = 'uploads/entry/' + image_name + '.png'
      image_uri = image.path
      file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
      @message.message_image = 'https://s3-ap-northeast-1.amazonaws.com/' + ENV['AWS_S3_BUCKET'] + "/" + png_path
    when 'development'
      bucket = storage.directories.get(ENV['AWS_S3_BUCKET'])
      image_name = SecureRandom.hex(10)
      png_path = 'uploads/entry/' + image_name + '.png'
      image_uri = image.path
      file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
      @message.message_image = 'https://s3-ap-northeast-1.amazonaws.com/'+ ENV['AWS_S3_BUCKET'] + "/" + png_path
    end
  end
end
