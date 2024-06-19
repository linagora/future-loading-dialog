// Copyright (c) 2020 Famedly
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:future_loading_dialog/src/widgets/dialog_widget.dart';
import 'package:future_loading_dialog/src/widgets/models/loading_dialog_result.dart';

/// Displays a loading dialog which reacts to the given [future]. The dialog
/// will be dismissed and the value will be returned when the future completes.
/// If an error occured, then [onError] will be called and this method returns
/// null. Set [title] and [backLabel] to controll the look and feel or set
/// [LoadingDialog.defaultTitle], [LoadingDialog.defaultBackLabel] and
/// [LoadingDialog.defaultOnError] to have global preferences.
Future<LoadingDialogResult<T>> showFutureLoadingDialog<T>({
  required BuildContext context,
  required Future<T> Function() future,
  required Widget loadingIcon,
  required String loadingTitle,
  required String errorTitle,
  required String errorDescription,
  Color? barrierColor,
  Color? backgroundNextLabel,
  Color? backgroundBackLabel,
  String? errorBackLabel,
  String? errorNextLabel,
  TextStyle? loadingTitleStyle,
  TextStyle? errorTitleStyle,
  TextStyle? errorDescriptionStyle,
  TextStyle? errorBackLabelStyle,
  TextStyle? errorNextLabelStyle,
  String Function(dynamic exception)? onError,
  bool barrierDismissible = false,
}) async {
  final result = await showDialog<LoadingDialogResult<T>>(
    context: context,
    barrierColor: barrierColor ?? Colors.black.withOpacity(0.3),
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) => LoadingDialog<T>(
      future: future,
      errorTitle: errorTitle,
      errorBackLabel: errorBackLabel,
      onError: onError,
      backgroundBackLabel: backgroundBackLabel,
      backgroundNextLabel: backgroundNextLabel,
      loadingIcon: loadingIcon,
      loadingTitle: loadingTitle,
      errorDescription: errorDescription,
      errorNextLabel: errorNextLabel,
      loadingTitleStyle: loadingTitleStyle,
      errorTitleStyle: errorTitleStyle,
      errorDescriptionStyle: errorDescriptionStyle,
      errorBackLabelStyle: errorBackLabelStyle,
      errorNextLabelStyle: errorNextLabelStyle,
    ),
  );
  return result ??
      LoadingDialogResult(
        error: Exception('FutureDialog canceled'),
        stackTrace: StackTrace.current,
      );
}
