$stdout.sync = true
require 'rubygems'
require 'bundler'
Bundler.require
require "fnordmetric"

FnordMetric.server_configuration = {
  :redis_url => ENV['REDISTOGO_URL'] || "redis://localhost:6379",
  :inbound_stream => ARGV[1],
  :inbound_protocol => :tcp
}
require "./app.rb"
FnordMetric.standalone