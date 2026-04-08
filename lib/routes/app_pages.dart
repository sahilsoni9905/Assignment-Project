import 'package:get/get.dart';
import 'package:tuff_project/features/profile/profile_binding.dart';
import 'package:tuff_project/features/balances/balances_binding.dart';
import '../features/auth/auth_binding.dart';
import '../features/auth/presentation/pages/auth_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/bottom_nav/bottom_nav_binding.dart';
import '../features/bottom_nav/presentation/pages/bottom_nav_page.dart';
import '../features/home/home_binding.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const BottomNavPage(),
      bindings: [
        BottomNavBinding(),
        Feature1Binding(),
        BalancesBinding(),
        ProfileBinding(),
      ],
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 700),
    ),
  ];
}
