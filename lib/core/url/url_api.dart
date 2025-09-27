// class AppApi {
//   static const String baseUrl2 =
//       'https://khaled.nylonsa.com/index.php?route=api';
//   static const String baseUrl =
//       'https://www.nylonsa.com/khaled/index.php?route=api';
//   static const String urlFullHome =
//       'https://khaled.nylonsa.com/index.php?route=api/Home/full_screen';
//   static const String urlFullCategory =
//       'https://khaled.nylonsa.com/khaled/index.php?route=api/Category/full_screen';
//   static const String createToken =
//       'https://khaled.nylonsa.com/index.php?route=api/login';
//   static const String getCartUrl = '$baseUrl2/cart/products&api_token=';
//   static const String addCartUrl = '$baseUrl/cart/add&api_token=';
//   static const String removeCartUrl = '$baseUrl2/cart/remove&api_token=';
//   static const String editCartUrl = '$baseUrl2/cart/edit&api_token=';
//   static const String addAddressPaymentUrl =
//       '$baseUrl2/payment/address&api_token=';
//   static const String getPaymentUrl = '$baseUrl2/payment/methods&api_token=';
//   static const String selectPaymentUrl = '$baseUrl2/payment/method&api_token=';

//   static const String getShippingMethodsUrl =
//       '$baseUrl2/shipping/methods&api_token=';
//   static const String addAddressShippingUrl =
//       '$baseUrl2/shipping/address&api_token=';
//   static const String selectShipping =
//       'https://khaled.nylonsa.com/index.php?route=api/shipping/method&api_token=';
// // static const String addCustomerUrl = '$baseUrl2/customer&api_token=';
//   static const String createNewCustomerUrl =
//       '$baseUrl2/customer/createNewCustomer&api_token=';
//   static const String addOrderUrl = '$baseUrl2/order/add&api_token=';
//   static const String getZoneUrl = '$baseUrl2/zone';
//   static const String sendCodeBySms =
//       '$baseUrl2/login/tempPasswordGenerator&api_token=';
// //'$baseUrl2/login/activeCodeBySms&api_token=';
//   static const String sendCodefromUser = '$baseUrl2/login/validate&api_token=';
// // 'https://khaled.nylonsa.com/index.php?route=api/login/validateLogin';
//   static const String getLogo =
//       'https://khaled.nylonsa.com/index.php?route=api/setting/logo';
//   static const String urlgetCustomerByphone =
//       '$baseUrl2/customer/getCustomerByphone';
//   static const String urlgetCustomerById =
//       '$baseUrl2/customer/getCustomerByid&api_token=';
//   static const String urlAddAddress = '$baseUrl2/customer/addAdress&api_token=';
//   static const String urlGetAllOrders =
//       '$baseUrl2/order/getOrderByCustomerId&api_token=';
//   static const String urlGetOneProduct =
//       '$baseUrl2/product/getproduct&api_token=';
//   static const String urlGetOneOrder =
//       '$baseUrl2/order/getDataOrder&api_token=';
//   static const String urlgetCouponUrl =
//       '$baseUrl2/coupon/getAllCouponActive&api_id=';
//   static const String urlApplyCoupon = '$baseUrl2/coupon/Confirm&api_token=';
//   static const String urlRemoveCoupon = '$baseUrl2/coupon/unConfirm&api_token=';
//   static const String urlgetTrackingShipping =
//       '$baseUrl2/TrackingShipping/getOrderById&api_token=';
//   static const String urlGetReturnOrder =
//       '$baseUrl2/return/getReturnByCustomerId&api_token=';
//   static const String urlGetOneOrderReturn =
//       '$baseUrl2/return/getReturn&api_token=';
//   static const String urladdReturnOrder =
//       '$baseUrl2/return/addReturnOrder&api_token=';
//   static const String urlGetOneCategory = '$baseUrl2/categoryPage&api_token=';
//   static const String urlGetFavorites = '$baseUrl2/wishlist&api_token=';
//   static const String urlAddFavorites = '$baseUrl2/wishlist/add&api_token=';
//   static const String urlRemoveFavorites =
//       '$baseUrl2/wishlist/remove&api_token=';
//   static const String urlUpdataAddress =
//       '$baseUrl2/customer/editAddress&api_token=';
//   static const String urlDeleteAddress =
//       '$baseUrl2/customer/deleteAddress&api_token=';
//   static const String urlUpdataUserData =
//       '$baseUrl2/customer/UpdateCustomer&api_token=';
//   static const String urlSelectIdAddressnOrder =
//       '$baseUrl2/customer/fastCheckout&api_token=';
//   static const String urlGetBalance =
//       '$baseUrl2/customer/getTransactionTota&api_token=';
//   static const String urlAddBalance = '$baseUrl2/cart/balance&api_token=';
//   static const String urlGetProductsBalace =
//       '$baseUrl2/cart/getBalance&api_token=';
//   static const String urlAddOrderBalace = '$baseUrl2/order/Balance&api_token=';
//   static const String urladdImageBankTr = '$baseUrl2/payment/upload&api_token=';
//   static const String urlConfirmBankTransfer =
//       '$baseUrl2/payment/confirmBankTransfer&api_token=';
//   static const String urlAddReward = '$baseUrl2/spinwin/active&api_token=';
//   static const String urlGetReward = '$baseUrl2/spinwin/index&api_token=';
//   static const String urladdDeviceToken =
//       '$baseUrl2/devicetokens/addDeviceToken&api_token=';
//   static const String urlMyfatoorah =
//       "https://khaled.nylonsa.com/index.php?route=extension/payment/myfatoorah_pg/confirm&api_token=";
//   static const String clearCartUrl = "$baseUrl/cart/clear&api_token=";

