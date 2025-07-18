





import 'package:nylon/core/function/status_request.dart';

handlingData(response){
  if(response is StatusRequest){
    return response;
  }else{
    return StatusRequest.success;
  }

}
/*
handlingDataInpot({required StatusRequest statusRequest,required String message}){
  if(StatusRequest.success==statusRequest){
    return statusRequest;
  }else if (StatusRequest.serverFailure==statusRequest){
    customDialog(
        null,
        message,
        dismissOnTouch: true,
        context: Get.context!,
        title:    "",
        dialogType: DialogType.error);
  }else if(StatusRequest.internetFailure==statusRequest){
    customDialog(
        null,
        'الرجاء التحقق من اتصالك بالانترنت',
        dismissOnTouch: true,
        context: Get.context!,
        title:    "",
        dialogType: DialogType.error);
  }else if(StatusRequest.offLienFailure==statusRequest){
    customDialog(
        null,
        'حدث خطأ ما الرجاء المحاولة مره اخري',
        dismissOnTouch: true,
        context: Get.context!,
        title:    "",
        dialogType: DialogType.error);
  }
}
 */