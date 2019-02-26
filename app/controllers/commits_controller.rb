class CommitsController < ApplicationController
  def index
    @commits = (@user ? @user.commits : Commit).order(:date)
    respond_with(@commits)
  end
end
