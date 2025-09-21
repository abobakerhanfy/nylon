// lib/features/home/presentation/widgets/mobile_slider_section.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/features/home/data/models/mobile_slider.dart';

/// فعّل/أوقف لوجات السلايدر من هنا
const bool kEnableSliderLogs = true;

/// ===== Helpers لتطبيع روابط الصور (تفادي الـ double-encode) =====
String _normalizedImageUrl(String? raw) {
  final s = (raw ?? '').trim();
  if (s.isEmpty) return '';

  // 1) لو الرابط متشفّر مرتين (زي %2520) نفك تشفير مرة واحدة
  String onceDecoded;
  try {
    onceDecoded = Uri.decodeFull(s);
  } catch (_) {
    onceDecoded = s;
  }

  // 2) نحول المسافات العادية لـ %20 فقط بدون أي encode إضافي لباقي الأجزاء
  final cleaned = onceDecoded.replaceAll(' ', '%20');

  // مهم: منعملش Uri.encodeFull هنا علشان مايحصلش %25 مرة تانية
  return cleaned;
}

/// ===== Helpers لتحليل الروابط القادمة من الـ API =====
extension _LinkX on String {
  String get unescaped => replaceAll('&amp;', '&').replaceAll(' ', '');
  Uri? get asUri => Uri.tryParse(unescaped);

  bool get isCategoryLink {
    final u = asUri;
    return u != null &&
        u.queryParameters['route'] == 'product/category' &&
        u.queryParameters.containsKey('path');
  }

  bool get isProductByIdLink {
    final u = asUri;
    return u != null &&
        u.queryParameters['route'] == 'product/product' &&
        u.queryParameters.containsKey('product_id');
  }

  bool get isProductSlugLink {
    final u = asUri;
    if (u == null) return false;
    final segs = u.pathSegments;
    final idx = segs.indexOf('products');
    return idx != -1 && segs.length > idx + 1;
  }

  String? get categoryPath => asUri?.queryParameters['path'];
  String? get productId => asUri?.queryParameters['product_id'];

  String? get productSlug {
    final u = asUri;
    if (u == null) return null;
    final segs = u.pathSegments;
    final idx = segs.indexOf('products');
    if (idx == -1 || segs.length <= idx + 1) return null;
    return segs[idx + 1];
  }

  bool get isMobileSpecials =>
      asUri?.queryParameters['route'] == 'mobile_product/specials';
}

class MobileSliderSection extends StatelessWidget {
  final MobileSlider slider;

  const MobileSliderSection({super.key, required this.slider});

  @override
  Widget build(BuildContext context) {
    final List<ImageData> items = (slider.image ?? [])
        .where((e) => _normalizedImageUrl(e.image).isNotEmpty)
        .toList()
      ..sort((a, b) => a.getSortOrder().compareTo(b.getSortOrder()));

    if (kEnableSliderLogs) {
      debugPrint(
          '🎞️ MobileSliderSection.build -> items=${items.length}, status=${slider.status}, sort=${slider.sort}');
    }

    if (items.isEmpty) return const SizedBox.shrink();

    // تشخيص: اطبع تصنيف الروابط أول مرة
    _debugPrintLinks(items);

    final pageController = PageController(viewportFraction: 0.95);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.22,
      child: PageView.builder(
        controller: pageController,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final imgUrl = _normalizedImageUrl(item.image);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            child: InkWell(
              onTap: () async {
                // ركّز الكارت أولاً لو مش هو الظاهر حاليًا
                final current = pageController.page?.round() ?? 0;
                if (current != index) {
                  await pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                }
                // بعد التركيز (أو لو كان بالفعل مُتمركز)، نفّذ التنقّل فورًا
                _onSlideTap(item);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imgUrl.isEmpty
                    ? _broken()
                    : CachedNetworkImage(
                        imageUrl: imgUrl,
                        fit: BoxFit.cover,
                        // نفضّل صيغ مدعومة (لتجنّب AVIF/HEIC على بعض الأجهزة)
                        httpHeaders: const {
                          'Accept':
                              'image/webp,image/jpeg,image/png;q=0.9,*/*;q=0.1',
                        },
                        // تقليل الضغط على الإيموليتر
                        memCacheWidth: (MediaQuery.of(context).size.width *
                                MediaQuery.of(context).devicePixelRatio)
                            .toInt(),
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) {
                          if (kEnableSliderLogs) {
                            debugPrint('❌ Image decode failed: $url -> $error');
                          }
                          return _broken();
                        },
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _broken() => Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image_outlined),
      );

  /// الضغط على السلايد: قسم/منتج (ID أو Slug) أو Specials
  void _onSlideTap(ImageData item) {
    final raw = (item.link ?? '').trim();
    if (raw.isEmpty) {
      if (kEnableSliderLogs) debugPrint('⚠️ Tap with empty link');
      Get.snackbar('تنبيه', 'لا يوجد رابط لهذا البنر.');
      return;
    }

    final link = raw.unescaped;
    if (kEnableSliderLogs) debugPrint('🖱️ Tap link: $link');

    if (link.isCategoryLink) {
      final path = link.categoryPath!;
      final lastId = path.split('_').last;
      if (kEnableSliderLogs) {
        debugPrint('➡️ Navigate: Category | path=$path | id=$lastId');
      }
      Get.toNamed(
        NamePages.pOneCategory,
        arguments: {
          'categoryId': lastId,
          'category_id': lastId, // احتياط لو الشاشة تقرأ الاسم ده
          'path': path,
          'rawLink': link,
          'source': 'mobile_slider',
        },
      );
      return;
    }

    if (link.isProductByIdLink) {
      final id = link.productId!;
      if (kEnableSliderLogs) {
        debugPrint('➡️ Navigate: ProductById | id=$id');
      }
      Get.toNamed(
        NamePages.pOneProduct,
        arguments: {
          'product_id': id,
          'rawLink': link,
          'source': 'mobile_slider',
        },
      );
      return;
    }

    if (link.isProductSlugLink) {
      final slug = link.productSlug!;
      if (kEnableSliderLogs) {
        debugPrint('➡️ Navigate: ProductBySlug | slug=$slug');
      }
      Get.toNamed(
        NamePages.pOneProduct,
        arguments: {
          'slug': slug,
          'rawLink': link,
          'source': 'mobile_slider',
        },
      );
      return;
    }

    if (link.isMobileSpecials) {
      if (kEnableSliderLogs) {
        debugPrint('ℹ️ Specials tapped (no internal page wired).');
      }
      Get.snackbar(
          'معلومة', 'رابط العروض الخاصة غير مربوط بصفحة داخلية حالياً.');
      return;
    }

    if (kEnableSliderLogs) debugPrint('⚠️ Unknown link type: $link');
    Get.snackbar('تنبيه', 'نوع الرابط غير معروف.');
  }

  void _debugPrintLinks(List<ImageData> items) {
    if (!kEnableSliderLogs) return;
    for (final it in items) {
      final l = (it.link ?? '').replaceAll('&amp;', '&');
      if (l.isEmpty) continue;
      if (l.isCategoryLink) {
        debugPrint('🔎 [CATEGORY] path=${l.categoryPath}');
      } else if (l.isProductByIdLink) {
        debugPrint('🔎 [PRODUCT_ID] id=${l.productId}');
      } else if (l.isProductSlugLink) {
        debugPrint('🔎 [PRODUCT_SLUG] slug=${l.productSlug}');
      } else if (l.isMobileSpecials) {
        debugPrint('🔎 [SPECIALS]');
      } else {
        debugPrint('🔎 [UNKNOWN] $l');
      }
    }
  }
}
