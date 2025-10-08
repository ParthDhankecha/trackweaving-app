import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/custom_progress_btn_.dart';
import 'package:trackweaving/common_widgets/main_btn.dart';
import 'package:trackweaving/controllers/machine_parts_controller.dart';
import 'package:get/get.dart';
import 'package:trackweaving/controllers/users_controller.dart';
import 'package:trackweaving/models/users_list_response.dart';
import 'package:trackweaving/screens/settings_screen/users/widgets/user_active_switch.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:trackweaving/utils/date_formate_extension.dart';

class AddUpdateUsersScreen extends StatefulWidget {
  final UserModel? userModel;
  final int index;
  const AddUpdateUsersScreen({super.key, this.userModel, this.index = -1});

  @override
  State<AddUpdateUsersScreen> createState() => _AddUpdateUsersScreenState();
}

class _AddUpdateUsersScreenState extends State<AddUpdateUsersScreen> {
  UsersController controller = Get.find<UsersController>();
  TextEditingController userFullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userMobileController = TextEditingController();
  RxBool isActive = false.obs;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    if (widget.userModel != null) {
      userFullNameController.text = widget.userModel?.fullname ?? '';
      userNameController.text = widget.userModel?.userName ?? '';
      userEmailController.text = widget.userModel?.email ?? '';
      userMobileController.text = widget.userModel?.mobile ?? '';
      isActive.value = widget.userModel?.isActive ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,

      appBar: AppBar(
        title: Text(
          widget.userModel != null ? 'edit_user'.tr : 'create_user'.tr,
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Divider(height: 1, thickness: 0.2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildInputField(
                      title: '${'user_full_name'.tr} *',
                      hintText: 'user_full_name'.tr,
                      controller: userFullNameController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Name Field can not Empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    _buildPhoneField(
                      title: 'user_name'.tr,
                      hintText: 'user_name'.tr,
                      controller: userNameController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'UserName Field can not Empty';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    _buildPhoneField(
                      title: 'password'.tr,
                      hintText: 'password'.tr,
                      controller: userPasswordController,
                      validator: (String? value) {
                        if (widget.userModel == null &&
                            (value == null || value.isEmpty)) {
                          return 'Password Field can not Empty';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    _buildPhoneField(
                      title: 'mobile'.tr,
                      hintText: 'mobile'.tr,
                      controller: userMobileController,
                      validator: (String? value) {
                        if (value!.isNotEmpty) {
                          if (value.length != 10) {
                            return 'Phone must be 10 Digit Number';
                          }
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    _buildInputField(
                      title: 'email'.tr,
                      hintText: 'email'.tr,
                      controller: userEmailController,
                      inputType: TextInputType.emailAddress,
                      validator: (String? value) {
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => UserActiveSwitch(
                        isActive: isActive.value,
                        onChanged: (value) {
                          isActive.value = value;
                        },
                      ),
                    ),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Obx(
                          () => controller.isLoading.value
                              ? CustomProgressBtn()
                              : MainBtn(
                                  label: widget.userModel == null
                                      ? 'save'.tr
                                      : 'update'.tr,
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      onSaveOrUpdate();
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSaveOrUpdate() {
    if (widget.userModel == null) {
      // Create new user
      controller
          .createUser(
            fullname: userFullNameController.text.trim(),
            userName: userNameController.text.trim(),
            password: userPasswordController.text.trim(),
            email: userEmailController.text.trim(),
            mobile: userMobileController.text.trim(),
            isActive: isActive.value,
          )
          .then((success) {
            print('User creation success: $success');
            if (success) {
              Get.back();
              clearData();
            }
          });
    } else {
      controller
          .updateUser(
            id: widget.userModel?.id ?? '',
            fullname: userFullNameController.text.trim(),
            userName: userNameController.text.trim(),
            password: userPasswordController.text.trim(),
            email: userEmailController.text.trim(),
            mobile: userMobileController.text.trim(),
            isActive: isActive.value,
          )
          .then((success) {
            print('User update success: $success');
            if (success) {
              Get.back();
              clearData();
            }
          });
    }
  }

  void clearData() {
    userFullNameController.clear();
    userNameController.clear();
    userPasswordController.clear();
    userEmailController.clear();
    userMobileController.clear();
    isActive.value = false;
  }

  Widget _buildDateField(
    String title,
    DateTime selectedDate,
    ValueChanged<DateTime> onDateSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        TextFormField(
          readOnly: true,
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null && pickedDate != selectedDate) {
              onDateSelected(pickedDate);
            }
          },
          controller: TextEditingController(text: selectedDate.ddmmyyFormat2),
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            suffixIcon: const Icon(Icons.calendar_month, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String? value) validator,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        TextFormField(
          keyboardType: inputType,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            // labelText: title,
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String? value) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        TextFormField(
          keyboardType: TextInputType.phone,
          controller: controller,
          validator: validator,
          maxLength: 10,

          decoration: InputDecoration(
            counter: SizedBox.shrink(),
            // labelText: title,
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
