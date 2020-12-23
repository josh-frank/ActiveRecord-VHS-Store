class Rental < ActiveRecord::Base
    # Rental belongs to a client and vhs
    belongs_to :client
    belongs_to :vhs

    #converting self's timestamp to a date, and then adding 7. In the date class, math works on days

    def due_date
       self.created_at.to_date + 7
    end

    #helper method for self.past_due_date - tells us if this rental is past due
    def past_due?
      self.updated_at.to_date > self.due_date
    end

    #selects all the rental instances where past_due? is true.
    def self.past_due_date
      Rental.all.select{ |rental| rental.past_due?  }
    end

end
