# coding: utf-8
require 'spec_helper'

describe Order::Base do
  before do
    arr = []
    arr[63] = ""
    @order = Order::Rakuten.new(arr)
  end

  describe "#takes" do
    it "should be 1 when Tokyo." do
      "東京都".takes.should == 1
    end
  end
end
