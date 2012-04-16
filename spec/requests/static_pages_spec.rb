require 'spec_helper'

describe "Static pages" do
  # subject { page } allows us to eliminate the sources of 
  # duplication of stating it "should have xxxx" and page.should have_xxxx
  # by telling RSpec that page is the subject of all the tests
  subject { page }
  
  describe "Home page" do
    
    # example of old test to compare to updated tests below
    # it "should have content 'Help'" do
    #   visit help_path
    #   page.should have_selector('h1', :text => 'Help')
    # end
    
    # use before to eliminate the duplication of stating visit 
    # root_path in each test
    before { visit root_path }
    
    # using a variant of the it method to collapse the code and 
    # description into one line like below
    it { should have_selector('h1', text: 'Revoot') }
    # full_title is used just like in the helper for the actual view.  It is 
    # stored in spec/support/utilities.rb and is available to all RSpec tests
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector('title', text: '| Home') }
  end
  
  describe "Help page" do

    before { visit help_path }

    # the line "should have content 'Help'" do was removed as a result of
    # adding the subject { page } to the beginning of the page. brackets
    # are used instead of a do end block
    # all hashes have been changed from :text => 'Help' to new 1.9.3 simplified
    # text: 'Help' style.
    it { should have_selector('h1', text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }
  end
  
  describe "About page" do
    
    before { visit about_path }
    
    it { should have_selector('h1', :text => 'About Us') }
    it { should have_selector('title', text: full_title('About Us')) }
  end
  
  describe "Contact page" do
    before { visit contact_path }
    it { should have_selector('h1', text: 'Contact') }
    it { should have_selector('title', text: full_title('Contact')) }
  end
  
end
