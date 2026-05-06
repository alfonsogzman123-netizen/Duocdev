# Backend MVP

## Stack

- Node.js
- Express
- JSON local en `backend/src/data/`
- OpenAI preparado desde backend con fallback demo

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

## Estructura

- `routes/`: define endpoints.
- `controllers/`: valida request/response.
- `services/`: lógica de dominio, JSON local y fallback IA.
- `utils/`: validaciones mínimas.
- `data/`: materiales y ejercicios demo/persistidos.

## Seguridad MVP

- No hay claves en Flutter.
- `OPENAI_API_KEY` vive solo en backend.
- Si no hay clave, backend usa demo.
- Errores responden `{ "error": "Mensaje claro" }`.
- No hay rutas destructivas.

## Limitaciones

- Sin base de datos.
- Sin autenticación.
- Sin multiusuario.
- Sin subida real de archivos.
- Sin rate limiting.
