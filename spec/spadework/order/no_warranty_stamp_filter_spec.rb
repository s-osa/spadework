# coding: utf-8
require 'spec_helper'

describe "Filter: no_warranty_stamp_filter" do
  before { @order = Order::Rakuten.new([]) }

  describe "when ship_destination includes 電" do
    it "should set 【保証書無印】 as direction." do
      @order.stub(:ship_destination).and_return("東京都港区ミナト家電")
      @order.no_warranty_stamp_filter
      @order.direction.should =~ /【保証書無印】/
    end
  end

  describe "when ship_destination includes デン" do
    it "should set 【保証書無印】 as direction." do
      @order.stub(:ship_destination).and_return("東京都渋谷区シブヤデンキ")
      @order.no_warranty_stamp_filter
      @order.direction.should =~ /【保証書無印】/
    end
  end

  describe "when ship_destination includes でん" do
    it "should set 【保証書無印】 as direction." do
      @order.stub(:ship_destination).and_return("東京都品川区でんきの品川")
      @order.no_warranty_stamp_filter
      @order.direction.should =~ /【保証書無印】/
    end
  end

  describe "when ship_destination includes ガーデン" do
    it "should set nothing as direction." do
      @order.stub(:ship_destination).and_return("東京都板橋区ガーデン板橋")
      @order.no_warranty_stamp_filter
      @order.direction.should_not =~ /【保証書無印】/
    end
  end

  describe "when ship_destination includes ガーデン and 電" do
    it "should set 【保証書無印】 as direction." do
      @order.stub(:ship_destination).and_return("東京都豊島区ガーデン電機")
      @order.no_warranty_stamp_filter
      @order.direction.should =~ /【保証書無印】/
    end
  end

  describe "else" do
    it "should set nothing as message." do
      @order.stub(:ship_destination).and_return("東京都港区")
      @order.no_warranty_stamp_filter
      @order.direction.should_not =~ /【保証書無印】/
    end
  end
end
