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
    # TBD
  end
end
