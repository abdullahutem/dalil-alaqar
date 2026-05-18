class ErrorModel {
  final int status;
  final String errorMessage;

  ErrorModel({required this.status, required this.errorMessage});

  factory ErrorModel.fromJson(Map jsonData) {
    return ErrorModel(
      errorMessage:
          jsonData["Message"] ??
          jsonData["error"] ??
          jsonData["message"] ??
          "Unknown error",
      status: jsonData["status"] ?? 0,
    );
  }
}
