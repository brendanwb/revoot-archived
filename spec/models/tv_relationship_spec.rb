require 'spec_helper'

describe TvRelationship do
  
  let(:user_follower) {FactoryGirl.create(:user)}
  let(:tv_show_followed) {FactoryGirl.create(:tv_show)}
  let(:tv_relationship) {user_follower.tv_relationships.build(tv_show_id: tv_show_followed.id)}

  subject { tv_relationship }

  it { should be_valid }

  describe "accessible attributes" do
  	it "should not allow access to user_follower id" do
  		expect do
  			TvRelationship.new(user_id: user_follower.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end

  describe "follower methods" do
  	it { should respond_to(:user) }
  	it { should respond_to(:tv_show) }
  	its(:user_id) { should == user_follower.id }
  	its(:tv_show_id) { should == tv_show_followed.id }
  end

  describe "when tv_show id is not present" do
  	before { tv_relationship.tv_show_id = nil }
  	it { should_not be_valid }
  end

  describe "when user id is not present" do
  	before { tv_relationship.user_id = nil }
  	it { should_not be_valid }
  end
end
