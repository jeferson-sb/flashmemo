# frozen_string_literal: true

class RevisionsController < ApplicationController
  before_action :authenticate_request

  def show
    @revision = Revision.find(params[:id])
  end
end
