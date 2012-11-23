# coding: utf-8
require 'date'
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
  File.open("lib/spadework/data/islands.txt"){ |file| file.each_line{|line| @@islands_zip << line.strip} }

  attr_accessor :arr,:status,:shipping_date,:delivery_date,:carrier,:delivery_time,:notes,:domestic_notes,:direction,:message,:warning

  def initialize(arr)
    @arr  = arr
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

  def inspect ; "<#{self.class}: >" ; end
  def to_s    ; self.to_a           ; end

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

  def island? ; @@islands_zip.include? self.zipcode ; end
  def ship_days ; ShipDaysTo[self.pref] ; end

  def size
    return :huge    if self.title =~ /\[引越\]/
    return :xlarge  if self.title =~ /\[特大\]/
    return :large   if self.title =~ /\[大型\]/
    return :regular
  end

  def arrival_date
    Date.new(Date.today.year+($1.to_i >= Date.today.month ? 0 : 1), $1.to_i, $2.to_i) if self.title =~ /【(\d{1,2})月(\d{1,2})日/
  end

  def shippable_date
    if self.arrival_date
      self.arrival_date
    elsif self.order_datetime < DateTime.new(Time.now.year, Time.now.month, Time.now.day, 13, 30)
      Date.today
    elsif self.order_datetime > DateTime.new(Time.now.year, Time.now.month, Time.now.day, 15, 30)
      Date.today + 1
    else
      Date4.parse(self.order_datetime.to_s).national_holiday? ? Date.today + 1 : Date.today
    end
  end

  def payment_method(str)
    if str =~ /カード/ || str =~ /Card/ || str.empty?
      :card
    elsif str =~ /代金引換/ || str =~ /COD/
      :cod
    else
      :other
    end
  end

  def memo ; "" ; end

#### Filters ####

  def set_schedule_filter
    if ! self.wish_date
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

  def set_carrier_filter
    if  self.size == :huge
      @carrier = "ヤマトHC" ; alert "[引越]"
    elsif self.island?
      @carrier = (self.size == :xlarge) ? "ヤマト便" : "ヤマト運輸"
      alert self.size == :xlarge ? "[離島大型]" : "[離島]"
    elsif self.size == :xlarge
      self.set_yamato
    elsif %w(鳥取県 島根県 岡山県 広島県 山口県 香川県 徳島県 愛媛県 高知県 青森県 和歌山県).include? self.pref
      self.set_yamato
    elsif self.wish_date.nil? || self.wish_date >= self.shippable_date + 2
      @carrier = "佐川急便"
    else
      self.set_yamato
    end
  end

  def set_status_filter
    return if self.payment_method != :card && self.payment_method != :cod
    if (self.domestic_notes + self.memo + self.demand).empty?
      @status = "出荷準備OK"
    else
      alert "domestic_notes #{self.domestic_notes}" unless self.domestic_notes.empty?
      alert "memo #{self.memo}" unless self.memo.empty?
      alert "demand #{self.demand}" unless self.demand.empty?
      @status = "確認待"
    end
  end

protected
  def alert(str) ; @domestic_notes << str ; end
  def info(str)  ; @warning << str        ; end

  def set_yamato
    if self.size == :xlarge || self.size == :large
      @carrier = "ヤマト便"
      alert "[時間指定不可]" if self.wish_time
    elsif self.size == :regular
      @carrier = "ヤマト運輸"
      alert "[時間指定可？]" if self.wish_time
    end
  end
end

