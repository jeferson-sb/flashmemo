# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rewards::Compensation do
  describe '#rules' do
    let(:compensator) do
      Rewards::Compensation.new
    end

    describe 'when low score' do
      it 'return zero seeds and nutrients' do
        seeds, nutrients = compensator.rules({
                                               score: 0
                                             })
        expect(seeds).to eq(0)
        expect(nutrients).to eq(0)
      end
    end

    describe 'when score > 10' do
      context 'has no answers available' do
        it 'return with first interaction bonus' do
          seeds, nutrients = compensator.rules({
                                                 score: 20,
                                                 answers: 0,
                                                 trees: 0
                                               })

          expect(seeds).to eq(1)
          expect(nutrients).to eq(0)
        end
      end

      context 'when is the twenth tree' do
        it 'return with the 20th tree bonus' do
          seeds, nutrients = compensator.rules({
                                                 score: 50,
                                                 answers: 1,
                                                 trees: 19
                                               })

          expect(seeds).to eq(3)
        end
      end

      context 'when score > 90' do
        it 'return with the high score bonus' do
          seeds, nutrients = compensator.rules({
                                                 score: 95,
                                                 answers: 1,
                                                 trees: 0
                                               })

          expect(seeds).to eq(2)
          expect(nutrients).to eq(1)
        end
      end

      describe 'when is new topic' do
        context 'and season is summer' do
          it 'return with summer seasonal bonus' do
            summer = Time.new(2024, 1, 5)
            seeds, nutrients = compensator.rules({
                                                   score: 50,
                                                   answers: 1,
                                                   trees: 0,
                                                   is_new_topic: true
                                                 }, summer)

            expect(seeds).to eq(1)
            expect(nutrients).to eq(4)
          end
        end

        context 'and season is spring' do
          it 'return with spring seasonal bonus' do
            spring = Time.new(2024, 11, 30)
            seeds, nutrients = compensator.rules({
                                                   score: 50,
                                                   answers: 1,
                                                   trees: 0,
                                                   is_new_topic: true
                                                 }, spring)

            expect(seeds).to eq(3)
            expect(nutrients).to eq(1)
          end
        end
      end

      describe 'when is a review' do
        context 'and season is winter' do
          it 'return with winter seasonal bonus' do
            winter = Time.new(2024, 8, 25)
            seeds, nutrients = compensator.rules({
                                                   score: 50,
                                                   answers: 1,
                                                   trees: 0,
                                                   is_review: true
                                                 }, winter)

            expect(seeds).to eq(1)
            expect(nutrients).to eq(3)
          end
        end

        context 'and season is autumn' do
          it 'return with autumn seasonal bonus' do
            autumn = Time.new(2024, 4, 1)
            seeds, nutrients = compensator.rules({
                                                   score: 50,
                                                   answers: 1,
                                                   trees: 0,
                                                   is_new_topic: true
                                                 }, autumn)

            expect(seeds).to eq(3)
            expect(nutrients).to eq(1)
          end
        end
      end

      describe 'when valid season and first bonus' do
        it 'return sum bonus' do
          summer = Time.new(2024, 1, 5)
          seeds, nutrients = compensator.rules({
                                                 score: 50,
                                                 answers: 0,
                                                 trees: 0,
                                                 is_new_topic: true
                                               }, summer)

          expect(seeds).to eq(2)
          expect(nutrients).to eq(4)
        end
      end

      describe 'when 2 valid bonus available' do
        it 'return only first bonus' do
          seeds, nutrients = compensator.rules({
                                                 score: 95,
                                                 answers: 0,
                                                 trees: 0
                                               })

          expect(seeds).to eq(1)
          expect(nutrients).to eq(0)
        end
      end
    end
  end
end
