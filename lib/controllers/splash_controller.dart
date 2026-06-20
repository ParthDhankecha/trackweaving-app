import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trackweaving/repository/dashboard_repo.dart';
import 'package:trackweaving/screens/auth_screens/login_screen.dart';
import 'package:trackweaving/screens/home/home_screen.dart';
import 'package:trackweaving/utils/shared_pref.dart';

class SplashController extends GetxController implements GetxService {
  final Sharedprefs sp;
  final DashboardRepo dashboardRepo;

  SplashController({required this.sp, required this.dashboardRepo});

  RxBool isLoading = false.obs;

  Future<Map<String, String>> checkPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    return {
      'appName': appName,
      'packageName': packageName,
      'version': version,
      'buildNumber': buildNumber,
    };
  }

  Future<void> checkUser() async {
    //await getSettings();
    Future.delayed(Duration(seconds: 2), () {
      if (sp.userToken.isNotEmpty) {
        print("Subscribed to ${sp.currentLoginId}");
        FirebaseMessaging.instance.subscribeToTopic(sp.currentLoginId);
        Get.offAll(() => HomeScreen());
      } else {
        Get.offAll(() => LoginScreen());
      }
    });
  }
}
