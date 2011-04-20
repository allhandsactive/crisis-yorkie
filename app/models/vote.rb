class Vote < ActiveRecord::Base

  attr_accessor :token, :name, :decision_intern, :human_hash, :question_type

  def validate
    determine_decision_id!
    determine_voter_id!
    validate_value
  end

private
  def determine_voter_id!
    @human_hash ? determine_voter_id_with_human_hash! :
      determine_voter_id_with_token!
  end
  def determine_voter_id_with_human_hash!
    require 'digest/sha2'
    hash = ::Digest::SHA2.new << @human_hash.strip
    hashed_secret = hash.to_s
    if v = Voter.find_by_hashed_secret(hashed_secret) # @todo multiple!?
      self.voter_id = v.id
    else
      errors.add(:base, "Sorry, this human hash is not on record: "<<
        @human_hash.inspect)
    end
  end
  def determine_voter_id_with_token!
    if v = Voter.find_by_token(@token)
      self.voter_id = v.id
    else
      errors.add(:base, "Sorry, this vote token is not on record: \"#{@token}\"")
    end
  end
  def determine_decision_id!
    if d = Decision.find_by_intern(@decision_intern)
      self.decision_id = d.id
    else
      errors.add(:base, "Sorry, there is no record for "<<
        "the decision called #{@decision_intern.inspect}")
    end
  end
  def validate_value
    if :yes_no_abstain == question_type
      unless ['yes','no','abstain'].include? value
        errors.add(:base, "vote must be yes|no|abstain, not #{value.inspect}.")
      end
    end
  end
end
