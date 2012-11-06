# coding: utf-8
require 'spec_helper'

describe Order::Rakuten do
  before do
    arr = []
    arr[63] = ""
    @order = Order::Rakuten.new(arr)
  end

  describe "#order_datetime" do
    it "should return DateTime." do
      @order[2], @order[3] = "2012/10/30", "13:48:41"
      @order.order_datetime.should == DateTime.new(2012, 10, 30, 13, 48, 41)
      @order[2], @order[3] = "2012/11/01", "13:48:41"
      @order.order_datetime.should == DateTime.new(2012, 11, 1, 13, 48, 41)
    end
  end

  describe "#preorder?" do
    it "should be true when including date in item name." do
      @order[4] = "【大型】【11月13日発送予定】600L冷蔵庫"
      @order.preorder?.should == true
    end

    it "should be false when not including date in item name." do
      @order[4] = "【大型】600L冷蔵庫"
      @order.preorder?.should == false
    end
  end

  describe "#wish_date?" do
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

    it "should be false when including a wish time." do 
      @order[45] = <<EOS
[配送日時指定:]
18:00〜20:00
EOS
      @order.wish_date?.should == false
    end

    it "should be false when not including a wish date or time." do 
      @order[45] = <<EOS
[配送日時指定:]
EOS
      @order.wish_date?.should == false
    end
  end

  describe "#wish_date" do
    it "should return the Date when including a wish date and time." do 
      @order[45] = <<EOS
[配送日時指定:]
2012-11-01(木)
18:00〜20:00
EOS
      @order.wish_date.should == Date.new(2012, 11, 1)
    end

    it "should return the Date when includeing a wish date." do 
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
    it "should return arrival date when including this year date at item name." do
      @order[2], @order[3] = "2012/10/30", "13:48:41"
      @order[4] = "【大型】【12月31日発送予定】600L冷蔵庫"
      @order.shippable_date.should == Date.new(Date.today.year, 12, 31)
    end

    it "should return arrival date when including next year date at item name." do
      @order[2], @order[3] = "2012/10/30", "13:48:41"
      @order[4] = "【大型】【1月01日発送予定】600L冷蔵庫"
      @order.shippable_date.should == Date.new(Date.today.year + 1, 1, 1)
    end

    it "should return today when including no date in item name and ordered before 13:30." do
      @order[2], @order[3] = Time.now.strftime("%Y/%m/%d"), "12:48:41"
      @order[4] = "【大型】600L冷蔵庫"
      @order.shippable_date.should == Date.today
    end

    it "should return tomorrow when including no date in item name and ordered after 15:30." do
      @order[2], @order[3] = Time.now.strftime("%Y/%m/%d"), "15:48:41"
      @order[4] = "【大型】600L冷蔵庫"
      @order.shippable_date.should == Date.today + 1
    end

    it "should return today when including no date in item name and ordered between 13:30 to 15:30 on weekday." do
      pending("Today is holiday.") if Date4.parse(Time.now.to_s).national_holiday?
      @order[2], @order[3] = Time.now.strftime("%Y/%m/%d"), "14:48:41"
      @order[4] = "【大型】600L冷蔵庫"
      @order.shippable_date.should == Date.today
    end

    it "should return tomorrow when including no date in item name and ordered between 13:30 to 15:30 on holiday." do
      pending("Today is weekday.") unless Date4.parse(Time.now.to_s).national_holiday?
      @order[2], @order[3] = Time.now.strftime("%Y/%m/%d"), "14:48:41"
      @order[4] = "【大型】600L冷蔵庫"
      @order.shippable_date.should == Date.today + 1
    end
  end

  describe "#ship_days" do
    it "should be 1 when Tokyo." do
      @order[30] = "東京都"
      @order.ship_days.should == 1
    end

    it "should be 2 when Hokkaido." do
      @order[30] = "北海道"
      @order.ship_days.should == 2
    end
  end
end
