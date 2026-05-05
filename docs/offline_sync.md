# Modo offline y sincronización

DuocDev mantiene una cola simple de sincronización cuando el backend no está disponible.

## Qué se guarda localmente
- Materiales
- Ejercicios generados
- Estado de aprobación/publicación
- Tareas pendientes de sincronizar

## Qué significa pendiente
Acciones que se ejecutaron en app, pero no pudieron enviarse al backend.

## Cuándo se sincroniza
- Al presionar "Sincronizar ahora" en Panel Profesor.
- Cuando backend está disponible.

## Limitación actual
La cola vive en memoria del proceso. Se perdería al cerrar app.

## Evolución recomendada
Persistir cola y cache con SQLite/Hive para robustez offline real.
