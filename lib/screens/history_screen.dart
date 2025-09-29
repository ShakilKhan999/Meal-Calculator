import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meal_calculator/components/common_components.dart';
import 'package:meal_calculator/controllers/db_controller.dart';
import 'package:meal_calculator/helpers/color_helper.dart';
import 'package:meal_calculator/helpers/space_helper.dart';
import 'package:meal_calculator/screens/history_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make sure DbController is initialized before using it
    final DbController controller = Get.put(DbController());
    final CommonComponents components = CommonComponents();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculation History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.mealHistories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 64.sp,
                      color: Colors.grey,
                    ),
                    SpaceHelper.verticalSpace16,
                    components.commonText(
                      fontSize: 16,
                      textData: 'No calculation history yet',
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: controller.mealHistories.length,
              itemBuilder: (context, index) {
                final history = controller.mealHistories[index];
                final date = DateTime.parse(history['created_at']);
                final formattedDate =
                    DateFormat('MMM dd, yyyy - hh:mm a').format(date);

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: components.commonCard(
                    borderRadius: 12,
                    child: InkWell(
                      onTap: () => Get.to(
                          () => HistoryDetailScreen(historyId: history['id'])),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              components.commonText(
                                fontSize: 16,
                                textData: formattedDate,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: ColorHelper.errorColor,
                                ),
                                onPressed: () => _confirmDelete(context,
                                    components, controller, history['id']),
                              ),
                            ],
                          ),
                          const Divider(),
                          SpaceHelper.verticalSpace8,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildHistoryItem(
                                'Total Meals',
                                history['total_meals'].toString(),
                                Icons.restaurant,
                              ),
                              _buildHistoryItem(
                                'Total Cost',
                                '৳${history['total_paid']}',
                                Icons.attach_money,
                              ),
                              _buildHistoryItem(
                                'Meal Rate',
                                '৳${history['meal_rate'].toStringAsFixed(2)}',
                                Icons.calculate,
                              ),
                            ],
                          ),
                          SpaceHelper.verticalSpace8,
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: ColorHelper.primaryColor,
          size: 20.sp,
        ),
        SpaceHelper.verticalSpace5,
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
        SpaceHelper.verticalSpace3,
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, CommonComponents components,
      DbController controller, int historyId) {
    showDialog(
      context: context,
      builder: (context) => components.commonDialog(
        context: context,
        title: 'Delete History',
        message:
            'Are you sure you want to delete this calculation history? This action cannot be undone.',
        buttonText: 'Delete',
        isConfirmationDialog: true,
        cancelButtonText: 'Cancel',
        onOkPressed: () async {
          Navigator.pop(context);
          await controller.deleteMealHistory(historyId);
          Get.snackbar(
            'Success',
            'History deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: ColorHelper.successColor,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(16.r),
          );
        },
        backgroundColor: ColorHelper.cardColor,
        textColor: Colors.white,
        buttonColor: ColorHelper.errorColor,
        iconColor: Colors.white,
      ),
    );
  }
}
