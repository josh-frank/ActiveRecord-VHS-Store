class Movie < ActiveRecord::Base
    # - Movie has many movie_genres and genres through movie_genres,
    # - Movie has many vhs and rentals through vhs,
    has_many :movie_genres
    has_many :genres, through: :movie_genres
    has_many :vhs
    has_many :rentals, through: :vhs

    # Using Vhs.available_now as a helper to get us a list of available tapes for rent, we map a list of available_now tapes to their movies using Movie.find, then remove duplicates with .uniq
    def self.available_now
        Vhs.available_now.map{ | tape | Movie.find( tape.movie_id ) }.uniq
    end

    # Grab each client from a particular movie's self.rentals and count the number of them
    def client_count
        self.rentals.map{ | rental | rental.client }.uniq.size
    end

    # Sorts Movie.all by number of unique clients using client_count, and picks the last (the Movie with the most unique clients)
    def self.most_clients
        Movie.all.sort_by{ | movie | movie.client_count }.last
    end

    def self.most_rentals
        Movie.all.sort_by{ | movie | movie.rentals.length }.last( 3 )
    end

    def self.most_popular_female_director
        movies_with_female_directors = Movie.where( female_director: true )
        movies_with_female_directors.sort_by{ | movie | movie.rentals.length }.last.director
    end

    def self.newest_first
        Movie.order( year: :desc )
    end

    def self.longest
        Movie.order( length: :desc )
    end

    def recommendation
        one_hundred_seventeen_emojis = "😀😃😄😁😆😅😂🤣😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🤩🥳😏😒😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤬🤯😳🥵🥶😱😨😰😥😓🤗🤔🤭🤫🤥😶😐😑😬🙄😯😦😧😮😲🥱😴🤤😪😵🤐🥴🤢🤮🤧😷🤒🤕🤑🤠😈👿👹👺🤡💩👻💀☠️👽👾🤖🎃😺😸😹😻😼😽🙀😿😾"
    end

end
