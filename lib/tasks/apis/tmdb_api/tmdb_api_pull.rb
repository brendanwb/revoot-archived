require 'rubygems'
require 'ruby-tmdb3'
APP_ROOT = File.dirname(__FILE__)
TMdbDir = "#{APP_ROOT}/apis/tmdb_api/"

WorkingDir     = '/Users/bwb/Sites/revoot/revoot_app/lib/tasks/apis/tmdb_api/'

# setup your API key
Tmdb.api_key = "241a892fe86fdce4c9e40293dd29b033"

# setup your default language
Tmdb.default_language = "en"


File.open("#{WorkingDir}Movies_List.txt", "r").each do |movie|
	@movie = TmdbMovie.find(:title => "#{movie}", :limit => 1)
	# => <OpenStruct>
  unless @movie.nil?
	language = @movie.spoken_languages


    File.open("#{WorkingDir}Movie_Pull.csv", "a") do |file|
  	  # file.puts "#{@movie.id}~\"#{@movie.imdb_id}\"~\"#{@movie.title}\"~\"#{@movie.release_date}\"~\"#{@movie.overview}\"~\"#{@movie.status}\"~#{@movie.run_time}~\"#{@movie.production_companies}\"~\"#{@movie.spoken_languages}\"~\"#{@movie.genres}\""
  	  file.puts "#{@movie.id}~\"#{@movie.imdb_id}\"~\"#{@movie.title}\"~\"#{@movie.release_date}\"~\"#{@movie.overview}\""
    end
  end
end