require 'spec_helper'

describe MovieTracker do
  let(:user) { FactoryGirl.create(:user) }
  let(:movie) { FactoryGirl.create(:movie) }
  before do
  	@movie_tracker = user.movie_trackers.build(movie_id: movie.id, watched:1,rating:1)
  end

  subject { @movie_tracker }

  it { should respond_to(:user_id) }
  it { should respond_to(:movie_id) }
  it { should respond_to(:watched) }
  it { should respond_to(:rating) }
  it { should respond_to(:user) }
  it { should respond_to(:movie) }
  its(:user) { should == user }
  its(:movie) { should == movie }

  it { should be_valid }

  describe "when user id is not present" do
  	before { @movie_tracker.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when movie id is not present" do
  	before { @movie_tracker.movie_id = nil }
  	it { should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        MovieTracker.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
