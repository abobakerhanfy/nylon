import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/hindling_data_view.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/addresses/data/models/address_model.dart';
import 'package:nylon/features/cart/presentation/controller/controller_cart.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/button_on_cart.dart';
import 'package:nylon/features/cart/presentation/screens/widgets/row_invoice.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';
import 'package:nylon/features/orders/presentation/controller/controller_order.dart';
import 'package:nylon/features/orders/presentation/screens/widgets/container_address_details.dart';
import 'package:nylon/features/payment/presentation/controller/controller_payment.dart';
import 'package:nylon/features/payment/presentation/screens/widgets/container_payment_data.dart';
import 'package:nylon/features/shipping/presentation/controller/controller_shipping.dart';

class OrderConfirmationNew extends StatefulWidget {
  const OrderConfirmationNew({super.key});

  @override
  State<OrderConfirmationNew> createState() => _OrderConfirmationNewState();
}

class _OrderConfirmationNewState extends State<OrderConfirmationNew> {
  final ControllerCart _controller = Get.put(ControllerCart());
  final ControllerPayment _controllerPayment = Get.put(ControllerPayment());
  final ControllerShipping _controllerShipping = Get.put(ControllerShipping());
  final ControllerOrder _controllerOrder = Get.put(ControllerOrder());
  final ControllerLogin _controllerLogin = Get.put(ControllerLogin());

