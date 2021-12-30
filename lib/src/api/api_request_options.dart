class ApiRequestOptions {
  ApiRequestOptions({
    required this.baseUrl,
    required this.path,
    required this.method,
    this.headers,
  });

  String baseUrl;
  String path;
  String method;
  Map<String, dynamic>? headers;
}
