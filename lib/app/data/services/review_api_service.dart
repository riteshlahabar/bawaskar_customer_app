import '../../config/api_config.dart';
import '../models/review_model.dart';
import 'api_client.dart';

/// Product reviews: the public feed for one product, and the customer's own.
class ReviewApiService {
  ReviewApiService(this._client);

  final ApiClient _client;

  Future<({List<ReviewModel> reviews, ReviewSummaryModel summary})> forProduct(
    int productId,
  ) async {
    final response = await _client.getJson(ApiConfig.productReviews(productId));
    final data = response['data'];
    final raw = data?['reviews'];
    final summary = data?['summary'];

    return (
      reviews: raw is List
          ? raw.whereType<Map<String, dynamic>>().map(ReviewModel.fromJson).toList()
          : const <ReviewModel>[],
      summary: ReviewSummaryModel.fromJson(
        summary is Map<String, dynamic> ? summary : const <String, dynamic>{},
      ),
    );
  }

  Future<List<ReviewModel>> mine() async {
    final response = await _client.getJson(ApiConfig.reviews);
    final raw = response['data']?['reviews'];

    if (raw is! List) return const <ReviewModel>[];

    return raw.whereType<Map<String, dynamic>>().map(ReviewModel.fromJson).toList();
  }

  Future<void> submit({
    required int productId,
    required int rating,
    int? orderId,
    String? title,
    String? body,
  }) {
    return _client.postJson(ApiConfig.reviews, {
      'product_id': productId,
      'rating': rating,
      if (orderId != null && orderId > 0) 'order_id': orderId,
      if (title != null && title.trim().isNotEmpty) 'title': title.trim(),
      if (body != null && body.trim().isNotEmpty) 'body': body.trim(),
    });
  }
}
