require_relative "lib/services/book_service"

def print_books_with_locations(books_with_locations)
    books_with_locations.each.with_index(1) do |book_with_location, index|
        puts ""
        puts "--- #{index}件目 ---"
        book_with_location.attributes.each do |name, value|
            value = value.join(",") if value.is_a?(Array)
            puts "#{name}: #{value}"
        end
    end
end

book_service = BookService.new

begin
    case ARGV[0]
    when "add"
        book_registration_info = {}

        puts "登録したい本のタイトルを入力してください"
        book_registration_info[:title] = STDIN.gets.chomp.strip

        puts "著者を入力してください(共著者はカンマ区切りで入力)"
        book_registration_info[:authors] = STDIN.gets.chomp.strip
        
        puts "ジャンルを入力してください(複数ジャンルはカンマ区切りで入力)"
        book_registration_info[:genres] = STDIN.gets.chomp.strip

        puts "保管場所の番号を選択してください"
        locations = book_service.locations
        locations.each.with_index(1) do |location, index|
            puts "#{index}. #{location.name}"
        end

        puts "#{book_service.new_location_selection_number}. 新しい保管場所を追加する"
        book_registration_info[:location_selection_number] = STDIN.gets.chomp.to_i

        book_registration_info[:new_location_name] = ""
        if book_registration_info[:location_selection_number] == book_service.new_location_selection_number
            puts "新しい保管場所名を入力してください"
            book_registration_info[:new_location_name] = STDIN.gets.chomp.strip
        end

        book_service.add(book_registration_info)
   
        puts "登録が完了しました"
    when "list"
        books_with_locations = book_service.list

        if books_with_locations.empty?
            puts "登録されている本はありません"
        else
            puts "登録されている本が#{books_with_locations.size}件あります"
            print_books_with_locations(books_with_locations)
        end
    when "find"
        puts "検索キーワードを入力してください(複数条件はカンマ区切り)"
        keywords = STDIN.gets.chomp.strip
        books_with_locations = book_service.find(keyword_text: keywords)

        if books_with_locations.empty?
            puts "該当する本はありません"
        else
            puts "検索結果が#{books_with_locations.size}件見つかりました"
            print_books_with_locations(books_with_locations)
        end
    else
        puts "使い方: ruby app.rb add | find | list"
        exit 1
    end
rescue BookNotFound => e
    warn "お探しの本が見つかりません: #{e.message}"
    exit 1
rescue LocationSelectionError
    warn "保管場所の入力が正しくありません"
    exit 1
rescue BookPlacementNotFound
    warn "本の保管場所情報が見つかりません"
    exit 1
end
