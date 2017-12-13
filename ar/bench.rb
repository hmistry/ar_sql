# frozen_string_literal: true

require "benchmark/ips"
require "memory_profiler"

MemoryProfiler.start
require "active_record"
report = MemoryProfiler.stop
report.pretty_print(to_file: "ar.txt")

require "./db.rb"
require "./models.rb"
# require "byebug"



def bench(title)
  MemoryProfiler.start
  yield
  report = MemoryProfiler.stop
  report.pretty_print(to_file: "#{title.to_s}.txt")

  Benchmark.ips do |x|
    x.config(:time => 5, :warmup => 2)
    x.report("#{title}_ar") { yield }
    x.compare!
  end
end



begin
old_stdout = $stdout
$stdout.reopen("results.txt", "w")

puts "-----------------\n\n"

list = Topic.all.pluck(:id)

MemoryProfiler.start
Topic.first
report = MemoryProfiler.stop
report.pretty_print(to_file: "topic_first_init.txt")

bench("topic_first") do
  Topic.first
end

id = list.sample
bench("topic_find") do
  Topic.find(id)
end

id = list.sample
bench("topic_findby") do
  Topic.find_by(id: id)
end

id = list.sample
bench("topic_where") do
  Topic.where(id: id).first
end

id = list.sample
bench("topic_posts_eager") do
  Topic.includes(:posts).where(id: id).to_a
end

id = list.sample
topic = Topic.find_by(id: id)
post_count = topic.posts.count
from = Post.where(topic: topic).order(updated_at: :asc).limit(post_count/2).select(:updated_at).last.updated_at
bench("topic_posts_index_filtered") do
  Post.where(topic: topic).where("updated_at > ?", from).order(updated_at: :desc).to_a
end

id = list.sample
topic = Topic.find_by(id: id)
old_name = topic.name
bench("topic_update_2x") do
  topic.update(name: "Hello Bob")
  topic.update(name: "Hello Janet")
end
topic.update(name: old_name)

id = list.sample
topic = Topic.find_by(id: id)
old_name = topic.name
bench("topic_update_save_2x") do
  topic.name = "Hello Bob"
  topic.save
  topic.name = "Hello Janet"
  topic.save
end
topic.update(name: old_name)

topic = Topic.last
bench("topic_create") do
  Topic.create(name: "Hello Bob")
end

puts Topic.count.to_s + "--" + Topic.last.id.to_s
Topic.where("id > ?", topic.id).destroy_all
puts Topic.count.to_s + "--" + Topic.last.id.to_s


class Topic < ActiveRecord::Base
  validates :name, presence: true
end

topic = Topic.last
bench("topic_create_validation") do
  Topic.create(name: "Hello Bob")
end

puts Topic.count.to_s + "--" + Topic.last.id.to_s
Topic.where("id > ?", topic.id).destroy_all
puts Topic.count.to_s + "--" + Topic.last.id.to_s

puts "-----------------\n\n\n"

ensure
  ActiveRecord::Base.remove_connection
  $stdout = old_stdout
end
