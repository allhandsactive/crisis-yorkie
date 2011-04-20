class Decision < ActiveRecord::Base

  def create_path
    "#{::Rails.root.to_s}/app/views/decision/#{intern}.html.erb" # @todo
  end
end
