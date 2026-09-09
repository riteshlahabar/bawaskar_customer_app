import 'product_model.dart';

/// A saved product, as returned by `/customer/wishlist`.
///
/// The API nests the product under a `product` key; this flattens it so the
/// list view can reuse the same product widgets as the catalogue.
class WishlistItemModel {
  const WishlistItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.sku,
    required this.price,
    required this.mrp,
    this.imageUrl,
    this.isActive = true,
  });

  final int id;
  final int productId;
  final String name;
  final String sku;
  final double price;
  final double mrp;
  final String? imageUrl;
  final bool isActive;

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    final data = product is Map<String, dynamic> ? product : const <String, dynamic>{};

    return WishlistItemModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      productId: int.tryParse(
            (json['product_id'] ?? data['id'])?.toString() ?? '',
          ) ??
          0,
      name: data['name']?.toString() ?? 'Product',
      sku: data['sku']?.toString() ?? '',
      price: double.tryParse(data['customer_price']?.toString() ?? '') ?? 0,
      mrp: double.tryParse(data['mrp']?.toString() ?? '') ?? 0,
      imageUrl: data['image_url']?.toString(),
      isActive: data['is_active'] == null || data['is_active'] == true || data['is_active'] == 1,
    );
  }

  /// Lets the wishlist tile reuse the catalogue's product card.
  ProductModel toProduct() {
    return ProductModel(
      id: productId,
      name: name,
      sku: sku,
      price: price,
      mrp: mrp,
      gstPercent: 0,
      type: 'product',
      imageUrl: imageUrl,
    );
  }
}
