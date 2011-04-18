class Vote < ActiveRecord::Base

  attr_accessor :token, :name, :decision_intern

  def validate
    if v = Voter.find_by_token(@token)
      self.voter_id = v.id
    else
      errors.add(:base, "Sorry, this vote token is not on record: \"#{@token}\"")
    end

    if d = Decision.find_by_intern(@decision_intern)
      self.decision_id = d.id
    else
      errors.add(:base, "Sorry, there is no record for "<<
        "the decision called #{@decision_intern.inspect}")
    end

    unless ['yes','no','abstain'].include? value
      errors.add(:base, "vote must be yes|no|abstain, not #{value.inspect}.")
    end
  end
end
