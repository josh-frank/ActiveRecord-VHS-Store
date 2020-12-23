class Movie < ActiveRecord::Base
    # - Movie has many movie_genres and genres through movie_genres,
    # - Movie has many vhs and rentals through vhs,
    has_many :movie_genres
    has_many :genres, through: :movie_genres
    has_many :vhs
    has_many :rentals, through: :vhs
end
