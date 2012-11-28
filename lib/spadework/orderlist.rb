# coding: utf-8
require 'csv'
require 'date'
require 'fileutils'

class OrderList < Array
  OptionalHeader = [
    "ステータス",
    "指定出荷日",
    "指定配送日",
    "指定配送方法",
    "指定配送時間",
    "備考",
    "社内備考",
    "倉庫指示",
    "連絡",
    "警告",
  ]

  attr_accessor :path, :type, :header, :orders  

  def initialize(path)
    @path = path
    if @path =~ /\d{10,10}.txt/
      @type = Order::Amazon
    elsif @path =~ /default_all_orders/
#      @time = Order::Yahoo
    elsif @path =~ /[\w \(\)]+.csv/
      @type = Order::Rakuten
    end
    reader = CSV.open(@path, "r:windows-31j", col_sep: @type == Order::Amazon ? "\t" : nil)
    @header = reader.shift.map{ |col| col.to_s.encode("utf-8") } + OptionalHeader
    @orders = reader.map{ |row| @type.new(row.map{|col| col.to_s.encode("utf-8") }) }
  end

  def inspect ; [@path, @type, @header, @orders] ; end
  def size ; self.orders.size + 1 ; end

  def save_as(fname)
    CSV.open(fname, "w:windows-31j", col_sep: @type == Order::Amazon ? "\t" : nil) do |writer|
      writer << self.header
      self.orders.each{ |order| writer << order.to_a }
    end
  end

  def log_file_name
    process_rate = @orders.select{|row| row.status == "出荷準備OK" }.size / @orders.size
    timestamp = Time.now.strftime("%y%m%d_%H%M")
    "#{timestamp}_auto_processed_#{process_rate}_percent_#{File.basename(@path)}"
  end

  def save_log_as(fname)
    FileUtils.touch(fname)
=begin
    CSV.open(fname, "w:windows-31j") do |writer|
      writer << self.header
      self.orders.each{ |order| writer << order.to_log }
    end
=end
  end
end
