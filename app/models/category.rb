class Category < ActiveRecord::Base

  has_many :items_of_categories
  has_many :items, :through => :items_of_categories
  has_many :child, foreign_key: 'parent', class_name: 'Category'
  #belongs_to :parent, foreign_key: 'parent', class_name: 'Category'

  scope :roots, -> { where(parent: 0).order('sort asc') }

  validates_presence_of :name, :parent, :slug

  after_save :render_as_treeview
  after_destroy :render_as_treeview
  @datasource = []

  def render_as_treeview
    @datasource = Category.all.order('sort asc')
    tree = build_treeview_datasource
    depth = depth tree
    target = "#{Rails.root}/public/scripts/category.json"
    s = { "depth" => depth, "tree" => tree }.to_json

    File.open(target, 'w') do |file|
      file.puts "var tree="
      file.puts s
    end
  end

  def build_treeview_datasource parent = 0
    tree = []
    @datasource.each do |data|
      if data.parent == parent
        tree << {id: data.id, name: data.name, slug: data.slug, sort: data.sort, child: []}
        tree[-1][:child] = build_treeview_datasource(data.id)
      end
    end
    return tree
  end

  def depth tree, max=1
    tree.each do |x|
      nnn = x[:child].length
      max = nnn > max ? nnn : max
      depth x[:child], max if nnn > 0
    end
    return max
  end

  def sorted_child
    self.child
  end

end
