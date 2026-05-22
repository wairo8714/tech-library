require_relative "book_shelf"
class BookShelfNotFound < StandardError; end

class BookShelves

    attr_reader :book_shelves

    def initialize(book_shelves: [])
        @book_shelves = book_shelves
    end

    def place(book, location)
        shelf = find_or_create_book_shelf(location)
        shelf.add(book)
        shelf
    end

    def book_attributes
        @book_shelves.flat_map(&:book_attributes)
    end

    def search_attributes(keywords)
        @book_shelves.flat_map { |book_shelf | book_shelf.search_attributes(keywords) }
    end

    def to_data
        @book_shelves.map(&:to_data)
    end

    private
    
    def find_or_create_book_shelf(location)
        found = @book_shelves.find { |book_shelf| book_shelf.at?(location) }
        return found if found

        book_shelf = BookShelf.new(location: location, books: [])
        @book_shelves << book_shelf
        book_shelf
    end
end
