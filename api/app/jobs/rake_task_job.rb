# frozen_string_literal: true

class RakeTaskJob < ApplicationJob
  def perform(command)
    require "rake"

    Rake.application.init
    Rake.application.load_rakefile

    Rake::Task[command].invoke
  end
end