# coding: utf-8                                                                                                                             
require 'spec_helper'

describe "Filter: house_number_filter" do
  before { @order = Order::Rakuten.new([]) }

  describe "when order has no house number" do
    it "should set [番地無し] as alert." do
      @order.stub(:ship_address).and_return("東京都大田区蒲田")
      @order.house_number_filter
      @order.domestic_notes.should =~ /\[番地無し\]/
    end
  end

  describe "else" do
    it "should set nothing as alert." do
      @order.stub(:ship_address).and_return("東京都大田区蒲田4-41-9")
      @order.house_number_filter
      @order.domestic_notes.should_not =~ /\[番地無し\]/
    end
  end
end
