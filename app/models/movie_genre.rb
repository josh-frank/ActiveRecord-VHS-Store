class MovieGenre < ActiveRecord::Base
    # MovieGenre belongs to a movie and a genre
    belongs_to :movie
    belongs_to :genre

    # def initialize( genre )
    #     super
    #     MovieGenre.create( movie_id: self.id, genre_id: genre.id ) }
    # end
end