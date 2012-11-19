# coding: utf-8
require 'date'
require 'date4'
require 'date4/holiday'

class Order::Base < Array
  ShipDaysTo = {
    "北海道" => 2,
    "青森県" => 1, "岩手県" => 1, "宮城県" => 1, "秋田県" => 1, "山形県" => 1, "福島県" => 1,
    "茨城県" => 1, "栃木県" => 1, "群馬県" => 1, "埼玉県" => 1, "千葉県" => 1, "東京都" => 1, "神奈川県" => 1,
    "新潟県" => 1, "富山県" => 1, "石川県" => 1, "福井県" => 1, "山梨県" => 1, "長野県" => 1,
    "岐阜県" => 1, "静岡県" => 1, "愛知県" => 1, "三重県" => 1,
    "滋賀県" => 1, "京都府" => 1, "大阪府" => 1, "兵庫県" => 1, "奈良県" => 1, "和歌山県" => 1,
    "鳥取県" => 2, "島根県" => 2, "岡山県" => 2, "広島県" => 2, "山口県" => 2,
    "徳島県" => 2, "香川県" => 2, "愛媛県" => 2, "高知県" => 2,
    "福岡県" => 2, "佐賀県" => 2, "長崎県" => 2, "熊本県" => 2, "大分県" => 2, "宮崎県" => 2, "鹿児島県" => 2,
    "沖縄県" => 2
  }

  @@islands_zip = []
  File.open("lib/spadework/data/islands.txt") do |file|
    file.each_line{|line| @@islands_zip << line.strip}
  end

  attr_accessor :arr, :id,
                :status, :shipping_date, :delivery_date, :carrier, :delivery_time,
                :notes, :domestic_notes, :direction, :message, :warning

  def initialize(arr)
    @arr  = arr
    @id ||= arr[0]

    @status         ||= ""
    @shipping_date  ||= ""
    @delivery_date  ||= ""
    @carrier        ||= ""
    @delivery_time  ||= ""
    @notes          ||= ""
    @domestic_notes ||= ""
    @direction      ||= ""
    @message        ||= ""
    @warning        ||= ""
  end

  def inspect
    "<#{self.class}: >"
  end

  def to_s
    self.to_a
  end

  def to_a
    @arr + [
      @status,
      @shipping_date,
      @delivery_date,
      @carrier,
      @delivery_time,
      @notes,
      @domestic_notes,
      @direction,
      @message,
      @warning
    ]
  end

  def island?
    @@islands_zip.include? self.zipcode
  end

  def set_schedule_filter
    if ! self.wish_date?
      @shipping_date = self.shippable_date.strftime("%Y/%m/%d")
      @delivery_date = (self.shippable_date + self.ship_days).strftime("%Y/%m/%d")
    elsif self.wish_date >= self.shippable_date + 3
      @shipping_date = (self.wish_date - 3 ).strftime("%Y/%m/%d")
      @delivery_date = self.wish_date.strftime("%Y/%m/%d")
    elsif self.wish_date >= self.shippable_date + self.ship_days
      @shipping_date = self.shippable_date.strftime("%Y/%m/%d")
      @delivery_date = self.wish_date.strftime("%Y/%m/%d")
    else
      @shipping_date = self.shippable_date.strftime("%Y/%m/%d")
      @delivery_date = (self.shippable_date + self.ship_days).strftime("%Y/%m/%d")
      alert "[希望日不可]"
    end
  end

protected
  def alert(str)
    @domestic_notes << str
  end

  def info(str)
    @warning << str
  end
end

