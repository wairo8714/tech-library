require "json"
require_relative "../models/book_placement"
require_relative "books_repository"
require_relative "locations_repository"

class BookPlacementsRepository
    PATH = File.expand_path("../../book_placements.json", __dir__)
    
    def self.all
        return [] unless File.exist?(PATH)

        raw = File.read(PATH).strip
        return [] if raw.empty?

        book_list = BooksRepository.get
        location_list = LocationsRepository.all

        JSON.parse(raw).map do |h|
            book = book_list.find(h["book_id"])
            location = location_list.find { |location| location.id == h["location_id"] }
            raise "location_id=#{h["location_id"]}" unless location

            BookPlacement.new(placement_id: h["placement_id"], book: book, location: location)
        end
    rescue JSON::ParserError
        warn "book_placements.json の形式が正しくありません。空のリストで続行します。"
        []
    end

    def self.save(book_placements)
        File.write(PATH, JSON.generate(book_placements.map { |book_placement| {placement_id: book_placement.placement_id, book_id: book_placement.book.id, location_id: book_placement.location.id}}))
    end
end
