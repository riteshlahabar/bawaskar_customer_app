import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/models/homepage_model.dart';
import '../../../../app/data/models/product_model.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';
import '../../../main_shell/controllers/main_shell_controller.dart';
import '../../../../app/localization/t.dart';

/// Row of small promotional / product banner cards used for homepage
/// sections of type `top_small_banners`.
class SmallBannerSection extends StatelessWidget {
  const SmallBannerSection({required this.section, super.key});

  final HomepageSectionModel section;

  @override
  Widget build(BuildContext context) {
    if (section.items.isEmpty && section.products.isEmpty) {
      return const SizedBox.shrink();
    }

    final count = section.products.isNotEmpty
        ? section.products.length
        : section.items.length;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
        height: 128,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: count,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (_, index) {
            final banner = index < section.items.length
                ? section.items[index]
                : null;
            final product = index < section.products.length
                ? section.products[index]
                : null;
            return SizedBox(
              width: 198,
              child: _smallBannerCard(banner, product),
            );
          },
        ),
      ),
    );
  }

  String? _versionedImageUrl(String? imageUrl, String? version) {
    final url = imageUrl?.trim() ?? '';
    final cacheVersion = version?.trim() ?? '';
    if (url.isEmpty || cacheVersion.isEmpty) return imageUrl;

    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}v=${Uri.encodeComponent(cacheVersion)}';
  }

  Widget _smallBannerCard(HomepageItemModel? banner, ProductModel? product) {
    final imageUrl = _versionedImageUrl(
      product?.homepageMobileImageUrl ??
          product?.homepageImageUrl ??
          product?.imageUrl ??
          banner?.bestImageUrl,
      product?.imageVersion,
    );
    final title = product?.name ?? banner?.title ?? '';
    final buttonText = (banner?.buttonText.isNotEmpty ?? false)
        ? banner!.buttonText
        : t('catalog.shop_now');

    void openProduct() {
      if (product != null) {
        Get.toNamed(AppRoutes.productDetail, arguments: product);
        return;
      }
      Get.find<MainShellController>().changeTab(1);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: openProduct,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            color: AppColors.primarySoft,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (imageUrl != null)
                  ProductImage(imageUrl: imageUrl, fit: BoxFit.cover),
                if (imageUrl == null)
                  Container(
                    color: AppColors.primarySoft,
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.08,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: .42),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 8,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 28,
                        child: ElevatedButton(
                          onPressed: openProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            minimumSize: const Size(0, 28),
                          ),
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
