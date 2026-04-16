class Product {
  const Product({
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
    this.description = '',
    this.tags = const [],
  });

  final String name;
  final String price;
  final double rating;
  final String image;
  final String description;
  final List<String> tags;
}
