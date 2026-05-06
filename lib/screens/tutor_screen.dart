import 'package:duocdev/models/academic_material.dart';
import 'package:duocdev/services/ai_service.dart';
import 'package:duocdev/services/material_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

enum TutorMode { general, material, lesson, example, practice }

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
  String _answer =
      'Elige un contexto y escribe una pregunta. El Tutor IA responderá con una explicación breve, ejemplo o práctica.';
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
      if (mounted) {
        setState(() => _answer = 'No se pudo responder: $error');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final materials = materialService.cachedMaterials;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
        children: [
          HeroPanel(
            icon: Icons.auto_awesome,
            colors: const [
              Color(0xFF4C1D95),
              Color(0xFF164E63),
              Color(0xFF0F172A),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  label: _ai.lastMode == 'openai'
                      ? 'Backend IA'
                      : 'Modo demo/API',
                  color: _ai.lastMode == 'openai'
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFFB923C),
                  icon: _ai.lastMode == 'openai'
                      ? Icons.cloud_done_rounded
                      : Icons.science_rounded,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Tutor IA',
                  style: TextStyle(
                    fontSize: 36,
                    height: 1.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tu tutor de programación inteligente',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Pregunta, pide ejemplos, resume lecciones o genera práctica contextual.',
                  style: TextStyle(color: Colors.white70, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SectionTitle('Contexto'),
          const SizedBox(height: 10),
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
          const SizedBox(height: 18),
          const SectionTitle('Sugerencias rápidas'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SuggestionChip(
                label: 'Explícame este concepto',
                icon: Icons.lightbulb_rounded,
                onTap: () =>
                    _setQuestion('Explícame este concepto paso a paso.'),
              ),
              _SuggestionChip(
                label: 'Dame un ejemplo',
                icon: Icons.code_rounded,
                onTap: () =>
                    _setQuestion('Dame un ejemplo corto y fácil de probar.'),
              ),
              _SuggestionChip(
                label: 'Hazme una pregunta',
                icon: Icons.quiz_rounded,
                onTap: () => _setQuestion(
                  'Hazme una pregunta para verificar si entendí.',
                ),
              ),
              _SuggestionChip(
                label: 'Resume esta lección',
                icon: Icons.summarize_rounded,
                onTap: () =>
                    _setQuestion('Resume esta lección en 5 ideas clave.'),
              ),
              _SuggestionChip(
                label: 'Corrige mi respuesta',
                icon: Icons.rate_review_rounded,
                onTap: () => _setQuestion(
                  'Corrige mi respuesta y dime qué concepto debo repasar.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          DuocCard(
            radius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Color(0xFF22D3EE),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Tu pregunta',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Ej: ¿Cómo funciona un for en Python?',
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            label: _loading ? 'Consultando...' : 'Enviar pregunta',
            onPressed: _loading ? null : _send,
          ),
          const SizedBox(height: 18),
          _TutorAnswerCard(
            answer: _answer,
            mode: _ai.lastMode,
            loading: _loading,
          ),
          const SizedBox(height: 12),
          const Text(
            'El Tutor IA te ayuda a aprender, pero la práctica sigue siendo clave.',
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
      TutorMode.practice =>
        'Crea una pregunta de práctica sobre $_context con pista, respuesta correcta y explicación breve.',
    };
  }

  String _modeLabel(TutorMode mode) {
    return switch (mode) {
      TutorMode.general => 'Pregunta general',
      TutorMode.material => 'Material académico',
      TutorMode.lesson => 'Lección actual',
      TutorMode.example => 'Generar ejemplo',
      TutorMode.practice => 'Pregunta de práctica',
    };
  }

  void _setQuestion(String value) {
    setState(() => _controller.text = value);
  }
}

class _TutorAnswerCard extends StatelessWidget {
  const _TutorAnswerCard({
    required this.answer,
    required this.mode,
    required this.loading,
  });

  final String answer;
  final String mode;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return DuocCard(
      radius: 26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Respuesta del Tutor',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      mode == 'openai'
                          ? 'Conectado a backend'
                          : 'Modo demo seguro',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (loading)
            const LinearProgressIndicator(
              color: Color(0xFF22D3EE),
              backgroundColor: Color(0xFF334155),
            )
          else
            Text(answer, style: const TextStyle(fontSize: 16, height: 1.48)),
        ],
      ),
    );
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
        return const EmptyState(
          icon: Icons.article_outlined,
          title: 'Sin material cargado',
          message:
              'Puedes usar el modo general mientras el profesor sube contenido.',
        );
      }
      return DuocCard(
        radius: 22,
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
        radius: 22,
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
                    ? 'Usando contexto real de la lección actual.'
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
  const _SuggestionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: const Color(0xFF0F172A),
      side: const BorderSide(color: Color(0xFF334155)),
    );
  }
}
