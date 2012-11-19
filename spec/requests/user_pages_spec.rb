require 'spec_helper'

describe "User pages" do
  subject { page }
  
  describe "index" do

    let(:user) { FactoryGirl.create(:user) }
    
    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all)  { User.delete_all }
    
    before(:each) do
      sign_in user
      visit users_path
    end
    
    it { should have_selector('title', text: 'All users') }
    
    describe "pagination" do
      
      it { should have_link('Next') }
      its(:html) { should match('>2</a>') }
      
      it "should list each user" do
        User.all[0..2].each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
    
    describe "delete links" do
      
      it { should_not have_link('delete') }
      
      describe "as an admin user" do
        let(:admin)  { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        
        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
    
  end
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let(:tv_show) { FactoryGirl.create(:tv_show) }
    let(:episode_1) { FactoryGirl.create(:episode) }
    let(:episode_2) { FactoryGirl.create(:episode, tv_show: tv_show, tvdb_id: "307474", name: "Who Knows", season_num: "1", episode_num: "2", first_aired: "2006-10-08") }
    let!(:t1) { FactoryGirl.create(:episode_tracker, user: user, episode: episode_1, watched: 1) }
    let(:movie) { FactoryGirl.create(:movie) }
    let!(:mt1) { FactoryGirl.create(:movie_tracker, user: user, movie: movie, watched: 1, rating: 1) }

    before { visit user_path(user) }
    
    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }

    describe "show trackers" do
      # it { should have_content(t1.watched) } find a way to test for this
      it { should have_content(user.episode_trackers.count) }
    end

    describe "movie trackers" do
      it { should have_content(user.movie_trackers.count) }
    end

    describe "follow/unfollow buttons" do
      before { sign_in user }

      describe "following a tv_show" do
        before  { visit tv_show_path(tv_show)}

        it "should increment the followed shows count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_shows, :count).by(1)
        end

        it "should increment the tv_show_followers" do
          expect do
            click_button "Follow"
          end.to change(tv_show.tv_show_followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: "Unfollow") }
        end
      end

      describe "unfollowing a show" do
        before do
          user.follow_show!(tv_show)
          visit tv_show_path(tv_show)
        end

        it "should decrement the followed tv_show count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_shows, :count).by(-1)
        end

        it "should decrement the tv_shows followers count" do
          expect do
            click_button "Unfollow"
          end.to change(tv_show.tv_show_followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end        
      end
    end
  end
  
  describe "signup page" do
    before { visit signup_path }
    
    it { should have_selector('h1',    text: 'Sign up now!') }
    it { should have_selector('title', text: full_title('Sign up now!')) }
  end
  
  describe "signup" do
    
    before { visit signup_path }
    
    let(:submit) { "Create my account" }
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "error messages" do
        before { click_button submit }
        
        it { should have_selector('title', text: 'Sign up now!') }
        it { should have_selector('div.alert.alert-error', text: 'The form contains')}
        it { should have_selector('div', class: 'field_with_errors') }
        it { should have_content('error') }
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Name",             with: "Example User"
        fill_in "Email",            with: "user@example.com"
        fill_in "Password",         with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }
        
        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success'), text: 'Welcome'}
        it { should have_link('Sign out') }
      end
    end
  end
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end
    
    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title',  text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end
    
    describe "with invalid information" do
      before { click_button "Save changes" }
      
      it { should have_content('error') }
    end
    
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end
      
      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
      
    end
  end

  describe "following tv shows" do
    let(:user) { FactoryGirl.create(:user) }
    let(:tv_show) { FactoryGirl.create(:tv_show) }

    before { user.follow_show!(tv_show) }

    describe "followed tv show" do
      before do
        sign_in user
        visit user_path(user)
      end

      it { should have_link(tv_show.name, href: tv_show_page_path(tv_show)) }
    end
  end  
end
