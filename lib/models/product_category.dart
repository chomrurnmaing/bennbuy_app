class ProductCategory {
  final int id;
  final String name;
  final String slug;
  final int termGroup;
  final int parent;
  final String description;
  final Map thumbnail;
  final bool hasChildren;
  final int count;

  ProductCategory({
    this.id,
    this.name,
    this.slug,
    this.parent,
    this.description,
    this.hasChildren,
    this.termGroup,
    this.thumbnail,
    this.count
  });

  factory ProductCategory.fromJson(Map<String, dynamic> data) {
    return ProductCategory(
      id: data['term_id'],
      name: data['name'],
      slug: data['slug'],
      parent: data['parent'],
      description: data['description'],
      hasChildren: data['has_children'],
      termGroup: data['term_group'],
      thumbnail: data['thumbnail'],
      count: data['count'],
    );
  }
}