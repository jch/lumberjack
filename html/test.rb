require 'capybara'
require 'benchmark'
require 'pp'

Capybara.app_host = 'file:///Users/jch/projects/lumberjack/html'
Capybara.default_selector = :css
Capybara.register_driver :selenium do |app|
  Capybara::Driver::Selenium.new(app, :browser => :chrome)
end

module Lumberjack
  class AcceptanceTests
    class<<self
      def run
        @b = Capybara::Session.new(:selenium)
        @results = {}
        @success = true

        def run_test(name, t = nil)
          @b.visit "/"
          @b.visit("/test.html##{name.to_s}")
          sleep t if t
          @results[name.to_sym] = @b.find('.result').text
          @success = @success && @b.find('.failed').text == "0"
          if not @success
            puts "FAILED!!!"
          end
        end

        puts "\nRunning Lumberjack acceptance tests...\n"
        Benchmark.bm(15) do |x|
          x.report("test_lumberjack") { run_test :test_lumberjack }
          x.report("test_rails2") { run_test :test_rails2, 6 }
          x.report("test_rails3") { run_test :test_rails3 }
        end
        puts


        @results.each_pair do |name, result|
          puts name
          result.split("\n").each do |s|
            puts "  " + s
          end
          puts
        end
        @success
      end
    end
  end
end