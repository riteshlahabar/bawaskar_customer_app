import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/models/product_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_card.dart';
import '../../../../app/widgets/section_header.dart';
import '../../../main_shell/controllers/main_shell_controller.dart';

/// Horizontal row of products under a titled section header, used for
/// homepage product sections and the fallback featured/top-selling/new
/// arrivals rows.
class ProductSection extends StatelessWidget {
  const ProductSection({
    required this.title,
    required this.items,
    this.subtitle = '',
    super.key,
  });

  final String title;
  final List<ProductModel> items;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
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
}
