import 'package:flutter/material.dart';
import 'package:future_loading_dialog/src/widgets/models/loading_dialog_result.dart';

class LoadingDialog<T> extends StatefulWidget {
  final Widget loadingIcon;
  final String loadingTitle;
  final String errorTitle;
  final double? maxWidth;
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
  final bool isMobileResponsive;
  final Color? backgroundErrorDialog;

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
    this.maxWidth,
    this.errorBackLabel,
    this.errorNextLabel,
    this.loadingTitleStyle,
    this.errorTitleStyle,
    this.errorDescriptionStyle,
    this.errorBackLabelStyle,
    this.errorNextLabelStyle,
    this.backgroundNextLabel,
    this.backgroundBackLabel,
    this.isMobileResponsive = false,
    this.backgroundErrorDialog,
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
    if (exception != null) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: widget.isMobileResponsive ? double.infinity : 448,
                margin: EdgeInsets.symmetric(
                  horizontal: widget.isMobileResponsive ? 24.0 : 36,
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundErrorDialog,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      widget.isMobileResponsive ? 24 : 16,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                      spreadRadius: 3,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isMobileResponsive) ...[
                      const SizedBox(height: 24),
                    ] else
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          right: 8,
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: const SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.isMobileResponsive ? 24.0 : 36,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.errorTitle,
                            style: widget.errorTitleStyle,
                          ),
                          SizedBox(
                            height: widget.isMobileResponsive ? 16 : 27,
                          ),
                          Text(
                            defaultOnError(exception),
                            style: widget.errorDescriptionStyle,
                          ),
                          SizedBox(
                            height: widget.isMobileResponsive ? 24 : 65,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  overlayColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  splashFactory: NoSplash.splashFactory,
                                  enableFeedback: false,
                                  backgroundColor: WidgetStateProperty.all(
                                    widget.backgroundBackLabel,
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  widget.errorBackLabel ?? '',
                                  style: widget.errorBackLabelStyle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                style: ButtonStyle(
                                  overlayColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  splashFactory: NoSplash.splashFactory,
                                  enableFeedback: false,
                                  backgroundColor: WidgetStateProperty.all(
                                    widget.backgroundNextLabel,
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  widget.errorNextLabel ?? '',
                                  style: widget.errorNextLabelStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: widget.isMobileResponsive ? 24.0 : 36.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth ?? 400,
        ),
        child: Column(
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
        ),
      ),
    );
  }
}
