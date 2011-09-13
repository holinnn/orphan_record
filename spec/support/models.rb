# encoding: utf-8

# encoding: utf-8

require 'active_record'
require 'orphan_record'

OrphanRecord.register_orphan_record!

# Database
ActiveRecord::Base.configurations = {'test' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('test')


# Migration
class ModelMigrations < ActiveRecord::Migration
  def self.up
    create_table(:users) { |t| t.string :user_name }
    create_table(:comments) { |t| t.text :content; t.integer :user_id }
    create_table(:posts) { |t| t.text :content; t.integer :user_id }
  end
end

# Models

class User < ActiveRecord::Base
  has_many :comments

  def static_user_name
    "Picsou"
  end
end


class Post < ActiveRecord::Base
  has_many :comments
end
