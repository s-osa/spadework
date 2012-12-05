# coding: utf-8

class Order::Yahoo < Order::Base
  DateRegexp = /(\d{4})年(\d{1,2})月(\d{1,2})日/
  TimeRegexp = /(\d{1,2}):(\d{2}).(\d{1,2}):(\d{2})/

  @@items ||= []
  def self.items  ; @@items ; end
  def self.items= ; @@items ; end

  def initialize(arr)
    super(arr)
    @domestic_notes << "[複数]" if @@items.count{|row| row[0] == @arr[0]} > 1
  end

  def order_datetime ; DateTime.parse(@arr[5]) ; end
  def title ; @domestic_notes =~ /複数/ ? "" : @@items.find{|row| row[0] == @arr[0]}[5] ; end
  def zipcode ; @arr[13] ; end
  def pref ; @arr[11] ; end
  def destination ; @arr[11]+@arr[10]+@arr[8]+@arr[9]+@arr[7] ; end
  def payment_method ; super @arr[57] ; end
  def wish_date ; @arr[53] =~ DateRegexp ? Date.new($1.to_i, $2.to_i, $3.to_i) : nil ; end
  def wish_time ; @arr[54] =~ TimeRegexp ? "#{$1}:#{$2}-#{$3}:#{$4}" : nil ; end
  def demand ; @arr[34].gsub(/\n+/,"") ; end
end
