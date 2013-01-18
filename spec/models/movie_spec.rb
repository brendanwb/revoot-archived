# == Schema Information
#
# Table name: movies
#
#  id                 :integer         not null, primary key
#  tmdb_id            :integer
#  imdb_id            :string(255)
#  title              :string(255)
#  release_date       :string(255)
#  overview           :text
#  status             :string(255)
#  run_time           :integer
#  production_company :string(255)
#  language           :string(255)
#  genre              :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#


require 'spec_helper'

describe Movie do
  
  before do
  	@movie = Movie.create(tmdb_id:550, imdb_id:"tt0137523", title:"Fight Club", release_date:"1999-10-15", overview:"A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.", status:"Released", run_time:139, production_company:"20th Century Fox", language:"English", genre:"Action")
  end


  subject { @movie }

  it { should respond_to(:tmdb_id) }
  it { should respond_to(:imdb_id) }
  it { should respond_to(:title) }
  it { should respond_to(:release_date) }
  it { should respond_to(:overview) }
  it { should respond_to(:status) }
  it { should respond_to(:run_time) }
  it { should respond_to(:production_company) }
  it { should respond_to(:language) }
  it { should respond_to(:genre) }

  it { should be_valid }

  describe "with blank title" do
  	before { @movie.title = " " }
  	it { should_not be_valid }
  end

  describe "with title that is too long" do
  	before { @movie.title = "a" * 101 }
  	it { should_not be_valid }
  end

  describe "when tmdb_id is blank" do
  	before { @movie.tmdb_id = " "}
  	it { should_not be_valid }
  end

  describe "when run_time is too long" do
  	before { @movie.run_time = 1 * 1000 }
  	it { should_not be_valid }
  end

  describe "movie_tracker associations" do

  	before { @movie.save }
  	let!(:movie_tracker_first) do
  		FactoryGirl.create(:movie_tracker, user_id: 44, movie_id: @movie.id)
  	end

  	let!(:movie_tracker_second) do
  		FactoryGirl.create(:movie_tracker, user_id: 12, movie_id: @movie.id)
  	end

  	it "should show all movie_trackers for a given movie" do
  		@movie.movie_trackers.should == [movie_tracker_first,movie_tracker_second]
  	end

  	let(:movie_tracker) do
  		@movie.movie_trackers.first
  	end

  	it "should just contain the first movie tracker in the array" do
  		movie_tracker.should == movie_tracker_first
  	end

  	let(:movie_tracker_by_movie) do
  		@movie.movie_trackers.where(user_id:12).first
  	end

  	it "should contain the movie tracker with the user_id set to 12" do
  		movie_tracker_by_movie.should == movie_tracker_second
  	end

  	it "should destroy associated movie_trackers" do
  		movie_trackers = @movie.movie_trackers
  		@movie.destroy
  		movie_trackers.each do |movie_tracker|
  			MovieTracker.find_by_id(movie_tracker.id).should be_nil
  		end
  	end
  end
end
