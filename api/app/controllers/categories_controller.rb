# frozen_string_literal: true

class CategoriesController < ApplicationController
  allow_unauthenticated_access only: [:index]

  def index
    @categories = Category.all
    render json: @categories
  end

  def create
    @category = Category.new(title: create_params[:title].strip.downcase)

    if @category.save
      render json: { message: I18n.t('success.created', entity: Category.model_name.human) }, status: :created
    else
      message = @category.errors
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.permit(:title)
  end
end
