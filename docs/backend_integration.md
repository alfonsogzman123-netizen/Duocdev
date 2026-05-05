# Integración Flutter ↔ Backend (MVP híbrido)

## Backend
```bash
cd backend
npm.cmd install
npm.cmd run dev
```
En Linux/macOS:
```bash
cd backend
npm install
npm run dev
```

## Flutter conectado a backend
```bash
flutter run --dart-define=BACKEND_BASE_URL=http://10.0.2.2:3000
```

## Estrategia de fallback demo
- La app intenta backend para materiales y ejercicios.
- Si backend falla o está apagado, usa modo demo/local.
- Esto permite presentaciones sin servidor activo.

## Mensajes esperados
- "Material guardado en backend."
- "Backend no disponible. Se guardó en modo demo."
- "Ejercicios generados desde backend."
- "Usando generación demo local."
