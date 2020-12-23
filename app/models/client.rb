class Client < ActiveRecord::Base
    # Client has many rentals and vhs through rentals
    has_many :rentals
    has_many :vhs, through: :rentals
end
