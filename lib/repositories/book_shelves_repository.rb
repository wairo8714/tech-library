require "json"
require_relative "../models/book_shelf"
require_relative "../models/book_shelves"

class BookShelvesRepository
    PATH = File.expand_path("../../book_shelves.json", __dir__)

    def self.all(book_list:, location_list:)
        return BookShelves.new unless File.exist?(PATH)
        
        raw = File.read(PATH).strip
        return BookShelves.new if raw.empty?

        JSON.parse(raw).each_with_object(BookShelves.new) do |h, book_shelves|
            location = find_location!(location_list, h["location_id"])
            books = h["books"].map { |book_id| find_book!(book_list, book_id) }

            books.each { |book| book_shelves.place(book, location) }
        end
    rescue JSON::ParserError
        warn "book_shelves.json の形式が正しくありません。空のリストで続行します。"
        BookShelves.new
    end

    def self.save(book_shelves)
        File.write(PATH, JSON.generate(book_shelves.to_data))
    end

    def self.find_location!(location_list, location_id)
        location = location_list.find_by_id(location_id)
        raise "location_id=#{location_id}" unless location

        location
    end

    def self.find_book!(book_list, book_id)
        book = book_list.find_by_id(book_id)
        raise "book_id=#{book_id}" unless book

        book
    end
end
