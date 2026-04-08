import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuff_project/common_widgets/app_logo.dart';
import 'package:tuff_project/core/constants/app_constants.dart';
import '../controllers/auth_controller.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final bottomInset = MediaQuery.of(context).viewInsets.bottom;

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  28.w,
                  20.h,
                  28.w,
                  bottomInset + 20.h,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildTopCommonSection(),
                        SizedBox(height: 18.h),
                        buildSignInSignUpSwitchContainer(),
                        Obx(() {
                          if (controller.isSignInSelected.value) {
                            return buildSignInForm();
                          }
                          return buildSignUpForm();
                        }),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget buildTopCommonSection() {
    return Column(
      children: [
        AppLogo(size: 64.h, fontSize: 24.sp, borderRadius: 16.r),
        SizedBox(height: 10.h),
        Text(
          'Welcome to PayU',
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppConstants.whiteColor,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Send money global with the real exchange rate',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppConstants.greyColor,
          ),
        ),
        SizedBox(height: 40.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Get started',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppConstants.whiteColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Sign in to your account or create a new one',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppConstants.greyColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSignInSignUpSwitchContainer() {
    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        color: Color(0xFF262626),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Obx(() {
        return Row(
          children: [
            Expanded(
              child: buildSignContainer(
                title: 'Sign in',
                isSelected: controller.isSignInSelected.value,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: buildSignContainer(
                title: 'Sign up',
                isSelected: !controller.isSignInSelected.value,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildSignContainer({required String title, required bool isSelected}) {
    return InkWell(
      onTap: () {
        if (title == 'Sign in') {
          controller.isSignInSelected.value = true;
        } else {
          controller.isSignInSelected.value = false;
        }
      },
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

  Widget buildSignInForm({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20.h),
        Text(
          'Email',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppConstants.whiteColor,
          ),
        ),
        SizedBox(height: 4.h),
        TextFormField(
          controller: controller.signInEmailController,
          style: _authFieldTextStyle(),
          decoration: _authFieldDecoration(hint: 'Enter your email'),
        ),
        SizedBox(height: 12.h),
        Text(
          'Password',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppConstants.whiteColor,
          ),
        ),
        SizedBox(height: 4.h),
        Obx(() {
          final isVisible = controller.isSignInPasswordVisible.value;
          return TextFormField(
            controller: controller.signInPasswordController,
            obscureText: !isVisible,
            style: _authFieldTextStyle(),
            decoration: _authFieldDecoration(
              hint: 'Enter your password',
              suffixIcon: IconButton(
                onPressed: () {
                  controller.isSignInPasswordVisible.toggle();
                },
                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                color: AppConstants.greyColor,
              ),
            ),
          );
        }),
        SizedBox(height: 6.h),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Forgot password?',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppConstants.greyColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 44.h,
          child: ElevatedButton(
            onPressed: controller.signIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.whiteColor,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Obx(() {
              return controller.isButtonLoading.value
                  ? Padding(
                    padding:  EdgeInsets.all(2.h),
                    child: const CircularProgressIndicator(color: Colors.black),
                  )
                  : Text(
                      'Sign In',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    );
            }),
          ),
        ),
      ],
    );
  }

  Widget buildSignUpForm({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20.h),
        Text(
          'Full Name',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppConstants.whiteColor,
          ),
        ),
        SizedBox(height: 4.h),
        TextFormField(
          controller: controller.signUpNameController,
          style: _authFieldTextStyle(),
          decoration: _authFieldDecoration(hint: 'Enter your full name'),
        ),
        SizedBox(height: 12.h),
        Text(
          'Email',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppConstants.whiteColor,
          ),
        ),
        SizedBox(height: 4.h),
        TextFormField(
          controller: controller.signUpEmailController,
          style: _authFieldTextStyle(),
          decoration: _authFieldDecoration(hint: 'Enter your email'),
        ),
        SizedBox(height: 12.h),
        Text(
          'Password',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppConstants.whiteColor,
          ),
        ),
        SizedBox(height: 4.h),
        Obx(() {
          final isVisible = controller.isSignUpPasswordVisible.value;
          return TextFormField(
            controller: controller.signUpPasswordController,
            obscureText: !isVisible,
            style: _authFieldTextStyle(),
            decoration: _authFieldDecoration(
              hint: 'Create a password',
              suffixIcon: IconButton(
                onPressed: () {
                  controller.isSignUpPasswordVisible.toggle();
                },
                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                color: AppConstants.greyColor,
              ),
            ),
          );
        }),
        SizedBox(height: 12.h),
        Text(
          'Confirm Password',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppConstants.whiteColor,
          ),
        ),
        SizedBox(height: 4.h),
        Obx(() {
          final isVisible = controller.isSignUpConfirmPasswordVisible.value;
          return TextFormField(
            controller: controller.signUpConfirmPasswordController,
            obscureText: !isVisible,
            style: _authFieldTextStyle(),
            decoration: _authFieldDecoration(
              hint: 'Re-enter your password',
              suffixIcon: IconButton(
                onPressed: () {
                  controller.isSignUpConfirmPasswordVisible.toggle();
                },
                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                color: AppConstants.greyColor,
              ),
            ),
          );
        }),
        SizedBox(height: 12.h),
        SizedBox(
          height: 44.h,
          child: ElevatedButton(
            onPressed: controller.signUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.whiteColor,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'Sign Up',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _authFieldTextStyle() {
    return GoogleFonts.inter(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppConstants.whiteColor,
    );
  }

  InputDecoration _authFieldDecoration({
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
}
