require "rubygems"
require "benchmark"
require "json"
require "yaml"
require 'oj'
require 'yajl'


class SampleClass
  def initialize(string, number)
    @string = string
    @number = number
  end

  def to_s
    "In SampleClass:\n #{@string}, #{@number}\n"
  end

  def to_json(*a)
    {
        "json_class" => self.class.name,
        "data"       => {"string" => @string, "number" => @number }
    }.to_json(*a)
  end
end



def benchmark_serialize(output_file)
  Benchmark.realtime do
    File.open(output_file, "w") do |file|
      (1..500000).each do |index|
        yield(file, SampleClass.new("hello world", index))
      end
    end
  end
end

puts "Serialization speed test:"

#Yaml
time = benchmark_serialize("yaml.dat") do |file, object|
  file.puts YAML::dump(object)
  file.puts ""
end
puts "YAML: #{time} sec"

#Json
time = benchmark_serialize("json.dat") do |file, object|
  file.puts JSON.dump(object)
end
puts "JSON: #{time} sec"

#OJ Json
time = benchmark_serialize("oj.dat") do |file, object|
  file.puts Oj.dump(object)
end
puts "OJ Json: #{time} sec"

#Yail
time = benchmark_serialize("yail.dat") do |file, object|
  file.puts Yajl::Encoder.encode(object)
end
puts "Yail: #{time} sec"

#Marshal
time = benchmark_serialize("marshal.dat") do |file, object|
  file.print Marshal::dump(object)
  file.print "---_---"
end
puts "Marshal: #{time} sec"
