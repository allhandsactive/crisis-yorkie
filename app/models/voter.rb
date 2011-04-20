class Voter < ActiveRecord::Base

  has_many :votes

  class << self
    attr_accessor :ui_fields
  end

  self.ui_fields = [:email, :token, :public_identifier, :hashed_secret, :salt]

end
