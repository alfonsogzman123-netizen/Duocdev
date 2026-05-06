# DuocDev Backend MVP

Backend independiente (Node.js + Express) para gestionar material académico y generación de ejercicios (modo demo/OpenAI).

## Requisitos
- Node.js 18+

## Setup
```bash
cd backend
npm install
cp .env.example .env
npm run dev
```

Servidor por defecto en `http://localhost:3000`.

## Endpoint de salud
- `GET http://localhost:3000/health`

Respuesta esperada:
```json
{
  "ok": true,
  "service": "DuocDev Backend"
}
```

## Endpoints principales
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

## Ejemplos curl

Crear material:
```bash
curl -X POST http://localhost:3000/materials \
  -H "Content-Type: application/json" \
  -d '{
    "title":"Variables en Python",
    "courseId":"python",
    "unitName":"Unidad 1",
    "teacherName":"Profesor DuocDev",
    "rawText":"Texto largo de más de 100 caracteres ...",
    "tags":["python","variables"]
  }'
```

Generar ejercicios desde material:
```bash
curl -X POST http://localhost:3000/materials/mat_py_demo/generate-exercises \
  -H "Content-Type: application/json" \
  -d '{"quantity":5,"difficulty":"basic","type":"multiple_choice"}'
```

Aprobar/publicar ejercicio:
```bash
curl -X POST http://localhost:3000/exercises/EXERCISE_ID/approve
curl -X POST http://localhost:3000/exercises/EXERCISE_ID/publish
```

Tutor IA demo/API:
```bash
curl -X POST http://localhost:3000/ai/tutor \
  -H "Content-Type: application/json" \
  -d '{"question":"Explícame un if en Python","context":"Lección de condicionales"}'
```

## Seguridad
- Nunca subas `.env`.
- Usa `.env.example` como plantilla.
- En producción, la API key de OpenAI debe quedar **solo en backend**.
