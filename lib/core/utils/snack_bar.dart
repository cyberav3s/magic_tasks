import 'package:flutter/material.dart';
import 'package:magic_tasks/core/widgets/app_snackbar.dart';

final snackbarKey = GlobalKey<AppSnackbarState>();

/// Snack bar to show messages to the user.
void openSnackbar(
  SnackbarMessage message, {
  bool clearIfQueue = false,
  bool undismissable = false,
}) {
  snackbarKey.currentState?.post(
    message,
    clearIfQueue: clearIfQueue,
    undismissable: undismissable,
  );
}
/// Closes all snack bars.
void closeSnackbars() => snackbarKey.currentState?.closeAll();

void showCurrentlyUnavailableFeature({bool clearIfQueue = true}) =>
    openSnackbar(
      const SnackbarMessage.error(
        title: 'Feature is not available!',
        description:
            'We are trying our best to implement it as fast as possible.',
        icon: Icons.error_outline,
      ),
      clearIfQueue: clearIfQueue,
    );
