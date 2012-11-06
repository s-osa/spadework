# coding: utf-8
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'spadework/order'
require 'spadework/orderlist'

ImportDir = File.dirname(File.expand_path(__FILE__)) + "/../"
Stores    = ["maido"] #, "amazon", "plus", "yahoo"]

Dir.chdir ImportDir

Stores.each do |store|
  dir = File.expand_path(ImportDir + store)
  p Dir.glob("#{dir}/*")
end

=begin
Dir.glob("*").each do |dir|
  files = Dir.glob("#{dir}/*")
  case dir
  when "config"
    puts "config"
  when "amazon"
    puts "amazon"
  when "yahoo"
    puts "yahoo"
  else
    puts "rakuten"
  end
  puts files
  puts "==========================="
end
=end
