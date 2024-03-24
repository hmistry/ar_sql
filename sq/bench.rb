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

bench("topic_first_cast") do
  topic = Topic.first
  topic.id
  topic.name
  topic.created_at
  topic.updated_at
end

id = list.sample.id
bench("topic_id") do
  Topic[id]
end

bench("topic_id_cast") do
  topic = Topic[id]
  topic.id
  topic.name
  topic.created_at
  topic.updated_at
end

id = list.sample.id
bench("topic_find") do
  Topic.find(id: id)
end

bench("topic_find_cast") do
  topic = Topic.find(id: id)
  topic.id
  topic.name
  topic.created_at
  topic.updated_at
end

id = list.sample.id
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

id = list.sample.id
bench("topic_posts_eager") do
  Topic.eager(:posts).where(id: id).all
end

bench("topic_posts_eager_cast") do
  Topic.eager(:posts).where(id: id).paged_each do |topic|
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

id = list.sample.id
topic = Topic.find(id: id)
post_count = topic.posts.count
post_from = Post.where(topic: topic).order(:updated_at).offset(post_count/2-1).limit(1).first
bench("topic_posts_filtered") do
  Post.where(topic: topic).where(Sequel.lit("updated_at > ?", post_from.updated_at)).order(:updated_at).reverse.all
end

bench("topic_posts_filtered_cast") do
  Post.where(topic: topic).where(Sequel.lit("updated_at > ?", post_from.updated_at)).order(:updated_at).reverse.paged_each do |post|
    post.id
    post.body
    post.created_at
    post.updated_at
  end
end

bench("topic_posts_filtered_notime_cast") do
  Post.where(topic: topic).where(Sequel.lit("updated_at > ?", post_from.updated_at)).order(:updated_at).reverse.select(:id, :body).paged_each do |post|
    post.id
    post.body
  end
end

bench("topic_posts_filtered_time_cast") do
  Post.where(topic: topic).where(Sequel.lit("updated_at > ?", post_from.updated_at)).order(:updated_at).reverse.select(:id,:created_at, :updated_at).paged_each do |post|
    post.id
    post.created_at
    post.updated_at
  end
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
