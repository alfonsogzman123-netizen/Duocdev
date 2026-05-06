# Arquitectura DuocDev

## Capas principales

- `lib/screens/`: pantallas estudiante, Tutor IA y profesor.
- `lib/services/`: conexión backend, cache, sincronización, progreso, IA y flujo docente.
- `lib/models/`: modelos de curso, material, ejercicio generado y tareas de sincronización.
- `lib/data/`: cursos y datos demo profesionales.
- `lib/widgets/`: componentes visuales compartidos.
- `backend/src/`: API Express por rutas, controladores, servicios y datos JSON.

## Frontend Flutter

La app usa `MainShell` con navegación inferior:

- Inicio;
- Cursos;
- Práctica;
- Tutor IA;
- Perfil.

El diseño mantiene fondo oscuro premium, tarjetas, acentos cyan/morado y UI visible en español.

## Servicios Flutter

- `ApiService`: GET/POST, timeouts, errores JSON y health check.
- `MaterialService`: materiales remotos/locales y tareas de sincronización.
- `ExerciseGenerationService`: generación, aprobación, publicación y práctica estudiante.
- `LocalCacheService`: cache demo/en memoria.
- `SyncQueueService`: cola reintentable.
- `AIService`: Tutor IA vía backend con fallback local.
- `ProgressService`: XP, nivel, racha, progreso e insignias.

## Backend Express

El backend expone endpoints para:

- salud;
- materiales;
- generación de ejercicios;
- ejercicios;
- aprobación/publicación;
- Tutor IA.

La persistencia actual usa JSON en `backend/src/data/`. Los servicios aseguran que los archivos existan y devuelven arreglos válidos si el JSON falta o se corrompe.

## IA

Flutter no usa claves. Toda integración real con OpenAI debe pasar por backend:

- `generateExercisesFromMaterial` usa demo si no hay `OPENAI_API_KEY`;
- `answerTutorQuestion` usa demo o `demo_fallback` si OpenAI falla.

## Decisiones MVP

- JSON local en vez de base de datos para velocidad de iteración.
- Modo profesor simulado sin login real.
- Material ingresado como texto.
- Cola offline en memoria.
- Datos demo disponibles para presentación sin backend.

## Preparación para producción

La arquitectura deja puntos claros para evolucionar a:

- autenticación y roles;
- base de datos;
- almacenamiento de archivos;
- IA contextual con material indexado;
- persistencia offline;
- panel web profesor;
- CI/CD y publicación.
