class ProductAttribute {
  final int id;
  final String name;
  final String slug;
  final String type;
  final String orderBy;
  final bool hasArchives;


  ProductAttribute({
    this.id,
    this.name,
    this.slug,
    this.type,
    this.orderBy,
    this.hasArchives
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> data) {
    return ProductAttribute(
      id: data['id'],
      name: data['name'],
      slug: data['slug'],
      type: data['type'],
      orderBy: data['order_by'],
      hasArchives: data['has_archives']
    );
  }

}