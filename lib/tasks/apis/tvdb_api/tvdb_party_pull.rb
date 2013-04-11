require '/Users/bwb/Sites/tvdb_party/lib/tvdb_party.rb'
WorkingDir     = '/Users/bwb/Sites/revoot/revoot_app/lib/tasks/apis/tvdb_api/'

File.open("#{WorkingDir}TV_Show_List.txt", 'r').each do |show|
  tvdb               = TvdbParty::Search.new("102D37BF66CADAB7")
  results            = tvdb.search_by_imdb_id(show.chomp)
  tv_show            = tvdb.get_series_by_id(results.first["seriesid"])
  series_id          = tv_show.id
  series_name        = tv_show.name
  series_first_aired = tv_show.first_aired
  # year = series_first_aired.split("-").first
  network  = tv_show.network
  genres   = tv_show.genres
  runtime  = tv_show.runtime
  overview = tv_show.overview.gsub("\n"," ") unless tv_show.overview.nil?

  tv_show_info = {1 => [series_id,series_name,series_first_aired,network,genres,overview]}
  File.open("#{WorkingDir}TV_Show_Pull.csv", "a") do |file|
    tv_show_info.each_value do |v|
      file.puts "#{v[0]}~#{v[1]}~#{v[2]}~#{v[3]}~#{v[4]}~#{v[5]}"
    end
  end

	episodes = tvdb.get_all_episodes(tv_show)
  File.open("#{WorkingDir}Episode_Pull.csv","a") do |file|
    episodes.each do |ep|
      ep_id            = ep.id
      ep_name          = ep.name
      ep_season_number = ep.season_number
      ep_number        = ep.number
      ep_air_date      = ep.air_date
      ep_overview      = ep.overview.gsub("\n"," ") unless ep.overview.nil?
      file.puts "#{ep_id}~#{ep_name}~#{ep_season_number}~#{ep_number}~#{ep_air_date}~#{ep_overview}"
    end
  end
end