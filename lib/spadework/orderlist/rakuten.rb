# coding: utf-8

class OrderList::Rakuten < OrderList::Base
  def initialize(path)
    super(path, Order::Rakuten)
  end
end
