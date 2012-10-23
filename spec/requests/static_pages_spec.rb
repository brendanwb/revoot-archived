require 'spec_helper'

describe "Static pages" do
  # subject { page } allows us to eliminate the sources of 
  # duplication of stating it "should have xxxx" and page.should have_xxxx
  # by telling RSpec that page is the subject of all the tests
  subject { page }
  
  # RSpec supports a facility called shared examples to eliminate
  # the kind of duplication seen testing for h1 and title in Home page, 
  # Help page, About page and Contact page tests here.
  shared_examples_for "all static pages" do
    # using a variant of the it method to collapse the code and 
    # description into one line like below
    # all hashes have been changed from :text => 'Help' to new 1.9.3 simplified
    # text: 'Help' style.
    it { should have_selector('h1',    text: heading) }
    # full_title is used just like in the helper for the actual view.  It is 
    # stored in spec/support/utilities.rb and is available to all RSpec tests
    it { should have_selector('title', text: full_title(page_title)) }
  end
  
  describe "Home page" do
    
    # example of old test to compare to updated tests below
    # it "should have content 'Help'" do
    #   visit help_path
    #   page.should have_selector('h1', :text => 'Help')
    # end
    
    # use before to eliminate the duplication of stating visit 
    # root_path in each test
    before { visit root_path }
    
    # let is used to create local variables to be used in testing
    let(:heading)    { 'Revoot' }
    let(:page_title) { '' }
    
    it_should_behave_like "all static pages"
    it { should_not have_selector('title', text: '| Home') }
  end
  
  describe "Help page" do

    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end
  
  describe "About page" do
    
    before { visit about_path }
    let(:heading)    { 'About Us' }
    let(:page_title) { 'About Us' }
    
    it_should_behave_like "all static pages"
  end
  
  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }
    
    it_should_behave_like "all static pages"
  end
  
  describe "for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit root_path
    end

    # it "should render the user's feed" do
    #   user.f
    # end

    describe "followed_show counts" do
      let(:tv_show) { FactoryGirl.create(:tv_show) }
      before do
        user.follow_show!(tv_show)
        visit root_path
      end

      it { should have_link("1 TV Show Followed", href:user_path(user)) }
    end
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')    
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    page.should have_selector 'title', text: full_title('')
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up now!')
  end
  
end
