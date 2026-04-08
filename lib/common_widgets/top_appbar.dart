import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuff_project/common_widgets/app_logo.dart';
import 'package:tuff_project/core/constants/app_constants.dart';
import 'package:tuff_project/features/auth/presentation/controllers/auth_controller.dart';

class TopAppbar extends StatelessWidget {
  const TopAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      height: 69.h,
      child: Row(
        children: [
          AppLogo(size: 33.h, fontSize: 14.sp, borderRadius: 10.r),
          SizedBox(width: 12.w),
          Text(
            'PayU',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppConstants.whiteColor,
            ),
          ),
          Spacer(),
          Icon(Icons.search, color: AppConstants.greyColor, size: 20.sp),
          SizedBox(width: 16.w),
          Icon(
            Icons.notifications_none_outlined,
            color: AppConstants.greyColor,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => Get.find<AuthController>().logout(),
            icon: Icon(
              Icons.logout,
              color: AppConstants.greyColor,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
