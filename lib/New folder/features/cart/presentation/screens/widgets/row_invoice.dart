import 'package:flutter/material.dart';

/// ويدجت لصف سطر فاتورة بعنوان وسعر
Widget invoiceRow({required String title, required Widget priceWidget}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: priceWidget,
          ),
        ),
      ],
    ),
  );
}

/// ويدجت مساعدة لعرض نص السعر بجانب رمز الريال (صورة)
Widget textWithRiyal(String value, {TextStyle? style, double iconHeight = 14}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(value, style: style),
      const SizedBox(width: 4),
      Image.asset("images/riyalsymbol_compressed.png", height: iconHeight),
    ],
  );
}
