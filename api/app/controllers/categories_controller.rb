# frozen_string_literal: true

class CategoriesController < ApplicationController
  def create
    @category = Category.new(create_params)

    if @category.save
      render json: { message: 'Category successfully created.' }, status: :created
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
