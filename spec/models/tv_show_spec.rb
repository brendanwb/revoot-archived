# == Schema Information
#
# Table name: tv_shows
#
#  id         :integer         not null, primary key
#  tvdb_id    :string(255)
#  name       :string(255)
#  year       :string(255)
#  network    :string(255)
#  genre      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe TvShow do
  
  before do
    @tv_show = TvShow.new(tvdb_id:"79349", name:"dexter", year: 2006, network:"Showtime", genre:"|Action and Adventure|Drama|")
  end

  subject { @tv_show }
  
  it { should respond_to(:tvdb_id) }
  it { should respond_to(:name) }
  it { should respond_to(:year) }
  it { should respond_to(:network) }
  it { should respond_to(:genre) }
  it { should respond_to(:episodes) }
  it { should respond_to(:tv_show_followers) }
  
  describe "episode associations" do
    
    before { @tv_show.save }
    let!(:episode_first) do
      FactoryGirl.create(:episode, tv_show: @tv_show, tvdb_id: "310842", name: "Popping Cherry", season_num: "1", episode_num: "3", first_aired: "2006-10-15")
    end

    let!(:episode_second) do
      FactoryGirl.create(:episode, tv_show: @tv_show, tvdb_id: "341102", name: "Dex, Lies, and Videotape", season_num: "2", episode_num: "6", first_aired: "2007-11-04")
    end

    it "should show all the episodes for a given tv_show" do
      @tv_show.episodes.should == [episode_first,episode_second]
    end
    
    let(:episode) do
      @tv_show.episodes.first
    end
    
    it "should just contain the first episode tracker in the array" do
      episode.should == episode_first
    end
    
    let(:episode_by_ep) do
      @tv_show.episodes.where(name:"Dex, Lies, and Videotape").first
    end
    
    it "should contain the episode tracker with the user_id set to 44" do
      episode_by_ep.should == episode_second
    end

    it "should destroy associated episodes" do
      episodes = @tv_show.episodes
      @tv_show.destroy
      episodes.each do |episode|
        Episode.find_by_id(episode.id).should be_nil
      end
    end
  end
  
  describe "with blank name" do
    before { @tv_show.name = " " }
    it { should_not be_valid }
  end
  
  describe "with name that is too long" do
    before { @tv_show.name = "a" * 101 }
    it { should_not be_valid }
  end

  describe "user followers" do
    let(:user_follower) { FactoryGirl.create(:user) }
    before do
      @tv_show.save
      user_follower.follow_show!(@tv_show)
    end

    its(:tv_show_followers) { should include(user_follower) }
  end
  
end


