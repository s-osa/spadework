# coding: utf-8
require 'spec_helper'

describe Order::Rakuten do
  before do
    arr = []
    arr[63] = ""
    @order = Order::Rakuten.new(arr)
  end

  describe "Accessors for optional attribute" do
    it "arr" do
      @order.arr = ["123", "456"]
      @order.arr.size.should == 2
    end

    it "status" do
      @order.status = "ロジテム"
      @order.status.should == "ロジテム"
    end

    it "shipping_date" do
      @order.shipping_date = "2012/11/1"
      @order.shipping_date.should == "2012/11/1"
    end

    it "delivery_date" do
      @order.delivery_date = "2012/11/2"
      @order.delivery_date.should == "2012/11/2"
    end

    it "carrier" do
      @order.carrier = "ヤマト運輸"
      @order.carrier.should == "ヤマト運輸"
    end

    it "delivery_time" do
      @order.delivery_time = "12:00-14:00"
      @order.delivery_time.should == "12:00-14:00"
    end

    it "notes" do
      @order.notes = "備考欄"
      @order.notes.should == "備考欄"
    end

    it "domestic_notes" do
      @order.domestic_notes = "社内備考"
      @order.domestic_notes.should == "社内備考"
    end

    it "warning" do
      @order.warning = "警告\n"
      @order.warning.should == "警告\n"
    end
  end

  describe "#order_datetime" do
    it "should return DateTime." do
      @order.arr[2], @order.arr[3] = "2012/10/30", "13:48:41"
      @order.order_datetime.should == DateTime.new(2012, 10, 30, 13, 48, 41)
      @order.arr[2], @order.arr[3] = "2012/11/01", "13:48:41"
      @order.order_datetime.should == DateTime.new(2012, 11, 1, 13, 48, 41)
    end
  end

  describe "#title" do
    it "should return title of item." do
      @order.arr[4] = "商品名"
      @order.title.should == "商品名"
    end
  end

  describe "#zipcode" do
    it "should be zipcode like 123-4567" do
      @order.arr[28], @order.arr[29] = "012", "0345"
      @order.zipcode.should == "012-0345"
    end
  end

  describe "#pref" do
    it "should return prefecture." do
      @order.arr[30] = "東京都"
      @order.pref.should == "東京都"
    end
  end

  describe "#payment_method" do
    it "should be card" do 
      @order.arr[37] = "クレジットカード"
      @order.payment_method.should == :card
    end
  end

  describe "#wish_date" do
    it "should return the Date when including a wish date and time." do 
      @order.arr[45] = "[配送日時指定:]\n2012-11-01(木)\n18：00〜20：00"
      @order.wish_date.should == Date.new(2012, 11, 1)
    end

    it "should return the Date when includeing a wish date." do 
      @order.arr[45] = "[配送日時指定:]\n2012-11-01(木)"
      @order.wish_date.should == Date.new(2012, 11, 1)
    end

    it "should return nil when including a wish time." do 
      @order.arr[45] = "[配送日時指定:]\n18：00〜20：00"
      @order.wish_date.should == nil
    end

    it "should return nil when not including a wish date or time." do 
      @order.arr[45] = "[配送日時指定:]"
      @order.wish_date.should == nil
    end
  end

  describe "#wish_time" do
    it "should be String like 18:00-20:00 when including a wish date and time." do 
      @order.arr[45] = "[配送日時指定:]\n2012-11-01(木)\n18：00〜20：00"
      @order.wish_time.should == "18:00-20:00"
    end

    it "should be nil when includeing a wish date." do 
      @order.arr[45] = "[配送日時指定:]\n2012-11-01(木)"
      @order.wish_time.should == nil
    end

    it "should be String like 18:00-20:00 when including a wish time." do 
      @order.arr[45] = "[配送日時指定:]\n18：00〜20：00"
      @order.wish_time.should == "18:00-20:00"
    end

    it "should be String like 午前 when including a wish time in am." do 
      @order.arr[45] = "[配送日時指定:]\n午前"
      @order.wish_time.should == "午前"
    end

    it "should be String like 最終便(19：00以降) when including a wish time as latest time." do 
      @order.arr[45] = "[配送日時指定:]\n最終便(19：00以降)"
      @order.wish_time.should == "最終便(19：00以降)"
    end

    it "should be nil when not including a wish date or time." do 
      @order.arr[45] = "[配送日時指定:]"
      @order.wish_time.should == nil
    end
  end

  describe "#demand" do
    it "should be string if something written." do 
      @order.arr[45] = "[配送日時指定:]\n2012-11-01(木)\n18：00〜20：00\n領収書希望"
      @order.demand.should == "領収書希望"
    end

    it "should be blank if nothing written." do 
      @order.arr[45] = "[配送日時指定:]\n2012-11-01(木)\n18：00〜20：00\n"
      @order.demand.should == ""
    end
  end

  describe "#memo" do
    it "should be memo when something written." do
      @order.arr[63] = "ピンク注文"
      @order.memo.should == "ピンク注文"
    end

    it "should be nil when nothing written." do
      @order.arr[63] = nil
      @order.memo.should == ""
    end
  end
end
