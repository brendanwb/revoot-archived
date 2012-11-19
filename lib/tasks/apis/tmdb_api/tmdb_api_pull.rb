require 'rubygems'
require 'ruby-tmdb3'

WorkingDir     = '/Users/bwb/Sites/revoot/tmdb_api/'

# setup your API key
Tmdb.api_key = "241a892fe86fdce4c9e40293dd29b033"

# setup your default language
Tmdb.default_language = "en"


File.open("#{WorkingDir}Movies_List.txt", "r").each do |movie|
	@movie = TmdbMovie.find(:title => "#{movie}", :limit => 1)
	# => <OpenStruct>

	language = @movie.spoken_languages


  File.open("#{WorkingDir}Movie_Pull.csv", "a") do |file|
  	file.puts "#{@movie.id},\"#{@movie.imdb_id}\",\"#{@movie.title}\",\"#{@movie.release_date}\",\"#{@movie.overview}\",\"#{@movie.status}\",#{@movie.run_time},\"#{@movie.production_companies}\",\"#{@movie.spoken_languages}\",\"#{@movie.genres}\""
  end
end