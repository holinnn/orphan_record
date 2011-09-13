# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe OrphanRecord::ActiveRecord do
  before(:each) do
    Object.send(:remove_const, :Comment) if defined?(Comment)
    Object.send(:remove_const, :AdoptiveUser) if defined?(AdoptiveUser)
    comment_class = Class.new(ActiveRecord::Base) do
      belongs_to :user
    end
    Object.const_set(:Comment, comment_class)

    @comment = Comment.new
    @user = User.new
  end

  describe ".can_be_abandoned_by" do
    it "should alias the relation to keep a pointer" do
      expect {
        Comment.class_exec { can_be_abandoned_by :user }
      }.to change{ @comment.respond_to?(:original_user) }.from(false).to(true)
      
    end

    it "should raise an exception if relation is not defined" do
      expect {
        Comment.class_exec { can_be_abandoned_by :post }
      }.to raise_exception(OrphanRecord::RelationNotFound)
    end

    it "should raise an exception if relation is not a belongs_to" do
      expect {
        Post.class_exec { can_be_abandoned_by :comments }
      }.to raise_exception(OrphanRecord::InvalidRelation)
    end
  end

  describe ".redefine_relation_for_adopter" do
    it "should return adopter if foreign key is nil" do
      an_object = Object.new
      Comment.class_exec { can_be_abandoned_by :user, :adopted_by => an_object }

      @comment.user.should == an_object
    end

    it "should return the relation if foreign key is not nil" do
      an_object = Object.new
      Comment.class_exec { can_be_abandoned_by :user, :adopted_by => an_object }
      @comment.stub(:user_id).and_return(1)
      @comment.stub(:user).and_return(@user)
      @comment.user.should == @user
    end

    it "should return the relation if relation is set" do
      an_object = Object.new
      Comment.class_exec { can_be_abandoned_by :user, :adopted_by => an_object }
      @comment.user = @user
      @comment.user.should == @user
    end
  end

  describe ".create_adoptive_class" do
    it "should defined an anonymous class" do
      reflection = mock('reflection', :class_name => 'ActiveRecord::Base')
      expect {
        Comment.class_exec(reflection) { |reflection| create_adoptive_class(reflection, 'AdoptiveUser') }
      }.to change{ Object.const_defined?(:AdoptiveUser) }.from(false).to(true)
    end
  end
end
