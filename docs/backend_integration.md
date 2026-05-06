# Integración Flutter ↔ Backend (MVP híbrido)

## Objetivo
Conectar Flutter con backend real sin perder operatividad cuando el servidor está apagado.

## Arquitectura
Flutter → ApiService → Backend Express → JSON local/demo → IA futura.

## Configuración de URL
- Default emulador Android: `http://10.0.2.2:3000`
- Override:
```bash
flutter run --dart-define=BACKEND_BASE_URL=http://10.0.2.2:3000
```

## Cómo correr backend
```bash
cd backend
npm.cmd install
npm.cmd run dev
```
Linux/macOS:
```bash
cd backend
npm install
npm run dev
```

## Cómo probar backend
- `http://localhost:3000/health`
- `http://localhost:3000/materials`

## Servicios Flutter conectados
- ApiService
- MaterialService
- ExerciseGenerationService
- TeacherService

## Endpoints usados
- GET /health
- GET /materials
- POST /materials
- GET /materials/:id
- POST /materials/:id/generate-exercises
- GET /exercises
- POST /exercises/:id/approve
- POST /exercises/:id/publish
- GET /courses/:courseId/exercises

## Fallback demo
- Si backend falla, la app usa datos locales.
- Si falla generación remota, se genera contenido demo local.
- Profesor y estudiante mantienen flujo funcional.

## Modo offline y sincronización pendiente
- Se cachean materiales y ejercicios en `LocalCacheService` (memoria).
- Acciones fallidas se agregan a `SyncQueueService` como tareas pendientes.
- Panel profesor muestra conteo de pendientes y botón "Sincronizar ahora".
- Al reconectar backend, se intenta sincronizar tareas (material, approve, publish).
- Limitación actual: cola en memoria (no persistente al cerrar app).
- Mejora futura: persistencia local con Hive/SQLite + estrategia de reintentos.

## Limitaciones actuales
- Backend usa JSON local.
- Sin login real.
- Sin base de datos externa.
- Sin subida real de PDF/DOCX/PPTX.

## Próximos pasos
- Base de datos real.
- Login y roles reales.
- Subida de archivos académicos reales.
- IA solo desde backend seguro.
- Panel web de profesor.
