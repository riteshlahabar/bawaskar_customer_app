import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import 'coupon_section.dart';
import 'offer_banner_section.dart';
import 'product_section.dart';
import 'service_section.dart';
import 'small_banner_section.dart';
import 'strip_offer_banner.dart';
import '../../../../app/localization/t.dart';

/// Dispatches a homepage section to the widget matching its `type`.
class HomepageSectionView extends StatelessWidget {
  const HomepageSectionView({required this.section, super.key});

  final HomepageSectionModel section;

  @override
  Widget build(BuildContext context) {
    if (section.type == 'service_section') {
      return ServiceSection(section: section);
    }

    // Bank & Wallet Offers: two columns, same as the website — even when an
    // offer has no image, and never as plain product cards.
    if (section.isCoupon) {
      return section.items.isEmpty
          ? const SizedBox.shrink()
          : CouponSection(section: section);
    }

    // Offer strip: full-width image, no section heading (same as website).
    if (section.type == 'strip_offer_banner') {
      return section.items.isEmpty
          ? const SizedBox.shrink()
          : StripOfferBanner(item: section.items.first);
    }

    if (section.hasBanners) {
      return switch (section.type) {
        'top_small_banners' => SmallBannerSection(section: section),
        'offer_section' => OfferBannerSection(section: section),
        _ => SmallBannerSection(section: section),
      };
    }

    if (section.hasProducts) {
      return ProductSection(
        title: section.title.isEmpty ? t('common.products') : section.title,
        items: section.products,
        subtitle: section.subtitle,
      );
    }

    return const SizedBox.shrink();
  }
}
