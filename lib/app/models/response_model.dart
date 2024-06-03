class ResponseModel {
  ResponseModel({
    required this.body,
    required this.statusCode,
    required this.success,
    this.message,
  });

  final dynamic body;
  final int? statusCode;
  final bool success;
  final String? message;
}
