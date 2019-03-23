class ProductAttributeTerm{
  int id;
  String name;
  String slug;
  String description;
  int menuOrder;
  int count;

  ProductAttributeTerm({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.menuOrder,
    this.count,
  });

  factory ProductAttributeTerm.fromJson(Map data){
    return ProductAttributeTerm(
      id: data['id'],
      name: data['name'],
      slug: data['slug'],
      description: data['description'],
      menuOrder: data['menu_order'],
      count: data['count']
    );
  }
}