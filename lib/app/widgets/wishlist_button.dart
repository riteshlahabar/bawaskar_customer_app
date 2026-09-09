import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/wishlist/controllers/wishlist_controller.dart';
import '../theme/app_colors.dart';
import '../utils/auth_guard.dart';

/// Heart toggle shared by the product card and the product detail screen.
///
/// It reads the app-wide [WishlistController] rather than taking state as a
/// parameter, so every place a product appears stays in sync after a tap
/// without the parent having to pass anything down.
class WishlistButton extends StatelessWidget {
  const WishlistButton({super.key, required this.productId, this.size = 20});

  final int productId;
  final double size;

  @override
  Widget build(BuildContext context) {
    final wishlist = Get.find<WishlistController>();

    return Obx(() {
      final saved = wishlist.contains(productId);

      return IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(minWidth: size + 12, minHeight: size + 12),
        visualDensity: VisualDensity.compact,
        tooltip: saved ? 'Remove from wishlist' : 'Save for later',
        onPressed: () {
          final allowed = AuthGuard.ensureLoggedIn(
            message: 'Please login or sign up to use your wishlist.',
          );
          if (!allowed) return;
          wishlist.toggle(productId);
        },
        icon: Icon(
          saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: size,
          color: saved ? AppColors.danger : AppColors.textSecondary,
        ),
      );
    });
  }
}
