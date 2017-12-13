# frozen_string_literal: true

require "benchmark/ips"
require "memory_profiler"

MemoryProfiler.start
require "sequel"
report = MemoryProfiler.stop
report.pretty_print(to_file: "sq.txt")

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
    x.report("#{title}_sq") { yield }
    x.compare!
  end
end



begin
old_stdout = $stdout
$stdout.reopen("results.txt", "w")

puts "-----------------\n\n"

list = Topic.select(:id).all

bench("topic_first") do
  Topic.first
end

id = list.sample.id
bench("topic_find") do
  Topic.find(id: id)
end

id = list.sample.id
bench("topic_where") do
  Topic.where(id: id).first
end

id = list.sample.id
bench("topic_posts_eager") do
  Topic.eager(:posts).where(id: id).all
end

id = list.sample.id
topic = Topic.find(id: id)
post_count = topic.posts.count
from = Post.where(topic: topic).order(:updated_at).limit(post_count/2).select_map(:updated_at).last
bench("topic_posts_index_filtered") do
  Post.where(topic: topic).where(Sequel.lit("updated_at > ?", from)).order(:updated_at).reverse.all
end

id = list.sample.id
topic = Topic.find(id: id)
old_name = topic.name
bench("topic_update_2x") do
  topic.update(name: "Hello Bob")
  topic.update(name: "Hello Janet")
end
topic.update(name: old_name)

id = list.sample.id
topic = Topic.find(id: id)
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
Topic.where(Sequel.lit("id > ?", topic.id)).destroy
puts Topic.count.to_s + "--" + Topic.last.id.to_s

class Topic < Sequel::Model
  plugin :validation_helpers
  def validate
    super
    validates_presence :name
  end
end

topic = Topic.last
bench("topic_create_validation") do
  Topic.create(name: "Hello Bob")
end

puts Topic.count.to_s + "--" + Topic.last.id.to_s
Topic.where(Sequel.lit("id > ?", topic.id)).destroy
puts Topic.count.to_s + "--" + Topic.last.id.to_s

puts "-----------------\n\n\n"

ensure
  $stdout = old_stdout
end
