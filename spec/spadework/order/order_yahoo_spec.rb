# coding: utf-8
require 'spec_helper'

describe Order::Yahoo do
  before do
    arr = []
    arr[63] = ""
    @order = Order::Yahoo.new(arr)
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
      @order.arr[5] = "2012/10/30 13:48"
      @order.order_datetime.should == DateTime.new(2012, 10, 30, 13, 48)
      @order.arr[5] = "2012/11/01 13:48"
      @order.order_datetime.should == DateTime.new(2012, 11, 1, 13, 48)
    end
  end

  describe "#title" do
    it "should return title of item." do
      pending "fxxk yahoo!"
      @order.arr[0] = ""
      @order.title.should == ""
    end
  end

  describe "#pcode" do
    it "should return product code of item." do
      Order::Yahoo.items = [["123","1","1","ABC-DE01"], ["123","2","3","ABC-DE02"]]
      @order.arr[0] = "123"
      @order.pcode.should == ["ABC-DE01", "ABC-DE02"]
    end
  end

  describe "#zipcode" do
    it "should be zipcode like 123-4567" do
      @order.arr[13] = "012-0345"
      @order.zipcode.should == "012-0345"
    end
  end

  describe "#pref" do
    it "should return prefecture." do
      @order.arr[11] = "東京都"
      @order.pref.should == "東京都"
    end
  end

  describe "#ship_name" do
    it "should be name." do
      @order.arr[7] = "鈴木一郎"
      @order.ship_name.should == "鈴木一郎"
    end
  end

  describe "#ship_address" do
    it "should be address." do
      @order.arr[8] = "蒲田1000-100-10"
      @order.arr[9] = ""
      @order.arr[10] = "大田区"
      @order.arr[11] = "東京都"
      @order.ship_address.should == "東京都大田区蒲田1000-100-10"
    end
  end

  describe "#payment_method" do
    it "should be card" do 
      @order.arr[57] = "クレジットカード"
      @order.payment_method.should == :card
    end
  end

  describe "#wish_date" do
    it "should return the Date when including a wishdate." do 
      @order.arr[53] = "2012年11月1日"
      @order.wish_date.should == Date.new(2012, 11, 1)
    end

    it "should return nil when not including a wish date or time." do 
      @order.arr[53] = "お届け日指定なし"
      @order.wish_date.should == nil
    end
  end

  describe "#wish_time" do
    it "should be String like 9:00-12:00 when it includds a wishtime." do 
      @order.arr[54] = "9:00〜12:00"
      @order.wish_time.should == "9:00-12:00"
    end

    it "should be nil when it does not include wish time." do 
      @order.arr[54] = "時間指定なし"
      @order.wish_time.should == nil
    end
  end

  describe "#demand" do
    it "should be string if something written." do 
      @order.arr[34] = "領収書希望"
      @order.demand.should == "領収書希望"
    end

    it "should be blank if nothing written." do 
      @order.arr[34] = ""
      @order.demand.should == ""
    end
  end

  describe "#memo" do
    it "should be nil." do
      @order.memo.should == ""
    end
  end
end
