import 'package:flutter_texmunimx/controllers/home_controller.dart';
import 'package:flutter_texmunimx/controllers/login_controllers.dart';
import 'package:flutter_texmunimx/controllers/splash_controller.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => Sharedprefs(pref: preferences));

  //controllers
  Get.lazyPut(() => SplashController(sp: Get.find()));
  Get.lazyPut(() => LoginControllers(sp: Get.find<Sharedprefs>()));
  Get.lazyPut(() => HomeController(sp: Get.find()));
}
