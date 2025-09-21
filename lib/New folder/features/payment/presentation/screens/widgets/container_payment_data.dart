import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/features/coupon/presentation/screens/widgets/container_copy_past_text.dart';
import 'package:nylon/features/payment/data/models/payment_model.dart';
import 'package:nylon/features/payment/presentation/controller/controller_payment.dart';
import 'package:nylon/features/payment/presentation/screens/widgets/payment_placeholder_icon.dart';

// ignore: must_be_immutable
class ContainerPaymentData extends StatelessWidget {
  final PaymentsData paymentsData;
  final String? codePayment;

  const ContainerPaymentData({
    super.key,
    required this.paymentsData,
    this.codePayment,
  });
  bool isSvg(String? url) {
    return url != null && url.trim().toLowerCase().endsWith('.svg');
  }

  Widget buildSmartImage(String imagePath, String code) {
    final fileName = imagePath.split('/').last.split('?').first;
    final localPath = 'images/$fileName';
    final isSvg = fileName.toLowerCase().endsWith('.svg');

    if (imagePath.startsWith('http')) {
      if (isSvg) {
        return SvgPicture.network(
          imagePath,
          height: 50,
          placeholderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        );
      } else {
        return Image.network(
          imagePath,
          height: 50,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => PaymentPlaceholderIcon(code: code),
        );
      }
    }

    if (isSvg) {
      return SvgPicture.asset(
        localPath,
        height: 50,
        placeholderBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
      );
    } else {
      return Image.asset(
        localPath,
        height: 50,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => PaymentPlaceholderIcon(code: code),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerPayment>(
      builder: (controller) {
        // print(
        //     "code: ${paymentsData.code}, text: ${paymentsData.separatedText}");
        // print("ContainerPaymentData Widget Built ✅");

        return InkWell(
          onTap: () async {
            if (controller.selectCodePayment != paymentsData.code) {
              await controller.selectCode(
                code: paymentsData.code!,
                title: paymentsData.separatedText!,
              );

              if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
              // Get.snackbar(
              //   '212'.tr, // "جاري التحديث"
              //   '213'.tr, // "يتم تحديث الفاتورة..."
              //   snackPosition: SnackPosition.TOP,
              //   duration: const Duration(seconds: 1),
              // );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.colorCreditCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: controller.selectCodePayment == paymentsData.code
                    ? AppColors.primaryColor
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (paymentsData.separatedImages != null &&
                          paymentsData.separatedImages!.length > 1) ...[
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (context, i) =>
                                        const SizedBox(width: 7),
                                    itemCount:
                                        paymentsData.separatedImages!.length,
                                    itemBuilder: (context, i) {
                                      return buildSmartImage(
                                        paymentsData.separatedImages![i],
                                        paymentsData.code!,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  paymentsData.separatedText ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 12,
                                        color: const Color.fromARGB(
                                            255, 31, 27, 27),
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                if (controller.selectCodePayment ==
                                    paymentsData.code)
                                  Icon(Icons.check_circle,
                                      color: AppColors.primaryColor),
                              ],
                            ),
                          ),
                        ),
                      ] else if (paymentsData.separatedImages != null &&
                          paymentsData.separatedImages!.length == 1) ...[
                        buildSmartImage(
                          paymentsData.separatedImages!.first,
                          paymentsData.code!,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            paymentsData.separatedText ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontSize: 12,
                                  color: const Color.fromARGB(255, 31, 27, 27),
                                ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        if (controller.selectCodePayment == paymentsData.code)
                          Icon(Icons.check_circle,
                              color: AppColors.primaryColor),
                      ] else ...[
                        Expanded(
                          child: Text(
                            paymentsData.separatedText ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontSize: 12,
                                  color: const Color.fromARGB(255, 31, 27, 27),
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        if (controller.selectCodePayment == paymentsData.code)
                          Icon(Icons.check_circle,
                              color: AppColors.primaryColor),
                      ]
                    ],
                  ),
                  if (controller.selectCodePayment == "bank_transfer" &&
                      paymentsData.code == "bank_transfer") ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '178'.tr,
                            style: Theme.of(Get.context!)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ContainerTextCpoyPast(
                            sizeIcon: 24,
                            title: '179'.tr,
                            text: paymentsData.accountNumber != null
                                ? '${paymentsData.accountNumber}'
                                : '',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ContainerTextCpoyPast(
                            sizeIcon: 24,
                            title: 'IBAN',
                            text: paymentsData.iBAN != null
                                ? '${paymentsData.iBAN}'
                                : '',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GetBuilder<ControllerPayment>(
                            builder: (controllerPayment) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text('177'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Container(
                                        height: 95,
                                        width: 75,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: controllerPayment.file != null
                                            ? Image.file(
                                                controllerPayment.file!,
                                                fit: BoxFit.fill,
                                              )
                                            : Center(
                                                child: InkWell(
                                                    onTap: () async {
                                                      await controllerPayment
                                                          .addImagesPicker();
                                                    },
                                                    child: Icon(
                                                        Icons.upload_file,
                                                        size: 26,
                                                        color:
                                                            Colors.grey[800]))),
                                      ),
                                      if (controllerPayment.file != null)
                                        InkWell(
                                            onTap: () async {
                                              if (controllerPayment.file !=
                                                  null) {
                                                try {
                                                  if (await controllerPayment
                                                      .file!
                                                      .exists()) {
                                                    await controllerPayment
                                                        .file!
                                                        .delete();
                                                  }
                                                  controllerPayment.file = null;
                                                  controllerPayment.update();
                                                } catch (e) {
                                                  print(
                                                      'Error deleting file: $e');
                                                }
                                              }
                                            },
                                            child: const Icon(
                                              Icons.clear,
                                              size: 16,
                                              color: Colors.black,
                                            )),
                                    ],
                                  )
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                  if (controller.selectCodePayment == 'xpayment1' &&
                      paymentsData.code == 'xpayment1') ...{
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'عنوان المتجر : '.tr,
                            style: Theme.of(Get.context!)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            " الرياض - حي الزهره - شارع بديع الزمان",
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                  },
                  if (controller.selectCodePayment == "myfatoorah_pg" &&
                      paymentsData.code == "myfatoorah_pg") ...{
                    // PaymentCardField()
                  }
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
