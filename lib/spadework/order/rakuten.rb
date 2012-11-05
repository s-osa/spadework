# coding: utf-8
#require 'order/base'

class Order::Rakuten < Order::Base
  def initialize(arr)
    @arr = arr
  end

  def preorder?
    self[4] =~ /【[0-9０-９]{1,2}月[0-9０-９]{1,2}日/ ? true : false
  end
end
