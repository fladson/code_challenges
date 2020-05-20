class UsersController < ApplicationController
  before_action :set_user, only: :show

  # GET /users
  # GET /users.json
  def index
    @users = User.all.includes(:playlists)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