//   // "$baseUrl/myfatoorah/generateMobileLink&api_token=";
//   static const String urlTamarapay =
//       '$baseUrl/tamarapay/checkout_information&api_token=';
//   static const String urlTamarapayCheckOrder =
//       "$baseUrl2/tamarapay/authoriseOrder&api_token=";
//   static const String urlCheckPayment =
//       "$baseUrl2/myfatoorah/checkOrder&api_token=";
//   static const String logoutSession = "$baseUrl2/logout&api_token=";
//   static const String urlTabbyRedirect =
//       "https://khaled.nylonsa.com/index.php?route=api/tabby/checkout&api_token=";
//   static const String CheckOrder =
//       "$baseUrl2/myfatoorah/checkOrderBuyOrNo&order_id=";
//   static const String checkOrderBuyOrNo =
//       '$baseUrl2/myfatoorah/checkOrderBuyOrNo&order_id=';
// }

class AppApi {
  static const String baseUrl2 = 'https://www.nylonsa.com/index.php?route=api';
  static const String baseUrl = 'https://www.nylonsa.com/index.php?route=api';
  static const String urlFullHome =
      'https://www.nylonsa.com/index.php?route=api/Home/full_screen';
  static const String urlFullCategory =
      'https://www.nylonsa.com/index.php?route=api/Category/full_screen';
  static const String createToken =
      'https://www.nylonsa.com/index.php?route=api/login';
  static const String getCartUrl = '$baseUrl2/cart/products&api_token=';
  static const String addCartUrl = '$baseUrl/cart/add&api_token=';
  static const String removeCartUrl = '$baseUrl2/cart/remove&api_token=';
  static const String editCartUrl = '$baseUrl2/cart/edit&api_token=';
  static const String addAddressPaymentUrl =
      '$baseUrl2/payment/address&api_token=';
  static const String getPaymentUrl = '$baseUrl2/payment/methods&api_token=';
  static const String selectPaymentUrl = '$baseUrl2/payment/method&api_token=';

