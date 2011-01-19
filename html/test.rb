require 'capybara'
require 'benchmark'
require 'pp'

Capybara.app_host = 'file:///Users/jch/projects/lumberjack/html'
Capybara.default_selector = :css
Capybara.register_driver :selenium do |app|
  Capybara::Driver::Selenium.new(app, :browser => :chrome)
end

@b = Capybara::Session.new(:selenium)
@results = {}

def run_test(name, t = nil)
  @b.visit "/"
  @b.visit("/test.html##{name.to_s}")
  sleep t if t
  @results[name.to_sym] = @b.find('.result').text
end

Benchmark.bm(15) do |x|
  x.report { run_test :test_lumberjack }
  x.report { run_test :test_rails2, 3 }
  x.report { run_test :test_rails3 }
end

puts "\n"
pp @results