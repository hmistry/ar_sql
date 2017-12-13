# frozen_string_literal: true

require "./db.rb"

DB.drop_table :comments if DB.table_exists?(:comments)
DB.drop_table :posts if DB.table_exists?(:posts)
DB.drop_table :topics if DB.table_exists?(:topics)

DB.create_table :topics do
  primary_key :id
  String :name
  DateTime "created_at",                          null: false
  DateTime "updated_at",                          null: false
end

DB.create_table :posts do
  primary_key :id
  foreign_key :topic_id, :topics
  String :body, text: true
  DateTime "created_at",                          null: false
  DateTime "updated_at",                          null: false
  index :topic_id
end

DB.create_table :comments do
  primary_key :id
  foreign_key :post_id, :posts
  String :body, text: true
  DateTime "created_at",                          null: false
  DateTime "updated_at",                          null: false
  index :post_id
end
