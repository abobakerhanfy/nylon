// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/snack_bar.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/features/category/data/data_sources/category_data_source.dart';
import 'package:nylon/features/category/data/models/category_model.dart';
import 'package:nylon/features/home/data/models/category_menu.dart'; // SliderHome
import 'package:nylon/features/home/data/models/products_featured.dart'; // ProductsFeatured
import 'package:nylon/core/routes/name_pages.dart';

abstract class OneCategoryController extends GetxController {
  Future getOneCategory();
  Future getMoreCategory();
  void arguments();
}

class ControllerOneCategory extends OneCategoryController {
  final CategoryDataSourceImpl _categoryDataSourceImpl =
      CategoryDataSourceImpl(Get.find());

  StatusRequest? statusRequestOneCag;
  StatusRequest? statusRequestgetMoreCatg;

  final ScrollController scrollController = ScrollController();

  CategoryModel? oneCategory;
  int initPage = 1;

  // بدّل التخزين من موديل لنقطتين موحّدتين
  String? categoryId;
  String? categoryTitle;

  String selectedSort = "p.sort_order-ASC";

  void safeSnack(String msg) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showSnackBar(msg);
    });
  }

  bool get isArabic =>
      (Get.locale?.languageCode.toLowerCase() == 'ar') ||
      (Get.deviceLocale?.languageCode.toLowerCase() == 'ar');

  // -------------------- التقاط الـ arguments --------------------
  @override
  void arguments() {
    final arg = Get.arguments;
    debugPrint('>> ViewOneCategory ARGS type=${arg.runtimeType} = $arg');

    String? id;
    String? tAr;
    String? tEn;
    String? tUnified;

    // 1) Map: التقط كل المفاتيح المحتملة
    if (arg is Map) {
      id = (arg["categoryId"] ??
              arg["idCategory"] ??
              arg["category_id"] ??
              arg["id"])
          ?.toString();

      tAr = arg["titleAr"] as String?;
      tEn = arg["titleEn"] as String?;
      tUnified = arg["title"] as String?;

      if (id == null || id.isEmpty) {
        // If categoryId is still null or empty, try to get it from Get.parameters
        id = (Get.parameters["categoryId"] ??
            Get.parameters["category_id"] ??
            Get.parameters["id"]);

        if (id == null || id.isEmpty) {
          safeSnack("تعذر تحديد القسم. حاول من جديد.");
          _safeBackIfOnThisPage();
          return;
        }
      }

      categoryId = id;
      categoryTitle = tUnified ?? (isArabic ? (tAr ?? "") : (tEn ?? ""));
      debugPrint(
          "[args:Map resolved] categoryId = $categoryId, title = $categoryTitle");
      update();
      return; // <-- مهم جدًا علشان ما نكمّلش ونوصل للـ Snack بالغلط
    }
    // 2) SliderHome
    else if (arg is SliderHome && (arg.categoryId?.isNotEmpty ?? false)) {
      categoryId = arg.categoryId!.toString();

      String? t;
      try {
        t = (arg as dynamic).title as String?;
      } catch (_) {
        t = null;
      }
      categoryTitle = t ?? "";

      debugPrint(
          "[args:SliderHome] categoryId = $categoryId, title = $categoryTitle");
      update();
      return;
    }
    // 3) ProductsFeatured
    else if (arg is ProductsFeatured && (arg.categoryId?.isNotEmpty ?? false)) {
      categoryId = arg.categoryId!.toString();
      categoryTitle = isArabic ? (arg.nameAr ?? "") : (arg.nameEn ?? "");

      debugPrint(
          "[args:ProductsFeatured] categoryId = $categoryId, title = $categoryTitle");
      update();
      return;
    }
    // 4) جرّب باراميترات الراوت كـ fallback (This block is now redundant if the Map handling is improved)
    else {
      id = (Get.parameters["categoryId"] ??
          Get.parameters["category_id"] ??
          Get.parameters["id"]);

      if (id != null && id.isNotEmpty) {
        categoryId = id;
        categoryTitle = "";
        debugPrint("[args:parameters] categoryId = $categoryId");
        update();
        return;
      }
    }

    // 5) فشلنا في كل المحاولات
    safeSnack('تعذر تحديد القسم. حاول من جديد.');
    _safeBackIfOnThisPage();
  }

  void _safeBackIfOnThisPage() {
    if (!Get.isOverlaysOpen && Get.currentRoute == NamePages.pOneCategory) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!Get.isOverlaysOpen && Get.currentRoute == NamePages.pOneCategory) {
          Get.back();
        }
      });
    }
  }

  // -------------------- طلب أول صفحة --------------------
  @override
  Future getOneCategory({
    String? id,
    int? page,
    String? sort,
    String? order,
  }) async {
    final usedId = id ?? categoryId;
    final usedPage = page ?? initPage;
    final sortParts = splitText(sort ?? selectedSort);

    if (usedId == null || usedId.isEmpty) {
      statusRequestOneCag = StatusRequest.empty;
      update();
      safeSnack('لا يوجد معرف قسم لإحضار البيانات.');
      return;
    }

    statusRequestOneCag = StatusRequest.loading;
    update();

    final response = await _categoryDataSourceImpl.getOneCategory(
      idCategory: usedId,
      page: usedPage,
      sort: sortParts[0],
      order: order ?? sortParts[1],
    );

    return response.fold((failure) {
      statusRequestOneCag = failure;
      update();
    }, (data) {
      if (data != null &&
          data.isNotEmpty &&
          data["products"] != null &&
          data["products"].isNotEmpty) {
        oneCategory = CategoryModel.fromJson(data);
        final apiTitle = data['title']?.toString().trim();
        if (apiTitle != null && apiTitle.isNotEmpty) {
          categoryTitle = apiTitle;
        }
        statusRequestOneCag = StatusRequest.success;
      } else {
        statusRequestOneCag = StatusRequest.empty;
      }
      update();
    });
  }

  // -------------------- تغيير الفرز --------------------
  Future<void> onSelctSort(String value) async {
    selectedSort = value;
    initPage = 1;
    await getOneCategory(id: categoryId!);
  }

  // -------------------- تحميل المزيد (Scroll) --------------------
  @override
  Future getMoreCategory() async {
    // نسجّل الليسنر مرة واحدة
    scrollController.addListener(_onScroll);
  }

  void _onScroll() async {
    if (scrollController.position.pixels !=
        scrollController.position.maxScrollExtent) {
      return;
    }

    if (statusRequestgetMoreCatg == StatusRequest.loading) return;
    if (categoryId == null || categoryId!.isEmpty) return;

    statusRequestgetMoreCatg = StatusRequest.loading;
    update();

    initPage++;
    final sortParts = splitText(selectedSort);

    final response = await _categoryDataSourceImpl.getOneCategory(
      idCategory: categoryId!,
      page: initPage,
      sort: sortParts[0],
      order: sortParts[1],
    );

    response.fold((failure) {
      statusRequestgetMoreCatg = failure;
      safeSnack("فشل في تحميل المزيد من المنتجات");
      update();
    }, (data) {
      if (data != null &&
          data.isNotEmpty &&
          data["products"] != null &&
          data["products"].isNotEmpty) {
        statusRequestgetMoreCatg = StatusRequest.success;
        // لو أول مرة oneCategory لسه null (حالة نادرة)، ابنِها
        if (oneCategory == null) {
          oneCategory = CategoryModel.fromJson(data);
        } else {
          oneCategory!.products!.addAll(
            CategoryModel.fromJson(data).products!,
          );
        }
      } else {
        statusRequestgetMoreCatg = StatusRequest.empty;
        safeSnack("لا توجد منتجات إضافية");
      }
      update();
    });
  }

  // -------------------- أدوات مساعدة --------------------
  List<String> splitText(String? input) {
    final s = (input ?? 'p.sort_order-ASC');
    final parts = s.split('-');
    if (parts.length >= 2) return parts;
    return [parts.first, 'ASC'];
  }

  // -------------------- دورة حياة --------------------
  @override
  void onInit() {
    super.onInit();

    // اشتغل فقط لما نكون على راوت القسم
    if (Get.currentRoute == NamePages.pOneCategory) {
      arguments();
      if (categoryId?.isNotEmpty == true) {
        getOneCategory(id: categoryId!);
        getMoreCategory();
      } else {
        debugPrint('[OneCategory] No categoryId after arguments().');
      }
    } else {
      debugPrint('[OneCategory] Skipped init on route ${Get.currentRoute}');
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
