require 'httpclient'
require 'json'

class LocationController < ApplicationController

  def search
    json = fetch_locations(Rack::Utils.escape(params[:near]),Rack::Utils.escape(params[:query]))
    render json: json 
  end 

  def fetch_locations near,query
    LocationHelper.track("search","#{near}:#{query}")

    locations = Rails.cache.read(near + query) 
    if !locations.nil? then
      return locations
    end

    client = HTTPClient.new
    result = client.get("https://api.foursquare.com/v2/venues/search?near=#{near}&query=#{query}&v=20120101&client_id=#{FS_OAUTH_KEY}&client_secret=#{FS_OAUTH_SECRET}")
    json = JSON.parse(result.body)
    if json["meta"]["code"] != 200 then return nil end

    LocationHelper.delay.fetch_additional_data(near,query,json)
      
    h = {}
    h["foursquare"] = json["response"]["venues"]
    h
  end

end

class LocationHelper

  def self.track req_type, params
    Request.create(:req_type => req_type, :params => params)
  end

  def self.fetch_additional_data near,query,json
    client = HTTPClient.new

    lat = json["response"]["geocode"]["feature"]["geometry"]["center"]["lat"].to_s
    lng = json["response"]["geocode"]["feature"]["geometry"]["center"]["lng"].to_s

    result = client.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{query}&location=#{lat},#{lng}&radius=1000&sensor=false&key=#{G_PLACES_KEY}")
    more_json = JSON.parse(result.body)

    h = {}
    h["foursquare"] = json["response"]["venues"]
    h["google"] = more_json["results"]
    h

    Rails.cache.write(near + query, h, :timeToLive => 24.hours)
  end

end
