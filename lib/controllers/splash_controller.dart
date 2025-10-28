import 'package:package_info_plus/package_info_plus.dart';
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

  checkUser() async {
    //await getSettings();
    Future.delayed(Duration(seconds: 2), () {
      if (sp.userToken.isNotEmpty) {
        Get.offAll(() => HomeScreen());
      } else {
        Get.offAll(() => LoginScreen());
      }
    });
  }
}
