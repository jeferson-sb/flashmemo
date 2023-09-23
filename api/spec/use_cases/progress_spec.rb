# frozen_string_literal: true

RSpec.describe Users::Progress do
  describe '#perform' do
    let(:answers) do
      [double('Answer', score: 30, exam_id: 1), double('Answer', score: 60, exam_id: 2)]
    end

    it 'return average for answers' do
      average, exams = Users::Progress.perform(answers)

      expect(average).to eq(45.0)
      expect(exams).to eq([1, 2])
    end

    describe 'when answers are empty' do
      it 'return zero score' do
        average, exams = Users::Progress.perform([])

        expect(average).to eq(0)
      end

      it 'return no exams' do
        average, exams = Users::Progress.perform([])

        expect(exams).to be_empty
      end
    end
  end
end
