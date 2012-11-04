# coding: utf-8
$:.push(Dir::pwd + "/*/")
#require 'rubygems'
#require 'rspec'

puts Dir::pwd + "/order/"
require 'order'

describe "Order::Base" do
  it "should have version" do
    Order::Base::Version.should == 0.1
  end
end
