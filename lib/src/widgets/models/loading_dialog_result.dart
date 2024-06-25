import 'package:equatable/equatable.dart';

class LoadingDialogResult<T> with EquatableMixin {
  final T? result;
  final dynamic error;
  final StackTrace? stackTrace;

  LoadingDialogResult({this.result, this.error, this.stackTrace});

  @override
  List<Object?> get props => [
        result,
        error,
        stackTrace,
      ];
}
