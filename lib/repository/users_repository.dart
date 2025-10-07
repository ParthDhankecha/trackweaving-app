import 'dart:convert';

import 'package:get/get.dart';
import 'package:trackweaving/models/login_auth_model.dart';
import 'package:trackweaving/models/users_list_response.dart';
import 'package:trackweaving/repository/api_client.dart';
import 'package:trackweaving/utils/app_const.dart';
import 'package:trackweaving/utils/shared_pref.dart';

class UsersRepository extends GetxService {
  // This class can be expanded to include methods for interacting with a backend or database
  // to fetch, add, update, and delete user data.
  Sharedprefs sp = Get.find<Sharedprefs>();
  ApiClient apiClient = Get.find<ApiClient>();

  Future<List<UserModel>> getUsers() async {
    String endPoint = AppConst.getUrl(AppConst.users);
    List<UserModel> users = [];

    var data = await apiClient.request(
      endPoint,
      headers: {'Authorization': sp.userToken},
    );

    if (data != null) {
      UsersListResponse response = usersListResponseFromMap(data);
      users = response.data;
    }

    return users;
  }

  Future<bool> createUser({
    required String fullname,
    required String userName,
    required String password,
    String? email,
    String? mobile,
    bool isActive = true,
  }) async {
    final body = {
      "fullname": fullname,
      "userName": userName,
      "password": password,
      "email": email,
      "mobile": mobile,
      "isActive": isActive,
    };

    final response = await apiClient.request(
      AppConst.getUrl(AppConst.addUser),
      method: ApiType.post,
      body: body,
      headers: {'authorization': sp.userToken},
    );

    bool success = jsonDecode(response)['code'] == 'OK';
    return success;
  }

  Future<bool> updateUser({
    required String id,
    required String fullname,
    required String userName,
    String? password,
    String? email,
    String? mobile,
    bool isActive = true,
  }) async {
    final body = {
      "fullname": fullname,
      "userName": userName,
      if (password != null) "password": password,
      if (email != null) "email": email,
      if (mobile != null) "mobile": mobile,
      "isActive": isActive,
    };

    final response = await apiClient.request(
      AppConst.getUrl('${AppConst.addUser}/$id'),
      method: ApiType.put,
      body: body,
      headers: {'authorization': sp.userToken},
    );
    bool success = jsonDecode(response)['code'] == 'OK';
    return success;
  }
}
