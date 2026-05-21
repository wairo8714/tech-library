require_relative "location"

class LocationSelectionError < StandardError; end

class LocationList
    attr_reader :locations

    def initialize(locations: [])
        @locations = locations
    end

    def add(location)
        @locations << location
    end

    def find_by_name(name)
        @locations.find { |location| location.name == name }
    end

    def find_by_id(id)
        @locations.find { |location| location.id == id }
    end

    def find_by_selection_number(selection_number)
        unless selection_number.between?(1, @locations.size)
            raise LocationSelectionError
        end

        @locations[selection_number - 1]
    end

    def new_location_selection?(selection_number)
        selection_number == new_location_selection_number
    end

    def new_location_selection_number
        @locations.size + 1
    end

    def find_or_create_by_name(name)
        location = find_by_name(name)
        return location if location

        location = Location.new(id: next_id, name: name)
        add(location)
        location
    end

    private

    def next_id
        @locations.empty? ? 1 : @locations.map(&:id).max + 1
    end
end
