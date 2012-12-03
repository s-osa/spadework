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
    return if (1..2).any?{ |num| File.exist?("#{ExportDir}/#{store}#{num}/#{File.basename(loadpath)}") }

    orderlist = OrderList.new(loadpath)
    orderlist.orders.each do |order|
      #### Add filters in this block ###########################################
      order.set_schedule_filter
      order.set_carrier_filter
      order.set_status_filter   # This filter must be put on under all filters!!
    end

    (1..2).each { |num| orderlist.save_as("#{ExportDir}/#{store}#{num}/#{File.basename(loadpath)}") }
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
