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

bench("topic_first_cast") do
  topic = Topic.first
  topic.id
  topic.name
  topic.created_at
  topic.updated_at
end

id = list.sample
bench("topic_find") do
  Topic.find(id)
end

bench("topic_find_cast") do
  topic = Topic.find(id)
  topic.id
  topic.name
  topic.created_at
  topic.updated_at
end

id = list.sample
bench("topic_findby") do
  Topic.find_by(id: id)
end

bench("topic_findby_cast") do
  topic = Topic.find_by(id: id)
  topic.id
  topic.name
  topic.created_at
  topic.updated_at
end

id = list.sample
bench("topic_where") do
  Topic.where(id: id).first
end

bench("topic_where_cast") do
  topic = Topic.where(id: id).first
  topic.id
  topic.name
  topic.created_at
  topic.updated_at
end

id = list.sample
bench("topic_posts_eager") do
  Topic.includes(:posts).where(id: id).to_a
end

bench("topic_posts_eager_cast") do
  Topic.includes(:posts).where(id: id).find_each do |topic|
    topic.id
    topic.name
    topic.created_at
    topic.updated_at
    topic.posts.each do |post|
      post.id
      post.body
      post.created_at
      post.updated_at
    end
  end
end

id = list.sample
topic = Topic.find_by(id: id)
post_count = topic.posts.count
from = Post.where(topic: topic).order(updated_at: :asc).limit(post_count/2).select(:updated_at).last.updated_at
bench("topic_posts_filtered") do
  Post.where(topic: topic).where("updated_at > ?", from).order(updated_at: :desc).to_a
end

bench("topic_posts_filtered_cast") do
  Post.where(topic: topic).where("updated_at > ?", from).order(updated_at: :desc).find_each do |post|
    post.id
    post.body
    post.created_at
    post.updated_at
  end
end

bench("topic_posts_filtered_notime_cast") do
  Post.where(topic: topic).where("updated_at > ?", from).order(updated_at: :desc).select(:id, :body).find_each do |post|
    post.id
    post.body
  end
end

bench("topic_posts_filtered_time_cast") do
  Post.where(topic: topic).where("updated_at > ?", from).order(updated_at: :desc).select(:id,:created_at, :updated_at).find_each do |post|
    post.id
    post.created_at
    post.updated_at
  end
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
