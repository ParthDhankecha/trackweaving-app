import 'dart:developer';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:trackweaving/repository/api_exception.dart';
import 'package:trackweaving/repository/dashboard_repo.dart';
import 'package:trackweaving/screens/auth_screens/login_screen.dart';
import 'package:trackweaving/screens/home/home_screen.dart';
import 'package:trackweaving/utils/shared_pref.dart';
import 'package:get/get.dart';

class SplashController extends GetxController implements GetxService {
  final Sharedprefs sp;
  final DashboardRepo dashboardRepo;

  SplashController({required this.sp, required this.dashboardRepo});

  RxBool isLoading = false.obs;

  Future<void> checkPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    log('App Name: $appName');
    log('Package Name: $packageName');
    log('Version: $version');
    log('Build Number: $buildNumber');

    //sp.appVersion = version;
  }

  //get configurations
  Future<void> getSettings() async {
    await checkPackageInfo();
    try {
      isLoading.value = true;
      var data = await dashboardRepo.getConfiguration();
      sp.refreshInterval = data['refreshInterval'];
    } on ApiException catch (e) {
      //showErrorSnackbar('Remote Settings not Loaded. Try again');
      log('getSettings : error : $e');
    } finally {
      isLoading.value = false;
    }
  }

  checkUser() async {
    sp.hostUrl = '192.168.29.129:3000';

    await getSettings();
    Future.delayed(Duration(seconds: 2), () {
      if (sp.userToken.isNotEmpty) {
        Get.offAll(() => HomeScreen());
      } else {
        Get.off(() => LoginScreen());
      }
    });
  }
}
