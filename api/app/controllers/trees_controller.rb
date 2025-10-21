# frozen_string_literal: true

class TreesController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  def index
    @trees = Tree.all
  end

  def show
    @tree = Tree.find(params[:id])
  end
end
