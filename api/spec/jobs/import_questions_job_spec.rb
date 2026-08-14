# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportQuestionsJob, type: :job do
  let(:question_import) { create(:question_import, :with_file) }

  it 'hands the import to the use case' do
    allow(Questions::Import).to receive(:perform)

    described_class.perform_now(question_import.id)

    expect(Questions::Import).to have_received(:perform).with(question_import)
  end

  it 'runs on the background queue' do
    expect(described_class.new.queue_name).to eq('background')
  end
end
