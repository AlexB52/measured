# frozen_string_literal: true
module Measured
  module ConversionTableValidator
    module_function

    def validate_no_cycles(units)
      graph = units.select { |unit| unit.conversion_unit.present? }.group_by { |unit| unit.name }
      validate_acyclic_graph(graph, from: graph.keys[0])
    end

    # This uses a depth-first search algorithm: https://en.wikipedia.org/wiki/Depth-first_search
    def validate_acyclic_graph(graph, from:, visited: [])
      graph[from]&.each do |edge|
        adjacent_node = edge.conversion_unit
        if visited.include?(adjacent_node)
          raise Measured::CycleDetected.new(edge)
        else
          validate_acyclic_graph(graph, from: adjacent_node, visited: visited + [adjacent_node])
        end
      end
    end
  end
end
