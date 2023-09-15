import 'package:http/http.dart' as http;
import 'package:cancellation_token_http/http.dart' as cancellable_http;

class HttpRequestException implements Exception {
  const HttpRequestException(this.method, this.url, this.statusCode, this.body);

  final String method;
  final String url;

  final int statusCode;
  final String body;

  @override
  String toString() {
    return 'HttpRequestException($method : "$url", $statusCode)';
  }
}

extension HttpResponseExtensions on http.Response {
  void ensureSuccessStatusCode() {
    if (statusCode >= 200 && statusCode <= 299) {
      return;
    }

    throw HttpRequestException(
        request?.method ?? '', request?.url.toString() ?? '', statusCode, body);
  }
}

extension CancellableHttpResponseExtensions on cancellable_http.Response {
  void ensureSuccessStatusCode() {
    if (statusCode >= 200 && statusCode <= 299) {
      return;
    }

    throw HttpRequestException(
        request?.method ?? '', request?.url.toString() ?? '', statusCode, body);
  }
}
