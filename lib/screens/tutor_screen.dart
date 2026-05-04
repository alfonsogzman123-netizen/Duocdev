import 'package:duocdev/config/app_config.dart';
import 'package:duocdev/services/ai_service.dart';
import 'package:duocdev/services/material_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

enum TutorMode { general, material }

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
  TutorMode _mode = TutorMode.general;
  String? _materialId;

  Future<void> _send() async {
    if (_controller.text.trim().isEmpty) return;
    final materials = materialService.getMaterials();
    final selected = materials.where((m) => m.id == _materialId).toList();
    final materialContext = selected.isEmpty ? '' : 'Material: ${selected.first.title}\n${selected.first.rawText}';
    setState(() => _loading = true);
    try {
      final context = _mode == TutorMode.material ? materialContext : _context;
      final r = await _ai.askTutor(question: _controller.text.trim(), context: context);
      setState(() => _answer = r);
    } catch (e) {
      setState(() => _answer = 'No se pudo responder: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mats = materialService.getMaterials();
    return SafeArea(
      child: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('Tutor IA', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
        if (!AppConfig.hasApiKey) const Text('Modo demo activo: configura OPENAI_API_KEY para IA real', style: TextStyle(color: Color(0xFFFB923C))),
        const SizedBox(height: 8),
        SegmentedButton<TutorMode>(segments: const [ButtonSegment(value: TutorMode.general, label: Text('General')), ButtonSegment(value: TutorMode.material, label: Text('Basado en material'))], selected: {_mode}, onSelectionChanged: (v) => setState(() => _mode = v.first)),
        const SizedBox(height: 10),
        if (_mode == TutorMode.general)
          Wrap(spacing: 8, runSpacing: 4, children: ['Lógica', 'Python', 'Git/GitHub', 'Web', 'Java', 'SQL'].map((e) => ChoiceChip(label: Text(e), selected: _context == e, onSelected: (_) => setState(() => _context = e), selectedColor: const Color(0xFF8B5CF6))).toList())
        else if (mats.isEmpty)
          const DuocCard(child: Text('Aún no hay material académico cargado.'))
        else
          DropdownButtonFormField<String>(value: _materialId ?? mats.first.id, items: mats.map((m) => DropdownMenuItem(value: m.id, child: Text(m.title))).toList(), onChanged: (v) => setState(() => _materialId = v), decoration: const InputDecoration(labelText: 'Selecciona material')),
        const SizedBox(height: 12),
        DuocCard(child: TextField(controller: _controller, maxLines: 4, decoration: const InputDecoration(hintText: 'Ej: ¿Cómo funciona un for en Python?', border: InputBorder.none))),
        const SizedBox(height: 10),
        PrimaryButton(label: _loading ? 'Consultando...' : 'Enviar pregunta', onPressed: _loading ? null : _send),
        const SizedBox(height: 12),
        DuocCard(child: Text(_answer, style: const TextStyle(fontSize: 16, height: 1.4))),
      ]),
    );
  }
}
