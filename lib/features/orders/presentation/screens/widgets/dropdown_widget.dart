// ignore_for_file: must_be_immutable

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownContainer extends StatefulWidget {
  final List<String> items; // العناصر التي سيتم تمريرها لكل مرة
  final String hintText; // النص التلميحي (الـ hint)
 String? selectedValue;
 double? width;
 void Function(String?)? onChanged;

  CustomDropdownContainer({
    super.key, 
    required this.items,
    required this.hintText,
    this.selectedValue,
    this.width,
    this.onChanged,
  });

  @override
  _CustomDropdownContainerState createState() => _CustomDropdownContainerState();
}

class _CustomDropdownContainerState extends State<CustomDropdownContainer> {
 
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width:widget.width?? MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: DropdownSearch<String>(
           items: (filter, infiniteScrollProps) => widget.items,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '163'.tr;
            }
            return null;
          },
          autoValidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
             widget.onChanged?.call(value); //
          },
          selectedItem: widget.selectedValue,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              hintText: widget.hintText,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
             border: InputBorder.none,
            ),
          ),
          
          popupProps: PopupProps.menu(
            fit: FlexFit.loose,
            itemBuilder: (context, item, a,b) {
              return ListTile(
                title: Text(
                  item,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
