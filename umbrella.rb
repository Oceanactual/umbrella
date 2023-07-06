gmap_weather = ENV.fetch("GMAP_KEY")
require ("http")
require ("json")

pirate_weather = ENV.fetch("PIRATE_WEATHER_KEY")

pp "Where are you located?"
#your_location = gets.chomp.gsub(" ", "%20")
your_location = "Chicago"
pp "Checking the weather at " + your_location

raw_location = "https://maps.googleapis.com/maps/api/geocode/json?address=" + your_location + "&key=" + ENV.fetch("GMAP_KEY")

raw_response = HTTP.get(raw_location)
raw = JSON.parse(raw_response)
raw_results = raw.fetch("results").at(0)
geom = raw_results.fetch("geometry")
location = geom.fetch("location")
latit = location.fetch("lat").to_s
long = location.fetch("lng").to_s

pp "Your coordinates are " + latit + ", " + long

pirate_weather_web = "https://api.pirateweather.net/forecast/" + pirate_weather + "/" + latit + "," + long

pirate_one = HTTP.get(pirate_weather_web)
pirate_raw = JSON.parse(pirate_one)
pirate_current = pirate_raw.fetch("currently")
pirate_temp = pirate_current.fetch("temperature")
pp "It is currently " + pirate_temp.to_s + "F."

pirate_min = pirate_raw.fetch("minutely")
pirate_min_sum = pirate_min.fetch("summary")
pp "For the next hour it will be " + pirate_min_sum + "."

pirate_hour = pirate_raw.fetch("hourly")
pirate_hour_array = pirate_hour.fetch("data")

pirate_hour_twelve = pirate_hour_array[0..11]

pirate_hour_twelve.each do |percip|
  percip.keys[4]
  percent_chance = percip.fetch("precipProbability").round(1) * 100
  pp "The chance of rain during is #{percent_chance}%."
end
