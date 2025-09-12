import 'package:flutter_texmunimx/models/get_machinelog_model.dart';
import 'package:flutter_texmunimx/repository/api_exception.dart';
import 'package:flutter_texmunimx/repository/dashboard_repo.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';

class DashBoardController extends GetxController implements GetxService {
  final Sharedprefs sp;
  final DashboardRepo dashboardRepo;

  DashBoardController({required this.sp, required this.dashboardRepo});

  RxBool isLoading = false.obs;

  //
  RxString eff = ''.obs;
  RxString picks = ''.obs;
  RxString avgPick = ''.obs;
  RxString avgSpeed = ''.obs;
  RxString running = ''.obs;
  RxString stopped = ''.obs;
  RxString all = ''.obs;

  RxList<MachineLog> machineLogList = RxList<MachineLog>();

  void getData() async {
    try {
      isLoading.value = true;
      var data = await dashboardRepo.getMachineLogs();

      AggregateReport aggregateReport = data.data.aggregateReport;
      eff.value = '${aggregateReport.efficiency}';
      picks.value = '${aggregateReport.pick}';
      avgPick.value = '${aggregateReport.avgPicks}';
      avgSpeed.value = '${aggregateReport.avgSpeed}';
      running.value = '${aggregateReport.running}';
      stopped.value = '${aggregateReport.stopped}';
      all.value = '${aggregateReport.all}';

      machineLogList.value = data.data.machineLogs;
    } on ApiException catch (e) {
      print('on machine logs : $e');
    } finally {
      isLoading.value = false;
    }
  }
}
