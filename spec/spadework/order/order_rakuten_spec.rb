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

    it "id" do
      @order.id = "123"
      @order.id.should == "123"
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

  describe "#preorder?" do
    it "should be true when including date in item name." do
      @order.arr[4] = "【大型】【11月13日発送予定】600L冷蔵庫"
      @order.preorder?.should == true
    end

    it "should be false when not including date in item name." do
      @order.arr[4] = "【大型】600L冷蔵庫"
      @order.preorder?.should == false
    end
  end

  describe "#wish_date" do
    it "should return the Date when including a wish date and time." do 
      @order.arr[45] = "[配送日時指定:]\n2012-11-01(木)\n18:00〜20:00"
      @order.wish_date.should == Date.new(2012, 11, 1)
    end

    it "should return the Date when includeing a wish date." do 
      @order.arr[45] = "[配送日時指定:]\n2012-11-01(木)"
      @order.wish_date.should == Date.new(2012, 11, 1)
    end

    it "should return nil when including a wish time." do 
      @order.arr[45] = "[配送日時指定:]\n18:00〜20:00"
      @order.wish_date.should == nil
    end

    it "should return nil when not including a wish date or time." do 
      @order.arr[45] = "[配送日時指定:]"
      @order.wish_date.should == nil
    end
  end

  describe "#wish_time?" do
    it "should be true when including a wish date and time." do 
      @order.arr[45] = "[配送日時指定:]\n2012-11-01(木)\n18:00〜20:00"
      @order.wish_time?.should == true
    end

    it "should be false when includeing a wish date." do 
      @order.arr[45] = "[配送日時指定:]\n2012-11-01(木)"
      @order.wish_time?.should == false
    end

    it "should be true when including a wish time." do 
      @order.arr[45] = "[配送日時指定:]\n18:00〜20:00"
      @order.wish_time?.should == true
    end

    it "should be false when not including a wish date or time." do 
      @order.arr[45] = "[配送日時指定:]"
      @order.wish_time?.should == false
    end
  end

  describe "#shippable_date" do
    it "should return arrival date when including this year date at item name." do
      @order.arr[2], @order.arr[3] = "2012/10/30", "13:48:41"
      @order.arr[4] = "【大型】【12月31日発送予定】600L冷蔵庫"
      @order.shippable_date.should == Date.new(Date.today.year, 12, 31)
    end

    it "should return arrival date when including next year date at item name." do
      @order.arr[2], @order.arr[3] = "2012/10/30", "13:48:41"
      @order.arr[4] = "【大型】【1月01日発送予定】600L冷蔵庫"
      @order.shippable_date.should == Date.new(Date.today.year + 1, 1, 1)
    end

    it "should return today when including no date in item name and ordered before 13:30." do
      @order.arr[2], @order.arr[3] = Time.now.strftime("%Y/%m/%d"), "12:48:41"
      @order.arr[4] = "【大型】600L冷蔵庫"
      @order.shippable_date.should == Date.today
    end

    it "should return tomorrow when including no date in item name and ordered after 15:30." do
      @order.arr[2], @order.arr[3] = Time.now.strftime("%Y/%m/%d"), "15:48:41"
      @order.arr[4] = "【大型】600L冷蔵庫"
      @order.shippable_date.should == Date.today + 1
    end

    it "should return today when including no date in item name and ordered between 13:30 to 15:30 on weekday." do
      Time.stub(:now).and_return(Time.new(2012,11,5,14,30))
      @order.arr[2], @order.arr[3] = Time.now.strftime("%Y/%m/%d"), "14:48:41"
      @order.arr[4] = "【大型】600L冷蔵庫"
      @order.shippable_date.should == Date.today
    end

    it "should return tomorrow when including no date in item name and ordered between 13:30 to 15:30 on holiday." do
      Time.stub(:now).and_return(Time.new(2012,11,3,14,30))
      @order.arr[2], @order.arr[3] = Time.now.strftime("%Y/%m/%d"), "14:48:41"
      @order.arr[4] = "【大型】600L冷蔵庫"
      @order.shippable_date.should == Date.today + 1
    end
  end

  describe "#ship_days" do
    it "should be 1 when Tokyo." do
      @order.arr[30] = "東京都"
      @order.ship_days.should == 1
    end

    it "should be 2 when Hokkaido." do
      @order.arr[30] = "北海道"
      @order.ship_days.should == 2
    end
  end

  describe "#size" do
    it "should be huge when title include [引越]." do
      @order.arr[4] = "SONY Bravia 120V型　送料無料・クレジットカードOK！　[引越]"
      @order.size.should == :huge
    end

    it "should be xlarge when title include [特大]." do
      @order.arr[4] = "SONY Bravia 80V型　送料無料・クレジットカードOK！　[特大]"
      @order.size.should == :xlarge
    end

    it "should be large when title include [大型]." do
      @order.arr[4] = "SONY Bravia 50V型　送料無料・クレジットカードOK！　[大型]"
      @order.size.should == :large
    end

    it "should be regular when title include no tag." do
      @order.arr[4] = "SONY Bravia 24V型　送料無料・クレジットカードOK！"
      @order.size.should == :regular
    end
  end

  describe "#zipcode" do
    it "should be zipcode like 123-4567" do
      @order.arr[28], @order.arr[29] = "123", "4567"
      @order.zipcode.should == "123-4567"
      @order.arr[28], @order.arr[29] = "240", "0067"
      @order.zipcode.should == "240-0067"
    end
  end

  describe "#island?" do
    it "should be true  when zip is 043-1401." do
      @order.arr[28], @order.arr[29] = "043", "1401"
      @order.island?.should == true
      @order.arr[28], @order.arr[29] = "998", "0281"
      @order.island?.should == true
    end

    it "should be false when zip is 000-0000." do
      @order.arr[28], @order.arr[29] = "144", "0052"
      @order.island?.should == false
      @order.arr[28], @order.arr[29] = "240", "0067"
      @order.island?.should == false
    end
  end
end
