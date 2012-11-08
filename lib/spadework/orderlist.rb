# coding: utf-8

class OrderList < Array
end

require 'spadework/orderlist/base'
require 'spadework/orderlist/rakuten'

class OrderList < Array
  attr_accessor :path, :type, :header, :orders  

  def initialize(path)
    @path = path
    if @path =~ /\d{10,10}.txt/
#      @type = Order::Amazon
    elsif @path =~ /rakuten/
      @type = Order::Rakuten
    elsif @path =~ /default_all_orders/
#      @time = Order::Yahoo
    end
    reader = CSV.open(@path, "r:windows-31j")
    @header = reader.shift.map { |col| col.to_s.encode("utf-8") }
    @orders = reader.map{ |row| @type.new(row.map{|col| col.to_s.encode("utf-8") }) }
  end

  def inspect
    [@path, @type, @header, @orders]
  end

  def size
    self.orders.size + 1
  end
end
