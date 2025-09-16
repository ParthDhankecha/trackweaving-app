import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/controllers/home_controller.dart';
import 'package:flutter_texmunimx/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_texmunimx/screens/report_screen/report_screen.dart';
import 'package:flutter_texmunimx/screens/settings_screen/settings_screen.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';
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
    Text('Notifications'),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() {
      //     String title = '';
      //     switch (homeController.selectedNavIndex.value) {
      //       case 1:
      //         title = 'reports'.tr;
      //         break;

      //       case 2:
      //         title = 'notifications'.tr;
      //         break;

      //       case 3:
      //         title = 'settings'.tr;
      //         break;
      //       default:
      //         title = 'live_tracking'.tr;
      //     }
      //     return Text(title);
      //   }),
      // ),
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
