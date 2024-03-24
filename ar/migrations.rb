# frozen_string_literal: true

require "./db.rb"
ActiveRecord::Schema.define do
  create_table :comments, force: true do |t|
    t.integer :post_id
    t.string :body
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["post_id"], name: "index_comments_on_post_id", using: :btree
  end

  create_table :posts, force: true do |t|
    t.integer :topic_id
    t.string :body
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["topic_id"], name: "index_posts_on_topic_id", using: :btree
  end

  create_table :topics, force: true do |t|
    t.string :name
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_foreign_key :posts, :topics, column: :topic_id
  add_foreign_key :comments, :posts, column: :post_id
end

ActiveRecord::Base.remove_connection
