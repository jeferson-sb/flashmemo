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
    @garden = Garden.find(params[:garden_id])

    begin
      Gardener::Plant.perform(@garden, plant_params[:name])
      render json: { message: "Tree '#{plant_params[:name]}' successfully planted." }, status: :ok
    rescue Exception => e
      render json: { error: "Failed to plant: " + e.message }, status: :bad_request
    end
  end

  def nurture
    @garden = Garden.find(params[:garden_id])
    @tree = Tree.find(nutrients_params[:tree_id])

    begin
      Gardener::Nurture.perform(@tree, @garden, nutrients_params[:nutrients].to_i)
      render json: { message: "Tree '#{@tree.name}' successfully fed." }, status: :ok
    rescue Exception => e
      render json: { error: "Failed to feed tree: " + e.message }, status: :bad_request
    end
  end

  private

  def plant_params
    params.permit(:name)
  end

  def nutrients_params
    params.permit(:tree_id, :nutrients)
  end
end
