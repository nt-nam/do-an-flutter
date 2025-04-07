import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost/gas_api/';

  // Headers mặc định, có thể thêm token sau khi xác thực
  Map<String, String> _getHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<String> getBaseUrl() async {
    return baseUrl; // Hoặc xử lý dynamic domain nếu cần
  }

  // GET request
  Future<dynamic> get(String endpoint, {String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _getHeaders(token: token),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }

  // POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _getHeaders(token: token),
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform POST request: $e');
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _getHeaders(token: token),
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform PUT request: $e');
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint, {String? token}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _getHeaders(token: token),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform DELETE request: $e');
    }
  }

  Future<dynamic> uploadFile(String endpoint, File file, String fileName,
      {String? token}) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/$endpoint'));

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      filename: fileName,
    ));

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(responseData);
    } else {
      throw Exception('Upload failed: ${response.statusCode}');
    }
  }

  // Thêm hàm upload ảnh dạng base64
  Future<dynamic> postWithImage(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    try {
      // Xử lý ảnh nếu có
      if (data['HinhAnh'] is File) {
        final file = data['HinhAnh'] as File;
        final bytes = await file.readAsBytes();
        data['HinhAnh'] = "data:image/jpeg;base64,${base64Encode(bytes)}";
      }

      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _getHeaders(token: token),
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Xử lý phản hồi từ server
  dynamic _handleResponse(http.Response response) {
    final jsonResponse = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonResponse['data'] ?? jsonResponse; // Bóc tách 'data' nếu có, nếu không trả toàn bộ
      case 400:
        throw Exception('Bad request: ${jsonResponse['message']}');
      case 401:
        throw Exception('Unauthorized: ${jsonResponse['message']}');
      case 403:
        throw Exception('Forbidden: ${jsonResponse['message']}');
      case 404:
        throw Exception('Not found: ${jsonResponse['message']}');
      case 500:
        throw Exception('Server error: ${jsonResponse['message']}');
      default:
        throw Exception('Unexpected error: ${response.statusCode} - ${jsonResponse['message']}');
    }
  }
}
