import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/wishlist/controllers/wishlist_controller.dart';
import '../theme/app_colors.dart';
import '../utils/auth_guard.dart';
import '../localization/t.dart';

/// Heart toggle shared by the product card and the product detail screen.
///
/// It reads the app-wide [WishlistController] rather than taking state as a
/// parameter, so every place a product appears stays in sync after a tap
/// without the parent having to pass anything down.
class WishlistButton extends StatelessWidget {
  const WishlistButton({
    super.key,
    required this.productId,
    this.size = 20,
    this.unsavedColor = AppColors.textSecondary,
  });

  final int productId;
  final double size;

  /// Outline heart colour; white when shown on the green app bar.
  final Color unsavedColor;

  @override
  Widget build(BuildContext context) {
    final wishlist = Get.find<WishlistController>();

    return Obx(() {
      final saved = wishlist.contains(productId);

      return IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(minWidth: size + 12, minHeight: size + 12),
        visualDensity: VisualDensity.compact,
        tooltip: saved ? t('common.remove_from_wishlist') : t('common.save_for_later'),
        onPressed: () {
          final allowed = AuthGuard.ensureLoggedIn(
            message: t('login.before_wishlist'),
          );
          if (!allowed) return;
          wishlist.toggle(productId);
        },
        icon: Icon(
          saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: size,
          color: saved ? AppColors.danger : unsavedColor,
        ),
      );
    });
  }
}
