# coding: utf-8
require 'spadework/order/base'

class Order::Rakuten < Order::Base
  def pref
    @arr[30]
  end

  def order_datetime
    DateTime.parse(@arr[2] + " " + @arr[3])
  end

  def preorder?
    @arr[4] =~ /【\d{1,2}月\d{1,2}日/ ? true : false
  end

  def wish_date
    return nil unless @arr[45] =~ /\d{4}-\d{2}-\d{2}\(.\)/
    @arr[45] =~ /(\d{4})-(\d{2})-(\d{2})\(.\)/
    Date.new($1.to_i, $2.to_i, $3.to_i)
  end

  def wish_time?
    @arr[45] =~ /\d{1,2}:\d{2}〜\d{2}:\d{2}/ ? true : false
  end

  def shippable_date
    if self.preorder?
      @arr[4] =~ /【(\d{1,2})月(\d{1,2})日/
      Date.new(Date.today.year, $1.to_i, $2.to_i) > Date.today ? Date.new(Date.today.year, $1.to_i, $2.to_i)
                                                               : Date.new(Date.today.year + 1, $1.to_i, $2.to_i)
    elsif self.order_datetime < DateTime.new(Time.now.year, Time.now.month, Time.now.day, 13, 30)
      Date.today
    elsif self.order_datetime > DateTime.new(Time.now.year, Time.now.month, Time.now.day, 15, 30)
      Date.today + 1
    else
      Date4.parse(self.order_datetime.to_s).national_holiday? ? Date.today + 1 : Date.today
    end
  end

  def ship_days
    ShipDaysTo[self.pref]
  end

  def size
    return :huge    if self.arr[4] =~ /\[引越\]/
    return :xlarge  if self.arr[4] =~ /\[特大\]/
    return :large   if self.arr[4] =~ /\[大型\]/
    return :regular
  end

  def zipcode
    self.arr[28] << "-" << self.arr[29]
  end
end
