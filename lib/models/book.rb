class Book

    attr_reader :id, :title, :authors, :genres

    def initialize(id:, title:, authors:, genres:)
        @id = id
        @title = title
        @authors = authors
        @genres = genres
    end

    def attributes
        {
            id: id,
            title: title,
            authors: authors,
            genres: genres
        }
    end

    def same_as?(other)
        id == other.id
    end

    def matches?(keywords)
        values = attributes.values.flatten.map(&:to_s)

        keywords.all? do |keyword|
            values.any? { |value| value.include?(keyword) }
        end
    end
end
