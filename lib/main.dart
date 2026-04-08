import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_binding.dart';
import 'features/balances/balances_binding.dart';
import 'features/bottom_nav/bottom_nav_binding.dart';
import 'features/home/home_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.authBox);
  await Hive.openBox(AppConstants.feature1Box);
  await Hive.openBox(AppConstants.feature2Box);
  await Hive.openBox(AppConstants.ProfileBox);

  debugPrint(
    'Hive ${AppConstants.authBox}: ${Hive.box(AppConstants.authBox).toMap()}',
  );
  debugPrint(
    'Hive ${AppConstants.feature1Box}: ${Hive.box(AppConstants.feature1Box).toMap()}',
  );
  debugPrint(
    'Hive ${AppConstants.feature2Box}: ${Hive.box(AppConstants.feature2Box).toMap()}',
  );
  debugPrint(
    'Hive ${AppConstants.ProfileBox}: ${Hive.box(AppConstants.ProfileBox).toMap()}',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        initialBinding: BindingsBuilder(() {
          AuthBinding().dependencies();
        }),
        initialRoute: AppRoutes.splash,
        getPages: AppPages.routes,
      ),
    );
  }
}
