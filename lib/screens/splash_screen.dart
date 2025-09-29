import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:meal_calculator/helpers/color_helper.dart';
import 'package:meal_calculator/helpers/space_helper.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    Timer(const Duration(seconds: 2), () {
      Get.off(() => const HomeScreen());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 45, 45, 46).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 64.sp,
                  width: 64.sp,
                ),
              ),
            ),

            SpaceHelper.verticalSpace24,

            FadeTransition(
              opacity: _animation,
              child: Text(
                'Meal Calculator',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            SpaceHelper.verticalSpace16,
            FadeTransition(
              opacity: _animation,
              child: Text(
                'Split your meal costs easily',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[400],
                ),
              ),
            ),

            SpaceHelper.verticalSpace48,

            // Loading indicator
            SizedBox(
              width: 200.w,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(
                    ColorHelper.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
