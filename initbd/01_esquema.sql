CREATE TABLE albergues (
    id              SERIAL PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    concello        VARCHAR(100) NOT NULL,
    camino          VARCHAR(100) NOT NULL,
    num_plazas      INTEGER NOT NULL CHECK (num_plazas > 0),
    precio_noche    NUMERIC(6,2) NOT NULL CHECK (precio_noche >= 0)
);
