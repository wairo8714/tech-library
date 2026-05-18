class Book

    attr_accessor :id, :title, :authors, :genres, :location

    def initialize(id:, title:, authors:, genres:, location:)
        @id = id
        @title = title
        @authors = authors
        @genres = genres
        @location = location
    end
end