require_relative "book_placement"

class BookPlacementNotFound < StandardError; end

class BookPlacementList
    attr_reader :book_placements

    def initialize(book_placements: [])
        @book_placements = book_placements
    end

    def add(book_placement)
        @book_placements << book_placement
    end

    def place(book, location)
        book_placement = BookPlacement.new(
            placement_id: next_placement_id,
            book: book,
            location: location
        )
        add(book_placement)
        book_placement
    end

    def placement_for(book)
        placement = @book_placements.find { |book_placement| book_placement.for_book?(book) }
        raise BookPlacementNotFound unless placement

        placement
    end

    def placements_for(books)
        books.map { |book| placement_for(book) }
    end

    private

    def next_placement_id
        @book_placements.empty? ? 1 : @book_placements.map(&:placement_id).max + 1
    end
end
