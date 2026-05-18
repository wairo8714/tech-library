require "json"
require_relative "../models/book"
require_relative "../book_list"

class BooksRepository
    PATH = File.expand_path("../../books.json", __dir__)

    def self.get
        return BookList.new unless File.exist?(PATH)

        raw = File.read(PATH).strip
        return BookList.new if raw.empty?

        loaded_books = begin
            JSON.parse(raw).map do |h|
                Book.new(id: h["id"], title: h["title"], authors: h["authors"], genres: h["genres"], location: h["location"])
            end
        rescue JSON::ParserError
            warn "books.json の形式が正しくありません。空のリストで続行します。"
            []
        end

        BookList.new(books: loaded_books)
    end

    def self.save(books_list)
        array = []
        books_list.books.each do |book|
            array << { id: book.id, title: book.title, authors: book.authors, genres: book.genres, location: book.location}
        end
        File.write(PATH, JSON.generate(array))
    end
end