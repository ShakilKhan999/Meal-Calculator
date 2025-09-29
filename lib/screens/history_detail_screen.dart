import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meal_calculator/components/common_components.dart';
import 'package:meal_calculator/controllers/db_controller.dart';
import 'package:meal_calculator/helpers/color_helper.dart';
import 'package:meal_calculator/helpers/space_helper.dart';

class HistoryDetailScreen extends StatelessWidget {
  final int historyId;
  const HistoryDetailScreen({super.key, required this.historyId});

  @override
  Widget build(BuildContext context) {
    final DbController controller = Get.find<DbController>();
    final CommonComponents components = CommonComponents();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.shareHistoryDetails(historyId),
            icon: const Icon(Icons.share),
            tooltip: 'Share Results',
          ),
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: controller.getMembersForHistory(historyId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading details',
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No details found',
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  ),
                );
              }

              final members = snapshot.data!;
              final history = controller.mealHistories.firstWhere(
                (h) => h['id'] == historyId,
                orElse: () => {},
              );

              if (history.isEmpty) {
                return Center(
                  child: Text(
                    'History not found',
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  ),
                );
              }

              final date = DateTime.parse(history['created_at']);
              final formattedDate =
                  DateFormat('MMMM dd, yyyy - hh:mm a').format(date);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        SpaceHelper.verticalSpace8,
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14.sp,
                          ),
                        ),
                        SpaceHelper.verticalSpace16,
                        Row(
                          children: [
                            _buildSummaryItem(
                              context,
                              Icons.attach_money,
                              'Total Cost',
                              '৳${history['total_paid']}',
                            ),
                            _buildSummaryItem(
                              context,
                              Icons.restaurant,
                              'Total Meals',
                              history['total_meals'].toString(),
                            ),
                            _buildSummaryItem(
                              context,
                              Icons.calculate,
                              'Meal Rate',
                              '৳${history['meal_rate'].toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SpaceHelper.verticalSpace16,

                  // Members List
                  Expanded(
                    child: components.commonCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          components.commonText(
                            fontSize: 18,
                            textData: 'Members',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          SpaceHelper.verticalSpace16,
                          Expanded(
                            child: ListView.separated(
                              itemCount: members.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (context, index) {
                                final member = members[index];
                                final balance = member['balance'] as double;
                                final isPositive = balance >= 0;

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: isPositive
                                        ? ColorHelper.successColor
                                            .withOpacity(0.2)
                                        : ColorHelper.errorColor
                                            .withOpacity(0.2),
                                    child: Text(
                                      member['name'][0].toUpperCase(),
                                      style: TextStyle(
                                        color: isPositive
                                            ? ColorHelper.successColor
                                            : ColorHelper.errorColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    member['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SpaceHelper.verticalSpace5,
                                      Text(
                                        'Meals: ${member['meals']} • Paid: ৳${member['paid']}',
                                        style:
                                            TextStyle(color: Colors.grey[400]),
                                      ),
                                      SpaceHelper.verticalSpace5,
                                      Text(
                                        isPositive
                                            ? 'Received: ৳${balance.abs().toStringAsFixed(2)}'
                                            : 'Paid: ৳${balance.abs().toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: isPositive
                                              ? ColorHelper.successColor
                                              : ColorHelper.errorColor,
                                        ),
                                      ),
                                    ],
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
                ],
              );
            },
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
