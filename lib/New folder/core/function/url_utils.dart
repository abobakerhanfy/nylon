// lib/core/function/url_utils.dart
String? extractPathParam(String? url) {
  if (url == null || url.isEmpty) return null;

  final normalized = url.replaceAll('&amp;', '&');

  Uri? uri;
  try {
    uri = Uri.parse(normalized);
  } catch (_) {
    return null;
  }

  final qp = uri.queryParameters;
  if (qp.containsKey('path')) {
    final v = qp['path']?.trim();
    if (v != null && v.isNotEmpty) return v;
  }

  final reg = RegExp(r'([?&])path=([^&#]+)');
  final m = reg.firstMatch(normalized);
  if (m != null && m.groupCount >= 2) {
    final v = Uri.decodeComponent(m.group(2)!);
    if (v.isNotEmpty) return v;
  }

  return null; // مفيش path في الرابط
}

// lib/core/function/url_utils.dart
String normalizeUrl(String? raw) {
  var s = (raw ?? '').trim();
  if (s.isEmpty) return '';

  // HTML entities زي &amp;
  s = s.replaceAll('&amp;', '&');

  // لو الرابط متشفر مرتين (زي %2520)، فكّ تشفيره مرة/اتنين لحد ما يثبت
  for (var i = 0; i < 2; i++) {
    try {
      final decoded = Uri.decodeFull(s);
      if (decoded == s) break;
      s = decoded;
    } catch (_) {
      break;
    }
  }

  // أعد ترميزه ترميز كامل مع الحفاظ على : / ? & = %
  return Uri.encodeFull(s);
}
