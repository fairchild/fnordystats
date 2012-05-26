require "./app.rb"
p [:INBOUND_PORT, ENV['PORT']]

FnordMetric.server_configuration = {
  :redis_url => ENV['REDISTOGO_URL'] || "redis://localhost:6379",
  :inbound_stream => ["0.0.0.0", ENV["PORT"]||"5020"],
  :inbound_protocol => :tcp,
  :start_worker => true,
  :web_interface => false
}


FnordMetric.standalone
