# coding: utf-8
require 'spec_helper'

describe Order::Rakuten do
  describe "#preorder?" do
    before do
      arr = []
      arr[63] = ""
      @order = Order::Rakuten.new(arr)
    end

    it "should be true when including date in item name." do
      @order[4] = "【大型】【11月13日発送予定】600L冷蔵庫"
      @order.preorder?.should == true
    end

    it "should be true when not including date in item name." do
      @order[4] = "【大型】600L冷蔵庫"
      @order.preorder?.should == false
    end
  end

end
