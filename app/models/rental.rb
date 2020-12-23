class Rental < ActiveRecord::Base
    # Rental belongs to a client and vhs
    belongs_to :client
    belongs_to :vhs
end