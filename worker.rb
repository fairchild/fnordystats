require "./app.rb"
p [:WORKER_PORT, ENV['PORT']]

# FnordMetric.server_configuration = {
#   :redis_url => ENV['REDISTOGO_URL'] || "redis://localhost:6379",
#   :inbound_stream => ["0.0.0.0", ENV["PORT"]||"5020"],
#   :inbound_protocol => :tcp,
#   :start_worker => true,
#   :print_stats => 3
# }


FnordMetric.server_configuration = {
  :redis_url => ENV['REDISTOGO_URL'] || "redis://localhost:6379",
  :inbound_stream => false,
  :web_interface  => false,
  :start_worker => true,
  :print_stats => 5
}

FnordMetric.standalone