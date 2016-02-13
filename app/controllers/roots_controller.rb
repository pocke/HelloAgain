class RootsController < ApplicationController
  # GET /roots
  def index
    if !current_user
      redirect_to new_user_session_path
      return
    end

    if !current_user.card
      redirect_to new_card_path
      return
    end

    redirect_to cards_path
  end
end
