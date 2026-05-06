# Pendientes para producción

## Checklist funcional

- [ ] Login estudiante/profesor.
- [ ] Roles, permisos y autorización por curso.
- [ ] Base de datos real para usuarios, materiales, ejercicios, publicaciones y progreso.
- [ ] Persistencia local offline para cache, cola y progreso.
- [ ] Subida real de archivos PDF, DOCX y PPTX.
- [ ] Extracción segura de texto desde archivos.
- [ ] Revisión docente con historial, versiones y auditoría.
- [ ] Panel web profesor para revisión masiva.
- [ ] Notificaciones o recordatorios de práctica.

## Checklist IA

- [ ] OpenAI u otro proveedor solo desde backend.
- [ ] Indexación de material académico por curso/unidad.
- [ ] Respuestas con citas o referencias al material.
- [ ] Moderación y límites de uso.
- [ ] Métricas de calidad de ejercicios.
- [ ] Revisión académica antes de publicar contenido generado.

## Checklist seguridad y privacidad

- [ ] Política de privacidad.
- [ ] Términos de uso.
- [ ] Gestión de consentimiento para material académico.
- [ ] Protección de datos personales.
- [ ] Rate limiting en backend.
- [ ] Validación de archivos y tamaño máximo.
- [ ] Sanitización de entradas.
- [ ] Manejo seguro de secretos.
- [ ] Logs sin datos sensibles.

## Checklist calidad

- [ ] Tests unitarios para servicios Flutter.
- [ ] Tests de widgets para flujos críticos.
- [ ] Tests de integración backend.
- [ ] CI/CD con analyze, test y lint.
- [ ] Pruebas manuales en emulador Android y dispositivo físico.
- [ ] Revisión de overflows y accesibilidad.
- [ ] Capturas actualizadas para README después del rediseño visual.
- [ ] QA visual de Home, Ruta, Práctica, Tutor IA, Perfil y Panel Profesor en emulador Android.

## Checklist publicación

- [ ] Icono y splash profesionales.
- [ ] Nombre, descripción y assets para Google Play.
- [ ] Build release firmado.
- [ ] Revisión legal/académica.
- [ ] Monitoreo de errores.
- [ ] Analytics de uso y aprendizaje.

## Roadmap técnico

### Fase 1: MVP Flutter + backend + IA demo

Completar experiencia estudiante/profesor, fallback offline, JSON local y documentación.

### Fase 2: Base de datos real

Persistir materiales, ejercicios, progreso y publicaciones.

### Fase 3: Login y roles

Separar estudiante/profesor con permisos por curso.

### Fase 4: Subida de archivos

Implementar PDF/DOCX/PPTX, almacenamiento y extracción.

### Fase 5: IA real con material indexado

Responder y generar ejercicios con contexto verificable del material.

### Fase 6: Panel web profesor

Optimizar revisión, edición, publicación y analítica docente.

### Fase 7: Publicación

Preparar release, políticas, monitoreo y soporte operativo.
