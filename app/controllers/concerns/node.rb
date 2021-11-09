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

  def nodes
    nodes = [
      {id: 'a', state: :saved, into: [:submitted], children: ['b', 'c'], parent_id: nil},
      {id: 'b', state: :submitted, into: [:saved, :accepted], children: ['c'], parent_id: 'a'},
      {id: 'c', state: :accepted, into: [:submitted], children: [], parent_id: 'b'},
    ]
    nodes
  end
end
