require 'spec_helper'

describe "Tv Show Pages" do
	subject { page }

	describe "tv shows page" do
		before(:all) { 30.times { FactoryGirl.create(:tv_show) } }
		after(:all) { TvShow.delete_all }
		before { visit tv_path }

		it { should have_selector("h1",    text: "TV Shows") }
		it { should have_selector("title", text: full_title("TV Shows"))}
		# it { should have_selector("h2",    text: tv_show.name)}

	end

	describe "individual tv show page" do
		let(:user) { FactoryGirl.create(:user) }
		let(:single_tv_show) { FactoryGirl.create(:tv_show) }

		before do
			sign_in user
			visit tv_show_path(single_tv_show)
		end

		it { should have_selector('h1',     text: single_tv_show.name) }
		it { should have_selector('title',  text: single_tv_show.name) }
		it { should have_selector('p',      text: single_tv_show.year.to_s) }
		it { should have_selector('p',      text: single_tv_show.network) }
		it { should have_selector('p',      text: single_tv_show.genre) }
		it { should have_selector('h3',     text: "Seasons") }
		# it { should have_selector('li',     text: single_tv_show.episodes.first.name) }
		# it { should have_link(user.name, href: user_path(user)) }

		describe "follow/unfollow buttons" do
      before { sign_in user }

      describe "following a tv_show" do
        before  { visit tv_show_path(single_tv_show)}

        it "should increment the tv_show_followers" do
          expect do
            click_button "Follow"
          end.to change(single_tv_show.tv_show_followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: "Unfollow") }
        end
      end

      describe "unfollowing a show" do
        before do
          user.follow_show!(single_tv_show)
          visit tv_show_path(single_tv_show)
        end

        it "should decrement the tv_shows followers count" do
          expect do
            click_button "Unfollow"
          end.to change(single_tv_show.tv_show_followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end        
      end
    end
	end
end
