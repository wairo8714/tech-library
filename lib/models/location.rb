class Location
    attr_reader :id, :name

    def initialize(id:, name:)
        @id = id
        @name = name
    end

    def same_as?(other)
        id == other.id
    end

    def matches?(keywords)
        keywords.all? { |keyword| name.include?(keyword) }
    end
end
