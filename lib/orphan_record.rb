# encoding: utf-8

require 'rubygems'
require 'orphan_record/active_record'
require 'orphan_record/adoptive_model'

module OrphanRecord

  class RelationNotFound < StandardError; end
  class InvalidRelation < StandardError; end

  class << self
    def register_orphan_record!
      ::ActiveRecord::Base.class_eval do
        include OrphanRecord::ActiveRecord
      end
    end
  end
  
end

