import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import 'banner_card.dart';
import '../../../../app/localization/t.dart';

/// Home screen hero carousel: shows the homepage's promotional banners,
/// or a single fallback banner when none are configured.
class HeroBannerSection extends StatelessWidget {
  const HeroBannerSection({required this.banners, super.key});

  final List<HomepageItemModel> banners;

  /// Width / height of the admin hero banner images (e.g. 2176 x 723).
  static const _bannerAspectRatio = 3.0;

  static const _sidePadding = 12.0;

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return _fallbackHeroBanner();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Full screen width, and a height that follows the image's own shape
        // so the whole banner is visible instead of being cropped.
        final cardHeight = (constraints.maxWidth - _sidePadding * 2) / _bannerAspectRatio;

        return SizedBox(
          height: cardHeight,
          child: PageView.builder(
            itemCount: banners.length,
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: _sidePadding),
              child: BannerCard(banners[index], height: cardHeight, large: true),
            ),
          ),
        );
      },
    );
  }

  Widget _fallbackHeroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BannerCard(
        HomepageItemModel(
          id: 0,
          title: t('catalog.hero_title'),
          subtitle: t('catalog.hero_subtitle'),
          buttonText: t('catalog.shop_now'),
          imageUrl: 'assets/images/animal_medicine_banner.png',
        ),
        height: 176,
        large: true,
        isAsset: true,
      ),
    );
  }
}
