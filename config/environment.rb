require 'bundler/setup'
Bundler.require

# sets up connection to the database file
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3', # Postgres, MySQL, etc
  database: "db/development.sqlite"
)

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'vhs', 'vhs'
end

# enables logging in console whenever ActiveRecord writes SQL for us
ActiveRecord::Base.logger = Logger.new(STDOUT)

require_all 'app'
