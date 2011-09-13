# encoding: utf-8

require 'active_support/concern'
require 'active_support/inflector'

module OrphanRecord
  module AdoptiveModel
    extend ActiveSupport::Concern

    included do
      include Singleton
      redefine_methods_for_orphan
    end

    module ClassMethods
      def new
        @attributes = {}
        @attributes_cache = {}
        @new_record = true
        @readonly = false
        @destroyed = false
        @marked_for_destruction = false
        @previously_changed = {}
        @changed_attributes = {}
      end

      private
      def redefine_methods_for_orphan
        I18n.t("orphan_record.#{self.name.underscore}").each do |key, value|
          define_method(key) { value }
        end
      end
    end

    module InstanceMethods
      def readonly?
        true
      end

      def adopter?
        true
      end

      def id
        0
      end
    end
  end
end