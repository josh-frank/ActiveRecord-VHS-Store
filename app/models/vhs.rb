class Vhs < ActiveRecord::Base
    after_initialize :add_serial_number
    # Vhs belongs to a movie,
    # - Vhs has many rentals and clients through rentals,
    belongs_to :movie
    has_many :rentals
    has_many :clients, through: :rentals

    def self.hot_from_the_press(genre_name, movie_arg)
        find_genre = Genre.where(name: genre_name)
        if find_genre.empty?
            this_genre = Genre.create(name: genre_name)
        else
            this_genre = find_genre.first
        end
        new_movie = Movie.create(movie_arg)
        MovieGenre.create(movie_id: new_movie.id, genre_id: this_genre.id)
        3.times{Vhs.create(movie_id: new_movie.id)}
    end

    def rental_count
      Rental.all.count {|rental| rental.vhs_id == self.id }
    end

    def self.most_used
      three_most_rented = Vhs.all.sort_by{|tape| tape.rental_count }.last(3)
      three_most_rented.each do |tape|
        puts "serial number: #{tape.serial_number} | title: #{Movie.find(tape.movie_id).title}"
      end
    end

    #accesses all current rentals. Vhs.find goes into rentals to pull the current vhs id.
    #enumerates through all returned rentals and uses Vhs.find to pull out the correct vhs object/instance for each rental.
    def self.available_now
      all_returned_rentals = Rental.where(current: false)
      all_returned_rentals.map{|rental| Vhs.find(rental.vhs_id)}
    end




    private

    # generates serial number based on the title
    def add_serial_number
        serial_number = serial_number_stub
        # Converting to Base 36 can be useful when you want to generate random combinations of letters and numbers, since it counts using every number from 0 to 9 and then every letter from a to z. Read more about base 36 here: https://en.wikipedia.org/wiki/Senary#Base_36_as_senary_compression
        alphanumerics = (0...36).map{ |i| i.to_s 36 }
        13.times{|t| serial_number << alphanumerics.sample}
        self.update(serial_number: serial_number)
    end

    def long_title?
        self.movie.title && self.movie.title.length > 2
    end

    def two_part_title?
        self.movie.title.split(" ")[1] && self.movie.title.split(" ")[1].length > 2
    end

    def serial_number_stub
        return "X" if self.movie.title.nil?
        return self.movie.title.split(" ")[1][0..3].gsub(/s/, "").upcase + "-" if two_part_title?
        return self.movie.title.gsub(/s/, "").upcase + "-" unless long_title?
        self.movie.title[0..3].gsub(/s/, "").upcase + "-"
    end

end
