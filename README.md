# devops-obligatorio

Repositorio para el obligatorio de DevOps – finales 2025.  

El objetivo del proyecto es implementar una arquitectura DevOps completa para la aplicación **StockWiz**, garantizando **despliegues confiables, automatización, observabilidad y control de calidad**.

El equipo está formado por: **Camila Ayuto, Bruno Charletto y Constanza Esquivel**.

---

## Estrategia de ramas

El proyecto utiliza una variante ligera de **Trunk-Based Development**, con una rama de integración principal (`develop`) y ramas específicas para pruebas (`testing`) y producción (`main`).

### Ramas principales

- **main** → rama estable y de producción.  
  Solo recibe merges desde `testing` luego de pasar todos los controles y la aprobación manual del despliegue.

- **testing** → rama destinada a los testers para validar las funcionalidades antes de pasar a producción.  
  Recibe merges desde `develop` **solo cuando el equipo de desarrollo considera que la versión está lista para validación funcional**.  
  El despliegue hacia este ambiente **requiere aprobación manual**, lo que permite coordinar con QA qué cambios específicos deben probarse en cada ciclo.  
  De este modo, se evita que cada merge en `develop` se despliegue automáticamente en `testing`.

- **develop** → rama de integración y desarrollo activo.  
  Aquí los desarrolladores integran y prueban continuamente sus cambios antes de promoverlos a `testing`.

- **feature/<nombre>** → ramas temporales para nuevas funcionalidades o corrección de errores.  
  Se crean a partir de `develop` y se eliminan tras el merge.

---

## Flujo de trabajo

1. Crear una rama `feature/<nombre>` desde `develop`.
2. Realizar los commits y el push con los cambios.
3. Abrir un Pull Request hacia `develop`.
4. Validar los **pipelines de CI/CD** (build, tests, SonarQube) y revisión de código.
5. Mergear a `develop` para integrar los cambios.
6. Cuando las funcionalidades estén listas para validación, abrir un Pull Request de `develop` → `testing`.  
   Este paso requiere aprobación manual del equipo responsable para que los testers puedan planificar y ejecutar sus pruebas sobre una versión controlada.
7. Luego de la aprobación del equipo de QA y las pruebas exitosas, realizar merge de `testing` → `main` (producción).

---

## Ambientes y CI/CD

El pipeline de GitHub Actions implementa tres ambientes automatizados: development, testing y production.
Cada uno tiene un propósito definido dentro del flujo DevOps y cuenta con sus propios controles de calidad antes del despliegue.

1. Development (develop)

Este es el entorno de desarrollo activo.
Aquí los desarrolladores integran y prueban continuamente sus cambios.
Antes de permitir que el código avance, deben superarse con éxito las siguientes etapas del pipeline:

Build de los microservicios.

Ejecución de pruebas automatizadas (unitarias en Go y Python).

Análisis estático de código con SonarQube y cumplimiento de los quality gates.

2. Testing (testing)

En este entorno el equipo de QA realiza pruebas funcionales y de regresión.
Solo se promueven cambios a esta rama cuando:

El build y los tests en develop finalizaron correctamente.

El análisis de SonarQube no presenta fallos críticos.

Se otorga aprobación manual para el despliegue.

Esta aprobación manual garantiza que los testers reciban versiones controladas y documentadas, evitando que cada merge en develop se despliegue automáticamente en testing.

3. Production (main)

Es el entorno estable de producción.
Solo se actualiza luego de que el equipo de QA valide completamente la versión en testing.
El paso de testing a main también requiere aprobación manual, la cual se gestiona desde los environments protegidos de GitHub Actions.
De esta forma, el despliegue final se realiza únicamente con la confirmación del equipo responsable.

El pipeline contiene tres etapas:
1. **Build** – Compilación y construcción de los microservicios.  
2. **Test** – Ejecución de pruebas automáticas (Go y Python).  
3. **SonarQube** – Análisis estático de código y validación de *quality gates*.  
4. **Deploy** – Despliegue controlado en el ambiente correspondiente.

Los **quality gates** aseguran que:
- Solo se promuevan cambios de `develop` a `testing` si el build, las pruebas y el análisis de SonarQube son exitosos.  
- El paso de `develop` a `testing` requiere aprobación manual para garantizar que los testers validen versiones específicas.  
- El paso de `testing` a `production` también requiere **aprobación manual** configurada en GitHub Actions (environments protegidos).

---

## Herramientas utilizadas

- **GitHub Actions** – Automatización del pipeline CI/CD.  
- **Docker** – Construcción y despliegue de los microservicios.  
- **Go y Python** – Lenguajes base de los servicios.  
- **SonarQube** – Análisis estático de código y control de calidad.  
- **pytest / go test** – Testing automatizado.

---

## Resumen

Esta configuración garantiza:
- Integración continua y pruebas automatizadas en `develop`.  
- Despliegue controlado a `testing` solo con aprobación manual, evitando interferencias con el desarrollo y facilitando la validación por QA.  
- Despliegue seguro y aprobado en `production`.  
- Monitoreo de calidad mediante SonarQube y *quality gates* entre ambientes.

---
