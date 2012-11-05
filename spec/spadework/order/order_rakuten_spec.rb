# coding: utf-8
require 'spec_helper'

describe Order::Rakuten do
  before do
    arr = []
    arr[63] = ""
    @order = Order::Rakuten.new(arr)
  end

  describe "#preorder?" do
    it "should be true when including date in item name." do
      @order[4] = "【大型】【11月13日発送予定】600L冷蔵庫"
      @order.preorder?.should == true
    end

    it "should be true when not including date in item name." do
      @order[4] = "【大型】600L冷蔵庫"
      @order.preorder?.should == false
    end
  end

  describe "wish_date?" do
    it "should be true when including a wish date and time." do 
      @order[45] = <<EOS
[配送日時指定:]
2012-11-01(木)
18:00〜20:00
EOS
      @order.wish_date?.should == true
    end

    it "should be true when includeing a wish date." do 
      @order[45] = <<EOS
[配送日時指定:]
2012-11-01(木)
EOS
      @order.wish_date?.should == true
    end

    it "should be true when including a wish time." do 
      @order[45] = <<EOS
[配送日時指定:]
18:00〜20:00
EOS
      @order.wish_date?.should == false
    end

    it "should be true when not including a wish date or time." do 
      @order[45] = <<EOS
[配送日時指定:]
EOS
      @order.wish_date?.should == false
    end
  end

  describe "#wish_date" do
    it "should return Date when including a wish date and time." do 
      @order[45] = <<EOS
[配送日時指定:]
2012-11-01(木)
18:00〜20:00
EOS
      @order.wish_date.should == Date.new(2012, 11, 1)
    end

    it "should return Date when includeing a wish date." do 
      @order[45] = <<EOS
[配送日時指定:]
2012-11-01(木)
EOS
      @order.wish_date.should == Date.new(2012, 11, 1)
    end

    it "should return nil when including a wish time." do 
      @order[45] = <<EOS
[配送日時指定:]
18:00〜20:00
EOS
      @order.wish_date.should == nil
    end

    it "should return nil when not including a wish date or time." do 
      @order[45] = <<EOS
[配送日時指定:]
EOS
      @order.wish_date.should == nil
    end
  end

  describe "#shippable_date" do
    it "should return Date when including date in this year at item name." do
      @order[4] = "【大型】【12月31日発送予定】600L冷蔵庫"
      @order.shippable_date.should == Date.new(Date.today.year, 12, 31)
    end

    it "should return Date when including date in next year at item name." do
      @order[4] = "【大型】【1月01日発送予定】600L冷蔵庫"
      @order.shippable_date.should == Date.new(Date.today.year + 1, 1, 1)
    end

    it "should return nil when not including date in item name." do
      @order[4] = "【大型】600L冷蔵庫"
      @order.shippable_date.should == nil
    end
  end

  describe "#ship_days" do
    it "should be 1 when Tokyo." do
      @order[30] = "東京都"
      @order.ship_days.should == 1
    end

    it "should be 1 when Hokkaido." do
      @order[30] = "北海道"
      @order.ship_days.should == 2
    end
  end
end
