import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

mixin ApiServiceShowError {
  displayError(DioError dioError, BuildContext context) {
    var message = dioError.response?.data is Map<dynamic, dynamic>
        ? (dioError.response?.data['error'] ??
            dioError.error.toString() ??
            'unknown error')
        : dioError.response?.data ?? "";
    showToastNotification(
      context,
      style: ToastNotificationStyleType.DANGER,
      title: "Network Error",
      icon: Icons.error_outline,
      description: message,
    );
  }
}
