# Tarea 1.1 – PostgreSQL + Adminer con Docker Compose

Base de datos de albergues del Camino de Santiago (PostgreSQL 17) con Adminer 4 como interfaz web.

## Estructura

```
.
├── compose.yaml
├── .env.example      # plantilla (se sube al repositorio)
├── .env              # valores reales (NO se sube)
└── initbd/
    ├── 01_esquema.sql   # crea la tabla albergues
    └── 02_datos.sql     # inserta 9 albergues inventados
```

## Cómo arrancar el proyecto

1. Clonar el repositorio y entrar en la carpeta del proyecto.
2. Copiar la plantilla de variables de entorno:
   ```bash
   cp .env.example .env
   ```
3. Editar `.env` y poner una contraseña real en `POSTGRES_PASSWORD`.
4. Levantar los servicios:
   ```bash
   docker compose up -d
   ```
5. Comprobar que `db` está `healthy`:
   ```bash
   docker compose ps
   ```
6. Abrir Adminer en <http://localhost:8080>. El servidor `db` ya aparece por defecto; usar el sistema **PostgreSQL** con el usuario, contraseña y base de datos definidos en `.env`.
7. Para parar: `docker compose down` (conserva los datos) o `docker compose down -v` (los borra).

> Los scripts de `initbd/` solo se ejecutan la **primera vez**, cuando el volumen está vacío.

## Prueba de persistencia

| Paso | Acción | Comando | Resultado esperado | Resultado obtenido |
|------|--------|---------|--------------------|--------------------|
| 1 | Arrancar y comprobar los datos iniciales | `docker compose up -d` y `SELECT count(*) FROM albergues;` | 9 filas | _completar_ |
| 2 | Insertar un albergue nuevo | `INSERT INTO albergues (nombre, concello, camino, num_plazas, precio_noche) VALUES ('Albergue Prueba', 'Lugo', 'Camino Primitivo', 20, 9.00);` | 10 filas | _completar_ |
| 3 | Parar y eliminar los contenedores (sin `-v`) | `docker compose down` | Contenedores y red eliminados, volumen conservado | _completar_ |
| 4 | Volver a arrancar | `docker compose up -d` | Los scripts de initdb **no** se ejecutan de nuevo | _completar_ |
| 5 | Comprobar que el dato sigue | `SELECT count(*) FROM albergues;` | 10 filas (el albergue de prueba existe) | _completar_ |
| 6 | Borrar también el volumen | `docker compose down -v` y `docker compose up -d` | BD recreada desde los scripts | _completar_ |
| 7 | Comprobar tras borrar el volumen | `SELECT count(*) FROM albergues;` | 9 filas (el albergue de prueba desapareció) | _completar_ |

Consulta desde terminal:
```bash
docker compose exec db psql -U usuario -d albergues -c "SELECT count(*) FROM albergues;"
```
