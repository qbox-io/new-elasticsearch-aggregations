

require 'tire'


DATAFILE = "new-aggs-data.json"
index_name = "sports"
type_name = "athlete"


begin
  puts "Reading file: #{DATAFILE}..."

  raw = File.read(DATAFILE)

  puts "Parsing..."

  json_data = JSON.parse(raw)

  puts "#{json_data.count} data points in file"

  Tire.configure do
    url "localhost:9200"
  end

  json_data.each_slice(1_000).with_index do |chunk, i|
    data = chunk.map { |u| u.merge("type" => type_name)}

    puts "  importing chunk #{i}..."
    Tire.index(index_name) { import(data) }
  end

rescue Exception=>e
  p e
end

puts "Done"


