import '../../config/api_config.dart';
import '../models/offer_model.dart';
import 'api_client.dart';

/// Offers and coupon validation.
class OfferApiService {
  OfferApiService(this._client);

  final ApiClient _client;

  Future<List<OfferModel>> list() async {
    final response = await _client.getJson(ApiConfig.offers);
    final offers = response['data']?['offers'];

    if (offers is! List) return const <OfferModel>[];

    return offers.whereType<Map<String, dynamic>>().map(OfferModel.fromJson).toList();
  }

  /// Asks the server what this code is worth on the given cart value. The app
  /// never computes a discount itself.
  Future<AppliedCouponModel> validate({
    required String code,
    required double orderValue,
  }) async {
    final response = await _client.postJson(ApiConfig.validateCoupon, {
      'code': code.trim(),
      'order_value': orderValue,
    });

    final data = response['data'];

    return AppliedCouponModel.fromJson(
      data is Map<String, dynamic> ? data : const <String, dynamic>{},
    );
  }
}
