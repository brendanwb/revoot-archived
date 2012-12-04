require 'rubygems'
require 'net/http'
require 'nokogiri'

APP_ROOT = File.dirname(__FILE__)
WorkingDir = "#{APP_ROOT}/apis/tvdb_api/"

MirrorsPath    = 'http://www.thetvdb.com/api/102D37BF66CADAB7/'
ServerTimeUri  = 'http://www.thetvdb.com/api/Updates.php?type=none'
SeriesbyId     = 'http://www.thetvdb.com/api/GetSeries.php?seriesname='

def grab_xml(uri)
  begin
    response = Net::HTTP.get_response(uri)
    if response.code != "200"
      raise
    end
    return response
  rescue
    puts "Failed to grab Server Time"
    exit 1
  end
end

def create_xml(response)
  begin
    xml_doc = Nokogiri::XML(response.body)
  rescue
    puts "No valid XML"
    exit 1
  end
end

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ----------------    Grab the Server Time    -------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
uri     = URI.parse(ServerTimeUri)
uri_doc = grab_xml(uri)
xml_doc = create_xml(uri_doc)

$server_time = xml_doc.xpath("Items/Time").text
p $server_time

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ----------------       Grab the Series ID   -------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# shows = ["Game of Thrones","Dexter"]
# shows.each do |show|
File.open("#{WorkingDir}TV_Show_List.txt", 'r').each do |show|
  show.include?(" ") ? show.gsub!(" ","_").downcase! : show.downcase!

  uri     = URI.parse("#{SeriesbyId}#{show}")
  uri_doc = grab_xml(uri)
  xml_doc = create_xml(uri_doc)

  series_id = xml_doc.xpath("Data/Series[1]/seriesid").text
  p series_id

  series_name = xml_doc.xpath("Data/Series[1]/SeriesName").text
  p series_name
  
  series_first_aired = xml_doc.xpath("Data/Series[1]/FirstAired").text
  p series_first_aired
  
  first_aired_cut = series_first_aired.split("-")
  year = first_aired_cut[0]
  
  # ---------------------------------------------------------------------
  # ---------------------------------------------------------------------
  # ----------------  Grab the Episode IDs and Names   ------------------
  # ---------------------------------------------------------------------
  # ---------------------------------------------------------------------
  uri     = URI.parse("#{MirrorsPath}/series/#{series_id}/all/en.xml")
  uri_doc = grab_xml(uri)
  xml_doc = create_xml(uri_doc)

  network = xml_doc.xpath("Data/Series/Network").text
  p network

  genre = xml_doc.xpath("Data/Series/Genre").text
  p genre

  tv_shows = {1 => [series_id,series_name,year,network,genre].flatten}

  File.open("#{WorkingDir}#{$server_time}_TV_Show_Pull.csv","a") do |file|
    tv_shows.each_value do |v|
      file.puts "\"#{v[0]}\",\"#{v[1]}\",#{v[2]},\"#{v[3]}\",\"#{v[4]}\""
    end
  end

  episode_ids = Hash.new(0)
  i = 0
  1.upto(300) do |num|
    episode_ids[i+=1] = [series_id,xml_doc.xpath("Data/Episode[#{num}]/id").text]
  end

  episode_names = Hash.new(0)
  i = 0
  1.upto(300) do |num|
    episode_names[i+=1] = [xml_doc.xpath("Data/Episode[#{num}]/EpisodeName").text]
  end

  episode_season_nums = Hash.new(0)
  i = 0
  1.upto(300) do |num|
    episode_season_nums[i+=1] = [xml_doc.xpath("Data/Episode[#{num}]/Combined_season").text]
  end

  episode_nums = Hash.new(0)
  i = 0
  1.upto(300) do |num|
    episode_nums[i+=1] = [xml_doc.xpath("Data/Episode[#{num}]/Combined_episodenumber").text]
  end

  episode_first_aired = Hash.new(0)
  i = 0
  1.upto(300) do |num|
    episode_first_aired[i+=1] = [xml_doc.xpath("Data/Episode[#{num}]/FirstAired").text]
  end

  # p episode_ids
  # p episode_names
  # p episode_season_nums
  # p episode_nums

  episode_ids.merge!(episode_names){ |k,o,n| o+n }
  episode_ids.merge!(episode_season_nums){ |k,o,n| o+n }
  episode_ids.merge!(episode_nums){ |k,o,n| o+n }
  episode_ids.merge!(episode_first_aired){ |k,o,n| o+n }
  # p episode_ids
  
  File.open("#{WorkingDir}#{$server_time}_Episode_Pull.csv","a") do |file|
    episode_ids.each_value do |v|
      unless v[3].empty? || v[3] == "0"
        file.puts "\"#{v[0]}\",\"#{v[1]}\",\"#{v[2]}\",\"#{v[3]}\",\"#{v[4]}\",\"#{v[5]}\""
      end
    end
  end
  
  
  episode_ids.each_value do |v|
    unless v[2].empty? || v[2] == "0"
      puts "Id: #{v[0]}\n"
      puts "Episode Name: #{v[1]}\n"
      puts "Season Num: #{v[2]}\n"
      puts "Episode Num: #{v[3]}\n"
      puts "Episode First Aired: #{v[4]}\n"
      puts "-----------------------------------------------------\n"
    end
  end

  sleep 5  
end
