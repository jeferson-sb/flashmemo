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
    
    edges.each do |e|
      from, to = e
      
      ActiveRecord::Base.transaction do
        from_node = Node.find_by(nodeable_type: "Exam", nodeable_id: from)
        unless from_node
          from_node = Node.new(nodeable_type: "Exam", nodeable_id: from, graph_id: @mm.id)
          from_node.save!
        end
  
        to_node = Node.find_by(nodeable_type: "Exam", nodeable_id: to)
        unless to_node
          to_node = Node.new(nodeable_type: "Exam", nodeable_id: to, graph_id: @mm.id)
          to_node.save!
        end
        
        edge = Edge.create!(from_node_id: from_node.id, to_node_id: to_node.id)
      end
    end
  end

  def update; end

  private

  def create_params
    params.permit(:name, :category_id, edges: { multiple: true })
  end
end
