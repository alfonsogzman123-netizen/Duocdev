# Estrategia de producto DuocDev

## Problema

Los estudiantes de Ingeniería Informática suelen practicar con ejercicios genéricos que no siempre están alineados con la guía, clase o evaluación real del semestre. Al mismo tiempo, los profesores tienen material académico valioso, pero no siempre cuentan con tiempo para convertirlo en práctica personalizada, revisable y medible.

## Solución

DuocDev transforma material académico real en práctica móvil:

`Profesor sube material → IA/demo genera ejercicios → profesor revisa/publica → estudiante practica → la app mide progreso, XP, racha y desempeño.`

El MVP mantiene modo demo/offline para que el flujo pueda presentarse incluso sin infraestructura completa. La demo final incluye bienvenida integrada, home premium, ruta visual, práctica inteligente filtrable, Tutor IA contextual, perfil gamificado y panel profesor profesional.

## Diferenciador

DuocDev no es una biblioteca genérica de cursos. Su valor está en conectar práctica, material docente y revisión humana. La IA acelera la creación inicial, pero el profesor mantiene control editorial antes de publicar al estudiante.

## Comparación con apps de referencia

- SoloLearn: inspira microlecciones, quizzes rápidos, rutas y perfil de progreso.
- Coddy/CoddyTech: inspira práctica técnica guiada y foco en programación.
- Duolingo: inspira racha, XP, metas diarias, feedback inmediato y motivación frecuente.

DuocDev toma esos patrones, pero los orienta a una experiencia académica de Duoc UC: contenido contextual, rol profesor y práctica basada en material real.

## Flujo estudiante

1. Inicio con hero de bienvenida, nivel, XP, racha, meta diaria, misiones y continuidad.
2. Ruta visual tipo roadmap con cursos ordenados por nivel, progreso, dificultad, estados y práctica docente disponible.
3. Curso con resumen, lecciones y ejercicios publicados.
4. Lección con objetivo, explicación, ejemplo, tip docente y acceso al Tutor IA.
5. Desafío con alternativas, feedback inmediato, pista y XP.
6. Resultado con progreso, motivación, continuidad y retorno seguro.
7. Práctica inteligente con filtros, ejercicios revisados/publicados o fallback demo.
8. Perfil premium con carrera, Duoc UC, nivel, XP, progreso, resumen e insignias.

## Flujo profesor

1. Perfil → Entrar como profesor.
2. Panel Profesor visual con estado de backend, sincronización, métricas, recomendación IA y acciones rápidas.
3. Subir material como texto académico con contador de caracteres y validaciones.
4. Generar ejercicios desde material.
5. Revisar/editar pregunta, alternativas, respuesta correcta, explicación y XP.
6. Aprobar.
7. Publicar.
8. El estudiante practica ejercicios publicados.

## Rol de IA

La IA cumple dos funciones:

- Generar ejercicios iniciales desde material académico.
- Responder dudas del estudiante como Tutor IA contextual.

Regla de producto: la IA no reemplaza al profesor ni a la práctica. El profesor revisa/publica y el estudiante aprende practicando.

## Rol del backend

El backend Node.js/Express sostiene:

- materiales;
- ejercicios generados;
- aprobación y publicación;
- Tutor IA seguro;
- fallback demo si no existe `OPENAI_API_KEY`;
- persistencia JSON local para MVP.

Flutter se comunica con `ApiService` y usa cache local cuando el backend no está disponible.

## Roadmap recomendado

### Fase 1: MVP Flutter + backend + IA demo

Estado actual: app móvil, panel profesor, práctica inteligente, Tutor IA vía backend/fallback y persistencia JSON.

### Fase 2: Base de datos real

Migrar materiales, ejercicios, progreso, publicaciones y cola a PostgreSQL u otra base administrada.

### Fase 3: Login y roles

Agregar autenticación, autorización y separación real estudiante/profesor.

### Fase 4: Subida de archivos

Permitir PDF, DOCX y PPTX; extraer texto; validar tamaño, tipo y seguridad.

### Fase 5: IA real con material indexado

Procesar material, generar embeddings/búsqueda contextual y responder desde backend con trazabilidad.

### Fase 6: Panel web profesor

Crear revisión masiva, métricas docentes, gestión por curso y publicación granular.

### Fase 7: Publicación

Preparar Google Play, políticas, términos, privacidad, monitoreo, CI/CD y soporte.
