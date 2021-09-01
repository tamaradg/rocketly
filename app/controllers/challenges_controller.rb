class ChallengesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_challenge, only: [:show, :selected]

  def index
    @challenges = policy_scope(Challenge)
    # skip_authorization
    if params[:filter].present?
      @challenges = Challenge.where(status: params[:filter])
    else
      @challenges = @challenges.sort_by{|c| c.status}
    end
  end

  def show
    @artworks = @challenge.artworks
    @users = @artworks.select(:user_id).distinct
    @artwork = Artwork.new
  end

  def create
    @challenge = Challenge.new(challenge_params)
    @challenge.user = current_user
    authorize @challenge

    if @challenge.save
      redirect_to challenge_path(@challenge)
    else
      render :new
    end
  end

  def new
    @challenge = Challenge.new
    authorize @challenge
  end

  def selected
    params["artworks"].each do |artwork_id|
      Artwork.find(artwork_id.to_i).update(selected: true)
    end
    redirect_to challenges_path
  end

  private

  def challenge_params
    params.require(:challenge)
      .permit(:name, :description, :reward, :status, :start_date, :end_date, :photo)
  end

  def set_challenge
    @challenge = Challenge.find(params[:id])
    authorize @challenge
  end
end
