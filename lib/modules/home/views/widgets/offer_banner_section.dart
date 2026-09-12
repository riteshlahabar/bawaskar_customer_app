import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import '../../../../app/widgets/section_header.dart';
import 'banner_card.dart';

/// Stacked large banner cards for homepage sections of type
/// `offer_section`.
class OfferBannerSection extends StatelessWidget {
  const OfferBannerSection({required this.section, super.key});

  final HomepageSectionModel section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title.isNotEmpty) SectionHeader(title: section.title),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (final item in section.items) ...[
                BannerCard(item, height: 122, textWidth: 170),
                if (item != section.items.last) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
