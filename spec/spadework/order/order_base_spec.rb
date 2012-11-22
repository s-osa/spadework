# coding: utf-8
require 'spec_helper'

describe Order::Base do
  before { @order = Order::Rakuten.new([]) }

  describe "#island?" do
    it "should be true  when zip is 043-1401." do
      @order.stub(:zipcode).and_return("998-0281")
      @order.island?.should == true
    end

    it "should be false when zip is 240-0067." do
      @order.stub(:zipcode).and_return("240-0067")
      @order.island?.should == false
    end
  end

  describe "#ship_days" do
    it "should be 1 when Tokyo." do
      @order.stub(:pref).and_return("東京都")
      @order.ship_days.should == 1
    end

    it "should be 2 when Hokkaido." do
      @order.stub(:pref).and_return("北海道")
      @order.ship_days.should == 2
    end
  end

  describe "#size" do
    it "should be huge when title include [引越]." do
      @order.stub(:title).and_return("SONY Bravia 120V型　送料無料・クレジットカードOK！　[引越]")
      @order.size.should == :huge
    end

    it "should be xlarge when title include [特大]." do
      @order.stub(:title).and_return("SONY Bravia 120V型　送料無料・クレジットカードOK！　[特大]")
      @order.size.should == :xlarge
    end

    it "should be large when title include [大型]." do
      @order.stub(:title).and_return("SONY Bravia 120V型　送料無料・クレジットカードOK！　[大型]")
      @order.size.should == :large
    end

    it "should be regular when title include no tag." do
      @order.stub(:title).and_return("SONY Bravia 24V型　送料無料・クレジットカードOK！")
      @order.size.should == :regular
    end
  end
 
  describe "#arrival_date" do
    before { Date.stub(:today).and_return(Date.new(2012,10,10)) }

    it "should be Date when title include arrival date." do
      @order.stub(:title).and_return("【12月12日入荷予定】テレビ")
      @order.arrival_date.should == Date.new(2012,12,12)
    end

    it "should be Date on next year when title include arrival date on next year." do
      @order.stub(:title).and_return("【2月12日入荷予定】テレビ")
      @order.arrival_date.should == Date.new(2013,2,12)
    end

    it "should be nil when title does not include arrival date." do
      @order.stub(:title).and_return("テレビ")
      @order.arrival_date.should == nil
    end
  end

  describe "#shippable_date" do
    describe "when include date at item name" do
      it "should be arrival date in the future." do
        @order.arr[2], @order.arr[3] = "2012/10/30", "13:48:41"
        @order.arr[4] = "【大型】【12月31日発送予定】600L冷蔵庫"
        @order.shippable_date.should == Date.new(Date.today.year, 12, 31)
        @order.arr[2], @order.arr[3] = "2012/10/30", "13:48:41"
        @order.arr[4] = "【大型】【1月01日発送予定】600L冷蔵庫"
        @order.shippable_date.should == Date.new(Date.today.year + 1, 1, 1)
      end
    end

    describe "when include no date at item name" do
      it "should be today if ordered before 13:30." do
        @order.arr[2], @order.arr[3] = Time.now.strftime("%Y/%m/%d"), "12:48:41"
        @order.arr[4] = "【大型】600L冷蔵庫"
        @order.shippable_date.should == Date.today
      end

      it "should be today if ordered between 13:30 to 15:30 on weekday." do
        Time.stub(:now).and_return(Time.new(2012,11,5,14,30))
        @order.arr[2], @order.arr[3] = Time.now.strftime("%Y/%m/%d"), "14:48:41"
        @order.arr[4] = "【大型】600L冷蔵庫"
        @order.shippable_date.should == Date.today
      end

      it "should be tomorrow and ordered after 15:30." do
        @order.arr[2], @order.arr[3] = Time.now.strftime("%Y/%m/%d"), "15:48:41"
        @order.arr[4] = "【大型】600L冷蔵庫"
        @order.shippable_date.should == Date.today + 1
      end

      it "should be tomorrow when and ordered between 13:30 to 15:30 on holiday." do
        Time.stub(:now).and_return(Time.new(2012,11,3,14,30))
        @order.arr[2], @order.arr[3] = Time.now.strftime("%Y/%m/%d"), "14:48:41"
        @order.arr[4] = "【大型】600L冷蔵庫"
        @order.shippable_date.should == Date.today + 1
      end
    end
  end

  describe "#payment_method" do
    before { @order = Order::Base.new([]) }

    it "should be card when argument includes string like カード." do
      @order.payment_method("クレジットカード").should == :card
      @order.payment_method("YahooCreditCardSettle").should == :card
      @order.payment_method("").should == :card
    end

    it "should be cod when argument includes string like 代金引換." do
      @order.payment_method("代金引換").should == :cod
      @order.payment_method("代金引換（代引き）").should == :cod
      @order.payment_method("COD").should == :cod
    end

    it "should be other when argument does not includes something like above." do
      @order.payment_method("銀行振込").should == :other
      @order.payment_method("銀行振込（前払い）").should == :other
      @order.payment_method("NT_CVS_Seven").should == :other
    end
  end
end
