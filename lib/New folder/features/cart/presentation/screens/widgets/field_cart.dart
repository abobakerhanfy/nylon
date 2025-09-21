// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomFiledCart extends StatelessWidget {
  final double width;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  IconData? icon;

  CustomFiledCart(
      {super.key,
      required this.width,
      required this.hint,
      required this.controller,
      this.validator,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        validator: validator,
        controller: controller,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 16,
              color: Colors.black,
            ),
        textAlign: TextAlign.start,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
          suffixIcon: Icon(
            icon,
            size: 18,
            color: Colors.black54,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 206, 47, 47), width: 1),
          ),
        ),
        cursorHeight: 25,
        cursorColor: Colors.blue,
      ),
    );
  }
}
