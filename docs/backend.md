# Backend MVP

## Endpoints
- GET /health
- GET /materials
- POST /materials
- GET /materials/:id
- POST /materials/:id/generate-exercises
- GET /exercises
- POST /exercises/:id/approve
- POST /exercises/:id/publish
- GET /courses/:courseId/exercises

## Estructura
- routes: define endpoints
- controllers: orquestan request/response
- services: lógica de dominio
- data: JSON local
