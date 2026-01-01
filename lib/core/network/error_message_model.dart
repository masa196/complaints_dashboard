// lib/core/network/error_message_model.dart
import 'package:equatable/equatable.dart';

class ErrorMessageModel extends Equatable {
  final String message;
  final Map<String, dynamic>? errors;
  final int? retryAfterSeconds;

  const ErrorMessageModel({
    required this.message,
    this.errors,
    this.retryAfterSeconds,
  });

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    String msg = "";
    Map<String, dynamic> extractedErrors = {};
    int? retrySec;

    // -------------------------------------------------------------------
    // 1. محاولة قراءة message مباشرة
    // -------------------------------------------------------------------
    if (json["message"] is String) {
      msg = json["message"].toString().trim();
    }

    // استخراج عدد الثواني من الرسالة في حالة 429
    if (json["status_code"] == 429 && msg.contains("seconds")) {
      final regex = RegExp(r'(\d+)\s*seconds');
      final match = regex.firstMatch(msg);
      if (match != null) {
        retrySec = int.tryParse(match.group(1)!);
      }
    }


    // -------------------------------------------------------------------
    // 2. محاولة قراءة errors الرسمية (Laravel style)
    // -------------------------------------------------------------------
    if (json["errors"] is Map) {
      extractedErrors = Map<String, dynamic>.from(json["errors"]);
    }

    // -------------------------------------------------------------------
    // 3. إذا كانت errors الرسمية غير موجودة:
    //    قد يعيد السيرفر المفتاح هكذا:
    //    "errors": "Incorrect password"
    // -------------------------------------------------------------------
    if (json["errors"] is String) {
      extractedErrors["general"] = json["errors"];
    }

    // -------------------------------------------------------------------
    // 4. Laravel قد يعيد error بدون message/errors
    // -------------------------------------------------------------------
    if (json["error"] is String) {
      extractedErrors["general"] = json["error"];
    }

    // -------------------------------------------------------------------
    // 5. إذا لم يوجد errors → نبحث عن مفاتيح خطأ مباشرة مثل:
    //    { "email": "Email not found" }
    //    { "password": ["Incorrect password"] }
    // -------------------------------------------------------------------
    if (extractedErrors.isEmpty) {
      json.forEach((key, value) {
        if (key != "success" &&
            key != "message" &&
            key != "data" &&
            key != "status_code" &&
            key != "errors") {
          extractedErrors[key] = value;
        }
      });
    }

    // -------------------------------------------------------------------
    // 6. إذا وجدنا errors → نتجاهل الـ message
    // -------------------------------------------------------------------
    if (extractedErrors.isNotEmpty) {
      msg = "";
    }

    // -------------------------------------------------------------------
    // 7. fallback message إذا كل شيء فارغ
    // -------------------------------------------------------------------
    if (msg.isEmpty && extractedErrors.isEmpty) {
      msg = "حدث خطأ غير معروف";
    }

    return ErrorMessageModel(
      message: msg,
      errors: extractedErrors.isNotEmpty ? extractedErrors : null,
      retryAfterSeconds: retrySec,
    );
  }

  // -------------------------------------------------------------------
  // 🔥 formatter النهائي الموحد لجميع الأخطاء
  // -------------------------------------------------------------------
  String userFriendlyMessage() {
    if (errors != null && errors!.isNotEmpty) {
      final sb = StringBuffer();

      errors!.forEach((key, value) {
        // قائمة رسائل
        if (value is List) {
          for (var v in value) {
            sb.writeln("- $v");
          }
        }
        // رسالة واحدة
        else {
          sb.writeln("- $value");
        }
      });

      return sb.toString().trim();
    }

    return message.isNotEmpty ? message : "حدث خطأ غير معروف";
  }

  @override
  List<Object?> get props => [message, errors, retryAfterSeconds];
}
