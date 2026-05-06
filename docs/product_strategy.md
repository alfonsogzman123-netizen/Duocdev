# Estrategia de producto DuocDev

## Problema que resuelve

Los estudiantes de Ingeniería Informática practican con ejercicios genéricos que muchas veces no se conectan con la guía, clase o evaluación real del semestre. Los profesores, por otro lado, tienen material valioso pero no siempre cuentan con tiempo para transformarlo en práctica personalizada, revisable y medible.

DuocDev conecta esas dos necesidades: convierte material académico real en ejercicios que el profesor puede revisar y publicar, y entrega al estudiante práctica contextual con progreso, feedback y apoyo del Tutor IA.

## Por qué no es una copia de SoloLearn, Duolingo o Coddy

DuocDev toma ideas útiles de esas apps, como microlecciones, progreso visible, feedback rápido y motivación diaria. La diferencia central es que no depende solo de contenido genérico prearmado. La plataforma nace desde el material de clase del profesor y lo convierte en práctica alineada al curso.

Esto cambia el foco: no es una app para aprender programación de forma aislada, sino una capa de práctica inteligente sobre el proceso académico real de Duoc UC.

## Diferenciador principal

El flujo distintivo es:

`Profesor sube material académico real → IA genera ejercicios → profesor revisa/publica → estudiante practica contenido personalizado → progreso y gamificación se actualizan`

Ese ciclo hace que DuocDev sea más útil que una biblioteca de cursos genéricos, porque adapta la práctica a lo que efectivamente se enseñó.

## Flujo estudiante

El estudiante entra a un dashboard de aprendizaje con nivel, XP, racha, meta diaria y continuidad de curso. Desde ahí puede avanzar por la ruta de programación, completar microlecciones, responder desafíos con feedback inmediato y practicar ejercicios generados desde material publicado por profesor.

La experiencia esperada es breve, clara y accionable: aprender un concepto, probarlo, recibir feedback y seguir practicando.

## Flujo profesor

El profesor accede desde el modo profesor, carga material académico, genera ejercicios, revisa la calidad de cada pregunta, aprueba y publica. El panel docente muestra estado del backend, pendientes de sincronización, métricas de materiales y ejercicios, y acciones rápidas para continuar el flujo.

El banco de ejercicios funciona como espacio de control editorial: ningún ejercicio generado debería llegar al estudiante sin revisión docente.

## Rol de IA

La IA cumple dos roles:

- Apoyar al profesor en la generación inicial de ejercicios desde material académico.
- Apoyar al estudiante como Tutor IA contextual con modos de pregunta general, material académico, lección actual y generación de ejemplos.

La IA no reemplaza la práctica ni la revisión docente. Acelera la creación de actividades y acompaña la comprensión.

## Rol del backend

El backend Node.js/Express sostiene el MVP con endpoints para salud, materiales, generación de ejercicios, aprobación y publicación. Hoy persiste en JSON local para mantener velocidad de iteración, pero la arquitectura deja preparado el camino hacia base de datos, autenticación y almacenamiento real.

Flutter consume el backend por `ApiService` y mantiene fallback local cuando el servidor no está disponible.

## Modo offline

El modo offline/demo es parte de la estrategia del MVP. Permite que estudiante y profesor sigan probando el flujo sin depender de infraestructura completa. Cuando una acción docente falla contra backend, se agrega a la cola de sincronización para reintentar luego.

La limitación actual es que la cola vive en memoria. La siguiente evolución debe persistirla localmente.

## Roadmap de producto

1. Persistencia local para progreso, cola offline y práctica completada.
2. Base de datos real para materiales, ejercicios y publicaciones.
3. Login con roles estudiante/profesor.
4. Subida real de PDF, DOCX y PPTX.
5. IA generativa solo desde backend seguro.
6. Analítica docente por curso, unidad y dificultad.
7. Recomendaciones adaptativas por desempeño.
8. Panel web profesor para revisión masiva.
9. Publicación móvil con políticas de privacidad y seguridad.

## Qué lo hace superior a una app educativa común

DuocDev combina aprendizaje móvil, feedback inmediato y gamificación, pero agrega una capa académica propia: el profesor puede convertir su material en práctica revisada y medible. Eso permite contenido más pertinente, más confianza docente y una experiencia estudiante que no se siente desconectada de la sala de clases.

La meta no es competir solo por tener más ejercicios, sino por tener ejercicios más relevantes.
