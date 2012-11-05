# coding: utf-8
require 'spadework/order/base'

class Order::Rakuten < Order::Base
  def initialize(arr)
    @arr = arr
    @ship_day      = nil
    @delivery_day  = nil
    @ship_way      = nil
    @delivery_time = nil
    @notice        = nil
    @notes         = nil
    @direction     = nil
    @message       = nil
    @warning       = nil
  end

  attr_accessor :ship_day, :delivery_day, :ship_way, :delivery_time, :notice, :notes, :direction, :message, :warning

  def preorder?
    self[4] =~ /【\d{1,2}月\d{1,2}日/ ? true : false
  end

  def wish_date?
    self[45] =~ /\d{4}-\d{2}-\d{2}\(.\)/ ? true : false
  end

  def wish_date
    return nil unless self.wish_date?
    self[45] =~ /(\d{4})-(\d{2})-(\d{2})\(.\)/
    Date.new($1.to_i, $2.to_i, $3.to_i)
  end

  def shippable_date
    return nil unless self.preorder?
    self[4] =~ /【(\d{1,2})月(\d{1,2})日/
    Date.new(Date.today.year, $1.to_i, $2.to_i) > Date.today ? Date.new(Date.today.year, $1.to_i, $2.to_i)
                                                             : Date.new(Date.today.year + 1, $1.to_i, $2.to_i)
  end

  def ship_days
    ShipDaysTo[self[30].to_sym]
  end
end
