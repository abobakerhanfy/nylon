import 'package:flutter/material.dart';
import 'package:nylon/features/payment/data/models/zone_id_city.dart';

class CustomFiledCartZone extends StatefulWidget {
  final double width;
  final String hint;
  final TextEditingController controller;
  final List<Zone> zones; // القائمة التي تحتوي على المناطق
  final String? Function(String?)? validator;

  const CustomFiledCartZone({
    super.key,
    required this.width,
    required this.hint,
    required this.controller,
    required this.zones,
    this.validator,
  });

  @override
  _CustomFiledCartZoneState createState() => _CustomFiledCartZoneState();
}

class _CustomFiledCartZoneState extends State<CustomFiledCartZone> {
  Zone? selectedZone; // المنطقة التي سيتم اختيارها

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 16,
              color: Colors.black,
            ),
        textAlign: TextAlign.start,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          hintText: widget.hint,
          hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.normal,
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
          suffixIcon: PopupMenuButton<Zone>(
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: (Zone value) {
              setState(() {
                selectedZone = value;
                widget.controller.text =
                    value.nameAr; // عرض اسم المنطقة في الـ TextField
              });
            },
            itemBuilder: (BuildContext context) {
              return widget.zones.map((Zone zone) {
                return PopupMenuItem<Zone>(
                  value: zone,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 300, // تحديد العرض الأقصى
                      minHeight: 50, // تحديد الارتفاع الأدنى
                    ),
                    child: Text(
                      zone.nameAr,
                      style: Theme.of(context).textTheme.bodySmall,
                    ), // عرض اسم المنطقة باللغة العربية
                  ),
                );
              }).toList();
            },
          ),
        ),
        cursorHeight: 25,
        cursorColor: Colors.blue,
      ),
    );
  }
}
