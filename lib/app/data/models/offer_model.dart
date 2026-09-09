/// A coupon offer shown on the offers screen and applied at checkout.
class OfferModel {
  const OfferModel({
    required this.id,
    required this.code,
    required this.title,
    required this.discountType,
    required this.discountValue,
    this.description = '',
    this.maxDiscount,
    this.minOrderValue = 0,
    this.endsAt,
  });

  final int id;
  final String code;
  final String title;
  final String description;
  final String discountType;
  final double discountValue;
  final double? maxDiscount;
  final double minOrderValue;
  final String? endsAt;

  bool get isPercent => discountType == 'percent';

  /// Short badge text, e.g. "20% OFF" or "FLAT 150 OFF".
  String get badge => isPercent
      ? '${discountValue.toStringAsFixed(discountValue % 1 == 0 ? 0 : 2)}% OFF'
      : 'FLAT ${discountValue.toStringAsFixed(0)} OFF';

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      code: json['code']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      discountType: json['discount_type']?.toString() ?? 'percent',
      discountValue: double.tryParse(json['discount_value']?.toString() ?? '') ?? 0,
      maxDiscount: double.tryParse(json['max_discount']?.toString() ?? ''),
      minOrderValue: double.tryParse(json['min_order_value']?.toString() ?? '') ?? 0,
      endsAt: json['ends_at']?.toString(),
    );
  }
}

/// Server's verdict on an applied coupon. The discount is always computed
/// backend-side, so this is the only value the cart may trust.
class AppliedCouponModel {
  const AppliedCouponModel({
    required this.code,
    required this.title,
    required this.discount,
    required this.payable,
  });

  final String code;
  final String title;
  final double discount;
  final double payable;

  factory AppliedCouponModel.fromJson(Map<String, dynamic> json) {
    return AppliedCouponModel(
      code: json['code']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      discount: double.tryParse(json['discount']?.toString() ?? '') ?? 0,
      payable: double.tryParse(json['payable']?.toString() ?? '') ?? 0,
    );
  }
}
