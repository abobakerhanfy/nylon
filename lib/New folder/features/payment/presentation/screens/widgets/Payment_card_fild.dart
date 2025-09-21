import 'package:flutter/material.dart';
import 'package:nylon/features/payment/data/models/payment_model.dart';
import 'package:nylon/features/payment/presentation/screens/widgets/payment_placeholder_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentCardField extends StatelessWidget {
  final PaymentsData? paymentsData;

  const PaymentCardField({super.key, this.paymentsData});

  Widget buildSmartImage(String imagePath, String code) {
    final fileName = imagePath.split('/').last.split('?').first;
    final localPath = 'images/$fileName';
    final isSvg = fileName.toLowerCase().endsWith('.svg');

    if (imagePath.startsWith('http')) {
      if (isSvg) {
        return SvgPicture.network(
          imagePath,
          height: 40,
          placeholderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
        );
      } else {
        return Image.network(
          imagePath,
          height: 40,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => PaymentPlaceholderIcon(code: code),
        );
      }
    }

    if (isSvg) {
      return SvgPicture.asset(
        localPath,
        height: 40,
        placeholderBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
      );
    } else {
      return Image.asset(
        localPath,
        height: 40,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => PaymentPlaceholderIcon(code: code),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (paymentsData == null || paymentsData!.separatedImages == null) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          children: paymentsData!.separatedImages!.map((img) {
            return buildSmartImage(img, paymentsData!.code ?? '');
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          paymentsData!.separatedText ?? '',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
