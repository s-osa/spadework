# coding: utf-8
require 'spec_helper'

describe "Filter: set_carrier_filter" do
  before do
    @order = Order::Rakuten.new([])
  end

  describe "when multi items order in yahoo" do
    it "should set nothing as carrier." do
      @order.domestic_notes = "[複数]"
      @order.set_carrier_filter
      @order.carrier.should == ""
    end
  end

  describe "when size of item is huge" do
    it "should set ヤマトHC as carrier." do
      @order.stub(:size).and_return(:huge)
      @order.set_carrier_filter
      @order.carrier.should == "ヤマトHC"
      @order.domestic_notes.should =~ /\[引越\]/
    end
  end

  describe "when deliver to island" do
    before do
      @order.stub(:island?).and_return(true)
    end

    it "should set ヤマト便 as carrier, 離島大型 as domestic_notes." do
      @order.stub(:size).and_return(:xlarge)
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト便"
      @order.domestic_notes.should =~ /\[離島大型\]/
    end

    it "should set ヤマト運輸 as carrier, 離島 as domestic_notes." do
      @order.stub(:size).and_return(:regular)
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト運輸"
      @order.domestic_notes.should =~ /\[離島\]/
    end
  end

  describe "when size is xlarge" do
    before do
      @order.stub(:island?).and_return(false)
      @order.stub(:size).and_return(:xlarge)
    end

    it "should set ヤマト便 as carrier." do
      @order.stub(:wish_time).and_return(false)
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト便"
      @order.domestic_notes.should_not =~ /\[時間指定不可\]/
    end

    it "should set ヤマト便 as carrier, 時間指定不可 as wish_time if wish_time." do
      @order.stub(:wish_time).and_return(true)
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト便"
      @order.domestic_notes.should =~ /\[時間指定不可\]/
    end
  end

  describe "when ship to Chugoku, Shikoku, Aomori or Wakayama." do
    before do
      @order.stub(:island?).and_return(false)
      @order.stub(:pref).and_return("鳥取県")
    end

    it "should set ヤマト便 as carrier." do
      @order.stub(:size).and_return(:large)
      @order.stub(:wish_time).and_return(false)
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト便"
      @order.domestic_notes.should_not =~ /\[時間指定\]/
    end

    it "should set ヤマト便 as carrier, 時間指定不可 as wish_time if wish_time." do
      @order.stub(:size).and_return(:large)
      @order.stub(:wish_time).and_return(true)
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト便"
      @order.domestic_notes.should =~ /\[時間指定不可\]/
    end

    it "should set ヤマト運輸 as carrier." do
      @order.stub(:size).and_return(:regular)
      @order.stub(:wish_time).and_return(false)
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト運輸"
      @order.domestic_notes.should_not =~ /\[時間指定\]/
    end

    it "should set ヤマト運輸 as carrier, 時間指定可？ as alert if wish_time before 16." do
      @order.stub(:size).and_return(:regular)
      @order.stub(:wish_time).and_return("14:00-16:00")
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト運輸"
      @order.domestic_notes.should =~ /\[時間指定可？\]/
    end

    it "should set ヤマト運輸 as carrier if wish_time after 16." do
      @order.stub(:size).and_return(:regular)
      @order.stub(:wish_time).and_return("16:00-18:00")
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト運輸"
      @order.domestic_notes.should_not =~ /\[時間指定可？\]/
    end
  end

  describe "when no wish_date." do
    it "should set 佐川急便 as carrier." do
      @order.stub(:size).and_return(:large)
      @order.stub(:island?).and_return(false)
      @order.stub(:pref).and_return("東京都")
      @order.stub(:wish_date).and_return(nil)
      @order.set_carrier_filter
      @order.carrier.should == "佐川急便"
    end
  end

  describe "when 2 days or more to wish_date." do
    it "should set 佐川急便 as carrier." do
      @order.stub(:size).and_return(:large)
      @order.stub(:island?).and_return(false)
      @order.stub(:pref).and_return("東京都")
      @order.stub(:shippable_date).and_return(Date.today)
      @order.stub(:wish_date).and_return(Date.today+4)
      @order.set_carrier_filter
      @order.carrier.should == "佐川急便"
    end
  end

  describe "when else." do
    before do
      @order.stub(:island?).and_return(false)
      @order.stub(:shippable_date).and_return(Date.today)
      @order.stub(:wish_date).and_return(Date.today+1)
      @order.stub(:pref).and_return("東京都")
    end

    it "should set ヤマト便 as carrier." do
      @order.stub(:size).and_return(:large)
      @order.stub(:wish_time).and_return(nil)
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト便"
      @order.domestic_notes.should_not =~ /\[時間指定\]/
    end

    it "should set ヤマト便 as carrier, 時間指定不可 as wish_time if wish_time." do
      @order.stub(:size).and_return(:large)
      @order.stub(:wish_time).and_return("12:00-14:00")
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト便"
      @order.domestic_notes.should =~ /\[時間指定不可\]/
    end

    it "should set ヤマト運輸 as carrier." do
      @order.stub(:size).and_return(:regular)
      @order.stub(:wish_time).and_return(nil)
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト運輸"
      @order.domestic_notes.should_not =~ /\[時間指定[^\]]+\]/
    end

    it "should set ヤマト運輸 as carrier, 時間指定可？ as wish_time if wish_time before 16." do
      @order.stub(:size).and_return(:regular)
      @order.stub(:wish_time).and_return("12:00-14:00")
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト運輸"
      @order.domestic_notes.should_not =~ /\[時間指定可？\]/
    end

    it "should set ヤマト運輸 as carrier if wish_time after 16." do
      @order.stub(:size).and_return(:regular)
      @order.stub(:wish_time).and_return("16:00-18:00")
      @order.set_carrier_filter
      @order.carrier.should == "ヤマト運輸"
      @order.domestic_notes.should_not =~ /\[時間指定可？\]/
    end
  end
end
