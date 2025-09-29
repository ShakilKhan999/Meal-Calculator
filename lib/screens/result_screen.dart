import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meal_calculator/components/common_components.dart';
import 'package:meal_calculator/controllers/meal_controller.dart';
import 'package:meal_calculator/helpers/color_helper.dart';
import 'package:meal_calculator/helpers/space_helper.dart';
import 'package:meal_calculator/screens/home_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MealController controller = Get.find<MealController>();
    final CommonComponents components = CommonComponents();

    final result = controller.getMembersWithRates();
    final totalPaid = controller.getTotalPaid();
    final totalMeals = controller.getTotalMeals();
    final mealRate = controller.getTotalMealRate();

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Calculation Results',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            IconButton(
              onPressed: () => controller.shareResults(),
              icon: const Icon(Icons.share),
              tooltip: 'Share Results',
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Summary Card
                components.commonCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      components.commonText(
                        fontSize: 18,
                        textData: 'Summary',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      SpaceHelper.verticalSpace16,
                      Row(
                        children: [
                          _buildSummaryItem(
                            context,
                            Icons.attach_money,
                            'Total Cost',
                            '৳$totalPaid',
                          ),
                          _buildSummaryItem(
                            context,
                            Icons.restaurant,
                            'Total Meals',
                            totalMeals.toString(),
                          ),
                          _buildSummaryItem(
                            context,
                            Icons.calculate,
                            'Meal Rate',
                            '৳${mealRate.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SpaceHelper.verticalSpace16,

                // Results List
                Expanded(
                  child: components.commonCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        components.commonText(
                          fontSize: 18,
                          textData: 'Individual Balances',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        SpaceHelper.verticalSpace16,
                        Expanded(
                          child: ListView.separated(
                            itemCount: result.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              final member = result[index];
                              final balance = member['balance'];
                              final isPositive = balance >= 0;

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isPositive
                                      ? ColorHelper.successColor
                                          .withOpacity(0.2)
                                      : ColorHelper.errorColor.withOpacity(0.2),
                                  child: Icon(
                                    isPositive
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: isPositive
                                        ? ColorHelper.successColor
                                        : ColorHelper.errorColor,
                                  ),
                                ),
                                title: Text(
                                  member['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  isPositive
                                      ? 'Will receive ৳${balance.abs().toStringAsFixed(2)}'
                                      : 'Needs to pay ৳${balance.abs().toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: isPositive
                                        ? ColorHelper.successColor
                                        : ColorHelper.errorColor,
                                  ),
                                ),
                                trailing: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isPositive
                                        ? ColorHelper.successColor
                                            .withOpacity(0.2)
                                        : ColorHelper.errorColor
                                            .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Text(
                                    '৳${balance.abs().toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: isPositive
                                          ? ColorHelper.successColor
                                          : ColorHelper.errorColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SpaceHelper.verticalSpace16,
                Row(
                  children: [
                    Expanded(
                      child: components.commonButton(
                        text: 'Back to Home',
                        onPressed: () {
                          controller.clearMembers();
                          Get.back();
                          // Unfocus after navigation completes
                          Future.delayed(const Duration(milliseconds: 200), () {
                            FocusManager.instance.primaryFocus?.unfocus();
                          });
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        borderRadius: 12,
                      ),
                    ),
                    // SpaceHelper.horizontalSpace12,
                    // Expanded(
                    //   child: components.commonButton(
                    //     text: 'Share Results',
                    //     onPressed: () => _shareResults(controller),
                    //     icon: const Icon(Icons.share, color: Colors.white),
                    //     borderRadius: 12,
                    //   ),
                    // ),
                    SpaceHelper.horizontalSpace12,
                    Expanded(
                      child: Obx(() => components.commonButton(
                            text: 'Save History',
                            onPressed: () async {
                              final success =
                                  await controller.saveHistoryWithFeedback();
                              if (success) {
                                controller.clearMembers();
                                Get.offAll(() => const HomeScreen());
                              }
                            },
                            icon: const Icon(Icons.save, color: Colors.white),
                            borderRadius: 12,
                            isLoading: controller.isCalculating.value,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildSummaryItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(5.sp),
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: ColorHelper.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: ColorHelper.primaryColor,
                size: 24.sp,
              ),
              SpaceHelper.verticalSpace8,
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[400],
                ),
              ),
              SpaceHelper.verticalSpace5,
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorHelper.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
