# coding: utf-8
require 'spec_helper'

describe "Filter: set_status_filter" do
  before { @order = Order::Rakuten.new([]) }

  describe "when payment method is not credit-card  or COD." do
    it "should set nothing as status." do
      @order.stub(:payment_method).and_return(:other)
      @order.set_status_filter
      @order.status.empty?.should == true
    end
  end

  [:card, :cod].each do |method|
    describe "when payment method is #{method}" do
      before { @order.stub(:payment_method).and_return(method) }

      describe "and nothing written in alert, memo in Rakuten, and comment." do
        it "should be 出荷準備OK." do
          @order.stub(:domestic_notes).and_return("")
          @order.stub(:demand).and_return("")
          @order.stub(:memo).and_return("")
          @order.set_status_filter
          @order.status.should == "出荷準備OK"
        end
      end

      describe "and something written in alert, memo in Rakuten or comment." do
        it "should be 確認待." do
          @order.stub(:domestic_notes).and_return("[希望日不可]")
          @order.stub(:demand).and_return("")
          @order.stub(:memo).and_return("")
          @order.set_status_filter
          @order.status.should == "確認待"
        end
      end
    end
  end
end
