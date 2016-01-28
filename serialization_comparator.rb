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

puts "YAML:"
time = benchmark_serialize("yaml.dat") do |file, object|
  file.puts YAML::dump(object)
  file.puts ""
end
puts "Time: #{time} sec"

puts "JSON:"
time = benchmark_serialize("json.dat") do |file, object|
  file.puts JSON.dump(object)
end
puts "Time: #{time} sec"

puts "OJ Json:"
time = benchmark_serialize("oj.dat") do |file, object|
  file.puts Oj.dump(object)
end
puts "Time: #{time} sec"

puts "Yail:"
time = benchmark_serialize("yail.dat") do |file, object|
  file.puts Yajl::Encoder.encode(object)
end
puts "Time: #{time} sec"

puts "Marshal:"
time = benchmark_serialize("marshal.dat") do |file, object|
  file.print Marshal::dump(object)
  file.print "---_---"
end
puts "Time: #{time} sec"
