class Vote < ActiveRecord::Base

  attr_writer :display_value
  attr_accessor :token, :name, :decision_intern, :human_hash, :question_type

  belongs_to :voter

  def validate
    determine_decision_id!
    determine_voter_id!
    determine_vote_ordinal!
    validate_value
  end

  def display_value
    @display_value || value.inspect
  end

  def parse_value
    send "parse_#{question_type}_value"
  end

private
  def parse_yes_no_abstain_value
    # nothing
  end
  def parse_multi_choice_value
    labels = value.split(',')
    alts = []
    used = {}
    ok = true
    labels.each do |label|
      alt = Alternative.find_by_name(label)
      if ! alt
        errors.add(:base, "alternative not found #{label.inspect}")
        ok = false
      elsif used[label]
        errors.add(:base, "multiple occurences of #{label.inspect}")
        ok = false
      else
        used[label] = true
        alts.push alt
      end
    end
    self.display_value = '(' << alts.map(&:name).each.with_index.map{ |n,i|
      "#{i+1}. #{n}"
    }.join(', ') << ')'
    self.value = alts.map(&:id).join(',')
    ok
  end
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
      errors.add(:base,
        "Sorry, this vote token is not on record: \"#{@token}\"")
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
  def determine_vote_ordinal!
    decision_id && 0 != decision_id && voter_id && 0 != voter_id or return
    num = Vote.count(:conditions =>
      ['decision_id = ? AND voter_id = ?', decision_id, voter_id])
    self.vote_ordinal = num + 1
  end
  def validate_value
    if :yes_no_abstain == question_type
      unless ['yes','no','abstain'].include? value
        errors.add(:base, "vote must be yes|no|abstain, not #{value.inspect}.")
      end
    end
  end
end