  static const String getShippingMethodsUrl =
      '$baseUrl2/shipping/methods&api_token=';
  static const String addAddressShippingUrl =
      '$baseUrl2/shipping/address&api_token=';
  static const String selectShipping =
      'https://www.nylonsa.com/index.php?route=api/shipping/method&api_token=';
// static const String addCustomerUrl = '$baseUrl2/customer&api_token=';
  static const String createNewCustomerUrl =
      '$baseUrl2/customer/createNewCustomer&api_token=';
  static const String addOrderUrl = '$baseUrl2/order/add&api_token=';
  static const String getZoneUrl = '$baseUrl2/zone';
  static const String sendCodeBySms =
      '$baseUrl2/login/tempPasswordGenerator&api_token=';
//'$baseUrl2/login/activeCodeBySms&api_token=';
  static const String sendCodefromUser = '$baseUrl2/login/validate&api_token=';
// 'https://www.nylonsa.com/index.php?route=api/login/validateLogin';
  static const String getLogo =
      'https://www.nylonsa.com/index.php?route=api/setting/logo';
  static const String urlgetCustomerByphone =
      '$baseUrl2/customer/getCustomerByphone';
  static const String urlgetCustomerById =
      '$baseUrl2/customer/getCustomerByid&api_token=';
  static const String urlAddAddress = '$baseUrl2/customer/addAdress&api_token=';
  static const String urlGetAllOrders =
      '$baseUrl2/order/getOrderByCustomerId&api_token=';
  static const String urlGetOneProduct =
      '$baseUrl2/product/getproduct&api_token=';
  static const String urlGetOneOrder =
      '$baseUrl2/order/getDataOrder&api_token=';
  static const String urlgetCouponUrl =
      '$baseUrl2/coupon/getAllCouponActive&api_id=';
  static const String urlApplyCoupon = '$baseUrl2/coupon/Confirm&api_token=';
  static const String urlRemoveCoupon = '$baseUrl2/coupon/unConfirm&api_token=';
  static const String urlgetTrackingShipping =
      '$baseUrl2/TrackingShipping/getOrderById&api_token=';
  static const String urlGetReturnOrder =
      '$baseUrl2/return/getReturnByCustomerId&api_token=';
  static const String urlGetOneOrderReturn =
      '$baseUrl2/return/getReturn&api_token=';
  static const String urladdReturnOrder =
      '$baseUrl2/return/addReturnOrder&api_token=';
  static const String urlGetOneCategory = '$baseUrl2/categoryPage&api_token=';
  static const String urlGetFavorites = '$baseUrl2/wishlist&api_token=';
  static const String urlAddFavorites = '$baseUrl2/wishlist/add&api_token=';
  static const String urlRemoveFavorites =
      '$baseUrl2/wishlist/remove&api_token=';
  static const String urlUpdataAddress =
      '$baseUrl2/customer/editAddress&api_token=';
  static const String urlDeleteAddress =
      '$baseUrl2/customer/deleteAddress&api_token=';
  static const String urlUpdataUserData =
      '$baseUrl2/customer/UpdateCustomer&api_token=';
  static const String urlSelectIdAddressnOrder =
      '$baseUrl2/customer/fastCheckout&api_token=';
  static const String urlGetBalance =
      '$baseUrl2/customer/getTransactionTota&api_token=';
  static const String urlAddBalance = '$baseUrl2/cart/balance&api_token=';
  static const String urlGetProductsBalace =
      '$baseUrl2/cart/getBalance&api_token=';
  static const String urlAddOrderBalace = '$baseUrl2/order/Balance&api_token=';
  static const String urladdImageBankTr = '$baseUrl2/payment/upload&api_token=';
  static const String urlConfirmBankTransfer =
      '$baseUrl2/payment/confirmBankTransfer&api_token=';
  static const String urlAddReward = '$baseUrl2/spinwin/active&api_token=';
  static const String urlGetReward = '$baseUrl2/spinwin/index&api_token=';
  static const String urladdDeviceToken =
      '$baseUrl2/devicetokens/addDeviceToken&api_token=';
  static const String urlMyfatoorah =
      "https://www.nylonsa.com/index.php?route=extension/payment/myfatoorah_pg/confirm&api_token=";
  static const String clearCartUrl = "$baseUrl/cart/clear&api_token=";

  // "$baseUrl/myfatoorah/generateMobileLink&api_token=";
  static const String urlTamarapay =
      '$baseUrl/tamarapay/checkout_information&api_token=';
  static const String urlTamarapayCheckOrder =
      "$baseUrl2/tamarapay/authoriseOrder&api_token=";
  static const String urlCheckPayment =
      "$baseUrl2/myfatoorah/checkOrder&api_token=";
  static const String logoutSession = "$baseUrl2/logout&api_token=";
  static const String urlTabbyRedirect =
      "https://www.nylonsa.com/index.php?route=api/tabby/checkout&api_token=";
  static const String CheckOrder =
      "$baseUrl2/myfatoorah/checkOrderBuyOrNo&order_id=";
  static const String checkOrderBuyOrNo =
      '$baseUrl2/myfatoorah/checkOrderBuyOrNo&order_id=';
  static const String deleteCustomer =
      '$baseUrl2/customer/deleteCustomerData&api_token=';
  static const String serachProduct = '$baseUrl2/product/search&api_token=';
  static const String getThemeColor = '$baseUrl2/app/getTheme';
}
