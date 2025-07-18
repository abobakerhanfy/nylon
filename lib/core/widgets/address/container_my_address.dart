import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/features/addresses/data/models/address_model.dart';
import 'package:nylon/features/addresses/presentation/controller/adreess_controller.dart';

class ContainerMyAddresses extends StatelessWidget {
  final Address address;
  const ContainerMyAddresses({
    super.key,
    required this.address,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.background,
            spreadRadius: 7,
            blurRadius: 2,
          ),
        ],
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 33,
            width: 33,
            child: SvgPicture.asset('images/IconAddress.svg'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (address.company != null && address.company!.isNotEmpty)
                  Text(
                    address.company!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                const SizedBox(height: 8),
                if (address.city != null && address.city!.isNotEmpty)
                  Text(
                    address.city!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                const SizedBox(height: 8),
                if (address.address1 != null && address.address1!.isNotEmpty)
                  Text(
                    address.address1!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textBlack,
                        ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                if (address.address2 != null && address.address2!.isNotEmpty)
                  Text(
                    address.address2!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textBlack,
                        ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          PopupMenuButton<String>(
            color: Colors.grey[100],
            shadowColor: AppColors.primaryColor,
            onSelected: (value) {
              if (value == 'edit') {
                print('Edit option selected');
                ControllerAddress controller = Get.find();
                Get.toNamed(NamePages.pUpdataAddress, arguments: address);
                controller.argumentsUpdateAddress();
              } else if (value == 'delete') {
                customDialogAcation(
                    title: 'هل تريد حذف هذا العنوان',
                    dialogType: DialogType.info,
                    onTap: () {
                      ControllerAddress controller = Get.find();
                      controller.deleteAddress(idAddress: address.addressId!);
                      Get.back();
                    });
                // تنفيذ الحذف هنا (على سبيل المثال، إظهار حوار تأكيد)
                print('Delete option selected');
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'edit',
                child: Text(
                  'تعديل',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'حذف',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.backGFieldPh,
              ),
              child: const Icon(
                Icons.linear_scale,
                size: 18,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
