import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_calculator/controllers/db_controller.dart';
import 'package:meal_calculator/helpers/color_helper.dart';
import 'package:meal_calculator/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(DbController());

  runApp(const MealCalculatorApp());
}

class MealCalculatorApp extends StatelessWidget {
  const MealCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Meal Calculator',
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: ColorHelper.primaryColor,
            scaffoldBackgroundColor: ColorHelper.bgColor,
            cardColor: ColorHelper.cardColor,
            colorScheme: const ColorScheme.dark(
              primary: ColorHelper.primaryColor,
              secondary: ColorHelper.primaryColor,
              surface: ColorHelper.cardColor,
              error: ColorHelper.errorColor,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorHelper.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: ColorHelper.inputBgColor,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                borderSide: const BorderSide(
                    color: ColorHelper.primaryColor, width: 1.5),
              ),
              labelStyle: const TextStyle(color: Colors.grey),
            ),
            dividerTheme: const DividerThemeData(
              color: ColorHelper.inputBgColor,
            ),
          ),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
