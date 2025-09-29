import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meal_calculator/components/common_components.dart';
import 'package:meal_calculator/controllers/meal_controller.dart';
import 'package:meal_calculator/helpers/color_helper.dart';
import 'package:meal_calculator/helpers/space_helper.dart';
import 'package:meal_calculator/screens/result_screen.dart';
import 'package:meal_calculator/screens/history_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    // _loadBannerAd();
  }

  @override
  void dispose() {
    // _bannerAd?.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _handleAddMember(MealController controller) {
    _dismissKeyboard();
    controller.addMember();
  }

  // void _loadBannerAd() {
  //   _bannerAd = BannerAd(
  //     // Use Google's test ad unit ID for banner ads during development
  //     adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ad unit ID
  //     // Use your real ad unit ID for production
  //     // adUnitId: 'ca-app-pub-2468130989368373/7761945061',
  //     size: AdSize.banner,
  //     request: const AdRequest(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (_) {
  //         setState(() {
  //           _isAdLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         print('Ad failed to load: ${error.message}');
  //         ad.dispose();
  //       },
  //     ),
  //   );

  //   _bannerAd?.load();
  // }

  @override
  Widget build(BuildContext context) {
    final MealController controller = Get.put(MealController());
    final CommonComponents components = CommonComponents();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_menu,
              color: ColorHelper.primaryColor,
              size: 24.sp,
            ),
            SpaceHelper.horizontalSpace8,
            const Text(
              'Meal Calculator',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history,
              color: ColorHelper.primaryColor,
            ),
            onPressed: () => Get.to(() => const HistoryScreen()),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: Stack(
          children: [
            // Main content with SingleChildScrollView
            SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header with app description
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Text(
                          'Split your meal costs easily with friends and roommates',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[400],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Add Member Card with modern design
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorHelper.cardColor,
                              ColorHelper.cardColor
                                  .withBlue(ColorHelper.cardColor.blue + 15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(
                                      color: ColorHelper.primaryColor
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.person_add,
                                      color: ColorHelper.primaryColor,
                                      size: 20.sp,
                                    ),
                                  ),
                                  SpaceHelper.horizontalSpace12,
                                  components.commonText(
                                    fontSize: 18,
                                    textData: 'Add New Member',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              SpaceHelper.verticalSpace16,
                              components.commonTextField(
                                controller: controller.nameController,
                                labelText: 'Name',
                                prefixIcon: Icons.person_outline,
                              ),
                              SpaceHelper.verticalSpace12,
                              components.commonTextField(
                                controller: controller.mealController,
                                labelText: 'Number of Meals',
                                prefixIcon: Icons.restaurant_outlined,
                                keyboardType: TextInputType.number,
                              ),
                              SpaceHelper.verticalSpace12,
                              components.commonTextField(
                                controller: controller.paidController,
                                labelText: 'Amount Paid',
                                prefixIcon: Icons.attach_money,
                                keyboardType: TextInputType.number,
                              ),
                              SpaceHelper.verticalSpace16,
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _handleAddMember(controller),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorHelper.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.add,
                                          color: Colors.white),
                                      SpaceHelper.horizontalSpace8,
                                      Text(
                                        'Add Member',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SpaceHelper.verticalSpace24,

                      // Members List with modern design
                      Obx(() {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorHelper.cardColor,
                                ColorHelper.cardColor
                                    .withBlue(ColorHelper.cardColor.blue + 15),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8.r),
                                          decoration: BoxDecoration(
                                            color: ColorHelper.primaryColor
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          child: Icon(
                                            Icons.group,
                                            color: ColorHelper.primaryColor,
                                            size: 20.sp,
                                          ),
                                        ),
                                        SpaceHelper.horizontalSpace12,
                                        components.commonText(
                                          fontSize: 18,
                                          textData: 'Members',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorHelper.primaryColor
                                            .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                      ),
                                      child: Text(
                                        '${controller.members.length}',
                                        style: TextStyle(
                                          color: ColorHelper.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SpaceHelper.verticalSpace16,
                                controller.members.isEmpty
                                    ? _buildEmptyMembersList(components)
                                    : SizedBox(
                                        height: 300.h,
                                        child: _buildMembersList(
                                            controller, components),
                                      ),
                              ],
                            ),
                          ),
                        );
                      }),

                      // Add padding at the bottom to ensure space for the floating button
                      SizedBox(height: 80.h),
                    ],
                  ),
                ),
              ),
            ),

            // Floating Calculate Button at the bottom
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              child: Container(
                height: 55.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorHelper.primaryColor,
                      ColorHelper.primaryColor
                          .withBlue(ColorHelper.primaryColor.blue + 30),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorHelper.primaryColor.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _goToResults(controller),
                    borderRadius: BorderRadius.circular(16.r),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calculate_outlined,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          SpaceHelper.horizontalSpace12,
                          Text(
                            'Calculate Results',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (_isAdLoaded && _bannerAd != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.transparent,
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildEmptyMembersList(CommonComponents components) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: ColorHelper.bgColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_outlined,
              size: 64.sp,
              color: Colors.grey,
            ),
            SpaceHelper.verticalSpace16,
            components.commonText(
              fontSize: 16,
              textAlign: TextAlign.center,
              textData: 'No members added yet',
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
            SpaceHelper.verticalSpace8,
            components.commonText(
              textAlign: TextAlign.center,
              fontSize: 14,
              textData: 'Add members to calculate meal costs',
              fontWeight: FontWeight.normal,
              color: Colors.grey.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersList(
      MealController controller, CommonComponents components) {
    return Scrollbar(
      thumbVisibility: true,
      thickness: 1.0,
      radius: const Radius.circular(8),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.members.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.withOpacity(0.2),
          height: 1,
        ),
        itemBuilder: (context, index) {
          final member = controller.members[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              leading: Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorHelper.primaryColor.withOpacity(0.7),
                      ColorHelper.primaryColor.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    member.name[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
              title: Text(
                member.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: ColorHelper.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.restaurant,
                            size: 12.sp,
                            color: ColorHelper.primaryColor,
                          ),
                          SpaceHelper.horizontalSpace5,
                          Text(
                            '${member.meals}',
                            style: TextStyle(
                              color: ColorHelper.primaryColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SpaceHelper.horizontalSpace8,
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon(
                          //   Icons.attach_money,
                          //   size: 12.sp,
                          //   color: Colors.green,
                          // ),
                          // SpaceHelper.horizontalSpace5,
                          Text(
                            '৳ ${member.paid}',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              trailing: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20.sp,
                  ),
                ),
                onPressed: () => controller.removeMember(index),
              ),
            ),
          );
        },
      ),
    );
  }

  void _goToResults(MealController controller) {
    if (controller.members.isNotEmpty) {
      Get.to(() => const ResultScreen());
    } else {
      Get.snackbar(
        'No Members',
        'Please add at least one member',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(16.r),
      );
    }
  }
}
