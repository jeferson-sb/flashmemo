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
      render json: { message: I18n.t('success.created', entity: Garden.model_name.human) }, status: :created
    else
      render json: { error: @garden.errors }, status: :unprocessable_entity
    end
  end

  def plant
    @garden = Garden.find(params[:garden_id])

    begin
      Gardener::Plant.perform(@garden, plant_params[:name])
      render json: { message: I18n.t('success.planted', entity: Tree.model_name.human, name: plant_params[:name]) }
    rescue StandardError => e
      render json: { error: I18n.t('error.failed_plant', reason: e.message) }, status: :bad_request
    end
  end

  def nurture
    @garden = Garden.find(params[:garden_id])
    @tree = Tree.find(nutrients_params[:tree_id])

    begin
      Gardener::Nurture.perform(@tree, @garden, nutrients_params[:nutrients].to_i)
      render json: { message: I18n.t('success.fed', entity: Tree.model_name.human, name: @tree.name) }
    rescue StandardError => e
      render json: { error: I18n.t('error.failed_feed', reason: e.message) }, status: :bad_request
    end
  end

  def journal
    @garden = Garden.find(params[:garden_id])
    answers = Answers::InRange.perform(@user.id, 'monthly')
    @surprise_question = Question.surprise_question
    return if answers.empty?

    @score, _ = Users::Progress.perform(answers)
  end

  private

  def plant_params
    params.permit(:name)
  end

  def nutrients_params
    params.permit(:tree_id, :nutrients)
  end
end
