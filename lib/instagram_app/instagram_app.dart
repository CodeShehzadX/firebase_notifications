import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_bindings.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'utils/app_colors.dart';
import 'utils/app_strings.dart';

/// Root widget for the dummy Instagram app.
class InstagramApp extends StatelessWidget {
  const InstagramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: AppColors.background,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.black,
        ),
      ),
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.main,
      getPages: AppPages.pages,
    );
  }
}
