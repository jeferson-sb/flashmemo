# frozen_string_literal: true

class GardensController < ApplicationController
  before_action :authenticate_request, except: %i[index show]

  def index
    @gardens = Garden.all
  end

  def show
    @garden = Garden.find(params[:id])
  end

  def create
    @garden = Garden.new(user_id: @user.id, name: "#{@user.name}'s garden")

    if @garden.save
      render json: { message: 'Garden successfully created.' }, status: :created
    else
      render json: { error: @garden.errors }, status: :unprocessable_entity
    end
  end

  def plant
    # TODO
  end

  def nurture
    # TODO
  end

  private

  def plant_params
    params.permit(:name)
  end

  def nutrients_params
    params.permit(:nutrients)
  end
end
