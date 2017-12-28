# frozen_string_literal: true

start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
require "sequel"
stop = Process.clock_gettime(Process::CLOCK_MONOTONIC)

puts "require Sequel: #{stop - start} seconds"
