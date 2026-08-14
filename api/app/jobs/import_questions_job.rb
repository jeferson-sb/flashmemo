# frozen_string_literal: true

class ImportQuestionsJob < ApplicationJob
  queue_as :background

  def perform(question_import_id)
    question_import = QuestionImport.find(question_import_id)

    Questions::Import.perform(question_import)
  end
end
