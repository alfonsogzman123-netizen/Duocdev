import 'package:duocdev/config/app_config.dart';
import 'package:duocdev/models/academic_material.dart';
import 'package:duocdev/services/ai_service.dart';
import 'package:duocdev/services/material_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

enum TutorMode { general, material, lesson, example }

class TutorScreen extends StatefulWidget {
  const TutorScreen({
    super.key,
    this.initialMode,
    this.initialQuestion,
    this.lessonContext,
  });

  final TutorMode? initialMode;
  final String? initialQuestion;
  final String? lessonContext;

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  final _controller = TextEditingController();
  final _ai = AIService();
  String _context = 'Lógica';
  String _answer = 'Elige un modo y escribe tu duda para comenzar.';
  bool _loading = false;
  TutorMode _mode = TutorMode.general;
  String? _materialId;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode ?? TutorMode.general;
    if (widget.initialQuestion != null) {
      _controller.text = widget.initialQuestion!;
    }
    _loadMaterials();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadMaterials() async {
    final materials = await materialService.getMaterials();
    if (mounted && materials.isNotEmpty && _materialId == null) {
      setState(() => _materialId = materials.first.id);
    }
  }

  Future<void> _send() async {
    if (_controller.text.trim().isEmpty || _loading) return;
    setState(() => _loading = true);
    try {
      final response = await _ai.askTutor(
        question: _controller.text.trim(),
        context: _buildTutorContext(),
      );
      if (mounted) setState(() => _answer = response);
    } catch (error) {
      if (mounted) setState(() => _answer = 'No se pudo responder: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final materials = materialService.cachedMaterials;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Tutor IA',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Asistente académico para entender, practicar y pedir ejemplos con contexto.',
            style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.35),
          ),
          const SizedBox(height: 12),
          if (!AppConfig.hasApiKey)
            const DuocCard(
              radius: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Color(0xFFFB923C)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Modo demo activo. El Tutor simula respuestas educativas sin usar claves reales.',
                      style: TextStyle(color: Colors.white70, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TutorMode.values.map((mode) {
              return ChoiceChip(
                label: Text(_modeLabel(mode)),
                selected: _mode == mode,
                onSelected: (_) => setState(() => _mode = mode),
                selectedColor: const Color(0xFF8B5CF6),
                backgroundColor: const Color(0xFF1E293B),
                side: const BorderSide(color: Color(0xFF334155)),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          _ContextSelector(
            mode: _mode,
            contextValue: _context,
            materials: materials,
            materialId: _materialId,
            hasLessonContext: widget.lessonContext != null,
            onTopicChanged: (value) => setState(() => _context = value),
            onMaterialChanged: (value) => setState(() => _materialId = value),
          ),
          const SizedBox(height: 14),
          const Text(
            'Sugerencias rápidas',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SuggestionChip(
                label: 'Explícame este concepto',
                onTap: () =>
                    _setQuestion('Explícame este concepto paso a paso.'),
              ),
              _SuggestionChip(
                label: 'Dame un ejemplo',
                onTap: () =>
                    _setQuestion('Dame un ejemplo corto y fácil de probar.'),
              ),
              _SuggestionChip(
                label: 'Hazme una pregunta',
                onTap: () => _setQuestion(
                  'Hazme una pregunta para verificar si entendí.',
                ),
              ),
              _SuggestionChip(
                label: 'Resume esta lección',
                onTap: () =>
                    _setQuestion('Resume esta lección en 5 ideas clave.'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          DuocCard(
            radius: 24,
            child: TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Ej: ¿Cómo funciona un for en Python?',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            label: _loading ? 'Consultando...' : 'Enviar pregunta',
            onPressed: _loading ? null : _send,
          ),
          const SizedBox(height: 14),
          DuocCard(
            radius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Color(0xFF22D3EE)),
                    SizedBox(width: 8),
                    Text(
                      'Respuesta del Tutor',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _answer,
                  style: const TextStyle(fontSize: 16, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'El Tutor IA apoya tu aprendizaje, pero no reemplaza la práctica.',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  String _buildTutorContext() {
    final materials = materialService.cachedMaterials;
    final selected = materials
        .where((material) => material.id == _materialId)
        .toList();
    return switch (_mode) {
      TutorMode.general => 'Pregunta general sobre $_context.',
      TutorMode.material =>
        selected.isEmpty
            ? 'No hay material académico seleccionado.'
            : 'Material académico: ${selected.first.title}\n${selected.first.rawText}',
      TutorMode.lesson =>
        widget.lessonContext ??
            'Lección actual no disponible. Responde como apoyo general.',
      TutorMode.example =>
        'Genera un ejemplo didáctico sobre $_context con código breve y una pregunta de práctica.',
    };
  }

  String _modeLabel(TutorMode mode) {
    return switch (mode) {
      TutorMode.general => 'Pregunta general',
      TutorMode.material => 'Material académico',
      TutorMode.lesson => 'Lección actual',
      TutorMode.example => 'Generar ejemplo',
    };
  }

  void _setQuestion(String value) {
    setState(() => _controller.text = value);
  }
}

class _ContextSelector extends StatelessWidget {
  const _ContextSelector({
    required this.mode,
    required this.contextValue,
    required this.materials,
    required this.materialId,
    required this.hasLessonContext,
    required this.onTopicChanged,
    required this.onMaterialChanged,
  });

  final TutorMode mode;
  final String contextValue;
  final List<AcademicMaterial> materials;
  final String? materialId;
  final bool hasLessonContext;
  final ValueChanged<String> onTopicChanged;
  final ValueChanged<String?> onMaterialChanged;

  @override
  Widget build(BuildContext context) {
    if (mode == TutorMode.material) {
      if (materials.isEmpty) {
        return const DuocCard(
          child: Text(
            'Aún no hay material académico cargado. Puedes usar el modo general mientras el profesor sube contenido.',
          ),
        );
      }
      return DuocCard(
        radius: 20,
        child: DropdownButtonFormField<String>(
          initialValue: materialId ?? materials.first.id,
          items: materials
              .map(
                (material) => DropdownMenuItem<String>(
                  value: material.id,
                  child: Text(material.title),
                ),
              )
              .toList(),
          onChanged: onMaterialChanged,
          decoration: const InputDecoration(
            labelText: 'Material de referencia',
          ),
        ),
      );
    }

    if (mode == TutorMode.lesson) {
      return DuocCard(
        radius: 20,
        child: Row(
          children: [
            Icon(
              hasLessonContext
                  ? Icons.check_circle_rounded
                  : Icons.info_outline,
              color: hasLessonContext
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFFB923C),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hasLessonContext
                    ? 'Usando el contexto de la lección actual.'
                    : 'Abre una lección y usa “Preguntar al Tutor IA” para enviar contexto específico.',
                style: const TextStyle(color: Colors.white70, height: 1.35),
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ['Lógica', 'Python', 'Git/GitHub', 'Web', 'Java', 'SQL']
          .map(
            (topic) => ChoiceChip(
              label: Text(topic),
              selected: contextValue == topic,
              onSelected: (_) => onTopicChanged(topic),
              selectedColor: const Color(0xFF8B5CF6),
              backgroundColor: const Color(0xFF1E293B),
              side: const BorderSide(color: Color(0xFF334155)),
            ),
          )
          .toList(),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: const Color(0xFF0F172A),
      side: const BorderSide(color: Color(0xFF334155)),
    );
  }
}
