# Offline, cache y sincronización

## Objetivo

DuocDev debe seguir siendo demostrable aunque el backend esté apagado. El modo offline permite cargar material, generar ejercicios demo, aprobar/publicar localmente y dejar tareas pendientes para sincronizar después.

## Cache local

`LocalCacheService` mantiene en memoria:

- materiales demo y materiales creados localmente;
- ejercicios generados;
- ejercicios publicados;
- estado local de aprobación/publicación.

La cache actual no persiste al cerrar la app. Es suficiente para MVP y presentación, pero no para producción.

## Cola de sincronización

`SyncQueueService` maneja tareas con:

- `id`;
- `type`;
- `payload`;
- `createdAt`;
- `status`;
- `errorMessage`.

Tipos soportados:

- `createMaterial`;
- `generateExercises`;
- `approveExercise`;
- `publishExercise`.

Estados:

- `pending`;
- `failed`;
- `synced`.

Las tareas fallidas vuelven a ser reintentables desde el botón **Sincronizar ahora**.

## Comportamiento con backend encendido

1. La app guarda materiales y ejercicios en backend.
2. Actualiza cache local con respuesta remota.
3. El contador de pendientes queda en cero.
4. El Panel Profesor muestra sincronización al día.

## Comportamiento con backend apagado

1. La app guarda material o cambios en memoria local.
2. Crea una tarea pendiente en la cola.
3. Muestra un mensaje claro de modo demo/sincronización pendiente.
4. El profesor puede seguir trabajando.
5. La app conserva contenido visible mediante materiales y ejercicios demo realistas.

## Cuando backend vuelve

1. El profesor presiona **Sincronizar ahora**.
2. La app verifica `/health`.
3. Se reintentan tareas pendientes o fallidas.
4. Las tareas correctas pasan a `synced` y luego se limpian.
5. Las tareas fallidas conservan error y quedan para nuevo intento.

## Limitaciones actuales

- Cola y cache viven en memoria.
- No hay resolución avanzada de conflictos.
- No hay usuario autenticado ni ownership real.
- No hay auditoría ni historial de cambios.

## Evolución recomendada

- Persistir cache y cola en SQLite/Hive.
- Agregar backoff y reintentos automáticos.
- Guardar relación entre IDs locales y remotos.
- Registrar auditoría docente.
- Mostrar historial de sincronización.
