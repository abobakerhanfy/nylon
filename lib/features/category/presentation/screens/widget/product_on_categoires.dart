// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nylon/core/languages/function_string.dart';
// import 'package:nylon/core/services/services.dart';
// import 'package:nylon/core/theme/colors_app.dart';
// import 'package:nylon/features/cart/presentation/screens/widgets/icon_add_cart.dart';
// import 'package:nylon/features/favorites/presentation/screens/widgets/icon_add_favorite.dart';

// class ContainerProductOnCategoires extends StatelessWidget {
//    ContainerProductOnCategoires({
//     super.key,
//   });
// final MyServices _myServices = Get.find();
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//           alignment:_myServices.sharedPreferences.getString('Lang')=='ar'? Alignment.topLeft:Alignment.topRight,

//       children: [
//         Container(
//           decoration: BoxDecoration(
//               color: Theme.of(context).scaffoldBackgroundColor
,
//               borderRadius: BorderRadius.circular(15)
//           ),
//           child: LayoutBuilder(
//             builder: (context,boxSize) {
//               return 
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: Container(
//                           // height: boxSize.maxHeight*0.65,
//                           decoration:const  BoxDecoration(
//                             borderRadius: BorderRadius.only(topLeft:Radius.circular(8) ,topRight: Radius.circular(8)),
//                             image: DecorationImage(
//                                 fit: BoxFit.contain,
//                                 image: AssetImage('images/test5.png',)),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: Container(
//                           padding: const EdgeInsets.all(3),
//                           // height: boxSize.maxHeight*0.35,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(translate('اطباق قصدير', 'Tin dishes')!,style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                 color: AppColors.greyColor,fontSize: 10
//                               ),maxLines: 2,overflow: TextOverflow.ellipsis,),
                             
//                               //    Text(translate('مناديل جيب فاين (10حبة)', 'Tin dishes')!,style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                               //   color: AppColors.textColor1,fontSize: 10
//                               // ),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        
//                             // StarRatingWidget(rating: 4,),
                              
//                               Text('20.00 ${'11'.tr}',style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                 color: AppColors.primaryColor,fontSize: 10,
//                               ),),
                              
                         
                                    
//                             ],
//                           ),
//                         ),
//                       )
                                  
//                     ],
//                   )
                
//               ;
//             }
//           ),
//         ),
//           const Padding(
//                 padding: EdgeInsets.symmetric(horizontal:6,vertical: 2),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                      FavoriteIcon(),
//                       CartIcon(idProduct: '1',),
//                   ],
//                 ),
//               )
//       ],
//     );
//   }
// }