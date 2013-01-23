# == Schema Information
#
# Table name: episodes
#
#  id          :integer         not null, primary key
#  tv_show_id  :integer
#  tvdb_id     :string(255)
#  imdb_id     :string(255)
#  name        :string(255)
#  season_num  :string(255)
#  episode_num :string(255)
#  first_aired :string(255)
#  overview    :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Episode do
  
  let(:tv_show) { FactoryGirl.create(:tv_show) }
  
  before do
    @episode = tv_show.episodes.build(tvdb_id:"4122165", 
                                      name:"A Horse of a Different Color", 
                                      season_num:"6", episode_num:"4", 
                                      first_aired:"2011-10-23")
  end
  
  subject { @episode }
  
  it { should respond_to(:tv_show_id) }
  it { should respond_to(:tvdb_id) }
  it { should respond_to(:name) }
  it { should respond_to(:season_num) }
  it { should respond_to(:episode_num) }
  it { should respond_to(:first_aired) }
  it { should respond_to(:tv_show) }
  its(:tv_show) { should == tv_show }
  
  it { should be_valid }
  
  describe "when tv_show_id is not present" do
    before { @episode.tv_show_id = nil }
    it { should_not be_valid }
  end
  
  describe "when name is not present" do
    before { @episode.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @episode.name = "a" * 101 }
    it { should_not be_valid }
  end
  
  describe "when season_num is not present" do
    before { @episode.season_num = " " }
    it { should_not be_valid }
  end
  
  describe "when season_num is too long" do
    before { @episode.season_num = "a" * 5 }
    it { should_not be_valid }
  end
  
  describe "when episode_num is not present" do
    before { @episode.episode_num = " " }
    it { should_not be_valid }
  end
  
  describe "when episode_num is too long" do
    before { @episode.episode_num = "a" * 6 }
    it { should_not be_valid }
  end
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Episode.new(tv_show_id: tv_show.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  
  describe "episode_tracker associations" do
    
    before { @episode.save }
    let!(:episode_tracker_first) do
      FactoryGirl.create(:episode_tracker, user_id: 44, episode_id: @episode.id)
    end

    let!(:episode_tracker_second) do
      FactoryGirl.create(:episode_tracker, user_id: 12, episode_id: @episode.id)
    end

    it "should show all the episode trackers for a given user" do
      @episode.episode_trackers.should == [episode_tracker_first,episode_tracker_second]
    end
    
    let(:episode_tracker) do
      @episode.episode_trackers.first
    end
    
    it "should just contain the first episode tracker in the array" do
      episode_tracker.should == episode_tracker_first
    end
    
    let(:episode_tracker_by_ep) do
      @episode.episode_trackers.where(user_id:12).first
    end
    
    it "should contain the episode tracker with the user_id set to 12" do
      episode_tracker_by_ep.should == episode_tracker_second
    end

    it "should destroy associated episode_trackers" do
      episode_trackers = @episode.episode_trackers
      @episode.destroy
      episode_trackers.each do |episode_tracker|
        EpisodeTracker.find_by_id(episode_tracker.id).should be_nil
      end
    end
  end
  
end


