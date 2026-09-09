/// A product review, as shown on the product page and in "my reviews".
class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.rating,
    this.title = '',
    this.body = '',
    this.reviewer = '',
    this.status = '',
    this.productName = '',
    this.verifiedPurchase = false,
    this.createdAt = '',
  });

  final int id;
  final int rating;
  final String title;
  final String body;
  final String reviewer;
  final String status;
  final String productName;
  final bool verifiedPurchase;
  final String createdAt;

  bool get isPending => status == 'pending';

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    final productMap = product is Map<String, dynamic> ? product : const <String, dynamic>{};

    return ReviewModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      rating: int.tryParse(json['rating']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      reviewer: json['reviewer']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      productName: productMap['name']?.toString() ?? '',
      verifiedPurchase: json['verified_purchase'] == true,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

/// Aggregate rating for a product.
class ReviewSummaryModel {
  const ReviewSummaryModel({required this.total, required this.average});

  final int total;
  final double average;

  factory ReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return ReviewSummaryModel(
      total: int.tryParse(json['total']?.toString() ?? '') ?? 0,
      average: double.tryParse(json['average']?.toString() ?? '') ?? 0,
    );
  }
}
