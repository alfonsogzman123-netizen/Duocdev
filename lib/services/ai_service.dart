import 'dart:convert';

import 'package:duocdev/config/app_config.dart';
import 'package:http/http.dart' as http;

class AIService {
  static const _systemPrompt =
      'Eres Tutor IA de DuocDev. Responde breve, claro, con ejemplo simple y opcional mini ejercicio.';

  Future<String> askTutor({
    required String question,
    required String context,
  }) async {
    if (!AppConfig.hasApiKey) {
      return 'Modo demo activo. [$context] Para "$question": comienza separando el problema en pasos, prueba un ejemplo mínimo y valida el resultado esperado. Después intenta resolver una variación sin mirar la respuesta.';
    }

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/responses'),
      headers: {
        'Authorization': 'Bearer ${AppConfig.openAIApiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-4.1-mini',
        'input': [
          {'role': 'system', 'content': _systemPrompt},
          {'role': 'user', 'content': 'Contexto: $context\nDuda: $question'},
        ],
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Error API (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final text = data['output_text'];
    if (text is String && text.isNotEmpty) return text;
    return 'No se recibió respuesta. Intenta nuevamente.';
  }
}
