class Client < ActiveRecord::Base
    # Client has many rentals and vhs through rentals
    has_many :rentals
    has_many :vhs, through: :rentals

    #first we create a new client, with the client_attributes argument as a hash. Then assign the new client to a temporary method variable. Then use that new client id to create a new rental.
    def self.first_rental(vhs, client_attributes)
        new_client = Client.create(name: client_attributes[:name], home_address: client_attributes[:home_address])
        Rental.create(vhs_id: vhs.id, client_id: new_client.id, current: true)
    end

    # helper method for most_active - returns a specific Client's number of returned rentals
    def number_of_returned_rentals
        self.rentals.where( current: false ).length
    end

    # - sort Client.all by #number_of_returned_rentals
    # - pick the last( 5 )
    def self.most_active
        Client.all.sort_by{ | client | client.number_of_returned_rentals }.last( 5 )

        # FIRST SOLUTION:
        # clients_sorted_by_returns = Client.all.sort_by{ | client | client.number_of_returned_rentals }
        # clients_sorted_by_returns.last( 5 )
    end

    # helper method for all_my_genres which returns a non-unique array of all genres associated with this client's rentals
    def all_my_genres
        all_my_vhs = self.rentals.map( &:vhs )
        all_my_movies = all_my_vhs.map{ | vhs | Movie.find( vhs.movie_id ) }
        all_my_movies.collect( &:genres ).flatten
    end

    def favorite_genre
        # - collect all a particular Client's rented VHS genres with a helper method called all_my_genres
        # - use max_by to find the most frequently occuring genre in all_my_genres
        all_my_genres.max_by{ | genre | all_my_genres.count( genre ) }
    end

    #helper method for non_grata. returns true if a client instance has a past_due? rental
    def has_past_due?
      !self.rentals.find{|rental| rental.past_due?}.nil?
    end

    #creating an array of all the client instances where has_past_due? is true.
    def self.non_grata
      Client.all.select{|client| client.has_past_due?}
    end

    #call max_by on Client.all finding the client with the most rentals
    def self.paid_most
      Client.all.max_by{|client| client.rentals.length }
    end

    #helper for total_watch_time. returns a sum of a particular clients movie length watched.
    def my_total_watch_time
      all_my_vhs = self.rentals.map( &:vhs )
      all_my_movies = all_my_vhs.map{ | vhs | Movie.find( vhs.movie_id ) }
      all_my_movies.sum{|movie| movie.length}
    end

    #returns the sum of all my_total_watch_time(s)
    def self.total_watch_time
      Client.all.sum(&:my_total_watch_time)
    end

    def return_one(vhs)
      this_rental = Rental.find_by(vhs_id: vhs.id)
      Rental.update(this_rental.id, current: false)
    end

    def return_all
      self.rentals.each{|rental| Rental.update(rental.id, current: false)}
    end

    def last_return
      self.return_all
      self.destroy
    end






end
