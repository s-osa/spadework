# coding: utf-8
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'spadework/order'
require 'spadework/orderlist'
require 'fileutils'

ExportDir = File.expand_path(File.dirname(__FILE__) + "/../export")
ImportDir = File.expand_path(File.dirname(__FILE__) + "/../import")
Stores    = ["maido", "amazon", "plus", "yahoo"]

def convert(store)
  Dir.glob("#{ImportDir}/#{store}/*").each do |loadpath|
    return if (1..2).any?{ |num| File.exist?("#{ExportDir}/#{store}#{num}/#{loadpath}") }
    next if loadpath =~ /default_all_items/

    orderlist = OrderList.new(loadpath)
    orderlist.orders.each do |order|
      #### Add filters in this block ###########################################
      order.set_schedule_filter
      order.set_carrier_filter
      order.tel_before_delivery_filter
      order.no_warranty_stamp_filter
      order.wish_datetime_format_filter if order.class == Order::Yahoo
      order.recycle_filter
      order.house_number_filter
      order.set_status_filter   # This filter must be put under all filters!!
    end

    (1..2).each { |num| orderlist.save_as("#{ExportDir}/#{store}#{num}/#{orderlist.save_file_name}") }
    orderlist.save_log_as("#{ExportDir}/log/#{orderlist.log_file_name}")

    puts "  Deleting ...   #{loadpath}"
    File.unlink(loadpath)
  end
end

Stores.each do |store|
  begin
    puts "== #{store} ============================================================"
    convert(store)
    puts "  => FINISH!",""
  rescue
    puts "  => ERROR!!",""
    puts $!
    puts $@
  end
end
