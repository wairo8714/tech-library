class BookShelf
    attr_reader :location
        
    def initialize(location:, books: [])
        @location = location
        @books = books
    end

    def add(book)
        @books << book
    end

    def search(keywords)
        @books.select do |book|
            book.matches?(keywords)
        end
    end

    def at?(location)
        @location.same_as?(location)
    end

    def book_attributes
        @books.map { |book| attributes_for(book) }
    end

    def search_attributes(keywords)
        searchable_books(keywords).map { |book| attributes_for(book) }
    end

    def to_data
        {
            location_id: @location.id,
            books: @books.map(&:id)
        }
    end

    private

    def searchable_books(keywords)
        if @location.matches?(keywords)
            return @books
        end
        
        @books.select { |book| book.matches?(keywords) }
    end

    def attributes_for(book)
        book.attributes.merge(location: @location.name)
    end
end
