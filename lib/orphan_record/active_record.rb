# encoding: utf-8

require 'active_support/concern'
require 'active_support/inflector'

module OrphanRecord
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      private
      def can_be_abandoned_by(relation, options = {})
        if reflection = reflect_on_association(relation)
          raise OrphanRecord::InvalidRelation.new("relation #{relation} is not a belongs_to relation") unless reflection.macro == :belongs_to
        else
          raise OrphanRecord::RelationNotFound.new("relation #{relation} was not found in #{name}")
        end
        
        alias_method "original_#{relation}".to_sym, relation

        adoptive_class_name = "Adoptive#{reflection.class_name}"
        create_adoptive_class(reflection, adoptive_class_name) unless Object.const_defined?(adoptive_class_name)
        adopted_by = options[:adopted_by] || adoptive_class_name.constantize.instance
        redefine_relation_for_adopter(relation, adopted_by)
      end

      def create_adoptive_class(reflection, adoptive_class_name)
        adoptive_class = Class.new(reflection.class_name.constantize)
        Object.const_set(adoptive_class_name.to_sym, adoptive_class)

        # We must include this module once the class name is set
        adoptive_class.instance_exec { include OrphanRecord::AdoptiveModel }
      end

      def redefine_relation_for_adopter(relation, adopted_by = nil)
        define_method(relation) do
          parent = send("original_#{relation}".to_sym)
          if(send("#{relation}_id".to_sym).nil? && parent.nil?)
            adopted_by
          else
            parent
          end
        end
      end
      
    end
  end
end