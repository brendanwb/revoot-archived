# == Schema Information
#
# Table name: users
#
#  id                      :integer         not null, primary key
#  name                    :string(255)
#  email                   :string(255)
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#  password_digest         :string(255)
#  remember_token          :string(255)
#  admin                   :boolean         default(FALSE)
#  password_reset_token    :string(255)
#  password_reset_sent_at  :datetime
#  confirmation_token      :string(255)
#  confirmation_token_sent :datetime
#  state                   :string(255)
#

require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Example User", email: "user@example.com", 
                     password: "foobar", password_confirmation: "foobar")
  end
  
  subject { @user }
  
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:episodes) }
  it { should respond_to(:episode_trackers) }
  it { should respond_to(:tv_relationships) }
  it { should respond_to(:followed_shows) }
  it { should respond_to(:following_show?) }
  it { should respond_to(:follow_show!) }
  it { should respond_to(:unfollow_show!) }
  it { should respond_to(:watched_episode?) }
  it { should respond_to(:watch_episode!) }
  it { should respond_to(:unwatch_episode!) }
  it { should respond_to(:movies) }
  it { should respond_to(:movie_trackers) }
  it { should respond_to(:following_movie?) }
  it { should respond_to(:follow_movie!) }
  it { should respond_to(:unfollow_movie!) }
  
  it { should be_valid }
  it { should_not be_admin }
  
  describe "with admin attribute set to 'true" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    
    it { should be_admin }
  end
  
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end
  
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cm]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it { should_not be_valid }
  end
  
  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end
  
  describe "when password doesn't match confirmaiton" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }
    
    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end
    
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
  
  describe "accessible attributes" do
    it "should not allow access to admin" do
      expect do
        User.new(admin: true)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  
  describe "episode_tracker associations" do
    
    before { @user.save }
    let!(:episode_tracker_first) do
      FactoryGirl.create(:episode_tracker, user: @user, episode_id:5)
    end

    let!(:episode_tracker_second) do
      FactoryGirl.create(:episode_tracker, user: @user, episode_id:3)
    end

    it "should show all the episode trackers for a given user" do
      @user.episode_trackers.should == [episode_tracker_second,episode_tracker_first]
    end
    
    let(:episode_tracker) do
      @user.episode_trackers.first
    end
    
    it "should just contain the first episode tracker in the array" do
      episode_tracker.should == episode_tracker_second
    end
    
    let(:episode_tracker_by_ep) do
      @user.episode_trackers.where(episode_id:"5").first
    end
    
    it "should contain the episode tracker with the episode_id set to 5" do
      episode_tracker_by_ep.should == episode_tracker_first
    end

    it "should destroy associated episode_trackers" do
      episode_trackers = @user.episode_trackers.dup
      @user.destroy
      episode_trackers.should_not be_empty
      episode_trackers.each do |episode_tracker|
        EpisodeTracker.find_by_id(episode_tracker.id).should be_nil
      end
    end
  end

  describe "following tv_show" do
    let(:tv_show_followed) { FactoryGirl.create(:tv_show) }
    before do
      @user.save
      @user.follow_show!(tv_show_followed)
    end

    it { should be_following_show(tv_show_followed) }
    its(:followed_shows) { should include(tv_show_followed) }

    describe "and unfollowing" do
      before { @user.unfollow_show!(tv_show_followed) }

      it { should_not be_following_show(tv_show_followed) }
      its(:followed_shows) { should_not include(tv_show_followed) }
    end
  end
  
  describe "movie_tracker associations" do
    
    before { @user.save }
    let!(:movie_tracker_first) do
      FactoryGirl.create(:movie_tracker, user: @user, movie_id:5)
    end

    let!(:movie_tracker_second) do
      FactoryGirl.create(:movie_tracker, user: @user, movie_id:3)
    end

    it "should show all the movie trackers for a given user" do
      @user.movie_trackers.should == [movie_tracker_second,movie_tracker_first]
    end
    
    let(:movie_tracker) do
      @user.movie_trackers.first
    end
    
    it "should just contain the first movie tracker in the array" do
      movie_tracker.should == movie_tracker_second
    end
    
    let(:movie_tracker_by_movie) do
      @user.movie_trackers.where(movie_id:5).first
    end
    
    it "should contain the movie tracker with the movie_id set to 5" do
      movie_tracker_by_movie.should == movie_tracker_first
    end

    it "should destroy associated movie_trackers" do
      movie_trackers = @user.movie_trackers.dup
      @user.destroy
      movie_trackers.should_not be_empty
      movie_trackers.each do |movie_tracker|
        MovieTracker.find_by_id(movie_tracker.id).should be_nil
      end
    end
  end

  describe "following movie" do
    let(:movie_followed) { FactoryGirl.create(:movie) }
    before do
      @user.save
      @user.follow_movie!(movie_followed)
    end

    it { should be_following_movie(movie_followed) }
    its(:movie_trackers) { should_not be_nil }

    describe "and unfollowing" do
      before { @user.unfollow_movie!(movie_followed) }

      it { should_not be_following_movie(movie_followed) }
      its(:movie_trackers) { should_not include(movie_followed) }
    end
  end
  
end
