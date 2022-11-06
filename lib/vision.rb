require 'base64'
require 'json'
require 'net/https'

module Vision
  class << self
    def get_image_data(image_file)
      #APIのURL作成
      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_KEY']}"

      #画像をbase64にエンコード
      # dir_tree =image_file.key.scan(/.{1,#{2}}/)
      # base64_image = Base64.encode64(open("#{Rails.root}/public/uploads/#{dir_tree[0]}/#{dir_tree[1]}/#{image_file.key}").read)
      base64_image = Base64.encode64(image_file.tempfile.read)
      # APIリクエスト用のJSONパラメータ
      params = {
        requests: [{
          image: {
            content: base64_image
          },
          features:[
            {
              type:"IMAGE_PROPERTIES"
            },
          ]
        }]
      }.to_json

      # Google Cloud Vision APIにリクエスト
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      response = https.request(request,params)
      response_body = JSON.parse(response.body)
      #APIレスポンス出力
      if(error = response_body['responses'][0]['error']).present?
        raise error['message']
      else
        # 何もない配列用意
        red = []
        green = []
        blue = []
        
        # Google Vision APIからのデータを取得
        colors = response_body['responses'][0]['imagePropertiesAnnotation']['dominantColors']['colors']
        
        # 色を空の配列にnilでなければ追加していく
        colors.each do |color|
          red << color['color']['red'] unless color['color']['red'].nil?
          green << color['color']['green'] unless color['color']['green'].nil?
          blue << color['color']['blue'] unless color['color']['blue'].nil?
        end
        
        # 平均値を四捨五入して求める
        red_avg = red.sum.fdiv(red.length).round
        green_avg = green.sum.fdiv(green.length).round
        blue_avg = blue.sum.fdiv(blue.length).round
        
        # 平均値のRGBをHSLに変換
        rgb = ColorCode::RGB.new(r: red_avg, g: green_avg, b: blue_avg)
        hsl = rgb.to_hsl
        
        # HSLのSを100にしたものをRGBに戻す
        color = ColorCode::HSL.new(h: hsl.h, s: 100, l: hsl.l)
        color.to_rgb
      end
    end
  end
end