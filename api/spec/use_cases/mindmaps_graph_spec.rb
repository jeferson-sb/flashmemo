# frozen_string_literal: true

require 'rails_helper'

# Dev and test point at the same Neo4j instance (config/neo4j.yml has no
# per-database separation), so every node here is scoped to its own mind_map
# and torn down explicitly rather than truncating the graph wholesale.
RSpec.describe Mindmaps::Graph do
  let(:mind_map) { create(:mind_map) }

  after do
    CategoryNode.where(mindmap_id: mind_map.id).destroy_all
    ExamNode.where(mindmap_id: mind_map.id).destroy_all
  end

  describe '.perform' do
    context 'with no nodes' do
      it 'returns an empty graph' do
        expect(described_class.perform(mind_map.id)).to eq(nodes: [], edges: [])
      end
    end

    context 'with an isolated node and no relationships' do
      it 'still reports the node' do
        node = CategoryNode.create!(name: 'Ruby', category_id: 1, mindmap_id: mind_map.id)

        result = described_class.perform(mind_map.id)

        expect(result[:nodes]).to contain_exactly(id: node.id, label: 'Ruby', type: 'category')
        expect(result[:edges]).to be_empty
      end
    end

    context 'with related nodes' do
      it 'reports both node types and both relationship types' do
        ruby = CategoryNode.create!(name: 'Ruby', category_id: 1, mindmap_id: mind_map.id)
        rails = CategoryNode.create!(name: 'Rails', category_id: 2, mindmap_id: mind_map.id)
        exam = ExamNode.create!(name: 'Ruby Basics', exam_id: 1, mindmap_id: mind_map.id)
        rails.categories << ruby
        exam.category << ruby

        result = described_class.perform(mind_map.id)

        expect(result[:nodes]).to contain_exactly(
          { id: ruby.id, label: 'Ruby', type: 'category' },
          { id: rails.id, label: 'Rails', type: 'category' },
          { id: exam.id, label: 'Ruby Basics', type: 'exam' }
        )
        expect(result[:edges]).to contain_exactly(
          { source: rails.id, target: ruby.id, type: 'RELATES_TO' },
          { source: exam.id, target: ruby.id, type: 'IN' }
        )
      end
    end

    context 'when a related node belongs to a different mind map' do
      it 'excludes both the foreign node and the edge to it' do
        own = CategoryNode.create!(name: 'Ruby', category_id: 1, mindmap_id: mind_map.id)
        other_map = create(:mind_map)
        foreign = CategoryNode.create!(name: 'Elixir', category_id: 2, mindmap_id: other_map.id)
        own.categories << foreign

        result = described_class.perform(mind_map.id)

        expect(result[:nodes]).to contain_exactly(id: own.id, label: 'Ruby', type: 'category')
        expect(result[:edges]).to be_empty

        CategoryNode.where(mindmap_id: other_map.id).destroy_all
      end
    end
  end
end
