import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_calculator/helpers/color_helper.dart';

class CommonComponents {
  // Common text widget
  Widget commonText({
    required double fontSize,
    required String textData,
    required FontWeight fontWeight,
    required Color color,
    TextAlign? textAlign,
  }) {
    return Text(
      textData,
      style: TextStyle(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
    );
  }

  // Common card widget
  Widget commonCard({
    required Widget child,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(16.r),
        child: child,
      ),
    );
  }

  // Common button widget
  Widget commonButton({
    required String text,
    required VoidCallback onPressed,
    Icon? icon,
    double? fontSize,
    double? borderRadius,
    bool isLoading = false,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorHelper.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: 20.h,
              width: 20.h,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon,
                  SizedBox(width: 8.w),
                ],
                Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize?.sp ?? 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }

  // Common text field widget
  Widget commonTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: ColorHelper.primaryColor),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }

  // Common list tile widget
  Widget commonListTile({
    required String title,
    required String subtitle,
    required Widget leading,
    required Widget trailing,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: 8.w,
      ),
      leading: leading,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[400]),
      ),
      trailing: trailing,
    );
  }

  // Common dialog widget
  Widget commonDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onOkPressed,
    bool isConfirmationDialog = false,
    String? cancelButtonText,
    Color? backgroundColor,
    Color? textColor,
    Color? buttonColor,
    Color? iconColor,
  }) {
    return AlertDialog(
      backgroundColor: backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          color: textColor ?? Colors.black,
        ),
      ),
      actions: [
        if (isConfirmationDialog)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              cancelButtonText ?? 'Cancel',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        TextButton(
          onPressed: onOkPressed,
          child: Text(
            buttonText,
            style: TextStyle(
              color: buttonColor ?? ColorHelper.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
