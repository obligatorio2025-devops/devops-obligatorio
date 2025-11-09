# devops-obligatorio
Repositorio para el obligatorio de DevOps para finales de 2025.  

El equipo esta formado por: Camila Ayunto, Bruno Charletto y Constanza Esquivel

## Estrategia de ramas

El proyecto utiliza una variante ligera de **Trunk-Based Development** con una rama de integración (`develop`):

- `main`: rama estable (solo merges de PR aprobados).
- `develop`: rama de integración y pruebas continuas.
- `feature/<nombre>`: ramas temporales para nuevas funcionalidades o fixes.

El flujo de trabajo es:
1. Crear una rama `feature/<nombre>` desde `develop`.
2. Commit y push con cambios.
3. Abrir Pull Request hacia `develop`.
4. Validar CI/CD y revisión cruzada.
5. Merge a `develop`.
6. Al cerrar una iteración o release, merge de `develop` → `main`.

Los merges hacia `main` requieren aprobación y todos los checks (build, lint, tests, Sonar) deben pasar.
