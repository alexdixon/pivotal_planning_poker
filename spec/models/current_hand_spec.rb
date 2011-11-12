require 'spec_helper'

describe CurrentHand do
  it "should create a hand for a project" do
    CurrentHand.create!(:project_id => 789, :story_id => 543)
    CurrentHand.find_by_project_id(789).story_id.should == 543
  end

  it "should not create 2 hands for the same project" do
    CurrentHand.create!(:project_id => 555, :story_id => 543)
    lambda { CurrentHand.create!(:project_id => 555, :story_id => 543) }.should raise_error(ActiveRecord::RecordNotUnique)
  end

  it "should require story_id" do
    lambda { CurrentHand.create!(:project_id => 789) }.should raise_error(ActiveRecord::StatementInvalid)
  end

  it "should require project id" do
    lambda { CurrentHand.create!(:story_id => 543) }.should raise_error(ActiveRecord::StatementInvalid)
  end
end
