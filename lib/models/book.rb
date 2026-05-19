class Book

    attr_reader :id, :title, :authors, :genres

    def initialize(id:, title:, authors:, genres:)
        @id = id
        @title = title
        @authors = authors
        @genres = genres
    end
end
