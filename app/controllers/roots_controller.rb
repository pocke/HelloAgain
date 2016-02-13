class RootsController < ApplicationController
  # GET /roots
  def index
    if current_user
      # TODO
      sign_out current_user
    else
      redirect_to new_user_session_path
    end
  end
end
