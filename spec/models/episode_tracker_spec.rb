# == Schema Information
#
# Table name: episode_trackers
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  episode_id :integer
#  watched    :boolean
#  rating     :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe EpisodeTracker do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:episode) { FactoryGirl.create(:episode) }
  before do
    @episode_tracker = user.episode_trackers.build(episode_id: episode.id,watched:1)
  end
  
  subject { @episode_tracker }
  
  it { should respond_to(:user_id) }
  it { should respond_to(:episode_id) }
  it { should respond_to(:watched) }
  it { should respond_to(:user) }
  it { should respond_to(:episode) }
  its(:user) { should == user }
  its(:episode) { should == episode }
  
  it { should be_valid }
  
  describe "when user id is not present" do
    before { @episode_tracker.user_id = nil }
    it { should_not be_valid }
  end

  describe "when episode id is not present" do
    before { @episode_tracker.episode_id = nil }
    it { should_not be_valid }
  end
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        EpisodeTracker.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  
end


