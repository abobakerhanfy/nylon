import 'package:flutter/material.dart';

class PaymentPlaceholderIcon extends StatelessWidget {
  final String code;
  final double size;

  const PaymentPlaceholderIcon({
    super.key,
    required this.code,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = _getIconForCode(code);

    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      radius: size / 2,
      child: Icon(iconData, size: size * 0.6, color: Colors.grey[700]),
    );
  }

  IconData _getIconForCode(String code) {
    switch (code) {
      case 'bank_transfer':
        return Icons.account_balance;
      case 'cod':
        return Icons.local_shipping;
      case 'xpayment1':
        return Icons.store;
      case 'myfatoorah_pg':
        return Icons.payment;
      case 'tamarapay':
        return Icons.credit_card;
      case 'tabby_cc_installments':
      case 'tabby_installments':
        return Icons.access_time;
      default:
        return Icons.account_balance_wallet;
    }
  }
}
