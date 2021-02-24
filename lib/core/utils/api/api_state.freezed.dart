// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'api_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$ApiStateTearOff {
  const _$ApiStateTearOff();

// ignore: unused_element
  Idle<T> idle<T>() {
    return Idle<T>();
  }

// ignore: unused_element
  Loading<T> loading<T>() {
    return Loading<T>();
  }

// ignore: unused_element
  Data<T> data<T>({@required T data}) {
    return Data<T>(
      data: data,
    );
  }

// ignore: unused_element
  Error<T> error<T>({@required NetworkExceptions error}) {
    return Error<T>(
      error: error,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $ApiState = _$ApiStateTearOff();

/// @nodoc
mixin _$ApiState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult idle(),
    @required TResult loading(),
    @required TResult data(T data),
    @required TResult error(NetworkExceptions error),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult idle(),
    TResult loading(),
    TResult data(T data),
    TResult error(NetworkExceptions error),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult idle(Idle<T> value),
    @required TResult loading(Loading<T> value),
    @required TResult data(Data<T> value),
    @required TResult error(Error<T> value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult idle(Idle<T> value),
    TResult loading(Loading<T> value),
    TResult data(Data<T> value),
    TResult error(Error<T> value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $ApiStateCopyWith<T, $Res> {
  factory $ApiStateCopyWith(
          ApiState<T> value, $Res Function(ApiState<T>) then) =
      _$ApiStateCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$ApiStateCopyWithImpl<T, $Res> implements $ApiStateCopyWith<T, $Res> {
  _$ApiStateCopyWithImpl(this._value, this._then);

  final ApiState<T> _value;
  // ignore: unused_field
  final $Res Function(ApiState<T>) _then;
}

/// @nodoc
abstract class $IdleCopyWith<T, $Res> {
  factory $IdleCopyWith(Idle<T> value, $Res Function(Idle<T>) then) =
      _$IdleCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$IdleCopyWithImpl<T, $Res> extends _$ApiStateCopyWithImpl<T, $Res>
    implements $IdleCopyWith<T, $Res> {
  _$IdleCopyWithImpl(Idle<T> _value, $Res Function(Idle<T>) _then)
      : super(_value, (v) => _then(v as Idle<T>));

  @override
  Idle<T> get _value => super._value as Idle<T>;
}

/// @nodoc
class _$Idle<T> with DiagnosticableTreeMixin implements Idle<T> {
  const _$Idle();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ApiState<$T>.idle()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'ApiState<$T>.idle'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Idle<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult idle(),
    @required TResult loading(),
    @required TResult data(T data),
    @required TResult error(NetworkExceptions error),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(data != null);
    assert(error != null);
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult idle(),
    TResult loading(),
    TResult data(T data),
    TResult error(NetworkExceptions error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult idle(Idle<T> value),
    @required TResult loading(Loading<T> value),
    @required TResult data(Data<T> value),
    @required TResult error(Error<T> value),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(data != null);
    assert(error != null);
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult idle(Idle<T> value),
    TResult loading(Loading<T> value),
    TResult data(Data<T> value),
    TResult error(Error<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class Idle<T> implements ApiState<T> {
  const factory Idle() = _$Idle<T>;
}

/// @nodoc
abstract class $LoadingCopyWith<T, $Res> {
  factory $LoadingCopyWith(Loading<T> value, $Res Function(Loading<T>) then) =
      _$LoadingCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$LoadingCopyWithImpl<T, $Res> extends _$ApiStateCopyWithImpl<T, $Res>
    implements $LoadingCopyWith<T, $Res> {
  _$LoadingCopyWithImpl(Loading<T> _value, $Res Function(Loading<T>) _then)
      : super(_value, (v) => _then(v as Loading<T>));

  @override
  Loading<T> get _value => super._value as Loading<T>;
}

/// @nodoc
class _$Loading<T> with DiagnosticableTreeMixin implements Loading<T> {
  const _$Loading();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ApiState<$T>.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'ApiState<$T>.loading'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Loading<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult idle(),
    @required TResult loading(),
    @required TResult data(T data),
    @required TResult error(NetworkExceptions error),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(data != null);
    assert(error != null);
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult idle(),
    TResult loading(),
    TResult data(T data),
    TResult error(NetworkExceptions error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult idle(Idle<T> value),
    @required TResult loading(Loading<T> value),
    @required TResult data(Data<T> value),
    @required TResult error(Error<T> value),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(data != null);
    assert(error != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult idle(Idle<T> value),
    TResult loading(Loading<T> value),
    TResult data(Data<T> value),
    TResult error(Error<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading<T> implements ApiState<T> {
  const factory Loading() = _$Loading<T>;
}

/// @nodoc
abstract class $DataCopyWith<T, $Res> {
  factory $DataCopyWith(Data<T> value, $Res Function(Data<T>) then) =
      _$DataCopyWithImpl<T, $Res>;
  $Res call({T data});
}

/// @nodoc
class _$DataCopyWithImpl<T, $Res> extends _$ApiStateCopyWithImpl<T, $Res>
    implements $DataCopyWith<T, $Res> {
  _$DataCopyWithImpl(Data<T> _value, $Res Function(Data<T>) _then)
      : super(_value, (v) => _then(v as Data<T>));

  @override
  Data<T> get _value => super._value as Data<T>;

  @override
  $Res call({
    Object data = freezed,
  }) {
    return _then(Data<T>(
      data: data == freezed ? _value.data : data as T,
    ));
  }
}

/// @nodoc
class _$Data<T> with DiagnosticableTreeMixin implements Data<T> {
  const _$Data({@required this.data}) : assert(data != null);

  @override
  final T data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ApiState<$T>.data(data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ApiState<$T>.data'))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Data<T> &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(data);

  @JsonKey(ignore: true)
  @override
  $DataCopyWith<T, Data<T>> get copyWith =>
      _$DataCopyWithImpl<T, Data<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult idle(),
    @required TResult loading(),
    @required TResult data(T data),
    @required TResult error(NetworkExceptions error),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(data != null);
    assert(error != null);
    return data(this.data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult idle(),
    TResult loading(),
    TResult data(T data),
    TResult error(NetworkExceptions error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (data != null) {
      return data(this.data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult idle(Idle<T> value),
    @required TResult loading(Loading<T> value),
    @required TResult data(Data<T> value),
    @required TResult error(Error<T> value),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(data != null);
    assert(error != null);
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult idle(Idle<T> value),
    TResult loading(Loading<T> value),
    TResult data(Data<T> value),
    TResult error(Error<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class Data<T> implements ApiState<T> {
  const factory Data({@required T data}) = _$Data<T>;

  T get data;
  @JsonKey(ignore: true)
  $DataCopyWith<T, Data<T>> get copyWith;
}

/// @nodoc
abstract class $ErrorCopyWith<T, $Res> {
  factory $ErrorCopyWith(Error<T> value, $Res Function(Error<T>) then) =
      _$ErrorCopyWithImpl<T, $Res>;
  $Res call({NetworkExceptions error});

  $NetworkExceptionsCopyWith<$Res> get error;
}

/// @nodoc
class _$ErrorCopyWithImpl<T, $Res> extends _$ApiStateCopyWithImpl<T, $Res>
    implements $ErrorCopyWith<T, $Res> {
  _$ErrorCopyWithImpl(Error<T> _value, $Res Function(Error<T>) _then)
      : super(_value, (v) => _then(v as Error<T>));

  @override
  Error<T> get _value => super._value as Error<T>;

  @override
  $Res call({
    Object error = freezed,
  }) {
    return _then(Error<T>(
      error: error == freezed ? _value.error : error as NetworkExceptions,
    ));
  }

  @override
  $NetworkExceptionsCopyWith<$Res> get error {
    if (_value.error == null) {
      return null;
    }
    return $NetworkExceptionsCopyWith<$Res>(_value.error, (value) {
      return _then(_value.copyWith(error: value));
    });
  }
}

/// @nodoc
class _$Error<T> with DiagnosticableTreeMixin implements Error<T> {
  const _$Error({@required this.error}) : assert(error != null);

  @override
  final NetworkExceptions error;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ApiState<$T>.error(error: $error)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ApiState<$T>.error'))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Error<T> &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  $ErrorCopyWith<T, Error<T>> get copyWith =>
      _$ErrorCopyWithImpl<T, Error<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult idle(),
    @required TResult loading(),
    @required TResult data(T data),
    @required TResult error(NetworkExceptions error),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(data != null);
    assert(error != null);
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult idle(),
    TResult loading(),
    TResult data(T data),
    TResult error(NetworkExceptions error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult idle(Idle<T> value),
    @required TResult loading(Loading<T> value),
    @required TResult data(Data<T> value),
    @required TResult error(Error<T> value),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(data != null);
    assert(error != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult idle(Idle<T> value),
    TResult loading(Loading<T> value),
    TResult data(Data<T> value),
    TResult error(Error<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error<T> implements ApiState<T> {
  const factory Error({@required NetworkExceptions error}) = _$Error<T>;

  NetworkExceptions get error;
  @JsonKey(ignore: true)
  $ErrorCopyWith<T, Error<T>> get copyWith;
}
