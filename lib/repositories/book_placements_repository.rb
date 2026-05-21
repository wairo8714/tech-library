require "json"
require_relative "../models/book_placement"
require_relative "../models/book_placement_list"

class BookPlacementsRepository
    PATH = File.expand_path("../../book_placements.json", __dir__)
    
    def self.all(book_list:, location_list:)
        return BookPlacementList.new unless File.exist?(PATH)

        raw = File.read(PATH).strip
        return BookPlacementList.new if raw.empty?

        book_placements = JSON.parse(raw).map do |h|
            book = book_list.find_by_id(h["book_id"])
            location = location_list.find_by_id(h["location_id"])

            raise "book_id=#{h["book_id"]}" unless book
            raise "location_id=#{h["location_id"]}" unless location

            BookPlacement.new(
                placement_id: h["placement_id"] || h["id"],
                book: book,
                location: location
            )
        end
        BookPlacementList.new(book_placements: book_placements)
    rescue JSON::ParserError
        warn "book_placements.json の形式が正しくありません。空のリストで続行します。"
        BookPlacementList.new
    end

    def self.save(book_placement_list)
        File.write(PATH, JSON.generate(book_placement_list.book_placements.map { |book_placement| {placement_id: book_placement.placement_id, book_id: book_placement.book.id, location_id: book_placement.location.id}}))
    end
end
