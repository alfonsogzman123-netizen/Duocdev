# Integración Flutter ↔ Backend

## Objetivo

Conectar Flutter con un backend propio sin perder el modo demo/offline cuando el servidor no está disponible.

## Arquitectura

`Flutter → ApiService → Backend Express → servicios de dominio → JSON local → IA demo/OpenAI backend`

Flutter nunca debe llamar OpenAI directamente ni guardar claves.

## Configuración de URL

URL por defecto para Android Emulator:

```text
http://10.0.2.2:3000
```

Override:

```bash
flutter run --dart-define=BACKEND_BASE_URL=http://10.0.2.2:3000
```

Para dispositivo físico, reemplazar por la IP local del computador donde corre backend.

## Ejecutar backend

Windows:

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

## Endpoints

- `GET /health`
- `GET /materials`
- `POST /materials`
- `GET /materials/:id`
- `POST /materials/:id/generate-exercises`
- `GET /exercises`
- `POST /exercises/:id/approve`
- `POST /exercises/:id/publish`
- `GET /courses/:courseId/exercises`
- `GET /ai/info`
- `POST /ai/tutor`

## Health

Respuesta esperada:

```json
{
  "ok": true,
  "service": "DuocDev Backend"
}
```

## Tutor IA

`POST /ai/tutor`

Body:

```json
{
  "question": "Explícame una condición en Python",
  "context": "Lección actual o material académico"
}
```

Respuesta:

```json
{
  "mode": "demo",
  "answer": "Respuesta educativa..."
}
```

Si `OPENAI_API_KEY` está vacío, el backend responde en modo demo. Si existe clave y falla la llamada, responde con `demo_fallback`.

## Fallback

- Si backend falla, `MaterialService` y `ExerciseGenerationService` usan cache local.
- Si falla generación remota, se crean ejercicios demo locales.
- Si falla una acción docente, se agrega una tarea a `SyncQueueService`.

## Limitaciones

- Persistencia en JSON local.
- Sin autenticación.
- Sin base de datos.
- Sin subida real de archivos.
- Sin sincronización persistente al cerrar la app.
