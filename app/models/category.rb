class Category < ActiveRecord::Base
  
  has_many :items
  has_many :child, foreign_key: 'parent', class_name: 'Category'

  scope :roots, -> { where(parent: 0).order('sort asc') }

  after_save :render_as_treeview
  @datasource = []

  def self.render_as_treeview
    @datasource = self.all.order('sort asc')
    tree = self.build_treeview_datasource
    depth = self.depth tree
    target = "#{Rails.root}/public/category.json"
    s = { "depth" => depth, "tree" => tree }.to_json

    File.open(target, 'w') do |file|
      file.puts "var tree="
      file.puts s
    end
  end

  def self.build_treeview_datasource parent = 0
    tree = []
    @datasource.each do |data|
      if data.parent == parent
        tree << {id: data.id, name: data.name, slug: data.slug, sort: data.sort, child: []}
        tree[-1][:child] = build_treeview_datasource(data.id)
      end
    end
    return tree
  end

  def self.depth tree, max=1
    tree.each do |x|
      nnn = x[:child].length
      max = nnn > max ? nnn : max
      self.depth x[:child], max if nnn > 0
    end
    return max
  end

  def sorted_child
    self.child
  end

end
