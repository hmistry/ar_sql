# frozen_string_literal: true

require "./db.rb"

Sequel::Model.plugin :timestamps, update_on_create: true

class Topic < Sequel::Model
  one_to_many :posts
end

class Post < Sequel::Model
  many_to_one :topic
  one_to_many :comments
end

class Comment < Sequel::Model
  many_to_one :post
end
