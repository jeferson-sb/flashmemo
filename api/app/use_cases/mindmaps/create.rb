# frozen_string_literal: true

module Mindmaps
  class Create
    class << self
      def perform(connections, mindmap)
        connections.each do |e|
          from, to = e
          # from_node = ExamNode.find_by(exam_id: from)
          # unless from_node
          #   from_node = ExamNode.find_or_create_by(name: "test", exam_id: from, mindmap_id: 1)
          # end

          # to_node = ExamNode.find_by(exam_id: to)
          # unless to_node
          #   to_node = ExamNode.create(name: "test", exam_id: to, mindmap_id: 1)
          # end

          # from_node.exams << to_node
          puts "Node type is #{from.inspect}"
          puts "Node type is #{to.inspect}"
        end
      end
    end
  end
end
