module Node
  class Node
    attr_accessor :parent, :children, :state
  
    def initialize(state)
      @state = state
      @children = []
    end
  end

  def build_tree(rows)
    nodes = {}
    rows.each do |row|
      node = Node.new(row[:state])
      nodes[row[:id]] = node
  
      node.parent = nodes[row[:parent_id]]
      if row[:parent_id]
        nodes[row[:parent_id]].children << node
      end
    end
  
    nodes.values.find {|node| node.parent.nil? }
    
  end
end
