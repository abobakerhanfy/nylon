import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';
import 'package:nylon/features/orders/presentation/screens/widgets/my_order_container.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  final ControllerOrder _controllerOrder = Get.put(ControllerOrder());
  @override
  void initState() {
    _controllerOrder.getAllOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fullAppBackgroundColor,
      appBar: customAppBarTow(title: '98'.tr),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: GetBuilder<ControllerOrder>(builder: (controller) {
          return controller.statusRequestAllOrders == StatusRequest.empty
              ? const Center(
                  child: Text("لاتوجد طلبات "),
                )
              : HandlingDataView(
                  statusRequest: controller.statusRequestAllOrders!,
                  widget: GetBuilder<ControllerOrder>(builder: (controller) {
                    return ListView.separated(
                        separatorBuilder: (context, i) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                        itemCount: controller.allOrder!.data?.length ?? 0,
                        itemBuilder: (context, i) {
                          return ContainerMyOrder(
                            order: controller.allOrder!.data![i],
                          );
                        });
                  }),
                  onRefresh: () {
                    controller.getAllOrders();
                  },
                );
        }),
      ),
    );
  }
}
