class CommitsController < ApplicationController
  before_action :set_user

  def index
    @pagy, @commits = pagy((@user ? @user.commits : Commit).order(:date), items: 10)
    respond_with(@commits)
  end

  private

  def set_user
    @user = User.find_by(email: params[:email]) if params[:email]
  end
end
