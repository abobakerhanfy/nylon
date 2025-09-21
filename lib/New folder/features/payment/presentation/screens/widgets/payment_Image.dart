import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentImageWidget extends StatelessWidget {
  final String? imageUrl;

  const PaymentImageWidget({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (isSvg(imageUrl)) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: SvgPicture.network(
          imageUrl!,
          placeholderBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Image.network(
          imageUrl!,
          fit: BoxFit.contain,
        ),
      );
    }
  }

  // دالة للتحقق مما إذا كان الرابط بصيغة SVG
  bool isSvg(String? url) {
    return url != null && url.trim().toLowerCase().endsWith('.svg');
  }
}
