class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @users = User.all
  end

  def create
    CreateUsersJob.perform_async
    head :ok
  end
end
