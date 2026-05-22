require_relative "book"

class BookNotFound < StandardError; end

class BookList
    attr_reader :books

    def initialize(books: [])
        @books = books
    end

    def add(book)
        @books << book
    end

    def register(book_registration_info)
        book = Book.new(
            id: next_id,
            title: book_registration_info[:title],
            authors: split_values(book_registration_info[:authors]),
            genres: split_values(book_registration_info[:genres])
        )
        add(book)
        book
    end

    def find(keywords:)
        @books.select { |book| book.matches?(keywords) }
    end
        
    def find_by_id(id)
        @books.find { |book| book.id == id }
    end

    private

    def next_id
        @books.empty? ? 1: @books.map(&:id).max + 1
    end

    def split_values(values)
        values.split(",").map(&:strip).reject(&:empty?)
    end
end
