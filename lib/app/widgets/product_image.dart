import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../theme/app_colors.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  final String? imageUrl;
  final String? assetPath;
  final double? height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = _resolveImageUrl(imageUrl);
    final asset = assetPath?.trim() ?? '';

    if (url.isNotEmpty) {
      return Image.network(
        url,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, _, _) {
          return _assetOrPlaceholder(asset);
        },
      );
    }

    return _assetOrPlaceholder(asset);
  }

  Widget _assetOrPlaceholder(String asset) {
    if (asset.isNotEmpty) {
      return Image.asset(
        asset,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, _, _) {
          return _placeholder();
        },
      );
    }

    return _placeholder();
  }

  String _resolveImageUrl(String? imageUrl) {
    final value = imageUrl?.trim() ?? '';

    if (value.isEmpty || value == 'null') {
      return '';
    }

    final apiBase =
        Uri.tryParse(ApiConfig.baseUrl);

    if (apiBase == null ||
        !apiBase.hasScheme ||
        apiBase.host.isEmpty) {
      return value;
    }

    final origin = Uri(
      scheme: apiBase.scheme,
      host: apiBase.host,
      port: apiBase.hasPort
          ? apiBase.port
          : null,
      path: '/',
    );

    final imageUri = Uri.tryParse(value);

    if (imageUri != null &&
        imageUri.hasScheme) {
      // Protect the mobile app if Laravel accidentally
      // returns localhost URLs.
      if (imageUri.host == 'localhost' ||
          imageUri.host == '127.0.0.1' ||
          imageUri.host == '10.0.2.2') {
        return imageUri
            .replace(
              scheme: origin.scheme,
              host: origin.host,
              port: origin.hasPort
                  ? origin.port
                  : null,
            )
            .toString();
      }

      return value;
    }

    final relative = Uri.tryParse(
      value.startsWith('/')
          ? value
          : '/$value',
    );

    if (relative == null) {
      return value;
    }

    return origin
        .resolveUri(relative)
        .toString();
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.eco,
        color: AppColors.primary,
        size: 32,
      ),
    );
  }
}