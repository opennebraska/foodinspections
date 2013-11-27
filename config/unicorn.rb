APP_PATH = "/var/www" # install location
worker_processes 4    # amount of unicorn workers to spin up
timeout 30            # restarts workers that hang for 30 seconds

### Configuration for HP Cloud servers
# Speed things up
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true
check_client_connection false

# Run unpriviliged
user "www-data", "www-data"

# Set our working directory
working_directory APP_PATH

# Set what we're listening on
listen APP_PATH + "/.unicorn.sock", :backlog => 64
listen 8080, :tcp_nopush => true

# PIDs are nice
pid APP_PATH + "/unicorn.pid"

# stderr/stdout logs
stderr_path APP_PATH + "/logs/unicorn.stderr.log"
stdout_path APP_PATH + "/logs/unicorn.stdout.log"