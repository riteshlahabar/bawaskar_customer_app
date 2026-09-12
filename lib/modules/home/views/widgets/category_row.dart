import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/models/category_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';
import '../../../../app/widgets/section_header.dart';
import '../../../catalog/controllers/catalog_controller.dart';
import '../../../main_shell/controllers/main_shell_controller.dart';

/// "Shop By Category" horizontal row shown on the home screen.
class CategoryRow extends StatelessWidget {
  const CategoryRow({required this.categories, super.key});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Shop By Category',
          actionText: 'View All',
          onAction: () => _openCategory(0),
        ),
        SizedBox(
          height: 104,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, index) {
              final category = categories[index];
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
