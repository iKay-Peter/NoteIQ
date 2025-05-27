import 'package:flutter/material.dart';
import 'package:notiq/app/config/routes/app_routes.dart';
import 'package:notiq/app/exception_handler/app_exceptions.dart';
import 'package:notiq/app/utils/generic_response.dart';
import 'package:notiq/ui/widgets/notification/toastification.dart';

typedef ProviderCall<T> = Future<GenericResponse<T>> Function();

Future<void> handleAction<T>({
  required BuildContext context,
  required ProviderCall<T> call,
  String loadingMessage = "Loading...",
  void Function(T? data)? onSuccess,
  void Function()? onError,
  void Function(dynamic error)? onException,
  bool navigateOnNetworkError = true,
  bool showSuccessNotification = true,
  bool showErrorNotification = true,
}) async {
  try {
    final response = await call();

    if (response.isSuccess) {
      if (showSuccessNotification) {
        ShowNotification.success(context, null, response.message);
      }
      if (onSuccess != null) onSuccess(response.data);
    } else {
      if (showErrorNotification) {
        ShowNotification.error(context, null, response.message);
      }
      if (onError != null) onError();
    }
  } catch (e) {
    ShowNotification.error(context, null, 'Unexpected error occurred: $e');
    if (onException != null) onException(e);
  }
}
