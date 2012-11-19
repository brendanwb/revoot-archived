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

  factory :movie do
    tmdb_id 550
    imdb_id "tt0137523"
    title "Fight Club"
    release_date "1999-10-15"
    overview "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion."
    status "Released"
    run_time 139
    production_company "20th Century Fox"
    language "English"
    genre "Action"
  end

  factory :movie_tracker do
    user
    movie
    watched true
    rating true
  end
end