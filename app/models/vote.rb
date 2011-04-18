class Vote < ActiveRecord::Base
  
  attr_accessor :token, :name
  
  def validate
    v = Voter.find_by_token(@token)
    if v
      @voter_id = v.id
    else
      errors.add(:base, "Sorry, this vote token is not on record: \"#{@token}\"")
    end
    
    unless ['yes','no','abstain'].include? value
      errors.add(:base, "vote must be yes|no|abstain, not #{value.inspect}.")
    end
    
  end
  
end
