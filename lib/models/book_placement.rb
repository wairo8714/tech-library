class BookPlacement
    attr_reader :placement_id, :book_id, :location_id

    def initialize(placement_id:, book_id:, location_id:)
        @placement_id = placement_id
        @book_id = book_id
        @location_id = location_id
    end
end
