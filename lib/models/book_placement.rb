class BookPlacement
    attr_reader :placement_id, :book, :location

    def initialize(placement_id:, book:, location:)
        @placement_id = placement_id
        @book = book
        @location = location
    end
end
