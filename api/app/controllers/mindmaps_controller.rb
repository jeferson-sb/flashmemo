# frozen_string_literal: true

class MindmapsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  def show
    @mm = MindMap.find(params[:id])
  end

  def index
    @mmaps = MindMap.all
  end

  def create
    @user = Current.session.user
    # @mm = MindMap.create!(name: create_params[:name], user_id: @user.id)
    connections = params[:connections]

    render json: { error: 'Should have at least one connection' }, status: :bad_request if connections.empty?

    # Mindmaps::Create.perform(connections, @mm)
    Mindmaps::Create.perform(connections, nil)
  end

  def update; end

  private

  def create_params
    params.permit(:name, connections: { multiple: true })
  end
end
