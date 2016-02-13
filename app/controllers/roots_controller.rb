class RootsController < ApplicationController
  # GET /roots
  def index
    if current_user
      redirect_to cards_path
    else
      redirect_to new_user_session_path
    end
  end
end
