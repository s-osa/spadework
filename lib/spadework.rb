# coding: utf-8
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'spadework/order'
require 'spadework/orderlist'
require 'csv'
require 'fileutils'

ExportDir = File.expand_path(File.dirname(__FILE__) + "/../export")
ImportDir = File.expand_path(File.dirname(__FILE__) + "/../import")
Stores    = ["maido"]
# Stores    = ["maido", "amazon", "plus", "yahoo"]

Stores.each do |store|
  puts "== #{store} ============================================================"
  Dir.glob("#{ImportDir}/#{store}/*").each do |loadpath|
    puts "  Loading ...   #{loadpath}"
    orderlist = OrderList.new(loadpath)

    orderlist.orders.each do |order|
      order.set_schedule_filter
    end

    (1..2).each do |num|
      writepath = "#{ExportDir}/#{store}#{num}/#{File.basename(loadpath)}"
      puts "  Writing ...   #{writepath}"
      FileUtils.mkdir_p(File.dirname(writepath)) unless File.exist? File.dirname(writepath)
      orderlist.save_as(writepath)
    end
  end
  puts "  => FINISH!!",""
end
