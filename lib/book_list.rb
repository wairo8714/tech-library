class BookNotFound < StandardError; end

class BookList
    attr_reader :books

    def initialize(books: [])
        @books = books
    end

    def add_book(book)
        @books << book
    end

    def find(id)
        book = @books.find { |book| book.id == id }
        raise BookNotFound, "id=#{id}" unless book
        book
    end

    def next_id
        @books.empty? ? 1: @books.map(&:id).max + 1
    end
end
