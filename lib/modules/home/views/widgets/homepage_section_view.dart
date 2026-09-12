import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import 'banner_card.dart';
import 'coupon_section.dart';
import 'offer_banner_section.dart';
import 'product_section.dart';
import 'service_section.dart';
import 'small_banner_section.dart';

/// Dispatches a homepage section to the widget matching its `type`.
class HomepageSectionView extends StatelessWidget {
  const HomepageSectionView({required this.section, super.key});

  final HomepageSectionModel section;

  @override
  Widget build(BuildContext context) {
    if (section.type == 'service_section') {
      return ServiceSection(section: section);
    }

    if (section.hasBanners) {
      return switch (section.type) {
        'top_small_banners' => SmallBannerSection(section: section),
        'coupon_section' => CouponSection(section: section),
        'offer_section' => OfferBannerSection(section: section),
        'strip_offer_banner' => Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
          child: BannerCard(
            section.items.first,
            height: 86,
            textWidth: MediaQuery.sizeOf(context).width * .48,
          ),
        ),
        _ => SmallBannerSection(section: section),
      };
    }

    if (section.hasProducts) {
      return ProductSection(
        title: section.title.isEmpty ? 'Products' : section.title,
        items: section.products,
        subtitle: section.subtitle,
      );
    }

    return const SizedBox.shrink();
  }
}
