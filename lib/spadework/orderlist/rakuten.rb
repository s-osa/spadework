# coding: utf-8

class OrderList::Rakuten < OrderList::Base
  def initialize(path)
    @arr ||= []
    CSV.foreach(path,"r:windows-31j") do |row|
      @arr << row.map { |col| col.to_s.encode("utf-8") }
    end
  end

  def size
    @arr.size
  end

  def header
    @arr[0]
  end

  def orders
    @arr[1..-1]
  end
end
