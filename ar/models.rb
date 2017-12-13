# frozen_string_literal: true

require "active_record"

class Topic < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :topic
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :post
end
