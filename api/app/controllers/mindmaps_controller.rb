# frozen_string_literal: true

class MindmapsController < ApplicationController
  before_action :authenticate_request, only: :create

  def show
    @mm = MindMap.find(params[:id])
  end

  def index
    @mmaps = MindMap.all
  end

  def create
    @mm = MindMap.create!(category_id: create_params[:category_id], name: create_params[:name], user_id: @user.id)
    edges = params[:edges]

    render json: { error: 'Should have at least one edge' }, status: :bad_request if edges.empty?

    Mindmaps::Create.perform(edges)
  end

  def update; end

  private

  def create_params
    params.permit(:name, :category_id, edges: { multiple: true })
  end
end
