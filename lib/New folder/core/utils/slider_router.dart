import 'dart:convert';

enum SliderTargetType { productBySlug, productById, category, unknown }

class SliderTarget {
  final SliderTargetType type;
  final String? slug;
  final int? productId;
  final String? path;
  final int? categoryId;

  SliderTarget._(this.type,
      {this.slug, this.productId, this.path, this.categoryId});

  static SliderTarget unknown() => SliderTarget._(SliderTargetType.unknown);
}

String _decodeHtml(String s) => s
    .replaceAll('&amp;', '&')
    .replaceAll('&nbsp;', ' ')
    .replaceAll('\u00A0', ' ')
    .trim();

SliderTarget parseSliderLink(String? rawLink) {
  if (rawLink == null || rawLink.trim().isEmpty) return SliderTarget.unknown();

  final cleaned = _decodeHtml(Uri.decodeFull(rawLink));

  // 1) /products/<slug>
  final productsIdx = cleaned.indexOf('/products/');
  if (productsIdx != -1) {
    final after = cleaned.substring(productsIdx + '/products/'.length);
    // اقطع عند أول ? أو نهاية السطر
    final slug = after.split('?').first.split('#').first.trim();
    if (slug.isNotEmpty) {
      return SliderTarget._(SliderTargetType.productBySlug, slug: slug);
    }
  }

  // 2) روابط index.php?route=...
  Uri? uri;
  try {
    uri = Uri.parse(cleaned);
  } catch (_) {
    return SliderTarget.unknown();
  }

  final route = uri.queryParameters['route'] ?? '';
  if (route == 'product/product') {
    final pidStr =
        uri.queryParameters['product_id'] ?? uri.queryParameters['productId'];
    final pid = int.tryParse((pidStr ?? '').trim());
    if (pid != null) {
      return SliderTarget._(SliderTargetType.productById, productId: pid);
    }
  }

  if (route == 'product/category') {
    final path = uri.queryParameters['path']
        ?.replaceAll(' ', ''); // لو حصلت مسافة غريبة زي "109_1 53"
    if (path != null && path.isNotEmpty) {
      final parts = path.split('_');
      final last = parts.isNotEmpty ? parts.last : path;
      final cid = int.tryParse(last);
      return SliderTarget._(
        SliderTargetType.category,
        path: path,
        categoryId: cid,
      );
    }
  }

  return SliderTarget.unknown();
}
