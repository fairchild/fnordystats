$stdout.sync = true
require 'rubygems'
require 'bundler'
Bundler.require
require "fnordmetric"

FnordMetric.server_configuration = {
  :redis_url => ENV['REDISTOGO_URL'] || "redis://localhost:6379",
  :inbound_stream => false,
  :start_worker => false
}
require "./app.rb"

FnordMetric.standalone
