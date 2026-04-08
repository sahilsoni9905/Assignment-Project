import 'package:flutter/material.dart';
import 'package:tuff_project/core/constants/app_constants.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final double fontSize;
  final double borderRadius;
  const AppLogo({super.key, required this.size, required this.fontSize, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.whiteColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      height: size,
      width: size,
      child: Center(
        child: Text(
          'P',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
