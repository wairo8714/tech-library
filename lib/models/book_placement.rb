class BookPlacement
    attr_reader :placement_id, :book, :location

    def initialize(placement_id:, book:, location:)
        @placement_id = placement_id
        @book = book
        @location = location
    end

    def for_book?(book)
        @book.same_as?(book)
    end

    def attributes
        book.attributes.merge(location: location.name)
    end

    def location_name
        location.name
    end
end
