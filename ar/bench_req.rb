# frozen_string_literal: true

start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
require "active_record"
stop = Process.clock_gettime(Process::CLOCK_MONOTONIC)

puts "require AR: #{stop - start} seconds"
