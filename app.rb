require_relative "lib/services/book_service"

book_service = BookService.new

begin
    case ARGV[0]
    when "add"
        puts "登録したい本のタイトルを入力してください"
        title = STDIN.gets.chomp.strip

        puts "著者を入力してください(共著者はカンマ区切りで入力)"
        authors = STDIN.gets.chomp.strip
        
        puts "ジャンルを入力してください(複数ジャンルはカンマ区切りで入力)"
        genres = STDIN.gets.chomp.strip

        puts "保管場所を入力してください"
        location = STDIN.gets.chomp.strip

        book = book_service.add(title: title, authors: authors, genres: genres, location: location)
        puts "登録が完了しました: #{book.title}"
    else
        puts "使い方: ruby app.rb add"
        exit 1
    end
end