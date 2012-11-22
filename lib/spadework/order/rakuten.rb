# coding: utf-8
class Order::Rakuten < Order::Base
  DateRegexp = /(\d{4})-(\d{2})-(\d{2})\(.\)/
  TimeRegexp = /(\d{1,2}):(\d{2})〜(\d{2}):(\d{2})/
  def order_datetime ; DateTime.parse(@arr[2] + " " + @arr[3]) ; end
  def title ; @arr[4] ; end
  def zipcode ; @arr[28] << "-" << @arr[29] ; end
  def pref ; @arr[30] ; end
  def payment_method ; super @arr[37] ; end
  def wish_date ; @arr[45] =~ DateRegexp ? Date.new($1.to_i, $2.to_i, $3.to_i) : nil ; end
  def wish_time ; @arr[45] =~ TimeRegexp ? "#{$1}:#{$2}-#{$3}:#{$4}" : nil ; end
  def demand ; @arr[45].gsub(/\[[^\]]+:\]/,"").gsub(DateRegexp,"").gsub(TimeRegexp,"").gsub(/\n{2,}/,"") ; end
  def memo ; @arr[63] ? @arr[63] : "" ; end
end
