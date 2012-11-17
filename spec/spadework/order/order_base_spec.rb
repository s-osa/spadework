# coding: utf-8
require 'spec_helper'

describe Order::Base do
  before do
#    arr = []
#    arr[63] = ""
#    @order = Order::Rakuten.new(arr)
  end

  describe "#set_schedule" do
    before do
      @order = Order::Rakuten.new([])
      @order.stub(:shippable_date).and_return(Date.new(2012,11,1))
      @order.stub(:ship_days).and_return(2)
    end

    describe "when no wish_date" do
      before do
        @order.stub(:wish_date?).and_return(false)
        @order.set_schedule_filter
      end

      it "should set shippable_date as shipping_date." do
        @order.shipping_date.should == "2012/11/01"
      end

      it "should set shippable_date + ship_days as delivery_date." do
        @order.delivery_date.should == "2012/11/03"
      end
    end

    describe "when wish_date is later than 3 days" do
      before do
        @order.stub(:wish_date?).and_return(true)
        @order.stub(:wish_date).and_return(Date.new(2012,11,20))
        @order.set_schedule_filter
      end

      it "should set wish_date - 3 days as shipping_date." do
        @order.shipping_date.should == "2012/11/17"
      end

      it "should set wishdate as delivery_date." do
        @order.delivery_date.should == "2012/11/20"
      end
    end

    describe "when wish_date is in 2days" do
      before do
        @order.stub(:wish_date?).and_return(true)
        @order.stub(:wish_date).and_return(Date.new(2012,11,3))
        @order.set_schedule_filter
      end

      it "should set shippable_date as shipping_date." do
        @order.shipping_date.should == "2012/11/01"
      end

      it "should set wish_date as delivery_date." do
        @order.delivery_date.should == "2012/11/03"
      end
    end

    describe "when wish_date is too close" do
      before do
        @order.stub(:wish_date?).and_return(true)
        @order.stub(:wish_date).and_return(Date.new(2012,11,2))
        @order.set_schedule_filter
      end

      it "should set shippable_date as shipping_date." do
        @order.shipping_date.should == "2012/11/01"
      end

      it "should set shippable_date + ship_days as delivery_date." do
        @order.delivery_date.should == "2012/11/03"
      end

      it "should set alert in domestic_notes." do
        @order.domestic_notes.should =~ /\[希望日不可\]/
      end
    end
  end
end
