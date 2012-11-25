# coding: utf-8
class Order::Amazon < Order::Base
  DateRegexp = /(\d{4})-(\d{2})-(\d{2})\(.\)/
  TimeRegexp = /(\d{1,2})：(\d{2}).(\d{2})：(\d{2})/
  def order_datetime ; DateTime.parse(@arr[3]) + 9.0/24.0 ; end
  def title ; @arr[8] ; end
  def zipcode ; @arr[22] ; end
  def pref ; @arr[21] ; end
  def payment_method ; super @arr[40] ; end
  def wish_date ; nil ; end
  def wish_time ; nil ; end
  def demand ; nil ; end
end
