import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/controllers/home_controller.dart';
import 'package:flutter_texmunimx/screens/dashboard/dashboard_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Tracking')),
      body: DashboardScreen(),
    );
  }
}
