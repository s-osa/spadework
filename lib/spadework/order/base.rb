# coding: utf-8

require 'date'
require 'date4'
require 'date4/holiday'

class Order::Base < Array
  Version = 0.1
  ShipDaysTo = {
北海道: 2,
青森県: 1, 岩手県: 1, 宮城県: 1, 秋田県: 1, 山形県: 1, 福島県: 1,
茨城県: 1, 栃木県: 1, 群馬県: 1, 埼玉県: 1, 千葉県: 1, 東京都: 1, 神奈川県: 1,
新潟県: 1, 富山県: 1, 石川県: 1, 福井県: 1, 山梨県: 1, 長野県: 1,
岐阜県: 1, 静岡県: 1, 愛知県: 1, 三重県: 1,
滋賀県: 1, 京都府: 1, 大阪府: 1, 兵庫県: 1, 奈良県: 1, 和歌山県: 1,
鳥取県: 2, 島根県: 2, 岡山県: 2, 広島県: 2, 山口県: 2,
徳島県: 2, 香川県: 2, 愛媛県: 2, 高知県: 2,
福岡県: 2, 佐賀県: 2, 長崎県: 2, 熊本県: 2, 大分県: 2, 宮崎県: 2, 鹿児島県: 2,
沖縄県: 2
  }
end
