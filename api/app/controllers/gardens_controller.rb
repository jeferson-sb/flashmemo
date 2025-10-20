# frozen_string_literal: true

class GardensController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  def index
    @gardens = Garden.all
  end

  def show
    @garden = Garden.find(params[:id])
  end

  def create
    @user = Current.session.user
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
    @user = Current.session.user
    answers = Answers::InRange.perform(@user.id, 'monthly')
    @surprise_question = Question.surprise_question
    return if answers.empty?

    @score, = Users::Progress.perform(answers)
  end

  def evaluate_surprise_question
    user_answer = params[:answer]

    @question = Question.surprise_question

    return render json: { error: I18n.t('error.max_attempts') } if max_attempts_reached?(@question)

    expected = @question.options.find_by(correct: true).id
    is_winner = user_answer.to_i == expected

    SurpriseQuestionAnswer.create(question_id: @question.id, user_id: @user.id, winner: is_winner)

    if is_winner
      render json: { result: I18n.t('success.won_seeds', seeds: draw_seeds) }
    else
      render json: { result: I18n.t('try_again') }
    end
  end

  private

  def plant_params
    params.permit(:name)
  end

  def nutrients_params
    params.permit(:tree_id, :nutrients)
  end

  def max_attempts_reached?(question)
    attempts = SurpriseQuestionAnswer.per_user(@user.id, question.id).count
    attempts >= SurpriseQuestionAnswer::MAX_ATTEMPTS
  end

  def draw_seeds
    distributor = Rewards::Distribute.new(@user.garden)
    Rewards::QuickPrize.draw(distributor)
  end
end
