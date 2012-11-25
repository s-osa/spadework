# coding: utf-8
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'spadework/order'
require 'spadework/orderlist'
require 'fileutils'

ExportDir = File.expand_path(File.dirname(__FILE__) + "/../export")
ImportDir = File.expand_path(File.dirname(__FILE__) + "/../import")
Stores    = ["maido"]
# Stores    = ["maido", "amazon", "plus", "yahoo"]

Stores.each do |store|
#  puts "== #{store} ============================================================"
  Dir.glob("#{ImportDir}/#{store}/*").each do |loadpath|
#    puts "  Loading ...   #{loadpath}"

    orderlist = OrderList.new(loadpath)
    orderlist.orders.each do |order|
      #### Add filters in this block ###########################################
      order.set_schedule_filter
      order.set_carrier_filter
      order.set_status_filter   # This filter must be put on under all filters!!
    end

    (1..2).each do |num|
      writepath = "#{ExportDir}/#{store}#{num}/#{File.basename(loadpath)}"
#      puts "  Writing ...   #{writepath}"
      FileUtils.mkdir_p(File.dirname(writepath), :mode => 0777) unless File.exist?(File.dirname(writepath))
      orderlist.save_as(writepath)
    end

    writepath = "#{ExportDir}/log/#{orderlist.log_file_name}"
    FileUtils.mkdir_p(File.dirname(writepath), :mode => 0777) unless File.exist?(File.dirname(writepath))
    orderlist.save_log_as(writepath)

#    puts "  Deleting ...   #{loadpath}"
    File.unlink(loadpath)
  end
#  puts "  => FINISH!!",""
end