  @override
  void initState() {
    super.initState();

    _controllerPayment.getPayment();
    _controllerLogin.getCustomerBypId();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId =
          _controllerLogin.myServices.sharedPreferences.getString('UserId');
      final cartIsEmpty =
          (_controller.cartModel.value?.products?.isEmpty ?? true);
      print('✅ userId = $userId');
      print('✅ cartIsEmpty = $cartIsEmpty');

      if (userId == null || userId.isEmpty) {
        Get.snackbar('تنبيه', 'لا يوجد حساب مسجل، برجاء التحقق أولا');
        await Future.delayed(const Duration(seconds: 1));
        _controller.indexScreensCart = 0;
        _controller.update();
        Get.offAllNamed(NamePages.pCart);
      } else if (cartIsEmpty) {
        Get.snackbar('تنبيه', 'السلة فارغة، الرجاء اضافة منتجات');
        await Future.delayed(const Duration(seconds: 1));
        _controller.indexScreensCart = 0;
        _controller.update();
        Get.offAllNamed(NamePages.pCart);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final ControllerPayment paymentController = Get.find();
          final ControllerOrder orderController = Get.find();

          paymentController.selectPaymentModel = null;
          paymentController.isReturningFromPayment = false;
          orderController.orderIdSuccess = null;
          orderController.update();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: SizedBox(
          height: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InvoiceWithAnimation(
                  animate: true,
                  invoiceRows: List.generate(
                      _controller.cartModel.value?.totals?.length ?? 0,
                      (i) => invoiceRow(
                            title:
                                _controller.cartModel.value?.totals?[i].title ??
                                    '',
                            priceWidget: textWithRiyal(
                                _controller.cartModel.value?.totals?[i].text ??
                                    ''),
                          )),
                ),
              ),
              GetBuilder<ControllerOrder>(builder: (controllerOrder) {
                return controllerOrder.statusRequestSendOrder ==
                        StatusRequest.loading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    : ButtonOnCart(
                        width: MediaQuery.of(context).size.width * 0.80,
                        label: '36'.tr,
                        onTap: () async {
                          if (_controllerLogin.selectedAddressId != null &&
                              _controllerPayment.selectCodePayment != '') {
                            await controllerOrder.sendIdAddress(
                                idAddress: _controllerLogin.selectedAddressId!);

                            await _controllerPayment.selectPayment(
                                paymentCode:
                                    _controllerPayment.selectCodePayment);

                            if (_controllerPayment.selectCodePayment ==
                                'bank_transfer') {
                              if (_controllerPayment.file != null) {
                                await _controllerPayment.addIamgeBankTr();
                                if (controllerOrder.statusRequestSenIdAddress ==
                                        StatusRequest.success &&
                                    _controllerPayment
                                            .statusRequestSelectPayment ==
                                        StatusRequest.success) {
                                  await controllerOrder.sendOrder();
                                  await _controllerPayment
                                      .confirmBankTransfer();
                                } else {
                                  controllerOrder.statusRequestSendOrder =
                                      StatusRequest.failure;
                                  controllerOrder.update();
                                  newCustomDialog(
                                    body: SizedBox(
                                      height: 40,
                                      child: PrimaryButton(
                                        label: 'موافق',
                                        onTap: () => Get.back(),
                                      ),
                                    ),
                                    title:
                                        'فشل في ارسال البيانات الرجاء المحاولة مره اخري',
                                    dialogType: DialogType.info,
                                  );
                                }
                              } else {
                                newCustomDialog(
                                  body: SizedBox(
                                    height: 40,
                                    child: PrimaryButton(
                                      label: 'موافق',
                                      onTap: () => Get.back(),
                                    ),
                                  ),
                                  title:
                                      "الرجاء ارسال صوره التحويل \n حتي نتمكن من تنفيذ الطلب ",
                                  dialogType: DialogType.info,
                                );
                              }
                            } else if (_controllerPayment.selectCodePayment ==
                                'myfatoorah_pg') {
                              await _controllerPayment.paymentMyFatoorah();
                            } else if (_controllerPayment.selectCodePayment ==
                                "tamarapay") {
                              await _controllerPayment.paymentTamaraPay();
                            } else if (_controllerPayment.selectCodePayment ==
                                "tabby_cc_installments") {
                              _controllerPayment.paymentTabby();
                            } else {
                              if (controllerOrder.statusRequestSenIdAddress ==
                                      StatusRequest.success &&
                                  _controllerPayment
                                          .statusRequestSelectPayment ==
                                      StatusRequest.success) {
                                await controllerOrder.sendOrder();
                                if (controllerOrder.statusRequestSendOrder ==
                                    StatusRequest.success) {
                                  await _controllerLogin.resetSession();
                                  await Future.delayed(
                                      const Duration(seconds: 3));
                                  Get.offAllNamed(NamePages.pBottomBar);
                                }
                              } else {
                                controllerOrder.statusRequestSendOrder =
                                    StatusRequest.failure;
                                controllerOrder.update();
                                newCustomDialog(
                                  body: SizedBox(
                                    height: 40,
                                    child: PrimaryButton(
                                      label: 'موافق',
                                      onTap: () => Get.back(),
                                    ),
                                  ),
                                  title:
                                      'فشل في ارسال البيانات الرجاء المحاولة مره اخري',
                                  dialogType: DialogType.info,
                                );
                              }
                            }
                          } else {
                            newCustomDialog(
                              body: SizedBox(
                                height: 40,
                                child: PrimaryButton(
                                  label: 'موافق',
                                  onTap: () => Get.back(),
                                ),
                              ),
                              title:
                                  'الرجاء اختيار العنوان ووسيلة الدفع \n حتي نتمكن من تنفيذ طلبك',
                              dialogType: DialogType.warning,
                            );
                          }
                        },
                      );
              }),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: LayoutBuilder(
            builder: (context, boxSize) {
              return ListView(
                children: [
                  const AddressUserOnCart(),
                  const WidgetPaymentDataCart(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  FreeShipping(
                    hasReachedTarget: _controller.hasReachedTarget,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class AddressUserOnCart extends StatefulWidget {
  const AddressUserOnCart({super.key});

  @override
  State<AddressUserOnCart> createState() => _AddressUserOnCartState();
}

class _AddressUserOnCartState extends State<AddressUserOnCart> {
  String? _loadingAddressId; // فوق الكلاس

  final bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerLogin>(builder: (contrrolerLogin) {
      return HandlingDataView(
        statusRequest: contrrolerLogin.statusRequestgetUserBP!,
        widget: GetBuilder<ControllerLogin>(builder: (contrrolerLogin) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '175'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.black),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Get.toNamed(NamePages.pAddAddress),
                    child: Text('85'.tr,
                        style: Theme.of(context).textTheme.bodySmall),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              contrrolerLogin.addressModel?.data!.address != null &&
                      contrrolerLogin.addressModel!.data!.address!.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(6),
                      color: Colors.white,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contrrolerLogin
                                .addressModel!.data!.address?.length ??
                            0,
                        separatorBuilder: (context, i) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          Address address =
                              contrrolerLogin.addressModel!.data!.address![i];
                          return Container(
                            color: AppColors.background,
                            child: Row(
                              children: [
                                Expanded(
                                  child: AddressDetails(
                                    address:
                                        '${address.address1}\n ${address.address2}',
                                    phone: '',
                                    city: address.city ?? '',
                                  ),
                                ),
                                Checkbox(
                                    value: contrrolerLogin.selectedAddressId ==
                                        address.addressId,
                                    activeColor: AppColors.primaryColor,
                                    onChanged: (value) async {
                                      if (value == true &&
                                          contrrolerLogin.selectedAddressId !=
                                              address.addressId &&
                                          _loadingAddressId !=
                                              address.addressId) {
                                        // أظهر اللودينج
                                        setState(() {
                                          _loadingAddressId = address.addressId;
                                        });

                                        // حدّد العنوان المختار محليًا
                                        contrrolerLogin.onSelectIdAddress(
                                            address.addressId!, true);

                                        // عرض Snackbar Shipping
                                        if (!Get.isSnackbarOpen) {
                                          Get.snackbar(
                                            '212'.tr, // "جاري التحديث"
                                            '213'.tr, // "يتم تحديث الفاتورة..."
                                            snackPosition: SnackPosition.TOP,
                                            duration:
                                                const Duration(seconds: 1),
                                          );
                                        }

                                        // حدّث العنوان في السيرفر
                                        await Get.find<ControllerOrder>()
                                            .sendIdAddress(
                                                idAddress: address.addressId!);

                                        // حدّث بيانات السلة
                                        await Get.find<ControllerCart>()
                                            .getCart();

                                        // أعد رسم الواجهة بعد تحديث السلة
                                        setState(() {
                                          _loadingAddressId = null;
                                        });

                                        // أعد بناء باقي GetBuilder أو GetX
                                        contrrolerLogin.update();
                                        Get.find<ControllerCart>().update();
                                        setState(
                                            () {}); // 👈 للتأكد من إعادة بناء الفاتورة في الـ StatefulWidget
                                      }
                                    }),
                                if (_loadingAddressId == address.addressId)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ))
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                          child: Text('لم تقم باضافه عنوان حتي الان ..!')),
                    ),
            ],
          );
        }),
        onRefresh: () => contrrolerLogin.getCustomerBypId(),
      );
    });
  }
}

class WidgetPaymentDataCart extends StatelessWidget {
  const WidgetPaymentDataCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerPayment>(builder: (controllerPayment) {
      return HandlingDataView(
        statusRequest: controllerPayment.statusRequestGetPayment!,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              '169'.tr,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.black),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            // 🔥 هنا استبدلنا الـ ListView بـ paymentsWidget
            paymentsWidget(context, controllerPayment),
          ],
        ),
        onRefresh: () {
          controllerPayment.getPayment();
        },
      );
    });
  }

  // 👇 إنشاء ميثود جديدة لعرض الدفع
  Widget paymentsWidget(
      BuildContext context, ControllerPayment controllerPayment) {
    final payments = controllerPayment.paymentsDataList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (payments.length == 1) ...[
          Image.network(
            'https://em-content.zobj.net/thumbs/120/apple/354/grinning-face_1f600.png',
            height: 50,
          ),
          const SizedBox(height: 8),
          Text(
            payments.first.separatedText ?? "إتمام الطلب مجانًا",
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
          const SizedBox(height: 16),
          const Text(
            'تم اختيار وسيلة الدفع',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ContainerPaymentData(
            codePayment: controllerPayment.selectCodePayment,
            paymentsData: payments[0],
          ),
        ] else if (payments.length > 1) ...[
          ...payments.map((payment) => Column(
                children: [
                  ContainerPaymentData(
                    codePayment: payment.code,
                    paymentsData: payment,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              )),
        ],
      ],
    );
  }
}

class FreeShipping extends StatelessWidget {
  final bool hasReachedTarget;
  const FreeShipping({
    super.key,
    required this.hasReachedTarget,
  });

  @override
  Widget build(BuildContext context) {
    return hasReachedTarget == true
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '170'.tr,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.black),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColors.colorCreditCard,
                    borderRadius: BorderRadius.circular(0),
                    border:
                        Border.all(color: AppColors.primaryColor, width: 2)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          'شحن مجاني',
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
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}

class InvoiceWithAnimation extends StatefulWidget {
  final List<Widget> invoiceRows;
  final bool animate;

  const InvoiceWithAnimation({
    super.key,
    required this.invoiceRows,
    required this.animate,
  });

  @override
  State<InvoiceWithAnimation> createState() => _InvoiceWithAnimationState();
}

class _InvoiceWithAnimationState extends State<InvoiceWithAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant InvoiceWithAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Column(children: widget.invoiceRows),
    );
  }
}
