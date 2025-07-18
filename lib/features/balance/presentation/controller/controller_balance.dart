// ignore_for_file: unnecessary_null_comparison

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/snack_bar.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/widgets/login/dialog.dart';
import 'package:nylon/core/widgets/primary_button.dart';
import 'package:nylon/features/balance/data/data_sources/balance_data_source.dart';
import 'package:nylon/features/balance/data/models/get_balance_model.dart';
import 'package:nylon/features/balance/data/models/get_cart_balance.dart';

abstract class BalanceController extends GetxController{
  Future  getBalace();
Future addBalace();
Future  getProductsBalace();
Future addOrderBalace();
selectCredit({required String value});
Future sendDataUser();
}
class ControllerBalance extends BalanceController{
 final BalanceDataSourceImpl _balanceDataSourceImpl = BalanceDataSourceImpl(Get.find());
final MyServices _myServices = Get.find();
GetBalanceModel? getBalanceModel;
GetBalanceCart? getTotalBalance;
 StatusRequest? statusRequestgetBalance,statusRequestAddBal,
 statusRequestSendOrderB,statusRequestGetCartB,statusRequestSendDUser;
 var cFirstName = TextEditingController();
 var cLastName = TextEditingController();
 GlobalKey<FormState> formAddDataUser=  GlobalKey<FormState>();
 String? credit ;
  @override
  Future addBalace()async {
     if(credit!=null){
   statusRequestAddBal = StatusRequest.loading; 
   update();
   var response = await _balanceDataSourceImpl.addBalace(credit: credit!);
   return response.fold((failure){
    statusRequestAddBal = failure;

    print(statusRequestAddBal);
    newHandleStatusRequestInput(statusRequestAddBal!);
   },(data){
   if(data!=null && data.isNotEmpty){
    statusRequestAddBal = StatusRequest.success;
  getProductsBalace();
    Get.toNamed(NamePages.pSendOrderBalance);

    update();
   }
   });
     }else{
       showSnackBar('رجاء اختار قيمة الرصيد المطلوب');
     }
     
  }
 
  @override
  Future addOrderBalace()async {
  statusRequestSendOrderB = StatusRequest.loading;
  update();
  var respnse = await _balanceDataSourceImpl.addOrderBalace();
  return respnse.fold((failure){
    statusRequestSendOrderB = failure;
    newHandleStatusRequestInput(statusRequestSendOrderB!);
    update();
  }, (data){
    print(data);
    if(data!=null && data.isNotEmpty&&data.containsKey('success')){
        newCustomDialog(
        body:SizedBox(  height: 40,
          child: PrimaryButton( label: 'موافق',
       onTap:(){
        Get.back();
        Get.back();},
        ),)
    ,title:'تم اضافه الرصيد بنجاح ',
     dialogType: DialogType.success);  
     statusRequestSendOrderB = StatusRequest.success;
     getBalace();
     update();
    }else{
      print('ffffffff not suess response ');
      statusRequestSendOrderB =StatusRequest.failure;
    newHandleStatusRequestInput(statusRequestSendOrderB!);
      update();
    }

  });
  }
 
  @override
  Future getBalace()async{
    if(_myServices.userIsLogin()){
   statusRequestgetBalance = StatusRequest.loading;
   update();
   var response = await _balanceDataSourceImpl.getBalace();
   return response.fold((failure){
    statusRequestgetBalance = failure;
    print(statusRequestgetBalance);
    print('errrrrrrrrrrrrrrrrrrrrr Balance');
    update();
   }, (data){
     if(data!=null &&data.isNotEmpty){
   getBalanceModel = GetBalanceModel.fromJson(data as Map<String,dynamic>);
  print('==========================================');
   print(getBalanceModel!.balance);
   statusRequestgetBalance = StatusRequest.success;
   update();
     }else{
     statusRequestgetBalance = StatusRequest.failure;
     update();
     }
   });
  }else{
    statusRequestgetBalance = StatusRequest.unauthorized;
    update();
  }
  }
 
  @override
  Future getProductsBalace()async {
    statusRequestGetCartB = StatusRequest.loading;
    var response = await _balanceDataSourceImpl.getProductsBalace();
    return response.fold((failure){
      statusRequestGetCartB = failure;
      print('errrrrrrrrrrrrrrrrrrrrrrrror');
    update();
    },(data){
      if(data!=null&&data.isNotEmpty){
       getTotalBalance = GetBalanceCart.fromJson(data as Map<String,dynamic>);
       statusRequestGetCartB = StatusRequest.success;
       print('sssssssssssssssuss');
       print(getTotalBalance!.totals!.length);
       print(getTotalBalance!.totals![0].text);
       update();
      }else{
        print('data nullllllllllllllllllll');
        statusRequestGetCartB = StatusRequest.failure;
        update();
      }
    });
  }
  
  @override
  selectCredit({required String value}) {
    credit = value;
    print('credit ================= $credit');
    update();
  }

     @override
  Future sendDataUser()async {
    
   var vild = formAddDataUser.currentState;
   if(vild!.validate()){
    statusRequestSendDUser = StatusRequest.loading;
    update();
    var respnse = await _balanceDataSourceImpl.sendDataUser(data: {
      'customer_id':_myServices.sharedPreferences.getString('UserId'),
      'firstname':cFirstName.text,
      'lastname':cLastName.text
    });
    return respnse.fold((failure){
      statusRequestSendDUser = failure;
      newHandleStatusRequestInput(statusRequestSendDUser!);
      update();
    }, (data){
      if(data!=null && data.isNotEmpty){
        print(data);
        print('ssssssssssssssssssssussesssssss');
        statusRequestSendDUser=StatusRequest.success;
        update();
      }else{
        statusRequestSendDUser = StatusRequest.failure;
        print('data  nullllllllllllllllllll ');
        newHandleStatusRequestInput(statusRequestSendDUser!);
        update();
      }
    });
   }
  }

  @override
  void onInit() {
getBalace();
    super.onInit();
  }
  

  
}