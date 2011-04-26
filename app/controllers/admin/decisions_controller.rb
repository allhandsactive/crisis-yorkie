class Admin::DecisionsController < ::AdminController
  respond_to :html, :json
  does :everything
end
