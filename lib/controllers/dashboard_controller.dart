import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:trackweaving/models/get_machinelog_model.dart';
import 'package:trackweaving/models/status_enum.dart';
import 'package:trackweaving/repository/api_exception.dart';
import 'package:trackweaving/repository/dashboard_repo.dart';
import 'package:trackweaving/screens/auth_screens/login_screen.dart';
import 'package:trackweaving/utils/date_formate_extension.dart';
import 'package:trackweaving/utils/shared_pref.dart';
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

  Rx<DateTime> currentTime = Rx(DateTime.now());
  RxString currentTimeString = ''.obs;

  late Timer timer;

  RxString showStatus = 'all'.obs; //running and stopped,
  Rx<MachineStatus> currentStatus = Rx(MachineStatus.all);

  int efficiencyAveragePer = 85;
  int efficiencyGoodPer = 90;

  RxString currentAppVersion = ''.obs;
  RxString latestAppVersion = ''.obs;
  RxBool forceUpdate = false.obs;
  RxBool isUpdateAvailable = false.obs;

  //change status
  void changeStatus(MachineStatus status) {
    currentStatus.value = status;
    switch (status) {
      case MachineStatus.running:
        showStatus.value = 'running';
        break;

      case MachineStatus.stopped:
        showStatus.value = 'stopped';
        break;
      default:
        showStatus.value = 'all';
    }

    getData();
  }

  //save last update prompt time
  void saveLastUpdatePromptTime(DateTime timestamp) {
    sp.lastUpdatePromptTime = timestamp.millisecondsSinceEpoch;
  }

  Future<bool> shouldPromptForUpdate() async {
    int lastPromptTime = sp.lastUpdatePromptTime;

    DateTime lastPromptDateTime = DateTime.fromMillisecondsSinceEpoch(
      lastPromptTime,
    );
    Duration difference = DateTime.now().difference(lastPromptDateTime);
    log('Difference in hours: ${difference.inHours}');
    if (difference.inMinutes >= 24 || lastPromptTime == 0) {
      return true;
    }
    return false;
  }

  //get configurations

  Future<void> getSettings() async {
    try {
      isLoading.value = true;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      var data = await dashboardRepo.getConfiguration();
      sp.refreshInterval = data['refreshInterval'];
      efficiencyAveragePer = data['efficiencyAveragePer'];
      efficiencyGoodPer = data['efficiencyGoodPer'];

      latestAppVersion.value = Platform.isAndroid
          ? data['androidVersion'] ?? packageInfo.version
          : data['iosVersion'] ?? packageInfo.version;

      forceUpdate.value = Platform.isAndroid
          ? data['androidForceUpdate'] ?? false
          : data['iosForceUpdate'] ?? false;

      String version = packageInfo.version;
      currentAppVersion.value = version;

      int currentVersionInt = int.tryParse(version.replaceAll('.', '')) ?? 0;
      int latestVersionInt =
          int.tryParse(latestAppVersion.value.replaceAll('.', '')) ?? 0;

      log(
        'getSettings : version : $currentVersionInt , latestVersionInt: $latestVersionInt',
      );
      isUpdateAvailable.value = latestVersionInt > currentVersionInt
          ? true
          : false;

      log('getSettings : isUpdateAvailable : ${isUpdateAvailable.value}');
    } on ApiException catch (e) {
      log('getSettings : error : $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getData() async {
    try {
      isLoading.value = true;
      var data = await dashboardRepo.getMachineLogs(status: showStatus.value);

      AggregateReport aggregateReport = data.data.aggregateReport;
      eff.value = '${aggregateReport.efficiency}';
      picks.value = '${aggregateReport.pick}';
      avgPick.value = '${aggregateReport.avgPicks}';
      avgSpeed.value = '${aggregateReport.avgSpeed}';
      running.value = '${aggregateReport.running}';
      stopped.value = '${aggregateReport.stopped}';
      all.value = '${aggregateReport.all}';

      machineLogList.value = data.data.machineLogs;
      currentTime.value = DateTime.now();
      currentTimeString.value = currentTime.value.ddmmyyhhmmssFormat;
    } on ApiException catch (e) {
      machineLogList.value = [];
      switch (e.statusCode) {
        case 401:
          //  showErrorSnackbar('Unauthenticated. Login and Try again.');
          timer.cancel();
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: sp.refreshInterval), (timer) {
      getData();
    });
  }

  stopTimer() {
    if (timer.isActive) {
      timer.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    stopTimer();
  }
}
