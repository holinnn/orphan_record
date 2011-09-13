# encoding: utf-8

module OrphanRecord
  module Helpers
    def url_for(options = {})
      if options.is_a?(::ActiveRecord::Base) && options.adopter?
        '#'
      else
        super
      end
    end
  end
end