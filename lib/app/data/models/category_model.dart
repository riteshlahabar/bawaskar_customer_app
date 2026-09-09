class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
    this.assetPath,
  });

  final int id;
  final String name;
  final String slug;
  final String? imageUrl;
  final String? assetPath;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? json['storefront_name']?.toString() ?? json['category_name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      imageUrl: _image(json),
    );
  }

  static int _asInt(dynamic value) => int.tryParse(value?.toString() ?? '') ?? 0;

  static String? _image(Map<String, dynamic> json) {
    for (final key in ['image_url', 'storefront_image_url', 'image']) {
      final value = json[key]?.toString().trim() ?? '';
      if (value.isNotEmpty && value != 'null') return value;
    }
    return null;
  }
}
