require "json"
require_relative "../models/book_placement"

class BookPlacementsRepository
    PATH = File.expand_path("../../book_placements.json", __dir__)
    
    def self.all
        return [] unless File.exist?(PATH)

        raw = File.read(PATH).strip
        return [] if raw.empty?

        JSON.parse(raw).map { |h| BookPlacement.new(placement_id: h["placement_id"], book_id: h["book_id"], location_id: h["location_id"] )}
    rescue JSON::ParserError
        warn "book_placements.json の形式が正しくありません。空のリストで続行します。"
        []
    end

    def self.save(book_placements)
        File.write(PATH, JSON.generate(book_placements.map { |book_placement| {placement_id: book_placement.placement_id, book_id: book_placement.book_id, location_id: book_placement.location_id}}))
    end
end
