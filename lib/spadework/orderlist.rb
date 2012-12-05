# coding: utf-8
require 'csv'
require 'date'
require 'fileutils'

class OrderList < Array
  OptionalHeader = %w(ステータス 指定出荷日 指定配送日 指定配送方法 指定配送時間 備考 社内備考 倉庫指示 連絡 警告)

  attr_accessor :timestamp, :loadpath, :header, :orders

  def initialize(loadpath)
    puts "  Loading ...   #{loadpath}"
    @timestamp = Time.now
    @loadpath = loadpath
    if self.type == Order::Yahoo
      path = File.dirname(@loadpath) + "/default_all_items.csv"
      raise RuntimeError, "could not find default_all_items.csv" unless File.exist?(path)
      reader = CSV.open(path, "r:windows-31j")
      reader.each{ |row| Order::Yahoo.items << row.map{|col| col.to_s.encode("utf-8") } }
      File.rename(path, File.expand_path(File.dirname(path) + "/../../export/yahoo1/Yahoo_#{@timestamp.strftime("%Y%m%d_%H%M%S")}.csv"))
    end
    reader = CSV.open(@loadpath, "r:windows-31j", col_sep: self.type == Order::Amazon ? "\t" : ",")
    @header = reader.shift.map{ |col| col.to_s.encode("utf-8") } + OptionalHeader
    @orders = reader.map{ |row| self.type.new(row.map{|col| col.to_s.encode("utf-8") }) }
  end

  def inspect ; [@path, @type, @header, @orders] ; end
  def size ; self.orders.size + 1 ; end

  def type
    case @loadpath
    when /\d{10,10}([\s\(\)\d])*\.txt/ then Order::Amazon
    when /default_all_orders/          then Order::Yahoo
    when /default_all_items/           then nil
    when /[\w\s\(\)]+\.csv/            then Order::Rakuten
    end
  end

  def load_file_name ; File.basename(@loadpath) ; end

  def save_file_name
    return "Yahoo_#{@timestamp.strftime("%Y%m%d_%H%M%S")}h.csv" if self.type == Order::Yahoo
    self.load_file_name
  end

  def save_as(fname)
    puts "  Writing ...   #{fname}"
    FileUtils.mkdir_p(File.dirname(fname), :mode => 0777) unless File.exist?(File.dirname(fname))
    CSV.open(fname, "w:windows-31j", col_sep: @type == Order::Amazon ? "\t" : ",") do |writer|
      writer << self.header
      self.orders.each{ |order| writer << order.to_a }
    end
  end

  def log_file_name
    process_rate = @orders.count{|row| row.status == "出荷準備OK" } * 100 / @orders.size
    timestamp = Time.now.strftime("%y%m%d_%H%M")
    "#{timestamp}_auto_processed_#{process_rate}%_of_#{@orders.size}orders_in_#{File.basename(@loadpath)}"
  end

  def save_log_as(fname)
    puts "  Writing ...   #{fname}"
    FileUtils.mkdir_p(File.dirname(fname), :mode => 0777) unless File.exist?(File.dirname(fname))
    FileUtils.touch(fname)
=begin
    CSV.open(fname, "w:windows-31j") do |writer|
      writer << self.header
      self.orders.each{ |order| writer << order.to_log }
    end
=end
  end
end
