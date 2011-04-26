class Admin::UsersController < ::AdminController
  respond_to :html, :json
  does :everything
end
