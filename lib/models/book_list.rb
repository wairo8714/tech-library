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
        @books.select do |book|
            values = searchable_values_for(book)
            values += yield(book) if block_given? # 検索結果に保管場所を追加する
            keywords.all? do |keyword|
                values.any? { |value| value.include?(keyword) }
            end
        end
    end

    def find_by_id(id)
        @books.find { |book| book.id == id }
    end

    private

    def next_id
        @books.empty? ? 1: @books.map(&:id).max + 1
    end

    def searchable_values_for(book)
        book.attributes.values.flatten.map(&:to_s)
    end

    def split_values(values)
        values.split(",").map(&:strip).reject(&:empty?)
    end
end
