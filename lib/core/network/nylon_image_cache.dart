import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/foundation.dart';

class NylonHttpFileService extends HttpFileService {
  const NylonHttpFileService();

  @override
  Future<HttpGetResponse> get(String url, {Map<String, String>? headers}) {
    // نحدد Accept لامتدادات مدعومة (ابعِد عن AVIF/HEIC)
    final merged = {
      'Accept': 'image/webp,image/jpeg,image/png;q=0.9,*/*;q=0.1',
      'User-Agent': 'NylonApp/1.0 (Flutter)',
      ...?headers,
    };
    if (kDebugMode) {
      // Debug: اطبع الرابط اللي بيتجاب
      // print('🖼️ HTTP GET $url');
    }
    return super.get(url, headers: merged);
  }
}

class NylonCacheManager extends CacheManager {
  static const key = 'nylonImageCache';
  static NylonCacheManager? _instance;
  factory NylonCacheManager() => _instance ??= NylonCacheManager._();

  NylonCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 7),
            maxNrOfCacheObjects: 200,
            fileService: const NylonHttpFileService(),
          ),
        );
}
