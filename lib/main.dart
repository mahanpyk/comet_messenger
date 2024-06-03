import 'package:comet_messenger/app/bindings/main_binding.dart';
import 'package:comet_messenger/app/core/languages/app_localization.dart';
import 'package:comet_messenger/app/routes/app_pages.dart';
import 'package:comet_messenger/app/routes/app_routes.dart';
import 'package:comet_messenger/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async{
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetMaterialApp(
      builder: (context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaler: const TextScaler.linear(1)),
          child: child!,
        );
      },
      title: 'app_name'.tr,
      theme: AppTheme.themeData(),
      initialBinding: MainBinding(),
      translations: AppLocalization(),
      locale: AppLocalization.locale,
      fallbackLocale: AppLocalization.fallbackLocale,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.LOGIN,
      debugShowCheckedModeBanner: false,
    );
  }
}
