require File.expand_path("app.rb", File.dirname(__FILE__))
$stdout.sync = true

logger = Logger.new($stdout)
use Rack::CommonLogger, logger

run FnordMetric.embedded(
  :redis_url => ENV['REDISTOGO_URL'] || "redis://localhost:6379",
  :redis_prefix => "fnordmetric",
  :inbound_stream => ["0.0.0.0", "1337"],
  :inbound_protocol => :tcp,
  :web_interface => ["0.0.0.0", "4242"],
  :web_interface_server => "thin",
  :start_worker => true,
  :print_stats => 3,
  :event_queue_ttl => 120,
  :event_data_ttl => 3600*24*30,
  :session_data_ttl => 3600*24*30
)



# ===================
# = Default Options =
# =================== 

# :redis_url => "redis://localhost:6379",
# :redis_prefix => "fnordmetric",
# :inbound_stream => ["0.0.0.0", "1337"],
# :inbound_protocol => :tcp,
# :web_interface => ["0.0.0.0", "4242"],
# :web_interface_server => "thin",
# :start_worker => true,
# :print_stats => 3,
# :event_queue_ttl => 120,
# :event_data_ttl => 3600*24*30,
# :session_data_ttl => 3600*24*30