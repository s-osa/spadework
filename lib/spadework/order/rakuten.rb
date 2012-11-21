# coding: utf-8
require 'spadework/order/base'

class Order::Rakuten < Order::Base
  def order_datetime ; DateTime.parse(@arr[2] + " " + @arr[3]) ; end
  def title ; @arr[4] ; end
  def zipcode ; self.arr[28] << "-" << self.arr[29] ; end
  def pref ; @arr[30] ; end
  def wish_date ; @arr[45] =~ /(\d{4})-(\d{2})-(\d{2})\(.\)/ ? Date.new($1.to_i, $2.to_i, $3.to_i) : nil ; end
  def wish_time ; @arr[45] =~ /(\d{1,2}):(\d{2})〜(\d{2}):(\d{2})/ ? "#{$1}:#{$2}-#{$3}:#{$4}" : nil ; end
end
