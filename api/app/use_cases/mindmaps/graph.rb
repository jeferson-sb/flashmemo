# frozen_string_literal: true

module Mindmaps
  # Flattens a mind map's Neo4j nodes and relationships into the
  # { nodes:, edges: } shape a force-directed renderer wants. One query
  # returns both sides at once, so a mind map with no relationships yet still
  # reports its lone nodes instead of coming back empty.
  class Graph
    NODE_TYPES = { 'ExamNode' => 'exam', 'CategoryNode' => 'category' }.freeze

    CYPHER = <<~CYPHER
      MATCH (n) WHERE n.mindmap_id = $mindmap_id
      OPTIONAL MATCH (n)-[r]->(m) WHERE m.mindmap_id = $mindmap_id
      RETURN n, type(r) AS r_type, m
    CYPHER

    class << self
      def perform(mindmap_id)
        nodes = {}
        edges = []

        ActiveGraph::Base.query(CYPHER, mindmap_id:).each do |row|
          register(nodes, row[:n])
          next unless row[:m]

          register(nodes, row[:m])
          edges << { source: row[:n].id, target: row[:m].id, type: row[:r_type] }
        end

        { nodes: nodes.values, edges: }
      end

      private

      def register(nodes, node)
        nodes[node.id] ||= { id: node.id, label: node.name, type: NODE_TYPES.fetch(node.class.name) }
      end
    end
  end
end
