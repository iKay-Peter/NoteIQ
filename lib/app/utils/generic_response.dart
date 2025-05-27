class GenericResponse<T> {
  final bool isSuccess;
  final String message;
  final T? data;

  GenericResponse({required this.isSuccess, required this.message, this.data});
  factory GenericResponse.fromJson(Map<String, dynamic> json) {
    return GenericResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? 'Unknown error',
      data: json['data'],
    );
  }
}
