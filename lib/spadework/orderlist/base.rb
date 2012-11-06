# coding: utf-8

require 'csv'

class OrderList::Base < Array
  attr_accessor :header, :orders  
  def size
    self.orders.size + 1
  end
end
