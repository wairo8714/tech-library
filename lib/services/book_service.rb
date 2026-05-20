require_relative "../repositories/books_repository"
require_relative "../models/book"
require_relative "../book_list"

class BookService

    def add(title:, authors:, genres:, location:)
        book_list = BooksRepository.get
        book = Book.new(id: book_list.next_id, title: title, authors: split_values(authors), genres: split_values(genres), location: location)
        book_list.add(book)
        BooksRepository.save(book_list)
        book
    end

    private

    def format(book)
        "#{book.id} #{book.title} #{book.authors} #{book.genres} #{book.location}"
    end

    def split_values(values)
        values.split(",").map(&:strip)
    end
end
