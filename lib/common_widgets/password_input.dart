import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';
import 'package:get/get.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.labelText = 'Password',
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  // Observable to manage password visibility state
  final RxBool _isPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        controller: widget.controller,
        obscureText: !_isPasswordVisible.value,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: 'Enter your password',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          hintStyle: TextStyle(color: AppColors.blackColor),
          labelStyle: TextStyle(color: AppColors.blackColor),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              _isPasswordVisible.value = !_isPasswordVisible.value;
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters long';
          }
          return null;
        },
      ),
    );
  }
}
