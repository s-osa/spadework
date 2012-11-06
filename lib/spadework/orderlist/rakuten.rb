# coding: utf-8

class OrderList::Rakuten < OrderList::Base
  def initialize(path)
    reader = CSV.open(path, "r:windows-31j")
    @header = reader.shift.map { |col| col.to_s.encode("utf-8") }
    @orders = reader.map { |row| Order::Rakuten.new(row.map { |col| col.to_s.encode("utf-8") } ) }
  end
end
