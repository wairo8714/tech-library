require "json"
require_relative "../models/location"
require_relative "../models/location_list"

class LocationsRepository
    PATH = File.expand_path("../../locations.json", __dir__)
    
    def self.all
        return LocationList.new unless File.exist?(PATH)

        raw = File.read(PATH).strip
        return LocationList.new if raw.empty?

        locations = JSON.parse(raw).map { |h| Location.new(id: h["id"], name: h["name"]) }
        LocationList.new(locations: locations)
    rescue JSON::ParserError
        warn "locations.json の形式が正しくありません。空のリストで続行します。"
        LocationList.new
    end

    def self.save(location_list)
        File.write(PATH, JSON.generate(location_list.locations.map { |location| {id: location.id, name: location.name }}))
    end
end
