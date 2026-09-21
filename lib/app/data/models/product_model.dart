class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.mrp,
    required this.gstPercent,
    required this.type,
    this.description = '',
    this.shortDescription = '',
    this.categoryId = 0,
    this.categoryName = '',
    this.unit = '',
    this.imageUrl,
    this.homepageImageUrl,
    this.homepageMobileImageUrl,
    this.imageVersion = '',
    this.assetPath,
    this.isFeatured = false,
    this.isTrending = false,
    this.isTopSelling = false,
    this.isNewArrival = false,
    this.mainVariantId = 0,
    this.availableStock,
    this.source = const {},
  });

  final int id;
  final String name;
  final String sku;
  final double price;
  final double mrp;
  final double gstPercent;
  final String type;
  final String description;
  final String shortDescription;
  final int categoryId;
  final String categoryName;
  final String unit;
  final String? imageUrl;
  final String? homepageImageUrl;
  final String? homepageMobileImageUrl;
  final String imageVersion;
  final String? assetPath;
  final bool isFeatured;
  final bool isTrending;
  final bool isTopSelling;
  final bool isNewArrival;
  final int mainVariantId;

  /// Units in stock for the main variant; null when unknown.
  final double? availableStock;

  /// Raw API payload, kept so the cart can be saved and restored.
  final Map<String, dynamic> source;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final variant = _mainVariant(json);

    return ProductModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      price: _firstPrice(json, const [
        'customer_price',
        'price',
        'sale_price',
        'selling_price',
      ]),
      mrp: _firstPrice(json, const ['mrp', 'old_price', 'compare_price']),
      gstPercent: _asDouble(json['gst_percent']),
      type:
          json['product_type']?.toString() ??
          json['type']?.toString() ??
          'product',
      description:
          json['description']?.toString() ??
          json['storefront_description']?.toString() ??
          '',
      shortDescription: json['short_description']?.toString() ?? '',
      categoryId: _asInt(json['category_id']),
      categoryName: _categoryName(json),
      unit: _unitName(json, variant),
      imageUrl: _image(json),
      homepageImageUrl: _cleanImage(json['homepage_image_url']),
      homepageMobileImageUrl: _cleanImage(json['homepage_mobile_image_url']),
      imageVersion: _imageVersion(json),
      isFeatured: _asBool(json['is_featured']),
      isTrending: _asBool(json['is_trending']),
      isTopSelling: _asBool(json['is_top_selling']),
      isNewArrival: _asBool(json['is_new_arrival']),
      mainVariantId: variant == null ? 0 : _asInt(variant['id']),
      availableStock: variant == null || variant['available_stock'] == null ? null : _asDouble(variant['available_stock']),
      source: json,
    );
  }

  /// `main_variant_id`, else the default variant, else the first one.
  static Map<String, dynamic>? _mainVariant(Map<String, dynamic> json) {
    final variants = json['variants'];
    if (variants is! List) return null;

    final list = variants.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    if (list.isEmpty) return null;

    final mainId = _asInt(json['main_variant_id']);

    for (final variant in list) {
      if (mainId > 0 && _asInt(variant['id']) == mainId) return variant;
    }
    for (final variant in list) {
      if (_asBool(variant['is_default'])) return variant;
    }
    return list.first;
  }

  static String? _image(Map<String, dynamic> json) {
    final images = json['images'];
    final firstImage =
        images is List && images.isNotEmpty && images.first is Map
        ? images.first as Map
        : null;
    final candidates = [
      json['image_url'],
      json['main_image_url'],
      json['thumbnail_url'],
      json['image'],
      json['storefront_image'],
      firstImage?['url'],
      json['homepage_image_path'],
    ];
    for (final item in candidates) {
      final value = _cleanImage(item);
      if (value != null) return value;
    }
    return null;
  }

  static String? _cleanImage(dynamic item) {
    final value = item?.toString().trim() ?? '';
    if (value.isNotEmpty && value != 'null') return value;
    return null;
  }

  static String _imageVersion(Map<String, dynamic> json) {
    final value = json['image_version']?.toString().trim() ?? '';
    if (value.isNotEmpty && value != 'null') return value;
    final updatedAt = json['updated_at']?.toString().trim() ?? '';
    if (updatedAt.isNotEmpty && updatedAt != 'null') return updatedAt;
    return json['id']?.toString() ?? '';
  }

  static String _categoryName(Map<String, dynamic> json) {
    final category = json['category'];
    if (category is Map) {
      return category['storefront_name']?.toString() ??
          category['name']?.toString() ??
          '';
    }
    return json['category_name']?.toString() ?? category?.toString() ?? '';
  }

  /// A variant carries the actual pack size ("1 KG", "500 G"); the product's
  /// own unit is only the measure ("Kilogram") with no quantity, so it is the
  /// last resort — and even then shown as "1" plus the short name rather than
  /// the bare, unhelpful full name.
  static String _unitName(Map<String, dynamic> json, Map<String, dynamic>? variant) {
    final variantName = variant?['name']?.toString().trim() ?? '';
    if (variantName.isNotEmpty) return variantName;

    final unit = json['unit'];
    final short = (unit is Map ? unit['short_name']?.toString() : json['unit_short_name']?.toString())?.trim() ?? '';
    if (short.isNotEmpty) return '1 $short';

    // No variant and no short name on the Unit master — still never show a
    // bare, quantity-less unit; "1 Kilogram" beats "Kilogram" alone.
    final full = (unit is Map ? (unit['name']?.toString() ?? unit['short_name']?.toString()) : (json['unit_name']?.toString() ?? unit?.toString()))?.trim() ?? '';
    return full.isEmpty ? '' : '1 $full';
  }

  static double _firstPrice(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = _asDouble(json[key]);
      if (value > 0) return value;
    }
    return 0;
  }

  static int _asInt(dynamic value) =>
      int.tryParse(value?.toString() ?? '') ?? 0;
  static double _asDouble(dynamic value) =>
      double.tryParse(value?.toString() ?? '') ?? 0;
  static bool _asBool(dynamic value) {
    final text = value?.toString().toLowerCase() ?? '';
    return text == '1' || text == 'true' || text == 'yes';
  }
}
