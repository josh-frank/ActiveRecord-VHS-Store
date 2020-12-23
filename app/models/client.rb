class Client < ActiveRecord::Base
    # Client has many rentals and vhs through rentals
    has_many :rentals
    has_many :vhs, through: :rentals

    #first we create a new client, with the client_attributes argument as a hash. Then assign the new client to a temporary method variable. Then use that new client id to create a new rental.
    def self.first_rental(vhs, client_attributes)
        new_client = Client.create(name: client_attributes[:name], home_address: client_attributes[:home_address])

        Rental.create(vhs_id: vhs.id, client_id: new_client.id, current: true)

    end






end
