# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')



describe OrphanRecord::AdoptiveModel do
  before(:each) do
    Object.send(:remove_const, :AdoptiveUser) if defined?(AdoptiveUser)
    adoptive_class = Class.new(User)
    adoptive_class.send(:include, Singleton)
    Object.const_set(:AdoptiveUser, adoptive_class)
  end

  describe ".redefine_methods_for_orphan" do
    it "should define method based on I18n keys/values" do
      expect {
        AdoptiveUser.instance_exec { include OrphanRecord::AdoptiveModel }
      }.to change { AdoptiveUser.instance.user_name }.from(nil).to('Account deleted')
    end

    it "should not redefine methods not in I18n file" do
      expect {
        AdoptiveUser.instance_exec { include OrphanRecord::AdoptiveModel }
      }.to_not change { AdoptiveUser.instance.static_user_name }
    end
  end
end
