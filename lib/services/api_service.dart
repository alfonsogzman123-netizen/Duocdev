import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:duocdev/config/api_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum ApiErrorType { unavailable, timeout, backend, invalidJson, unexpected }

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, required this.type});

  final String message;
  final int? statusCode;
  final ApiErrorType type;

  @override
  String toString() => message;
}

class ApiService {
  Uri _uri(String path) {
    final safePath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('${ApiConfig.baseUrl}$safePath');
  }

  Future<dynamic> get(String path) =>
      _request(() => http.get(_uri(path)), path, 'GET');

  Future<dynamic> post(String path, Map<String, dynamic> body) {
    return _request(
      () => http.post(
        _uri(path),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ),
      path,
      'POST',
    );
  }

  Future<dynamic> _request(
    Future<http.Response> Function() call,
    String path,
    String method,
  ) async {
    try {
      final response = await call().timeout(
        const Duration(seconds: ApiConfig.timeoutSeconds),
      );
      return _parse(response);
    } on TimeoutException catch (_) {
      throw const ApiException(
        'Tiempo de espera agotado al conectar con backend.',
        type: ApiErrorType.timeout,
      );
    } on SocketException catch (_) {
      throw const ApiException(
        'Backend no disponible.',
        type: ApiErrorType.unavailable,
      );
    } on ApiException {
      rethrow;
    } catch (error) {
      if (kDebugMode) debugPrint('$method $path error inesperado: $error');
      throw const ApiException(
        'Error inesperado al comunicarse con backend.',
        type: ApiErrorType.unexpected,
      );
    }
  }

  dynamic _parse(http.Response response) {
    if (response.statusCode >= 400) {
      throw ApiException(
        'Error del backend (${response.statusCode}).',
        statusCode: response.statusCode,
        type: ApiErrorType.backend,
      );
    }
    try {
      return jsonDecode(response.body);
    } catch (_) {
      throw const ApiException(
        'Respuesta inválida del backend.',
        type: ApiErrorType.invalidJson,
      );
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
