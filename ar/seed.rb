# frozen_string_literal: true

require "./db.rb"
require "./models.rb"
require "faker"

NUM_OF_TOPICS = 10
NUM_OF_POSTS_PER_TOPIC = 100
NUM_OF_COMMENTS_PER_POST = 20

def time_offset(start, stop) # in num of days
  raise "start must be greater than stop" if stop < start
  start_day = start * 86_400
  stop_day = stop * 86_400
  rand(start_day..stop_day)
end

topic_count = NUM_OF_TOPICS - Topic.all.count

topic_count = 0 if topic_count.negative?

name = Faker::Hipster.word
ActiveRecord::Base.transaction do
topic_count.times do
  time = Time.now.utc - time_offset(100, 101)
  Topic.create(
    name: name,
    created_at: time,
    updated_at: time + time_offset(0, 1)
  )
end
end

post_body = Faker::Hipster.paragraphs(2).to_s
comment_body = Faker::Hipster.sentence.to_s
ActiveRecord::Base.transaction do
Topic.all.each do |topic|
  break if topic.posts.count >= NUM_OF_POSTS_PER_TOPIC
  NUM_OF_POSTS_PER_TOPIC.times do
    time = topic.created_at + time_offset(0, 80)
    post = Post.create(
              topic: topic,
              body: post_body,
              created_at: time,
              updated_at: time + time_offset(0, 1)
            )

    NUM_OF_COMMENTS_PER_POST.times do
      time = post.created_at + time_offset(0, 20)
    Comment.create(
      post: post,
      body: comment_body,
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

ActiveRecord::Base.remove_connection
