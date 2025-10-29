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
    @mm = MindMap.create!(name: create_params[:name], user_id: @user.id)
    connections = params[:connections]

    if connections.empty?
      render json: { error: 'Should have at least one connection' }, status: :bad_request
    else
      Mindmaps::Create.perform(connections, @mm)
      render json: { message: I18n.t('success.created', entity: MindMap.model_name.human) }, status: :created
    end
  end

  def update; end

  def update_node
    mm = MindMap.find(params[:mindmap_id])
    changes = params[:changes]
    render json: { error: 'Changeset is required and should have at least one change' }, status: :bad_request if changes.empty?

    Mindmaps::Update.perform(changes, mm)

    render json: { message: I18n.t('success.updated', entity: MindMap.model_name.human) }, status: :ok
  end

  private

  def create_params
    params.permit(:name, connections: { multiple: true })
  end
end
