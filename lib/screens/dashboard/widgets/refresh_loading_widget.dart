import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefreshLoadingWidget extends StatefulWidget {
  final RxBool isLoading;

  const RefreshLoadingWidget({super.key, required this.isLoading});

  @override
  State<RefreshLoadingWidget> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<RefreshLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.isLoading.value) {
        return RotationTransition(
          turns: _animationController,
          child: const Icon(Icons.refresh),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
