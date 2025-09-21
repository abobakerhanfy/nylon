import 'package:get/get.dart';

class AppRoutes {
  // استخدم نفس أسماء الصفحات الموجودة عندك
  static const String pOneProduct = '/ViewOneProduct';
  static const String pOneCategory = '/ViewOneCategory';
}

/// دوال مساعدة لفك ترميز &amp; وتحليل الرابط
extension _UrlHelpers on String {
  String get unescaped => replaceAll('&amp;', '&');

  Uri? get asUri => Uri.tryParse(unescaped);

  bool get isProductLink {
    final u = asUri;
    if (u == null) return false;
    return u.pathSegments.contains('products');
  }

  bool get isCategoryLink {
    final u = asUri;
    if (u == null) return false;
    final route = u.queryParameters['route'];
    return route == 'product/category' && u.queryParameters.containsKey('path');
  }

  /// مثال: https://site.com/products/kudu-sandwich => يرجّع "kudu-sandwich"
  String? get productSlug {
    final u = asUri;
    if (u == null) return null;
    final idx = u.pathSegments.indexOf('products');
    if (idx == -1) return null;
    if (u.pathSegments.length > idx + 1) {
      return u.pathSegments[idx + 1];
    }
    return null;
  }

  /// يرجّع قيمة path كاملة (قد تكون 109 أو 109_234)
  String? get categoryPath {
    final u = asUri;
    if (u == null) return null;
    return u.queryParameters['path'];
  }
}

/// استدعِ الدالة دي وقت ضغط المستخدم على عنصر السلايدر
void handleLinkTap(String? link) {
  final _link = (link ?? '').trim();
  if (_link.isEmpty) {
    // تقدر تبدّلها بـ Snackbar حسب مشروعك
    print('No link attached to slider item');
    return;
  }

  if (_link.isProductLink) {
    final slug = _link.productSlug;
    if (slug == null || slug.isEmpty) {
      print('Could not extract product slug from: $_link');
      return;
    }

    Get.toNamed(
      AppRoutes.pOneProduct,
      arguments: {
        'slug': slug,
        'source': 'slider',
        'rawLink': _link.unescaped,
      },
    );
    return;
  }

  if (_link.isCategoryLink) {
    final path = _link.categoryPath;
    if (path == null || path.isEmpty) {
      print('Could not extract category path from: $_link');
      return;
    }
    final lastId = path.split('_').last;

    Get.toNamed(
      AppRoutes.pOneCategory,
      arguments: {
        'path': path, // القيمة كاملة (مثال: 109 أو 109_234)
        'category_id': lastId, // آخر ID فقط لو محتاجه
        'source': 'slider',
        'rawLink': _link.unescaped,
      },
    );
    return;
  }

  // لو مش منتج ولا قسم، اختياري: افتح WebView أو تجاهل
  print('Unknown link type, open in WebView or browser: $_link');
  // مثال لو عندك صفحة ويب:
  // Get.toNamed('/WebView', arguments: {'url': _link.unescaped});
}
