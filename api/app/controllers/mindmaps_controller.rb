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
    @mm = MindMap.new(category_id: create_params[:category_id], name: create_params[:name], user_id: @user.id)
    edges = params[:edges]

    render json: { error: 'Should have at least one edge' }, status: :bad_request if edges.empty?

    edges.each do |e|
      from, to = e
      
      from_node = Node.new(nodeable_type: "Exam", nodeable_id: from)
      from_node.save!

      if !Node.exists?(nodeable_type: "Exam", nodeable_id: to)
        to_node = Node.new(nodeable_type: "Exam", nodeable_id: to)
        to_node.save!
      else
        to_node = Node.where(nodeable_type: "Exam", nodeable_id: to).first
      end
      
      edge = Edge.create(from_node_id: from_node.id, to_node_id: to_node.id)
    end

    render json: { ok: true }
  end

  def update; end

  private

  def create_params
    params.permit(:name, :category_id, edges: { multiple: true })
  end
end
