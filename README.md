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

Comando para contar los albergues desde la terminal (alternativa a Adminer):

```bash
docker compose exec db psql -U usuario -d albergues -c "SELECT count(*) FROM albergues;"
```

| Paso | Comando | Resultado obtenido |
|------|---------|--------------------|
| 1 | `docker compose up -d` y comprobar con `docker compose exec db psql -U usuario -d albergues -c "SELECT count(*) FROM albergues;"` | _Completar (esperado: 9 filas)_ |
| 2 | Insertar un albergue nuevo desde Adminer (http://localhost:8080 → Comando SQL): `INSERT INTO albergues (nombre, concello, camino, num_plazas, precio_noche) VALUES ('Albergue Prueba', 'Lugo', 'Camino Primitivo', 20, 9.00);` | _Completar (esperado: 10 filas)_ |
| 3 | `docker compose down` y `docker compose up -d`, y repetir el `SELECT count(*) FROM albergues;` | _Completar (esperado: 10 filas)_ |
| 4 | `docker compose down -v` y `docker compose up -d`, y repetir el `SELECT count(*) FROM albergues;` | _Completar (esperado: 9 filas)_ |

## ¿Por qué en el paso 4 el resultado es distinto?

En el paso 3, `docker compose down` elimina los contenedores y la red, pero conserva el volumen `pgdata`. Al volver a arrancar, PostgreSQL encuentra datos en el volumen, no ejecuta los scripts de `initbd/` y el albergue añadido sigue ahí.

En el paso 4, `docker compose down -v` borra también el volumen con nombre. Al arrancar, el volumen está vacío, así que PostgreSQL ejecuta de nuevo `01_esquema.sql` y `02_datos.sql`, que dejan solo los 9 albergues originales. El albergue añadido en el paso 2 se pierde.
