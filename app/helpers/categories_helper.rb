#encoding: utf-8

module CategoriesHelper

  def render_tree_select(nodes, parent = 0, depth=0)
    tree = []
    nodes.each do |node|
      if node.parent == parent
        level = "&nbsp;&nbsp;" * depth
        tree << %Q[ <option value="#{node.id}">|-#{level}#{node.name}</option> ]
        tree << render_tree_select(nodes, node.id, depth+1)
      end
    end
    return tree
  end
end
