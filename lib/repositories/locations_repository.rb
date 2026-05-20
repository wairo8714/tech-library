require "json"
require_relative "../models/location"

class LocationsRepository
    PATH = File.expand_path("../../locations.json", __dir__)
    def self.all
        return [] unless File.exist?(PATH)

        raw = File.read(PATH).strip
        return [] if raw.empty?

        JSON.parse(raw).map { |h| Location.new(id: h["id"], name: h["name"]) }
    rescue JSON::ParserError
        warn "locations.json の形式が正しくありません。空のリストで続行します。"
        []
    end

    def self.save(locations)
        File.write(PATH, JSON.generate(locations.map { |location| {id: location.id, name: location.name }}))
    end
end
