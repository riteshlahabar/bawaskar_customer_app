import '../../config/api_config.dart';
import '../models/wishlist_item_model.dart';
import 'api_client.dart';

/// Saved-products endpoints.
class WishlistApiService {
  WishlistApiService(this._client);

  final ApiClient _client;

  Future<List<WishlistItemModel>> list() async {
    final response = await _client.getJson(ApiConfig.wishlist);
    final items = response['data']?['items'];

    if (items is! List) return const <WishlistItemModel>[];

    return items
        .whereType<Map<String, dynamic>>()
        .map(WishlistItemModel.fromJson)
        .toList();
  }

  Future<void> add(int productId) =>
      _client.postJson(ApiConfig.wishlist, {'product_id': productId});

  Future<void> remove(int productId) =>
      _client.deleteJson(ApiConfig.wishlistItem(productId));
}
