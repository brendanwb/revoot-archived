require 'csv'
TVdbDir = "/Users/bwb/Sites/revoot/tvdb_api/"
TMdbDir = "/Users/bwb/Sites/revoot/tmdb_api/"

namespace :db do
  
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Example User",
                 email: "example@revoot.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@revoot.com"
      password = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    # Fill db with TVShows
    CSV.open("#{TVdbDir}1352758523_TV_Show_Pull.csv","r").each do |show|
      tvdb_id  = show[0]
      name     = show[1]
      year     = show[2]
      network  = show[3]
      genre    = show[4]
      tv_show = TvShow.create!(tvdb_id: tvdb_id,
                               name: name,
                               year: year,
                               network: network,
                               genre: genre)

         # Fill db with Episodes
           CSV.open("#{TVdbDir}1352758523_Episode_Pull.csv","r").each do |ep|
             if show[0] == ep[0]
               tvdb_id     = ep[1]
               name        = ep[2]
               season_num  = ep[3]
               episode_num = ep[4]
               first_aired = ep[5]
               tv_show.episodes.create!(tvdb_id: tvdb_id,
                                        name: name,
                                        season_num: season_num,
                                        episode_num: episode_num,
                                        first_aired: first_aired)
             end
           end                   
                     
    end
  
    users = User.all(limit: 6)
    episode_nums = (1..2189).to_a
    watched = [0,1]
    50.times do
      ep_num = episode_nums.shuffle.pop
      watch = watched.shuffle.pop
      users.each { |user| user.episode_trackers.create!(episode_id: ep_num,watched: watch) }
    end

   
    tv_shows = TvShow.all(limit: 10)
    user  = User.first
    tv_shows.each { |followed| user.follow_show!(followed) }

    CSV.open("#{TMdbDir}Movie_Pull.csv","r").each do |movie|
      tmdb_id      = movie[0]
      imdb_id      = movie[1]
      title        = movie[2]
      release_date = movie[3]
      overview     = movie[4]
      status       = movie[5]
      # run_time     = movie[6]
      # prod_comp    = movie[7]
      # language     = movie[8]
      # genre        = movie[9]
      Movie.create!(tmdb_id: tmdb_id,
                    imdb_id: imdb_id,
                    title: title,
                    release_date: release_date,
                    overview: overview,
                    status: status)
    end

    movies = Movie.all(limit: 3)
    user  = User.first
    movies.each { |followed| user.follow_movie!(followed) }
    
  end


end