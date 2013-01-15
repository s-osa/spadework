# coding: utf-8

n = 1

File.open("island_zipcodes.yml", "w") do |yml|
  file = File.open('islands.txt').each_line do |line|
    line = line.gsub(/^/,"zipcode#{n}:\n  id: #{n}\n  zipcode: ") << "\n"
    yml.puts line
    n += 1
  end
end
