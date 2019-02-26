class CommitsController < ApplicationController
  def index
    @pagy, @commits = pagy((@user ? @user.commits : Commit).order(:date), items: 10)
    respond_with(@commits)
  end
end
