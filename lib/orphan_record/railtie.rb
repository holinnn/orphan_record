# encoding: utf-8

module OrphanRecord
  class Railtie < ::Rails::Railtie
    initializer 'orphan_record' do |app|
      ActiveSupport.on_load(:active_record) do
        OrphanRecord.register_orphan_record!
      end
    end
  end
end