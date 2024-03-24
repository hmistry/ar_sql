# frozen_string_literal: true

require "./db.rb"
require "./models.rb"
require "faker"

NUM_OF_TOPICS = 10000
NUM_OF_POSTS_PER_TOPIC = 100
NUM_OF_COMMENTS_PER_POST = 20

Topic.plugin :timestamps, allow_manual_update: true, update_on_create: false
Post.plugin :timestamps, allow_manual_update: true, update_on_create: false
Comment.plugin :timestamps, allow_manual_update: true, update_on_create: false

def time_offset(start, stop) # in num of days
  raise "start must be greater than stop" if stop < start
  start_day = start * 86_400
  stop_day = stop * 86_400
  rand(start_day..stop_day)
end

topic_count = NUM_OF_TOPICS - Topic.all.count

topic_count = 0 if topic_count.negative?

DB.transaction do
topic_count.times do
  time = Time.now.utc - time_offset(100, 101)
  Topic.create(
    name: Faker::Hipster.word,
    created_at: time,
    updated_at: time + time_offset(0, 1)
  )
end
end

DB.transaction do
Topic.all.each do |topic|
  break if topic.posts.count >= NUM_OF_POSTS_PER_TOPIC
  NUM_OF_POSTS_PER_TOPIC.times do
    time = topic.created_at + time_offset(0, 80)
    post = Post.create(
              topic: topic,
              body: Faker::Hipster.paragraphs(number: 2).to_s,
              created_at: time,
              updated_at: time + time_offset(0, 1)
            )

    NUM_OF_COMMENTS_PER_POST.times do
      time = post.created_at + time_offset(0, 20)
    Comment.create(
      post: post,
      body: Faker::Hipster.sentence.to_s,
      created_at: time,
      updated_at: time + time_offset(0, 1)
    )
    end
  end
end
end

puts "Topic: #{Topic.all.count}"
puts "Post: #{Post.all.count}"
puts "Comment: #{Comment.all.count}"
