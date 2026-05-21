require_relative "../repositories/book_list_repository"
require_relative "../repositories/locations_repository"
require_relative "../repositories/book_placements_repository"
require_relative "../models/book"
require_relative "../models/location"
require_relative "../models/location_list"
require_relative "../models/book_placement"
require_relative "../models/book_placement_list"
require_relative "../models/book_list"

class BookService
    def locations
        LocationsRepository.all.locations
    end

    def new_location_selection_number
        LocationsRepository.all.new_location_selection_number
    end

    def add(book_registration_info)
        location_list = LocationsRepository.all
        location = location_for(book_registration_info, location_list)
        LocationsRepository.save(location_list)

        book_list = BookListRepository.get
        book = book_list.register(book_registration_info)
        BookListRepository.save(book_list)
        book_placement_list = book_placement_list_for(book_list, location_list)
        book_placement_list.place(book, location)
        BookPlacementsRepository.save(book_placement_list)

        book
    end

    def list
        book_list = BookListRepository.get
        location_list = LocationsRepository.all
        book_placement_list = book_placement_list_for(book_list, location_list)

        books_with_locations_for(book_list.books, book_placement_list)
    end

    def find(keyword_text:)
        keywords = split_values(keyword_text)
        book_list = BookListRepository.get
        location_list = LocationsRepository.all
        book_placement_list = book_placement_list_for(book_list, location_list)
        books = book_list.find(keywords: keywords) do |book|
            [book_placement_list.placement_for(book).location_name]
        end

        books_with_locations_for(books, book_placement_list)
    end

    private

    def books_with_locations_for(books, book_placement_list)
        book_placement_list.placements_for(books)
    end

    def book_placement_list_for(book_list, location_list)
        BookPlacementsRepository.all(
            book_list: book_list,
            location_list: location_list
        )
    end

    def location_for(book_registration_info, location_list)
        selection_number = book_registration_info[:location_selection_number]

        if location_list.new_location_selection?(selection_number)
            name = book_registration_info[:new_location_name]
            raise LocationSelectionError if name.empty?

            return location_list.find_or_create_by_name(name)
        end

        location_list.find_by_selection_number(selection_number)
    end

    def split_values(values)
        values.split(",").map(&:strip).reject(&:empty?)
    end
end
