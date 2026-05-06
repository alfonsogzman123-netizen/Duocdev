import 'package:duocdev/services/api_service.dart';

class AIService {
  String lastMode = 'demo';

  Future<String> askTutor({
    required String question,
    required String context,
  }) async {
    try {
      final data =
          await apiService.post('/ai/tutor', {
                'question': question,
                'context': context,
              })
              as Map<String, dynamic>;
      lastMode = (data['mode'] as String?) ?? 'backend';
      final answer = data['answer'] as String?;
      if (answer != null && answer.trim().isNotEmpty) return answer.trim();
    } catch (_) {
      lastMode = 'demo_local';
    }

    return _demoAnswer(question: question, context: context);
  }

  String _demoAnswer({required String question, required String context}) {
    final focus = context.length > 180
        ? '${context.substring(0, 180)}...'
        : context;
    return 'Modo demo activo. Contexto: $focus\n\nPara "$question": separa el problema en pasos, prueba un ejemplo mínimo y valida el resultado esperado. Luego intenta una variación: cambia un dato de entrada y explica por qué cambia la salida.';
  }
}
