import 'dart:convert';
import 'package:rakwa/main.dart';

class DataResult {
  int status;
  Map<String, dynamic>? data;

  DataResult({
    required this.status,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'data': data,
    };
  }

  factory DataResult.fromMap(Map<String, dynamic> map) {
    return DataResult(
      status: map['status'],
      data: (map.containsKey('data'))
          ? Map<String, dynamic>.from(map['data'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataResult.fromJson(String source) =>
      DataResult.fromMap(json.decode(source));
}

class LoadingWS {}

class WebServiceResult<T> {
  T? data;
  String message = MyApp.resources.strings.errorWS;
  WebServiceResultStatus status;
  int code = 0;
  String? additionalData = "Somthing went wrong !";

  WebServiceResult(
      {required this.status, this.additionalData, this.data, this.code = 0});

  WebServiceResult.withMessage(
      {required this.status,
      this.data,
      this.additionalData,
      required this.message,
      this.code = 0});

  WebServiceResult<T> copy({
    T? data,
    String? message,
    WebServiceResultStatus? status,
    int? code,
  }) {
    return WebServiceResult.withMessage(
      data: data ?? this.data,
      message: message ?? this.message,
      status: status ?? this.status,
      code: code ?? this.code,
    );
  }
}

enum WebServiceResultStatus { success, error, loading, unauthorized }

enum WebServiceCodeStatus {
  success,
  created,
  noContent,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  methodNotAllowed,
  errorItem,
  requestTimeOut,
  unprocessableEntity,
  serverError,
  badGatway,
  failed
}

extension WebServiceCodeStatusExtension on WebServiceCodeStatus {
  static WebServiceCodeStatus decode(int value) {
    switch (value) {
      case 200:
        return WebServiceCodeStatus.success;
      case 201:
        return WebServiceCodeStatus.created;
      case 204:
        return WebServiceCodeStatus.noContent;
      case 400:
        return WebServiceCodeStatus.badRequest;
      case 401:
        return WebServiceCodeStatus.unauthorized;
      case 403:
        return WebServiceCodeStatus.forbidden;
      case 404:
        return WebServiceCodeStatus.notFound;
      case 405:
        return WebServiceCodeStatus.methodNotAllowed;
      case 406:
        return WebServiceCodeStatus.errorItem;
      case 408:
        return WebServiceCodeStatus.requestTimeOut;
      case 409:
        return WebServiceCodeStatus.unauthorized;
      case 500:
        return WebServiceCodeStatus.serverError;
      case 422:
        return WebServiceCodeStatus.unprocessableEntity;
      case 502:
        return WebServiceCodeStatus.badGatway;
      default:
        return WebServiceCodeStatus.failed;
    }
  }
}

class ErrorString {
  String message;
  ErrorString({
    required this.message,
  });

  ErrorString copyWith({
    String? message,
  }) {
    return ErrorString(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'message': message});

    return result;
  }

  factory ErrorString.fromMap(Map<String, dynamic> map) {
    return ErrorString(
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorString.fromJson(String source) =>
      ErrorString.fromMap(json.decode(source));

  @override
  String toString() => 'ErrorString(message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ErrorString && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
