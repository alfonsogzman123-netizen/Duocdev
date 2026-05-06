# DuocDev

**Plataforma educativa móvil para estudiantes de Ingeniería Informática.**

DuocDev es una app educativa inspirada en **SoloLearn, CoddyTech y Duolingo**, orientada a estudiantes de Ingeniería Informática de **Duoc UC**. El proyecto combina aprendizaje por rutas, desafíos interactivos, gamificación (XP/progreso), Tutor IA y un modo profesor simulado para crear y publicar práctica académica.

> ⚠️ Estado del proyecto: **MVP educativo avanzado en desarrollo** (no producción).

---

## Capturas del proyecto

Las siguientes capturas muestran el estado actual del MVP de **DuocDev**, incluyendo la experiencia del estudiante, la ruta de aprendizaje, el Tutor IA y el perfil.

<br>

<table>
  <tr>
    <td align="center">
      <strong>Inicio</strong>
    </td>
    <td align="center">
      <strong>Cursos</strong>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="docs/images/inicio.png" alt="Pantalla de inicio de DuocDev" width="270"/>
    </td>
    <td align="center">
      <img src="docs/images/cursos.png" alt="Ruta de cursos de DuocDev" width="270"/>
    </td>
  </tr>
  <tr>
    <td align="center">
      <strong>Tutor IA</strong>
    </td>
    <td align="center">
      <strong>Perfil</strong>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="docs/images/tutor-ia.png" alt="Tutor IA de DuocDev" width="270"/>
    </td>
    <td align="center">
      <img src="docs/images/perfil.png" alt="Perfil del estudiante en DuocDev" width="270"/>
    </td>
  </tr>
</table>

<br>

## Funcionalidades actuales

- [Estrategia de producto](docs/product_strategy.md)

- Ruta de aprendizaje por cursos.
- Lecciones con contenido y ejemplos.
- Desafíos interactivos.
- Pantalla de resultado.
- XP y progreso local.
- Perfil del estudiante.
- Tutor IA.
- Modo profesor.
- Carga de material académico.
- Generación de ejercicios desde material.
- Aprobación y publicación de ejercicios.
- Backend MVP.

---

## Modo estudiante 👨‍🎓

Flujo principal:

`Inicio → Cursos → Curso → Lección → Desafío → Resultado → Perfil`

---

## Modo profesor 👩‍🏫

Flujo principal:

`Perfil → Modo Profesor → Subir material → Generar ejercicios → Aprobar/Publicar → Estudiante practica`

---

## Tutor IA 🤖

- Funciona en **modo demo** cuando no hay API key.
- Está preparado para **IA real** con integración OpenAI.
- Permite trabajar con **contexto académico** para respuestas más útiles.

---

## Backend MVP (Node.js + Express) 🛠️

El repositorio incluye un backend independiente en `backend/` para materiales y ejercicios.

Endpoints principales:

- `GET /health`
- `GET /materials`
- `POST /materials`
- `POST /materials/:id/generate-exercises`
- `GET /exercises`
- `POST /exercises/:id/approve`
- `POST /exercises/:id/publish`

---

## Tecnologías

- Flutter
- Dart
- Node.js
- Express
- OpenAI API preparada
- Git/GitHub
- Android Studio

---

## Estructura del proyecto

```text
Duocdev/
  lib/
  backend/
  android/
  README.md
```

---

## Cómo ejecutar la app Flutter

```bash
flutter clean
flutter pub get
flutter run
```

---

## Cómo ejecutar backend

**Opción Windows (CMD):**

```bash
cd backend
npm.cmd install
npm.cmd run dev
```

**Opción estándar:**

```bash
cd backend
npm install
npm run dev
```

---

## Probar backend

Abrir en navegador o cliente HTTP:

`http://localhost:3000/health`

---

## Variables de entorno 🔐

- No se suben claves reales al repositorio.
- Usar archivo de ejemplo:
  - `backend/.env.example`
- Variable preparada:
  - `OPENAI_API_KEY=`

---

## Estado actual

DuocDev se encuentra como **MVP avanzado en desarrollo**, enfocado en validación académica, flujo completo de aprendizaje y preparación técnica para una arquitectura más robusta.

---

## Roadmap

- Conectar Flutter al backend real.
- Login de estudiantes/profesores.
- Base de datos.
- Subida real de PDF/DOCX/PPTX.
- Panel web para profesores.
- Publicación en Google Play.
- Políticas legales y privacidad.

---

## Autor

**Alfonso Guzmán**  
Estudiante de Ingeniería Informática - Duoc UC
