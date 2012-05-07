$stdout.sync = true
require 'rubygems'
require 'bundler'
Bundler.require

FnordMetric.options(
  :redis_url =>  ENV['REDISTOGO_URL'] || "redis://localhost:6379",
  :inbound_stream => ["0.0.0.0", "1339"]
)
require "./app.rb"

FnordMetric.standalone
