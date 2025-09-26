import 'package:flutter/material.dart';
import 'package:trackweaving/controllers/home_controller.dart';
import 'package:trackweaving/screens/dashboard/dashboard_screen.dart';
import 'package:trackweaving/screens/report_screen/report_screen.dart';
import 'package:trackweaving/screens/settings_screen/maintenance_category/maintenance_category_screen.dart';
import 'package:trackweaving/screens/settings_screen/maintenance_entry/maintenance_entry_screen.dart';
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
    homeController.showToken();
  }

  List<Widget> widgetsList = [
    DashboardScreen(),
    ProductionReportPage(),
    MaintenanceEntryScreen(),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              label: 'notifications'.tr,
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
