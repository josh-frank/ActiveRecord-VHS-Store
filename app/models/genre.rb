class Genre < ActiveRecord::Base
    # Genre has many movie_genres and movies through movie_genres
    has_many :movie_genres
    has_many :movies, through: :movie_genres

    # - `Genre.most_popular` - returns a list of 5 most popular genres based on number of movies
    # - `Genre.longest_movies` - returns a genre whose movies length average is the highest (remember to also test it with an instance of a Genre that does not have any movies associated)
    def self.most_popular
        Genre.all.sort_by{|genre| genre.movies.length}.last(5)
    end

    def average_movie_length
        return 0 if self.movies.size <= 0
        movie_length_sum = self.movies.sum{|movie| movie.length}
        movie_length_sum / self.movies.size.to_f
    end

    def self.longest_movies
        Genre.all.max_by{|genre| genre.average_movie_length}
    end


end