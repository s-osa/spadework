# coding: utf-8                                                                                                                             
require 'spec_helper'

describe "Filter: recycle_filter" do
  before { @order = Order::Rakuten.new([]) }

  describe "when item is recycle ticket" do
    it "should set 【リサイクル券】 as direction." do
      @order.stub(:pcode).and_return(["ReCycLE-A"])
      @order.recycle_filter
      @order.direction.should =~ /【リサイクル券】/
    end
  end

  describe "else" do
    it "should set nothing as direction." do
      @order.stub(:pcode).and_return(["ABC-DE01"])
      @order.recycle_filter
      @order.direction.should_not =~ /【リサイクル券】/
    end
  end
end
