# frozen_string_literal: true

module Mindmaps
  class Update
    class << self
      def perform(changes, mindmap)
        if !changes[:add].empty?
          changes[:add].each do |e|
            from, to = e
            from_node = find_or_create_node(from, mindmap.id)
            to_node = find_or_create_node(to, mindmap.id)
  
            if to.key?(:exam_id)
            from_node.exams << to_node
            else
            from_node.categories << to_node
            end
          end
        end

        if !changes[:remove].empty?
          changes[:remove].each do |c|
            if CategoryNode.exists?(c[:id])
              CategoryNode.find(c[:id]).destroy
            elsif ExamNode.exists?(c[:id])
              ExamNode.find(c[:id]).destroy
            end
          end
        end

      end

      private

      def find_or_create_node(param, mindmap_id)
        if param.key?(:category_id)
          CategoryNode.find_or_create_by(name: param[:name], category_id: param[:category_id], mindmap_id: mindmap_id)
        else
          ExamNode.find_or_create_by(name: param[:name], exam_id: param[:exam_id], mindmap_id: mindmap_id)
        end
      end
    end
  end
end
