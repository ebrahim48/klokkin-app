import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class QuickAlertHelper {
  static void showSuccessAlert(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: message
    );
  }

  static void showErrorAlert(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: message
    );
  }

  static void showInfoAlert(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      text: message
    );
  }

  static void showLoadingAlert(BuildContext context, {String title = 'Loading...'}) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: title
    );
  }
}
