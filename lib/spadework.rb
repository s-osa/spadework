# coding: utf-8
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'spadework/order'
require 'spadework/orderlist'

require 'csv'

ImportDir = File.dirname(File.expand_path(__FILE__)) + "/../"
Stores    = ["maido"] #, "amazon", "plus", "yahoo"]

Dir.chdir ImportDir

Stores.each do |store|
  dir = File.expand_path(ImportDir + store)
  Dir.glob("#{dir}/*").each do |path|
    orderlist = OrderList.new(path)
=begin
    orderlist.orders.each do |order|
      p order.to_s
      order.shipping_date = order.shippable_date
    end
    p "==========================================="
    orderlist.orders.each do |order|
      p order.to_s
    end
=end
  end
end

