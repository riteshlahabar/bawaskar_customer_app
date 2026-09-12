import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import 'banner_card.dart';

/// Home screen hero carousel: shows the homepage's promotional banners,
/// or a single fallback banner when none are configured.
class HeroBannerSection extends StatelessWidget {
  const HeroBannerSection({required this.banners, super.key});

  final List<HomepageItemModel> banners;

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return _fallbackHeroBanner();

    return SizedBox(
      height: 188,
      child: PageView.builder(
        padEnds: false,
        controller: PageController(viewportFraction: .92),
        itemCount: banners.length,
        itemBuilder: (_, index) => Padding(
          padding: EdgeInsets.only(left: index == 0 ? 16 : 8, right: 8),
          child: BannerCard(banners[index], height: 176, large: true),
        ),
      ),
    );
  }

  Widget _fallbackHeroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const BannerCard(
        HomepageItemModel(
          id: 0,
          title: 'Farm Health Essentials',
          subtitle: 'Medicines, Seeds & Supplements',
          buttonText: 'Shop Now',
          imageUrl: 'assets/images/animal_medicine_banner.png',
        ),
        height: 176,
        large: true,
        isAsset: true,
      ),
    );
  }
}
