class Admin::VotesController < ::AdminController
  respond_to :html, :json
  does :everything, :except => [:new, :create, :edit, :update, :destroy]
end
