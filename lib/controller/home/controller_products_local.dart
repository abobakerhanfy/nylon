// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';

// import '../../core/model/local_product.dart';

// abstract class LocalProductsController extends GetxController{
// }
// class ControllerProductsLocal  extends LocalProductsController{
// var controllerEmail = TextEditingController();
// var controllerName = TextEditingController();
// var controllerPhone = TextEditingController();
// var controllerAddress = TextEditingController();
// var controllerCity = TextEditingController();
// var controllerPostalNumber = TextEditingController();
// DeliveryData deliveryData = new  DeliveryData();
// List<String> creditCard = [
//   'images/test6.png',
//   'images/test9.png',
//   'images/test7.png',
//   'images/test8.png',
//   'images/test7.png',
//   'images/test6.png',
// ];
// int selectVisa = 1;
// int? totalPriceCart ;
// void onTapVisa(int id){
//   selectVisa = id;
//   update();
// }

// addData(){

//  deliveryData=DeliveryData(
//    name: controllerName.text,
//    phone: controllerPhone.text,
//      email:controllerEmail.text ,
//    postalNumber: controllerPostalNumber.text,
//    address: controllerAddress.text,
//    city: controllerCity.text
//  );
//  update();

// }


// getTotalCart(){
//   totalPriceCart = LocalData.data.map((e) => e.price! * e.count).reduce((value, element) => value +element ).toInt();
//   update();
//   print(totalPriceCart);
//   return totalPriceCart;

// }

// }