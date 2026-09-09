import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/homepage_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/loading_view.dart';
import '../../../app/widgets/product_card.dart';
import '../../../app/widgets/product_image.dart';
import '../../../app/widgets/section_header.dart';
import '../../catalog/controllers/catalog_controller.dart';
import '../../main_shell/controllers/main_shell_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEmpty =
          controller.products.isEmpty &&
          controller.categories.isEmpty &&
          controller.sections.isEmpty &&
          controller.banners.isEmpty;
      if (controller.isLoading.value && isEmpty) {
        return const LoadingView(message: 'Preparing storefront...');
      }

      final otherSections = controller.sections
          .where((section) => !section.isHero && !section.isCategory)
          .toList();
      final smallBannerSections = otherSections
          .where((section) => section.type == 'top_small_banners')
          .toList();
      final remainingSections = otherSections
          .where((section) => section.type != 'top_small_banners')
          .toList();
      final content = <Widget>[
        _topSearch(context),
        _heroBanners(),
        _categories(),
        ...smallBannerSections.map(_smallBannerSection),
        ...remainingSections.map(
          (section) => _homepageSection(context, section),
        ),
      ];

      if (otherSections.isEmpty) {
        content.addAll([
          _productSection('Animal Medicine', controller.featuredProducts),
          _productSection('Top Selling Items', controller.topSellingProducts),
          _productSection('New Arrivals', controller.newArrivals),
        ]);
      }

      content.add(const SizedBox(height: 22));

      return RefreshIndicator(
        onRefresh: controller.loadHome,
        child: ListView(padding: EdgeInsets.zero, children: content),
      );
    });
  }

  Widget _topSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) => controller.searchText.value = value,
              decoration: const InputDecoration(
                hintText: 'Search medicines, seeds, fertilizers...',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.tune_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _heroBanners() {
    final banners = controller.banners;
    if (banners.isEmpty) return _fallbackHeroBanner();

    return SizedBox(
      height: 188,
      child: PageView.builder(
        padEnds: false,
        controller: PageController(viewportFraction: .92),
        itemCount: banners.length,
        itemBuilder: (_, index) => Padding(
          padding: EdgeInsets.only(left: index == 0 ? 16 : 8, right: 8),
          child: _bannerCard(banners[index], height: 176, large: true),
        ),
      ),
    );
  }

  Widget _fallbackHeroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _bannerCard(
        const HomepageItemModel(
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

  Widget _categories() {
    if (controller.categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Shop By Category',
          actionText: 'View All',
          onAction: () {
            Get.find<CatalogController>().selectCategory(0);
            Get.find<MainShellController>().changeTab(1);
          },
        ),
        SizedBox(
          height: 104,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, index) {
              final category = controller.categories[index];
              return _CategoryTile(
                category: category,
                onTap: () => _openCategory(category.id),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openCategory(int categoryId) {
    Get.find<CatalogController>().selectCategory(categoryId);
    Get.find<MainShellController>().changeTab(1);
  }

  Widget _homepageSection(BuildContext context, HomepageSectionModel section) {
    if (section.type == 'service_section') {
      return _serviceSection(section);
    }

    if (section.hasBanners) {
      return switch (section.type) {
        'top_small_banners' => _smallBannerSection(section),
        'coupon_section' => _couponSection(section),
        'offer_section' => _offerBannerSection(section),
        'strip_offer_banner' => Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
          child: _bannerCard(
            section.items.first,
            height: 86,
            textWidth: MediaQuery.sizeOf(context).width * .48,
          ),
        ),
        _ => _smallBannerSection(section),
      };
    }

    if (section.hasProducts) {
      return _productSection(
        section.title.isEmpty ? 'Products' : section.title,
        section.products,
        subtitle: section.subtitle,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _smallBannerSection(HomepageSectionModel section) {
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
        : 'Shop Now';

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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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

  Widget _couponSection(HomepageSectionModel section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: section.title.isEmpty ? 'Bank & Wallet Offers' : section.title,
        ),
        SizedBox(
          height: 118,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: section.items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, index) =>
                SizedBox(width: 250, child: _couponCard(section.items[index])),
          ),
        ),
      ],
    );
  }

  Widget _offerBannerSection(HomepageSectionModel section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title.isNotEmpty) SectionHeader(title: section.title),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (final item in section.items) ...[
                _bannerCard(item, height: 122, textWidth: 170),
                if (item != section.items.last) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _serviceSection(HomepageSectionModel section) {
    if (section.items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: section.title.isEmpty ? 'Store Services' : section.title,
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: section.items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 74,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (_, index) {
            final item = section.items[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (item.subtitle.isNotEmpty)
                          Text(
                            item.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _productSection(
    String title,
    List<ProductModel> items, {
    String subtitle = '',
  }) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        SectionHeader(
          title: title,
          actionText: 'See All',
          onAction: () => Get.find<MainShellController>().changeTab(1),
        ),
        if (subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        SizedBox(
          height: 248,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, index) =>
                SizedBox(width: 156, child: ProductCard(product: items[index])),
          ),
        ),
      ],
    );
  }

  Widget _couponCard(HomepageItemModel item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 92,
            height: double.infinity,
            child: ProductImage(imageUrl: item.bestImageUrl, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (item.subtitle.isNotEmpty)
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (item.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  if (item.couponCode.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        'Code: ${item.couponCode}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerCard(
    HomepageItemModel banner, {
    required double height,
    bool large = false,
    bool isAsset = false,
    double textWidth = 210,
  }) {
    final imageUrl = banner.bestImageUrl;
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(large ? 22 : 18),
        border: Border.all(color: AppColors.border),
        color: AppColors.primarySoft,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl != null)
            ProductImage(
              imageUrl: isAsset ? null : imageUrl,
              assetPath: isAsset ? imageUrl : null,
              fit: BoxFit.cover,
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withValues(alpha: .94),
                  Colors.white.withValues(alpha: .50),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 14,
            bottom: 14,
            width: textWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (banner.highlightText.isNotEmpty ||
                    banner.discountText.isNotEmpty) ...[
                  Text(
                    banner.highlightText.isNotEmpty
                        ? banner.highlightText
                        : banner.discountText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
                Text(
                  banner.title,
                  maxLines: large ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: large ? 22 : 16,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (banner.subtitle.isNotEmpty ||
                    banner.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    banner.subtitle.isNotEmpty
                        ? banner.subtitle
                        : banner.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11.5,
                      height: 1.25,
                    ),
                  ),
                ],
                if (large) ...[
                  const Spacer(),
                  SizedBox(
                    height: 34,
                    child: ElevatedButton(
                      onPressed: () =>
                          Get.find<MainShellController>().changeTab(1),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(108, 34),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      child: Text(
                        banner.buttonText.isEmpty
                            ? 'Shop Now'
                            : banner.buttonText,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, this.onTap});

  final CategoryModel category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        width: 82,
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(18),
              ),
              clipBehavior: Clip.antiAlias,
              child: category.imageUrl == null
                  ? Icon(
                      _iconFor(category.name),
                      color: AppColors.primary,
                      size: 28,
                    )
                  : ProductImage(
                      imageUrl: category.imageUrl,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 7),
            Text(
              category.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String name) {
    final value = name.toLowerCase();
    if (value.contains('medicine') || value.contains('veterinary')) {
      return Icons.medication_liquid_rounded;
    }
    if (value.contains('seed')) return Icons.grass_rounded;
    if (value.contains('fertil')) return Icons.eco_rounded;
    if (value.contains('tool') || value.contains('equipment')) {
      return Icons.agriculture_rounded;
    }
    if (value.contains('feed') || value.contains('supplement')) {
      return Icons.inventory_2_rounded;
    }
    return Icons.spa_rounded;
  }
}
