import 'package:duocdev/config/app_config.dart';
import 'package:duocdev/services/ai_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({super.key});

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  final _controller = TextEditingController();
  final _ai = AIService();
  String _context = 'Lógica';
  String _answer = 'Escribe tu duda para comenzar.';
  bool _loading = false;

  Future<void> _send() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _loading = true);
    try {
      final r = await _ai.askTutor(question: _controller.text.trim(), context: _context);
      setState(() => _answer = r);
    } catch (e) {
      setState(() => _answer = 'No se pudo responder: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Tutor IA', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          if (!AppConfig.hasApiKey)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Sin OPENAI_API_KEY: usando modo demo.', style: TextStyle(color: Colors.orangeAccent)),
            ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _context,
            items: const ['Lógica', 'Python', 'Git/GitHub', 'Web', 'Java', 'SQL']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _context = v ?? _context),
          ),
          const SizedBox(height: 12),
          TextField(controller: _controller, maxLines: 4, decoration: const InputDecoration(hintText: 'Ej: ¿Cómo funciona un for en Python?')),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _loading ? null : _send, child: Text(_loading ? 'Consultando...' : 'Enviar pregunta')),
          const SizedBox(height: 12),
          DuocCard(child: Text(_answer)),
        ],
      ),
    );
  }
}
