# DuocDev - Guía para agentes

## Descripción

DuocDev es un MVP educativo con app Flutter para estudiante/profesor simulado y backend Node.js/Express. La visión del producto es convertir material académico real en práctica personalizada revisada por profesor.

## Estructura

- `lib/`: app Flutter.
- `backend/`: API REST MVP.
- `docs/`: documentación técnica y de producto.

## Comandos

### Flutter

- `flutter clean`
- `flutter pub get`
- `flutter analyze`

### Backend

- `cd backend`
- `npm install` o `npm.cmd install` en Windows.
- `npm run dev`

## Reglas de trabajo

- Trabajar en ramas de feature; no mezclar cambios a `main` sin revisión.
- No eliminar funcionalidades existentes.
- Mantener toda la UI visible en español.
- Mantener el diseño premium oscuro actual.
- No eliminar ni degradar modo profesor.
- No eliminar backend.
- No eliminar Tutor IA.
- No eliminar fallback demo/offline.
- No eliminar cola de sincronización docente.
- No romper README ni capturas en `docs/images/`.
- No hardcodear claves, API keys ni secretos.
- No agregar Firebase, Supabase o login real hasta que exista una tarea explícita.
- Documentar cambios relevantes cuando impacten producto, arquitectura o flujos.
- Probar backend y Flutter antes de terminar cuando el entorno lo permita.
- Entregar un resumen claro de cambios, pruebas y limitaciones.

## Criterio de producto

- Priorizar que compile y que los flujos existentes sigan funcionando.
- Mantener la propuesta diferencial: profesor sube material, IA genera ejercicios, profesor revisa/publica, estudiante practica.
- Evitar reescrituras masivas; mejorar con cambios controlados.
- Preservar modo demo/offline como parte del MVP.
