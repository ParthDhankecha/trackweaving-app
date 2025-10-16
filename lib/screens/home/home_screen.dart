import 'package:flutter/material.dart';
import 'package:trackweaving/controllers/home_controller.dart';
import 'package:trackweaving/screens/dashboard/dashboard_screen.dart';
import 'package:trackweaving/screens/notifications/notifications_list_screen.dart';
import 'package:trackweaving/screens/report_screen/report_screen.dart';
import 'package:trackweaving/screens/settings_screen/settings_screen.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();
    homeController.selectedNavIndex.value = 0;
    homeController.showToken();
    homeController.fetchUnreadCount();
    _handleInitialNotificationNavigation();
  }

  void _handleInitialNotificationNavigation() {
    if (Get.arguments != null &&
        Get.arguments is Map<String, dynamic> &&
        Get.arguments['navigateToNotifications'] == true) {
      homeController.changeNavIndex(2); // Navigate to Notifications tab
    }
  }

  List<Widget> widgetsList = [
    DashboardScreen(),
    ProductionReportPage(),
    NotificationsListScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => widgetsList.elementAt(homeController.selectedNavIndex.value),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 10,
          currentIndex: homeController.selectedNavIndex.value,
          onTap: (value) => homeController.changeNavIndex(value),
          selectedItemColor: AppColors.mainColor,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'home'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              label: 'reports'.tr,
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.notifications_outlined),
            //   label: 'alert'.tr,
            // ),
            BottomNavigationBarItem(
              icon: Obx(
                () => Badge(
                  // Show the badge only if the count is greater than 0
                  isLabelVisible:
                      homeController.unreadNotificationCount.value > 0,

                  // Label displays the count, limited to '99+' for large numbers
                  label: Text(
                    homeController.unreadNotificationCount.value > 99
                        ? '99+'
                        : homeController.unreadNotificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Badge styling
                  backgroundColor: Colors.redAccent,
                  offset: const Offset(
                    8,
                    -2,
                  ), // Adjust position relative to the icon
                  // The actual icon for the tab
                  child: const Icon(Icons.notifications_outlined),
                ),
              ),
              label: 'alert'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'settings'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
