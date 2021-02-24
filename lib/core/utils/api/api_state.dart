import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'network_exceptions.dart';

part 'api_state.freezed.dart';

@freezed
abstract class ApiState<T> with _$ApiState<T> {
  const factory ApiState.idle() = Idle<T>;
  const factory ApiState.loading() = Loading<T>;
  const factory ApiState.data({@required T data}) = Data<T>;
  const factory ApiState.error({@required NetworkExceptions error}) =
      Error<T>;
}
