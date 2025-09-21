import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/function/status_request.dart';
import 'package:nylon/core/routes/name_pages.dart';
import 'package:nylon/core/theme/colors_app.dart';

class HandlingDataView extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  final  Function() onRefresh;

  const HandlingDataView({
    super.key,
    required this.statusRequest,
    required this.widget,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    switch (statusRequest) {
      case StatusRequest.loading:
        return Center(
          child: SizedBox(
            height: 500,
            child:  Center(child: CircularProgressIndicator(color: AppColors.primaryColor,)),
          ),
        );
      case StatusRequest.serverFailure:
        return _buildErrorView(
          context,
         '151'.tr,
          Icons.error,
          onRefresh
        );
      
      case StatusRequest.internetFailure:
        return _buildErrorView(
          context,
          '152'.tr,
          Icons.wifi_off_rounded,
          onRefresh
        );
      
      case StatusRequest.offLienFailure:
        return _buildErrorView(
          context,
          '153'.tr,
          Icons.error,
          onRefresh
        );

      case StatusRequest.failure:
        return _buildErrorView(
          context,
          '154'.tr,
          Icons.error,
          onRefresh
        );
         case StatusRequest.badRequest:
        return _buildErrorView(
          context,
          '154'.tr,
          Icons.error,
          onRefresh
        );

      case StatusRequest.unauthorized:
        return _buildUnauthorizedView(context);
      
      case StatusRequest.notFound:
        return  Center(child: Text('155'.tr));

      case StatusRequest.success:
        return widget;

      default:
        return const SizedBox();
    }
  }

  Widget _buildErrorView(BuildContext context, String message, IconData icon,  Function onRefresh) {
    return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.red),
            const SizedBox(height: 10),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                await onRefresh();
              },
              child: const Icon(Icons.refresh, color: Colors.black38, size: 30),
            ),
            const SizedBox(height: 20),
          ],
        
      ),
    );
  }

  Widget _buildUnauthorizedView(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 40, color: Colors.red),
            const SizedBox(height: 10),
            Column(
              children: [
                Text('156'.tr, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 10),
                Text(
                  '157'.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.amber),
                ),
              ],
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Get.toNamed(NamePages.pSignIn);
               // onRefresh();
                // Action for unauthorized state if needed
                // Get.offAllNamed(NamePages.pOnBoarding);
              },
              child: const Icon(Icons.login, color: Colors.black38, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
