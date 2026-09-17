import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/loading_view.dart';
import '../controllers/home_controller.dart';
import 'widgets/category_row.dart';
import 'widgets/hero_banner_section.dart';
import 'widgets/homepage_section_view.dart';
import 'widgets/product_section.dart';
import 'widgets/small_banner_section.dart';
import '../../../app/localization/t.dart';

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
        return LoadingView(message: t('catalog.preparing_store'));
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
        HeroBannerSection(banners: controller.banners),
        CategoryRow(categories: controller.categories),
        ...smallBannerSections.map(
          (section) => SmallBannerSection(section: section),
        ),
        ...remainingSections.map(
          (section) => HomepageSectionView(section: section),
        ),
      ];

      if (otherSections.isEmpty) {
        content.addAll([
          ProductSection(
            title: t('catalog.animal_medicine'),
            items: controller.featuredProducts,
          ),
          ProductSection(
            title: t('catalog.top_selling'),
            items: controller.topSellingProducts,
          ),
          ProductSection(title: t('catalog.new_arrivals'), items: controller.newArrivals),
        ]);
      }

      content.add(const SizedBox(height: 22));

      return RefreshIndicator(
        onRefresh: () => controller.loadHome(fresh: true),
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
              decoration: InputDecoration(
                hintText: t('catalog.search_home_hint'),
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
}
