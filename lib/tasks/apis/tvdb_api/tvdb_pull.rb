require 'rubygems'
require 'net/http'
require 'nokogiri'

APP_ROOT = File.dirname(__FILE__)
# WorkingDir = "#{APP_ROOT}/apis/tvdb_api/"
WorkingDir     = '/Users/bwb/Sites/revoot/revoot_app/lib/tasks/apis/tvdb_api/'
# WorkingDir     = '#{APP_ROOT}/lib/tasks/apis/tvdb_api/'

MirrorsPath    = 'http://www.thetvdb.com/api/102D37BF66CADAB7/'
ServerTimeUri  = 'http://www.thetvdb.com/api/Updates.php?type=none'
SeriesbyId     = 'http://www.thetvdb.com/api/GetSeriesByRemoteID.php?imdbid='

def grab_xml(uri)
  begin
    response = Net::HTTP.get_response(uri)
    if response.code != "200"
      raise
    end
    return response
  rescue => e
    puts "Error: #{e}"
  end
end

def create_xml(response)
  begin
    xml_doc = Nokogiri::XML(response.body)
  rescue
    puts "No valid XML"
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

  File.open("#{WorkingDir}TV_Show_Pull.csv","a") do |file|
    tv_shows.each_value do |v|
      file.puts "\"#{v[0]}\",\"#{v[1]}\",#{v[2]},\"#{v[3]}\",\"#{v[4]}\""
    end
  end

  1.upto(300) do |count|
    # a       = xml_doc.xpath("Data/Episode[#{count}]/FirstAired").text
    # a_split = a.split("-")
    # a_time  = Time.new(a_split[0],a_split[1],a_split[2])
    # unless Time.now < a_time

      episode_ids = Hash.new(0)
      i = 0
      episode_ids[i+=1] = [series_id,xml_doc.xpath("Data/Episode[#{count}]/id").text]

      episode_imdb_ids = Hash.new(0)
      i = 0
      episode_imdb_ids[i+=1] = [xml_doc.xpath("Data/Episode[#{count}]/IMDB_ID").text]

      episode_names = Hash.new(0)
      i = 0
      episode_names[i+=1] = [xml_doc.xpath("Data/Episode[#{count}]/EpisodeName").text]

      episode_season_nums = Hash.new(0)
      i = 0
      episode_season_nums[i+=1] = [xml_doc.xpath("Data/Episode[#{count}]/SeasonNumber").text]

      episode_nums = Hash.new(0)
      i = 0
      episode_nums[i+=1] = [xml_doc.xpath("Data/Episode[#{count}]/EpisodeNumber").text]

      episode_first_aired = Hash.new(0)
      i = 0
      episode_first_aired[i+=1] = [xml_doc.xpath("Data/Episode[#{count}]/FirstAired").text]

      episode_overview = Hash.new(0)
      i = 0
      raw_text = xml_doc.xpath("Data/Episode[#{count}]/Overview").text
      cleaned_text = raw_text.gsub!("\"","'")
      if cleaned_text.nil?
        episode_overview[i+=1] = [xml_doc.xpath("Data/Episode[#{count}]/Overview").text]
      else
        episode_overview[i+=1] = [cleaned_text]
      end

      # p episode_ids
      # p episode_names
      # p episode_season_nums
      # p episode_nums

      episode_ids.merge!(episode_imdb_ids){ |k,o,n| o+n }
      episode_ids.merge!(episode_names){ |k,o,n| o+n }
      episode_ids.merge!(episode_season_nums){ |k,o,n| o+n }
      episode_ids.merge!(episode_nums){ |k,o,n| o+n }
      episode_ids.merge!(episode_first_aired){ |k,o,n| o+n }
      episode_ids.merge!(episode_overview){ |k,o,n| o+n }
      # p episode_ids
      
      File.open("#{WorkingDir}Episode_Pull.csv","a") do |file|
        episode_ids.each_value do |v|
          unless v[4].empty? || v[4] == "0"
            file.puts "\"#{v[0]}\",\"#{v[1]}\",\"#{v[2]}\",\"#{v[3]}\",\"#{v[4]}\",\"#{v[5]}\",\"#{v[6]}\",\"#{v[7]}\""
          end
        end
      end
      
      
      episode_ids.each_value do |v|
        unless v[4].empty? || v[4] == "0"
          puts "Id: #{v[1]}\n"
          puts "Episode Name: #{v[3]}\n"
          puts "Season Num: #{v[4]}\n"
          puts "Episode Num: #{v[5]}\n"
          puts "Episode First Aired: #{v[6]}\n"
          puts "Episode Overview: #{v[7]}\n"
          puts "-----------------------------------------------------\n"
        end
      end
    # end
  end
  sleep 2.5
end
