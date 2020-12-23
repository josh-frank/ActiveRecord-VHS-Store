class MovieGenre < ActiveRecord::Base
    # MovieGenre belongs to a movie and a genre
    belongs_to :movie
    belongs_to :genre
end