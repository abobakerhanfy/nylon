import 'package:flutter/material.dart';

class TextWithRiyalIcon extends StatelessWidget {
  final String textBefore;
  final double amount;
  final String textAfter;
  final TextStyle? style;
  final double imageHeight;

  const TextWithRiyalIcon({
    super.key,
    required this.textBefore,
    required this.amount,
    this.textAfter = '',
    this.style,
    this.imageHeight = 14,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: style ?? DefaultTextStyle.of(context).style,
        children: [
          TextSpan(text: textBefore),
          TextSpan(
            text: amount.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Image.asset(
                "images/riyalsymbol_compressed.png",
                height: imageHeight,
              ),
            ),
          ),
          TextSpan(text: textAfter),
        ],
      ),
    );
  }
}
