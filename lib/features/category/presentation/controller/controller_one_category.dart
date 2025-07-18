// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/snack_bar.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/features/category/data/data_sources/category_data_source.dart';
import 'package:nylon/features/category/data/models/category_model.dart';
import 'package:nylon/features/home/data/models/category_menu.dart';

abstract class OneCategoryController extends GetxController{
   Future getOneCategory();
   Future getMoreCategory();
   arguments();
   
}
class ControllerOneCategory extends OneCategoryController{
    final CategoryDataSourceImpl _categoryDataSourceImpl = CategoryDataSourceImpl(Get.find());
  StatusRequest? statusRequestOneCag;
  StatusRequest? statusRequestgetMoreCatg;
   ScrollController scrollController =  ScrollController();
  CategoryModel? oneCategory;
  int initPage = 1;
  SliderHome? category;
  onSelctSort(String value)async{
    selectedSort = value;
    update();
    await getOneCategory();
  }
   @override
  arguments() {
  category =Get.arguments;
  print(category!.categoryId!);
   print(category!.title);
  update();
  }
 String selectedSort= "p.sort_order-ASC";
 
  @override
  Future getOneCategory()async {
    statusRequestOneCag = StatusRequest.loading;
    update();
   List<String> sort =  splitText(selectedSort);
    var response = await _categoryDataSourceImpl.getOneCategory(
      idCategory:category!.categoryId!,
      page: initPage,
      sort: sort[0],
      order: sort[1]
      );
      print(sort);
    return response.fold((failure){
      statusRequestOneCag = failure;
      update();
    },(data){
      if (data != null && data.isNotEmpty && data["products"] != null && data["products"].isNotEmpty){
        oneCategory = CategoryModel.fromJson(data as Map<String,dynamic>);
        print(oneCategory!.description);
         print(oneCategory!.totalProducts);
         statusRequestOneCag = StatusRequest.success;
         update();
         print('sssssssssssssssssssssssuess');
              }else{
                print('emptyyyyyyyyyyyyyyyyy');
        statusRequestOneCag = StatusRequest.empty;
        update();
      }
    });
  }
  

@override
void dispose() {
  scrollController.removeListener(() {});
  print('sssssss remove');
  super.dispose();
}


@override
  getMoreCategory() async {
  scrollController.addListener(() async {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (statusRequestgetMoreCatg == StatusRequest.loading) return; // إذا كان جاري تحميل، لا نقوم بإعادة تحميل البيانات
      statusRequestgetMoreCatg = StatusRequest.loading;
      update();
      print("get DATA CATEGORY moreeeeeeeeeeeee ");
      print("جاري تحميل المزيد من المنتجات...");
      initPage++; 
      List<String> sort =  splitText(selectedSort);
      print(sort);
    var response = await _categoryDataSourceImpl.getOneCategory(
      idCategory:category!.categoryId!,
      page: initPage,
      sort: sort[0],
      order: sort[1]
      );
      response.fold(
        (failure) {
          statusRequestgetMoreCatg = failure;
          showSnackBar("فشل في تحميل المزيد من المنتجات");
          update();
        },
        (data) {
         if (data != null && data.isNotEmpty && data["products"] != null && data["products"].isNotEmpty) {
            statusRequestgetMoreCatg = StatusRequest.success;
            oneCategory!.products!.addAll(CategoryModel.fromJson(data as Map<String, dynamic>).products!);
          } else {
            statusRequestgetMoreCatg = StatusRequest.empty;
            showSnackBar("لا توجد منتجات إضافية");
            print("لا توجد منتجات إضافية");
          }
          update();
        }
      );
    }
  });
}
 List<String> splitText(String? input) {
  return input!.split('-');
} 



  @override
  void onInit() {
    arguments();
    getOneCategory();
    getMoreCategory();
    super.onInit();
  }

 }