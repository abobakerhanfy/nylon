import 'package:flutter/material.dart';

class BottomOnOrder extends StatelessWidget {
  final String title;
  final Function() onTap;
  final Color colorBorder;
  final Color textColor;
  const BottomOnOrder({
    super.key, required this.title, required this.onTap, required this.colorBorder, required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        
        width: MediaQuery.of(context).size.width/2.5,
        alignment: Alignment.center,
        height: 48,
                 padding: const EdgeInsets.symmetric(horizontal: 12,vertical:0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color:colorBorder,width: 1)
        ),
        child: Text(title,style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: textColor,fontSize: 13,fontWeight: FontWeight.w400
        ),),
                 
      
      ),
    );
  }
}