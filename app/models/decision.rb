class Decision < ActiveRecord::Base
  attr_accessor :question_type # @todo
  def create_path
    "#{::Rails.root.to_s}/app/views/decision/#{intern}.html.erb" # @todo
  end
end
