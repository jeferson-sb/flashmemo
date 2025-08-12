# frozen_string_literal: true

module Mindmaps
  class Create
    class << self
      def perform(edges)
        edges.each do |e|
          from, to = e
      
          ActiveRecord::Base.transaction do
            from_node = Node.find_by(nodeable_type: 'Exam', nodeable_id: from)
            unless from_node
              from_node = Node.new(nodeable_type: 'Exam', nodeable_id: from, graph_id: @mm.id)
              from_node.save!
            end
      
            to_node = Node.find_by(nodeable_type: 'Exam', nodeable_id: to)
            unless to_node
              to_node = Node.new(nodeable_type: 'Exam', nodeable_id: to, graph_id: @mm.id)
              to_node.save!
            end
            
            edge = Edge.create!(from_node_id: from_node.id, to_node_id: to_node.id)
          end
        end
      end
    end
  end
end
