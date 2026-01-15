-- Haz clic derecho en Databases y selecciona Create > Database
-- Nombre: cat2025
-- Encoding: UTF8
-- Click en Save


-- 2. Activar PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

-- 3. Extensiones opcionales (descomenta si las necesitas)
 CREATE EXTENSION IF NOT EXISTS postgis_topology;
-- CREATE EXTENSION IF NOT EXISTS postgis_raster;
 CREATE EXTENSION IF NOT EXISTS postgis_sfcgal;

-- 4. Crear tablas

-- 1. Eliminar la tabla si ya existe
DROP TABLE IF EXISTS cat11_fincas CASCADE;

-- 2. Crear la nueva tabla sin restricción de unicidad en ref_catastral
CREATE TABLE cat11_fincas (
    id SERIAL PRIMARY KEY,
    delegacion TEXT,
    municipio_dgc TEXT,
    ref_catastral TEXT,
    provincia TEXT,
    municipio TEXT,
    via TEXT,
    num_pol TEXT,
    superficie_finca DOUBLE PRECISION,
    sup_const_total DOUBLE PRECISION,
    sup_const_sobre DOUBLE PRECISION,
    sup_const_bajo DOUBLE PRECISION,
    coor_x DOUBLE PRECISION,
    coor_y DOUBLE PRECISION,
    epsg TEXT,
    geom GEOMETRY(Point, 25830)
);

-- 3. (Opcional) Crear índice para búsquedas rápidas por ref_catastral
CREATE INDEX idx_cat11_ref_catastral ON cat11_fincas(ref_catastral);

-- CAT13 - Unidades constructivas
CREATE TABLE cat13_uc (
    ref_catastral TEXT,
    codigo_uc TEXT,
    provincia TEXT,
    municipio TEXT,
    via TEXT,
    num_pol TEXT,
    anio_construccion TEXT,
    sup_ocupada DOUBLE PRECISION
);

-- CAT14 - Construcciones
CREATE TABLE cat14_const (
    ref_catastral TEXT,
    codigo_construccion TEXT,
    codigo_uc TEXT,
    destino TEXT,
    anio_reforma TEXT,
    sup_total DOUBLE PRECISION
);

-- CAT15 - Bienes inmuebles
CREATE TABLE cat15_inmuebles (
    ref_catastral TEXT,
    num_cargo TEXT,
    provincia TEXT,
    municipio TEXT,
    via TEXT,
    num_pol TEXT,
    sup_constructiva DOUBLE PRECISION,
    sup_suelo DOUBLE PRECISION,
    coef_propiedad DOUBLE PRECISION
);

-- CAT16 - Reparto
CREATE TABLE cat16_reparto (
    ref_catastral TEXT,
    elemento TEXT,
    reparto1 TEXT,
    porcentaje1 DOUBLE PRECISION
);

-- CAT17 - Cultivos (solo rústica)
CREATE TABLE cat17_cultivos (
    ref_catastral TEXT,
    codigo_subparcela TEXT,
    tipo TEXT,
    sup_subparcela DOUBLE PRECISION,
    cultivo TEXT
);


-- 5. Importar CSVs fusionados (modifica rutas reales a tu sistema)

-- CAT11
COPY cat11_fincas(delegacion, municipio_dgc, ref_catastral, provincia, municipio, via, num_pol,
                  superficie_finca, sup_const_total, sup_const_sobre, sup_const_bajo,
                  coor_y, coor_x, epsg)
FROM 'C:\\a\\OMISOR2025\\CAT\\CAT11_fincas.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';

-- Crear geometría
UPDATE cat11_fincas
SET geom = ST_SetSRID(ST_MakePoint(coor_x, coor_y), 25830);

-- Resto de tablas
COPY cat13_uc FROM 'C:\\a\\OMISOR2025\\CAT\\CAT13_uc.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
COPY cat14_const FROM 'C:\\a\\OMISOR2025\\CAT\\CAT14_const.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
COPY cat15_inmuebles FROM 'C:\\a\\OMISOR2025\\CAT\\CAT15_inmuebles.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
COPY cat16_reparto FROM 'C:\\a\\OMISOR2025\\CAT\\CAT16_reparto.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
COPY cat17_cultivos FROM 'C:\\a\\OMISOR2025\\CAT\\CAT17_cultivos.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';


