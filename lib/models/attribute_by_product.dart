class AttributeByProduct{
  String name;
  String slug;
  int position;
  bool visible;
  bool variation;
  List options;

  AttributeByProduct({
    this.name,
    this.slug,
    this.position,
    this.variation,
    this.visible,
    this.options
  });

  factory AttributeByProduct.fromJson(Map attr){
    return AttributeByProduct(
      name: attr['name'],
      slug: attr['slug'],
      position: attr['position'],
      visible: attr['visible'],
      variation: attr['variation'],
      options: attr['options']
    );
  }
}