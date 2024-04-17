class GardensController < ApplicationController
  before_action :authenticate_request, except: %i[index show]

  def index
    @gardens = Garden.all
  end

  def show
    @garden = Garden.find(params[:id])
  end

  def create
    # TODO
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
