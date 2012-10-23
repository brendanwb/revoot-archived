FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "Person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    
    factory :admin do
      admin true
    end
  end
  
  factory :tv_show do
    sequence(:tvdb_id) { |n| "#{n}"}
    name "Dexter"
    year 2006
    network "Showtime"
    genre "Action"
  end
  
  factory :episode do
    tv_show
    tvdb_id "307473"
    name "Dexter"
    season_num "1"
    episode_num "1"
    first_aired "2006-10-01"
  end
  
  factory :episode_tracker do
    user
    episode
    watched true
  end
end