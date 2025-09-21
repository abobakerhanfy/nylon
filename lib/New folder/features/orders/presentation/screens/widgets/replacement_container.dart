import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/orders/data/models/get_all_order.dart';
import 'package:nylon/features/orders/presentation/screens/widgets/my_order_container.dart';

import '../../../../../core/routes/name_pages.dart';

class ContainerReplacement extends StatelessWidget {
  const ContainerReplacement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.toNamed(NamePages.pViewDetailsOrderReturned);
      },
      child: Container(
            width: 384,
            height: 191,
           margin: const EdgeInsets.symmetric(horizontal: 16),
           padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderBlack28,width: 1),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            
              children: [
           Row(
           
            children: [
              Container(
                width: 69,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
               child: SvgPicture.asset('images/iconReturn.svg',fit: BoxFit.none,),
              ),
              const SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('فهد احمد',style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal
                  ,color: AppColors.colorTextNew,
                  ),),
                  const SizedBox(height: 6,),
                   Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 6),
            
             
              
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.colorRed 
                ),
                child:  Text('121'.tr,style:const  TextStyle(fontSize: 11,color: Colors.white),),
              )
          
                ],
              ),
             
           
            ],
           ),
           OrderiInformationColumnWidget(order: Order(),)
          
            ],),
          
          ),
    );
  }
}