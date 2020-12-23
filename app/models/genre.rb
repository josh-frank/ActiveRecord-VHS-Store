class Genre < ActiveRecord::Base
    # Genre has many movie_genres and movies through movie_genres
    has_many :movie_genres
    has_many :movies, through: :movie_genres
end