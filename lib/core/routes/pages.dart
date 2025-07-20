import 'package:get/get.dart';
import 'package:nylon/core/routes/biding/biding.dart';
import 'package:nylon/features/addresses/presentation/screens/updata_address.dart';
import 'package:nylon/features/balance/presentation/screens/send_order_balance.dart';
import 'package:nylon/features/cart/presentation/screens/cart_screens/verification_user.dart';
import 'package:nylon/features/login/presentation/screens/register.screen.dart';
import 'package:nylon/features/profile/presentation/screens/profile_screen.dart';
import 'package:nylon/features/shipping/presentation/screens/add_address_shipping.dart';
import 'package:nylon/features/addresses/presentation/screens/add_address.dart';
import 'package:nylon/features/addresses/presentation/screens/my_addresses.dart';
import 'package:nylon/features/balance/presentation/screens/view_balance.dart';
import 'package:nylon/features/coupon/presentation/screens/my_coupons.dart';
import 'package:nylon/features/home/presentation/screens/bottom_bar.dart';
import 'package:nylon/features/one_product/presentation/screens/view_one_product.dart';
import 'package:nylon/features/orders/presentation/screens/my_orders.dart';
import 'package:nylon/features/orders/presentation/screens/order_details.dart';
import 'package:nylon/features/orders/presentation/screens/returned%20_order_details.dart';
import 'package:nylon/features/orders/presentation/screens/returns_orders.dart';
import 'package:nylon/features/orders/presentation/screens/send_complaints.dart';
import 'package:nylon/features/shipping/presentation/screens/send_number_order.dart';
import 'package:nylon/features/shipping/presentation/screens/track_the_shipment.dart';
import 'package:nylon/features/cart/presentation/screens/cart_screens/order_successfully.dart';

import '../../view/bordring/first_page.dart';
import '../../view/bordring/on_bordering.dart';
import '../../features/cart/presentation/screens/cart_screens/basic_screen_cart.dart';
import '../../features/category/presentation/screens/screen_one_Category.dart';
import '../../features/login/presentation/screens/sign_in.dart';
import '../../features/login/presentation/screens/verification_code.dart';
import '../../view/profile/language.dart';
import 'name_pages.dart';

List<GetPage> routes = [
  GetPage(
      name: NamePages.pFirst,
      page: () => const FirstPage(),
      binding: ControllerLoginBiding()),
  GetPage(name: NamePages.pOnBordering, page: () => const Bordering()),
  GetPage(
      name: NamePages.pSignIn,
      page: () => SignIn(),
      transition: Transition.circularReveal),
  GetPage(name: NamePages.pVerifyCode, page: () => VerificationCode()),
  GetPage(
      name: NamePages.pBottomBar,
      page: () => const BottomBar(),
      binding: HomeBiding(),
      transition: Transition.circularReveal),
  GetPage(name: NamePages.pOneProduct, page: () => ViewOneProduct()),
  GetPage(
      name: NamePages.pOneCategory,
      page: () => ViewOneCategory(),
      binding: ControllerOneCategoryBiding()),
  GetPage(name: NamePages.pCart, page: () => const ScreenCart()),
  GetPage(name: NamePages.pLanguage, page: () => Language()),
  GetPage(name: NamePages.pMyOrders, page: () => MyOrders()),
  GetPage(
      name: NamePages.pReplacementAndReturn,
      page: () => const ReplacementAndReturn()),
  GetPage(name: NamePages.pMyAddresses, page: () => MyAddresses()),
  GetPage(name: NamePages.pAddAddress, page: () => AddAddress()),
  GetPage(name: NamePages.pOrderDetails, page: () => OrderDetails()),
  GetPage(
    name: NamePages.pOrderConfirmation,
    page: () => const OrderSuccessfully(),
  ),
  GetPage(
      name: NamePages.pViewDetailsOrderReturned,
      page: () => ViewDetailsOrderReturned()),
  GetPage(name: NamePages.pSendComplaints, page: () => SendComplaints()),
  GetPage(
      name: NamePages.pSendNumerOrder, page: () => SendNumerOrderForTracking()),
  GetPage(
      name: NamePages.pTrackDetails,
      page: () => const TrackTheShipmentDetails()),
  GetPage(
      name: NamePages.pMyCoupons,
      page: () => MyCoupons(),
      binding: ControllerCouponBiding()),
  GetPage(
      name: NamePages.pViewBalance,
      page: () => ViewBalance(),
      binding: ControllerBalanceBiding()),
  GetPage(
      name: NamePages.pAddAddressShipping, page: () => AddAddressShipping()),
  GetPage(
      name: NamePages.pVerificationUserCart,
      page: () => VerificationUserCart()),
  GetPage(name: NamePages.pRegister, page: () => RegisterScreen()),
  GetPage(name: NamePages.pUpdataAddress, page: () => UpdataAddress()),
  GetPage(name: NamePages.pMyprofile, page: () => Myprofile()),
  GetPage(name: NamePages.pSendOrderBalance, page: () => SendOrderBalance())
];
