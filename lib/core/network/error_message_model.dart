import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

class ErrorMessageModel extends Equatable {
  final String message;
  final Map<String, dynamic>? errors;
  final int? retryAfterSeconds;

  const ErrorMessageModel({
    required this.message,
    this.errors,
    this.retryAfterSeconds,
  });

  static ErrorMessageModel fromDioError(dynamic e) {
    if (e is! DioException) return const ErrorMessageModel(message: "حدث خطأ غير متوقع");
    if (e.response != null) return ErrorMessageModel.handleResponse(e.response!);

    switch (e.type) {
      case DioExceptionType.connectionTimeout: return const ErrorMessageModel(message: "انتهت مهلة الاتصال بالسيرفر");
      case DioExceptionType.receiveTimeout: return const ErrorMessageModel(message: "السيرفر يستغرق وقتاً طويلاً للرد");
      case DioExceptionType.connectionError: return const ErrorMessageModel(message: "لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة");
      default: return const ErrorMessageModel(message: "حدث خطأ أثناء الاتصال بالسيرفر");
    }
  }

  static ErrorMessageModel handleResponse(Response response) {
    if (response.data is Map) {
      return ErrorMessageModel.fromJson(Map<String, dynamic>.from(response.data));
    } else {
      return ErrorMessageModel.fromHtml(response.data.toString());
    }
  }

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    String msg = "";
    Map<String, dynamic> extractedErrors = {};
    int? retrySec;

    if (json["message"] != null) {
      msg = json["message"].toString().trim();
    } else if (json["error"] != null) {
      msg = json["error"].toString().trim();
    }


    bool isRateLimit = msg.toLowerCase().contains("too many") ||
        msg.toLowerCase().contains("attempts") ||
        msg.toLowerCase().contains("requests");

    if (isRateLimit && msg.contains("seconds")) {
      final regex = RegExp(r'(\d+)');
      final match = regex.firstMatch(msg);
      if (match != null) retrySec = int.tryParse(match.group(1)!);
    }

    if (json["errors"] is Map) {
      extractedErrors = Map<String, dynamic>.from(json["errors"]);
    }

    if (extractedErrors.isNotEmpty && !isRateLimit) {
      msg = "";
    }

    if (msg.isEmpty && extractedErrors.isEmpty) {
      msg = "حدث خطأ غير معروف";
    }

    return ErrorMessageModel(
      message: msg,
      errors: extractedErrors.isNotEmpty ? extractedErrors : null,
      retryAfterSeconds: retrySec,
    );
  }

  factory ErrorMessageModel.fromHtml(String htmlBody) {
    if (htmlBody.contains("Too Many Requests") || htmlBody.contains("429")) {
      return const ErrorMessageModel(message: "Too Many Attempts. Please try again later.");
    }
    final match = RegExp(r'<title>(.*?)</title>').firstMatch(htmlBody);
    if (match != null && match.group(1) != null) {
      return ErrorMessageModel(message: match.group(1)!);
    }
    return const ErrorMessageModel(message: "استجابة غير صالحة من السيرفر");
  }

  String userFriendlyMessage() {
    if (errors != null && errors!.isNotEmpty) {
      final sb = StringBuffer();
      errors!.forEach((key, value) {
        if (value is List) sb.writeln(value.join("\n"));
        else sb.writeln("- $value");
      });
      return sb.toString().trim();
    }
    return message.isNotEmpty ? message : "حدث خطأ غير معروف";
  }

  @override
  List<Object?> get props => [message, errors, retryAfterSeconds];
}