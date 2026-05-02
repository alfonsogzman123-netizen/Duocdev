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
  Future<void> _send() async { if (_controller.text.trim().isEmpty) return; setState(() => _loading = true); try { final r = await _ai.askTutor(question: _controller.text.trim(), context: _context); setState(() => _answer = r);} catch (e) {setState(() => _answer = 'No se pudo responder: $e');} finally {setState(() => _loading = false);} }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Tutor IA', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
      const Text('Pregunta sobre programación', style: TextStyle(color: Colors.white70, fontSize: 18)),
      if (!AppConfig.hasApiKey) const Padding(padding: EdgeInsets.only(top: 8), child: DuocCard(child: Text('Modo demo activo: configura OPENAI_API_KEY para IA real', style: TextStyle(color: Color(0xFFFB923C))))),
      const SizedBox(height: 12),
      Wrap(spacing: 8, children: ['Lógica', 'Python', 'Git/GitHub', 'Web', 'Java', 'SQL'].map((e) => ChoiceChip(label: Text(e), selected: _context == e, onSelected: (_) => setState(() => _context = e), selectedColor: const Color(0xFF8B5CF6))).toList()),
      const SizedBox(height: 10),
      DuocCard(child: TextField(controller: _controller, maxLines: 4, decoration: const InputDecoration(hintText: 'Ej: ¿Cómo funciona un for en Python?', border: InputBorder.none))),
      const SizedBox(height: 10),
      PrimaryButton(label: _loading ? 'Consultando...' : 'Enviar pregunta', onPressed: _loading ? null : _send),
      const SizedBox(height: 12),
      DuocCard(child: Text(_answer, style: const TextStyle(fontSize: 16, height: 1.4))),
    ]));
  }
}
