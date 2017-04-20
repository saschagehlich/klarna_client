$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../', __FILE__)
require "support/fake_frontend.rb"
require "support/frontend_driver.rb"
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'klarna'
require 'ostruct'
require 'pry'


Capybara.register_driver :poltergeist do |app|
  # we're working with foreign origin iframes
  Capybara::Poltergeist::Driver.new(app, phantomjs_options: ["--web-security=false"])
end

Capybara.configure do |config|
  config.app = FakeFrontend
  config.javascript_driver = :poltergeist
end


def wait_for_ajax
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until finished_all_ajax_requests?
  end
end

def finished_all_ajax_requests?
  page.evaluate_script('jQuery.active').zero?
end


