import 'package:flutter_texmunimx/controllers/home_controller.dart';
import 'package:flutter_texmunimx/controllers/login_controllers.dart';
import 'package:flutter_texmunimx/controllers/splash_controller.dart';
import 'package:flutter_texmunimx/repository/api_client.dart';
import 'package:flutter_texmunimx/repository/login_repo.dart';
import 'package:flutter_texmunimx/utils/app_const.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  ApiClient apiClient = ApiClient(baseUrl: AppConst.baseUrl);

  Get.lazyPut(() => Sharedprefs(pref: preferences));

  //repository
  Get.lazyPut(() => LoginRepo(apiClient: apiClient));

  //controllers
  Get.lazyPut(() => SplashController(sp: Get.find()));
  Get.lazyPut(
    () => LoginControllers(
      sp: Get.find<Sharedprefs>(),
      repo: Get.find<LoginRepo>(),
    ),
  );
  Get.lazyPut(() => HomeController(sp: Get.find()));
}
