require 'spec_helper'

describe "Movie Pages" do
	subject { page }

	describe "movie page" do
		before(:all) { 30.times { FactoryGirl.create(:movie) } }
		let(:movie_test) { FactoryGirl.create(:movie) }
		after(:all) { Movie.delete_all }
		before { visit movies_path }

		it { should have_selector("h1",    text: "Movies") }
		it { should have_selector("title", text: full_title("Movies")) }
		it { should have_selector("h3",    text: movie_test.title) }
	end

	describe "individual movie page" do
		let(:user) { FactoryGirl.create(:user) }
		let(:single_movie) { FactoryGirl.create(:movie) }

		before do
			sign_in user
			visit movie_path(single_movie)
		end

		it { should have_selector('h1',       text: single_movie.title) }
		it { should have_selector('title',    text: single_movie.title) }
		it { should have_selector('p',        text: single_movie.release_date) }
		it { should have_selector('p',        text: single_movie.status) }
		it { should have_selector('p',        text: single_movie.overview) }
		it { should have_selector('h3',       text: "Overview") }

		describe "follow/unfollow buttons" do
      before { sign_in user }

      describe "following a movie" do
        before  { visit movie_path(single_movie)}

        it "should increment the movie_followers" do
          expect do
            click_button "Follow"
          end.to change(single_movie.movie_trackers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: "Unfollow") }
        end
      end

      describe "unfollowing a movie" do
        before do
          user.follow_movie!(single_movie)
          visit movie_path(single_movie)
        end

        it "should decrement the movies followers count" do
          expect do
            click_button "Unfollow"
          end.to change(single_movie.movie_trackers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end        
      end
    end
	end
end
