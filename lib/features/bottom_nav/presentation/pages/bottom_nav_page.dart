import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuff_project/core/constants/app_constants.dart';
import 'package:tuff_project/features/profile/presentation/pages/profile_page.dart';
import 'package:tuff_project/features/balances/presentation/pages/balances_page.dart';
import '../controllers/bottom_nav_controller.dart';
import '../../../home/presentation/pages/home_page.dart';

class BottomNavPage extends GetView<BottomNavController> {
  const BottomNavPage({super.key});

  static const List<Widget> _pages = [
    HomePage(),
    balancesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => SizedBox(
          height: 63.h,
          child: BottomNavigationBar(
            iconSize: 20.r,
            selectedIconTheme: IconThemeData(color: AppConstants.whiteColor),
            unselectedIconTheme: IconThemeData(color: AppConstants.greyColor),
            selectedLabelStyle: GoogleFonts.inter(
              color: AppConstants.whiteColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              color: AppConstants.greyColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                activeIcon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                activeIcon: Icon(Icons.account_balance_wallet),
                label: 'Balances',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_sharp),
                activeIcon: Icon(Icons.person_2_sharp),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
