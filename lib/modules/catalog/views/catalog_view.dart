import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../../../app/widgets/product_card.dart';
import '../controllers/catalog_controller.dart';
import 'widgets/category_menu_tile.dart';

class CatalogView extends GetView<CatalogController> {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.products.isEmpty) {
        return const LoadingView();
      }

      return Column(
        children: [
          _search(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _categoryMenu(),
                Expanded(child: _productArea()),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _search() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: TextField(
        onChanged: (value) => controller.search.value = value,
        decoration: const InputDecoration(
          hintText: 'Search product',
          prefixIcon: Icon(Icons.search_rounded),
        ),
      ),
    );
  }

  Widget _categoryMenu() {
    return Container(
      width: 94,
      decoration: const BoxDecoration(
        color: Color(0xFFF6F8F5),
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.only(top: 6, bottom: 18),
          itemCount: controller.categories.length + 1,
          itemBuilder: (_, index) {
            final isAll = index == 0;
            final category = isAll ? null : controller.categories[index - 1];
            final id = category?.id ?? 0;
            final active = controller.selectedCategoryId.value == id;

            return CategoryMenuTile(
              title: isAll ? 'All' : category!.name,
              active: active,
              category: category,
              onTap: () => controller.selectCategory(id),
            );
          },
        ),
      ),
    );
  }

  Widget _productArea() {
    return Obx(() {
      final products = controller.filteredProducts;

      if (controller.isLoading.value && products.isNotEmpty) {
        return Stack(
          children: [
            _productGrid(products),
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: LinearProgressIndicator(minHeight: 2),
            ),
          ],
        );
      }

      if (products.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.loadCatalog,
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: 420,
              child: EmptyState(
                title: 'No Products',
                message: 'No product found in selected category.',
              ),
            ),
          ),
        );
      }

      return _productGrid(products);
    });
  }

  Widget _productGrid(List products) {
    return RefreshIndicator(
      onRefresh: controller.loadCatalog,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 250 ? 2 : 1;
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: columns == 1 ? .78 : .58,
            ),
            itemBuilder: (_, index) => ProductCard(product: products[index]),
          );
        },
      ),
    );
  }
}
