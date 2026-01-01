class ApiConstants {
  static const String baseUrl = "http://127.0.0.1:8000";
  static const String loginEndpoint = "/api/admin/Login";
  static const String logoutEndpoint = "/api/admin/logout";
  static const String createEmailEndpoint = "/api/admin/register";

  static String get loginUrl => "$baseUrl$loginEndpoint";
  static String get logoutUrl => "$baseUrl$logoutEndpoint";
  static String get createEmailUrl => "$baseUrl$createEmailEndpoint";
}
