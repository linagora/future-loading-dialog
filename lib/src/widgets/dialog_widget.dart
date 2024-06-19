import 'package:flutter/material.dart';
import 'package:future_loading_dialog/src/widgets/models/loading_dialog_result.dart';

class LoadingDialog<T> extends StatefulWidget {
  final Widget loadingIcon;
  final String loadingTitle;
  final String errorTitle;
  final Color? backgroundNextLabel;
  final Color? backgroundBackLabel;
  final String? errorBackLabel;
  final String? errorNextLabel;
  final TextStyle? loadingTitleStyle;
  final TextStyle? errorTitleStyle;
  final TextStyle? errorDescriptionStyle;
  final TextStyle? errorBackLabelStyle;
  final TextStyle? errorNextLabelStyle;
  final Future<T> Function() future;
  final String Function(dynamic exception)? onError;

  // ignore: prefer_function_declarations_over_variables
  static String Function(dynamic exception) defaultOnError =
      (exception) => exception.toString();

  const LoadingDialog({
    Key? key,
    required this.loadingIcon,
    required this.future,
    this.loadingTitle = 'Loading...',
    this.errorTitle = 'Oops, something went wrong.',
    this.onError,
    this.errorBackLabel,
    this.errorNextLabel,
    this.loadingTitleStyle,
    this.errorTitleStyle,
    this.errorDescriptionStyle,
    this.errorBackLabelStyle,
    this.errorNextLabelStyle,
    this.backgroundNextLabel,
    this.backgroundBackLabel,
  }) : super(key: key);

  @override
  LoadingDialogState<T> createState() => LoadingDialogState<T>();
}

class LoadingDialogState<T> extends State<LoadingDialog> {
  dynamic exception;
  StackTrace? stackTrace;

  // ignore: prefer_function_declarations_over_variables
  static String Function(dynamic exception) defaultOnError =
      (exception) => exception.toString();

  @override
  void initState() {
    super.initState();
    widget.future().then(
          (result) => Navigator.of(context).pop<LoadingDialogResult<T>>(
            LoadingDialogResult(
              result: result,
            ),
          ),
          onError: (e, s) => setState(
            () {
              exception = e;
              stackTrace = s;
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: exception == null ? Colors.transparent : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: exception == null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.loadingIcon,
                const SizedBox(height: 24),
                Text(
                  widget.loadingTitle,
                  style: widget.loadingTitleStyle,
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 24,
                    bottom: 48,
                  ),
                  child: Text(
                    widget.errorTitle,
                    style: widget.errorTitleStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    defaultOnError(exception),
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: widget.errorDescriptionStyle,
                  ),
                ),
              ],
            ),
      actions: exception == null
          ? null
          : [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: widget.backgroundBackLabel,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    widget.errorBackLabel ?? '',
                    style: widget.errorBackLabelStyle,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop<LoadingDialogResult<T>>(
                  LoadingDialogResult(
                    error: exception,
                    stackTrace: stackTrace,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: widget.backgroundNextLabel,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    widget.errorNextLabel ?? '',
                    style: widget.errorNextLabelStyle,
                  ),
                ),
              ),
            ],
    );
  }
}
