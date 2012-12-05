# coding: utf-8
require 'spec_helper'

describe "Filter: tel_before_delivery_filter" do
  before { @order = Order::Rakuten.new([]) }

  describe "when item is xlarge or large" do
    it "should set お届け前要電話連絡 as message." do
      @order.stub(:size).and_return(:large)
      @order.tel_before_delivery_filter
      @order.message.should =~ /電話連絡/
    end
  end

  describe "else" do
    it "should set nothing as message." do
      @order.stub(:size).and_return(:regular)
      @order.tel_before_delivery_filter
      @order.message.should_not =~ /電話連絡/
    end
  end
end
