# frozen_string_literal: true

require "active_record"
require "logger"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "test_ar.sqlite3")
# ActiveRecord::Base.establish_connection(adapter: "postgresql", host: "localhost", database: "bench_ar", username: "postgres",password: "postgres")
# file = File.open("prod.log", File::WRONLY | File::APPEND | File::CREAT)
# ActiveRecord::Base.logger = Logger.new(file)
# ActiveRecord::Base.logger = Logger.new(STDOUT)
