# coding: utf-8
require 'spec_helper'

describe "Filter: wish_datetime_format_filter" do
  describe Order::Yahoo do
    before { @order = Order::Yahoo.new([]) }

    it "should set お届け前要電話連絡 as message." do
      @order.stub(:wish_date).and_return(Date.new(2012,12,1))
      @order.stub(:wish_time).and_return("12:00-14:00")
      @order.wish_datetime_format_filter
      @order.notes.should =~ /\[配送日時指定:\]/
      @order.notes.should =~ /2012-12-01\(土\)/
      @order.notes.should =~ /12:00-14:00/
    end
  end
end
