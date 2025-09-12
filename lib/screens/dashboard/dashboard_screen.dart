import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/loading_widget.dart';
import 'package:flutter_texmunimx/controllers/dashboard_controller.dart';
import 'package:flutter_texmunimx/models/get_machinelog_model.dart';
import 'package:flutter_texmunimx/screens/dashboard/widgets/dashboard_card.dart';
import 'package:flutter_texmunimx/screens/dashboard/widgets/top_row_widget.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashBoardController dashBoardController = Get.find<DashBoardController>();

  @override
  void initState() {
    super.initState();
    dashBoardController.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopRowWidget(),
        SizedBox(height: 8),
        Divider(thickness: 1.2),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              dashBoardController.getData();
              return Future.delayed(Duration(microseconds: 1));
            },
            child: Obx(
              () => dashBoardController.isLoading.value
                  ? LoadingDialog()
                  : ListView.builder(
                      itemCount: dashBoardController.machineLogList.length,
                      itemBuilder: (context, index) {
                        MachineLog machineLog =
                            dashBoardController.machineLogList.value[index];
                        return DashboardCard(machineLog: machineLog);
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
