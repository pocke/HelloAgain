class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  # GET /cards
  def index
    event = Event.date(Time.zone.now)
    user_ids = event.user_ids
    cards = user_ids.map{|x| User.find(x).card}.compact
    id = current_user.id

    @cards = cards.sort_by do |card|
      card.met?(event, current_user) || Card.new
    end

    @card_events = @cards.map{|x| x.met?(event, current_user)}
  end

  # GET /cards/1
  def show
  end

  # GET /cards/new
  def new
    @card = Card.new
    @card.name = current_user.name
    @card.image = current_user.image
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  def create
    @card = Card.new(card_params)
    @card.user = current_user

    if @card.save
      redirect_to cards_path
    else
      render :new
    end
  end

  # PATCH/PUT /cards/1
  def update
    if @card.update(card_params)
      redirect_to @card, notice: 'Card was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /cards/1
  def destroy
    @card.destroy
    redirect_to cards_url, notice: 'Card was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def card_params
      params[:card].permit!
    end
end
