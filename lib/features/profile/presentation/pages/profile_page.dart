import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuff_project/common_widgets/app_logo.dart';
import 'package:tuff_project/common_widgets/top_appbar.dart';
import 'package:tuff_project/core/constants/app_constants.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(bottom: 20.h),
          child: Column(
            children: [
              TopAppbar(),
              SizedBox(height: 10.h),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.h),
                    child: Row(
                      children: [
                        AppLogo(
                          size: 32.h,
                          fontSize: 14.sp,
                          borderRadius: 10.r,
                        ),
                        SizedBox(width: 10.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Text(
                                controller.currentUser.value?.name ?? 'User',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppConstants.whiteColor,
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  buildSwithBetweenPreviewAndEdit(),
                  SizedBox(height: 24.h),
                  Obx(() {
                    if (controller.isPreviewSelected.value) {
                      return _buildPreviewSection();
                    }
                    return _buildEditSection();
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSwithBetweenPreviewAndEdit() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 18.w),
          height: 36.h,
          decoration: BoxDecoration(
            color: Color(0xFF262626),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Obx(() {
            return Row(
              children: [
                Expanded(
                  child: buildHelperContainer(
                    title: 'Preview',
                    isSelected: controller.isPreviewSelected.value,
                    onTap: controller.selectPreview,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: buildHelperContainer(
                    title: 'Edit',
                    isSelected: !controller.isPreviewSelected.value,
                    onTap: controller.selectEdit,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget buildHelperContainer({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        height: 29.h,
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.whiteColor : null,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : AppConstants.greyColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Column(
      children: [
        Obx(() {
          return buildkeyValuePair(
            key: 'Total spendings: ',
            value: '\$${controller.totalSpendings.value.toStringAsFixed(2)}',
          );
        }),
        SizedBox(height: 10.h),
        Obx(() {
          return buildkeyValuePair(
            key: 'Email: ',
            value: controller.currentUser.value?.email ?? 'N/A',
          );
        }),
        SizedBox(height: 10.h),
        Obx(() {
          return buildkeyValuePair(
            key: 'Balance: ',
            value: '\$${controller.remainingBalance.value.toStringAsFixed(2)}',
          );
        }),
      ],
    );
  }

  Widget _buildEditSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Edit Profile',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppConstants.whiteColor,
            ),
          ),
          SizedBox(height: 16.h),
          _buildProfileField(
            label: 'Full name',
            controller: controller.fullNameController,
            hint: 'Enter your full name',
          ),
          SizedBox(height: 12.h),
          _buildProfileField(
            label: 'Email',
            controller: controller.emailController,
            hint: 'Enter your email',
          ),
          SizedBox(height: 12.h),
          Obx(() {
            final isVisible = controller.isPasswordVisible.value;
            return _buildProfileField(
              label: 'Password',
              controller: controller.passwordController,
              hint: 'Enter your password',
              obscureText: !isVisible,
              suffixIcon: IconButton(
                onPressed: controller.isPasswordVisible.toggle,
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppConstants.greyColor,
                ),
              ),
            );
          }),
          SizedBox(height: 12.h),
          Obx(() {
            final isVisible = controller.isConfirmPasswordVisible.value;
            return _buildProfileField(
              label: 'Confirm password',
              controller: controller.confirmPasswordController,
              hint: 'Confirm your password',
              obscureText: !isVisible,
              suffixIcon: IconButton(
                onPressed: controller.isConfirmPasswordVisible.toggle,
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppConstants.greyColor,
                ),
              ),
            );
          }),
          SizedBox(height: 12.h),
          Obx(() {
            if (controller.errorMessage.value.isEmpty) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                controller.errorMessage.value,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent,
                ),
              ),
            );
          }),
          SizedBox(
            height: 44.h,
            child: Obx(() {
              final isSaving = controller.isSaving.value;
              return ElevatedButton(
                onPressed: isSaving ? null : controller.submitProfileUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.whiteColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: isSaving
                    ? SizedBox(
                        height: 18.h,
                        width: 18.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Save changes',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppConstants.whiteColor,
          ),
        ),
        SizedBox(height: 4.h),
        TextFormField(
          controller: controller,
          style: _profileFieldTextStyle(),
          obscureText: obscureText,
          decoration: _profileFieldDecoration(
            hint: hint,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  TextStyle _profileFieldTextStyle() {
    return GoogleFonts.inter(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppConstants.whiteColor,
    );
  }

  InputDecoration _profileFieldDecoration({
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppConstants.greyColor.withOpacity(0.7),
      ),
      filled: true,
      fillColor: const Color(0xFF1F1F1F),
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: AppConstants.whiteColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }

  Widget buildkeyValuePair({required String key, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            key,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFFA1A1A1),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: AppConstants.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
