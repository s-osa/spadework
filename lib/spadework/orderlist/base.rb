# coding: utf-8

require 'csv'

class OrderList::Base < Array
  attr_accessor :header, :orders  

  def initialize(path, klass)
    reader = CSV.open(path, "r:windows-31j")
    @header = reader.shift.map { |col| col.to_s.encode("utf-8") }
    @orders = reader.map { |row| klass.new(row.map { |col| col.to_s.encode("utf-8") } ) }
  end

  def size
    self.orders.size + 1
  end
end
