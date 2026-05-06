# Flujo profesor

`Perfil → Entrar como profesor → Panel Profesor → Subir material → Generar ejercicios → Banco de ejercicios → Revisar/Aprobar/Publicar → Estudiante practica`

## Panel Profesor

Muestra estado del backend, pendientes de sincronizar, métricas de materiales/ejercicios, acciones rápidas y últimos materiales.

## Subir material

En el MVP el material se ingresa como texto. El formulario exige título, curso y contenido académico suficiente. Si backend falla, el material queda local y pendiente de sincronización.

## Generar ejercicios

El profesor elige material, cantidad y dificultad. El backend genera ejercicios o la app usa fallback demo local.

## Banco de ejercicios

Permite filtrar por todos, pendientes, aprobados y publicados. Cada card muestra pregunta, curso, dificultad, XP, explicación y acciones.

## Revisión

El profesor puede ajustar pregunta, alternativas, respuesta correcta, explicación y XP. Luego puede guardar, aprobar o publicar.

## Publicación

Solo los ejercicios publicados aparecen en Práctica inteligente para estudiantes. Si no hay backend, el estado se conserva localmente y queda en cola de sincronización.
