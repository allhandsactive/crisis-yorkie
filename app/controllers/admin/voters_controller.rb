class Admin::VotersController < ::AdminController
  respond_to :html, :json
  does :everything
end
