import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';

class ContaineronOrderInvoice extends StatelessWidget {
  const ContaineronOrderInvoice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Get.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '108'.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorTextBlckNew),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '109'.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.backgroundProduct,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.credit_card_outlined,
                    color: Colors.grey[500],
                    size: 28,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    children: [
                      Text(
                        'بطاقة الائتمان/الخصم',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: AppColors.colorTextBlckNew),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        'VISA ending in 6633',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '556.00',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorTextBlckNew,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset(
                    "images/riyalsymbol_compressed.png", // تأكد إن الصورة موجودة ضمن assets
                    height: 14,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),
          // invoiceRow(title: '110'.tr,price:10 ),
          // const SizedBox(height: 10,),
          // invoiceRow(title: '74'.tr,price:13 ),
          // const SizedBox(height: 10,),
          // invoiceRow(title: '111'.tr,price:15 ),
          //         const Padding(
          //           padding: EdgeInsets.symmetric(vertical: 8),
          //           child: Divider(height: 1,thickness: 1,color: Colors.black12,),
          //         ),
          //        Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text('112'.tr,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          //    color: AppColors.colorTextBlckNew,fontSize: 14,fontWeight: FontWeight.normal
          //  ),),
          //      Text('676 ${'11'.tr}',style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          //    color: AppColors.primaryColor, fontSize: 14,fontWeight: FontWeight.w600
          //  ),),
          //         ],
          //        )
        ],
      ),
    );
  }
}
