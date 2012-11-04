# coding: utf-8
require 'order/base'

module Order
g  class Rakuten < Order::Base
    def initialize(arr)
      @shipping_date = arr[]
      @pref          = arr[]
    end

    def shipping_date
    end

    def shipping_date=
    end

  end
end
