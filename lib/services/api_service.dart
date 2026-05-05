import 'dart:convert';

import 'package:duocdev/config/api_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, {this.statusCode});
  @override
  String toString() => message;
}

class ApiService {
  Uri _uri(String path) {
    final safePath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('${ApiConfig.baseUrl}$safePath');
  }

  Future<dynamic> get(String path) async {
    try {
      final response = await http.get(_uri(path)).timeout(const Duration(seconds: ApiConfig.timeoutSeconds));
      return _parse(response);
    } catch (e) {
      if (kDebugMode) debugPrint('GET $path error: $e');
      throw const ApiException('Backend no disponible.');
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            _uri(path),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: ApiConfig.timeoutSeconds));
      return _parse(response);
    } catch (e) {
      if (kDebugMode) debugPrint('POST $path error: $e');
      throw const ApiException('Backend no disponible.');
    }
  }

  dynamic _parse(http.Response response) {
    if (response.statusCode >= 400) {
      throw ApiException('Error del backend (${response.statusCode}).', statusCode: response.statusCode);
    }
    try {
      return jsonDecode(response.body);
    } catch (_) {
      throw const ApiException('Respuesta inválida del backend.');
    }
  }

  Future<bool> healthCheck() async {
    try {
      final data = await get('/health');
      return data is Map<String, dynamic> && data['ok'] == true;
    } catch (_) {
      return false;
    }
  }
}

final apiService = ApiService();
