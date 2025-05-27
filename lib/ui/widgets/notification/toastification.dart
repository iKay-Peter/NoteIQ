import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ShowNotification {
  static void success(context, String? title, String? message) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(title ?? "Success"),
      description: Text(message ?? ""),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return ScaleTransition(scale: animation, child: child);
      },
      dismissDirection: DismissDirection.up,
      boxShadow: highModeShadow,
      dragToClose: true,
      showProgressBar: true,
      applyBlurEffect: true,
    );
  }

  static void info(context, String? title, String? message) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      title: Text(title ?? "Info"),
      description: Text(message ?? ""),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return ScaleTransition(scale: animation, child: child);
      },
      dismissDirection: DismissDirection.up,
      boxShadow: highModeShadow,
      dragToClose: true,
      showProgressBar: true,
      applyBlurEffect: true,
    );
  }

  static void warning(context, String? title, String? message) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
      title: Text(title ?? "Warning"),
      description: Text(message ?? ""),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return ScaleTransition(scale: animation, child: child);
      },
      dismissDirection: DismissDirection.up,
      boxShadow: highModeShadow,
      dragToClose: true,
      showProgressBar: true,
      applyBlurEffect: true,
    );
  }

  static void error(context, String? title, String? message) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(title ?? "Error"),
      description: Text(message ?? "An error occurred."),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      boxShadow: highModeShadow,
      animationBuilder: (context, animation, alignment, child) {
        return ScaleTransition(scale: animation, child: child);
      },
      dismissDirection: DismissDirection.up,
      dragToClose: true,
      showProgressBar: true,
      applyBlurEffect: true,
    );
  }
}
