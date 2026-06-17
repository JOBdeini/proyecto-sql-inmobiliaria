DROP TABLE IF EXISTS dim_clientes CASCADE;

CREATE TABLE dim_clientes (

    cliente_id SERIAL PRIMARY KEY,

    nombre_cliente VARCHAR(100) NOT NULL,

    email VARCHAR(150) UNIQUE,

    edad INTEGER,

    provincia VARCHAR(100),

    tipo_cliente VARCHAR(30) NOT NULL,

    fecha_alta DATE NOT NULL,

    canal_origen VARCHAR(50),

    CONSTRAINT chk_edad
        CHECK (
            edad IS NULL
            OR edad BETWEEN 18 AND 100
        ),

    CONSTRAINT chk_tipo_cliente
        CHECK (
            tipo_cliente IN (
                'Comprador',
                'Vendedor',
                'Comprador/Vendedor'
            )
        )
);

-- Comprobación de la tabla Clientes
select *
from dim_clientes


/* ============================================================
   TABLA DIMENSIÓN: OFICINAS
   Granularidad: una fila por oficina
   ============================================================ */

DROP TABLE IF EXISTS dim_oficinas CASCADE;

CREATE TABLE dim_oficinas (

    oficina_id SERIAL PRIMARY KEY,

    nombre_oficina VARCHAR(100) NOT NULL UNIQUE,

    ciudad VARCHAR(100) NOT NULL,

    zona VARCHAR(100) NOT NULL,

    fecha_apertura DATE NOT NULL,

    activa BOOLEAN NOT NULL DEFAULT TRUE,

    numero_empleados INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT chk_numero_empleados
        CHECK (numero_empleados >= 0)

);

-- Comprobación de la tabla Oficinas
select *
from dim_oficinas

/* ============================================================
   TABLA DIMENSIÓN: AGENTES
   Granularidad: una fila por agente comercial
   Relación: cada agente pertenece a una oficina
   ============================================================ */

DROP TABLE IF EXISTS dim_agentes CASCADE;

CREATE TABLE dim_agentes (

    agente_id SERIAL PRIMARY KEY,

    nombre_agente VARCHAR(100) NOT NULL,

    email VARCHAR(150) UNIQUE,

    telefono VARCHAR(20),

    oficina_id INTEGER NOT NULL,

    fecha_alta DATE NOT NULL,

    especialidad VARCHAR(50),

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_agente_oficina
        FOREIGN KEY (oficina_id)
        REFERENCES dim_oficinas(oficina_id),

    CONSTRAINT chk_email_agente
        CHECK (
            email IS NULL
            OR email LIKE '%@%'
        ),

    CONSTRAINT chk_especialidad_agente
        CHECK (
            especialidad IS NULL
            OR especialidad IN (
                'Residencial',
                'Alquiler',
                'Obra nueva',
                'Inversión',
                'Locales',
                'Generalista'
            )
        )
);

--- Comprobación de la tabla Agentes
select * 
from dim_agentes
limit 5




/* ============================================================
   TABLA DIMENSIÓN: INMUEBLES
   Granularidad: una fila por inmueble comercializado
   ============================================================ */

DROP TABLE IF EXISTS dim_inmuebles CASCADE;

CREATE TABLE dim_inmuebles (

    inmueble_id SERIAL PRIMARY KEY,

    referencia VARCHAR(30) NOT NULL UNIQUE,

    tipo_inmueble VARCHAR(50) NOT NULL,

    ciudad VARCHAR(100) NOT NULL,

    provincia VARCHAR(100) NOT NULL,

    zona VARCHAR(100) NOT NULL,

    metros_cuadrados NUMERIC(8,2) NOT NULL,

    habitaciones INTEGER NOT NULL,

    banos INTEGER NOT NULL,

    planta INTEGER,

    ascensor BOOLEAN NOT NULL DEFAULT FALSE,

    estado_inmueble VARCHAR(50) NOT NULL,

    precio_estimado NUMERIC(12,2) NOT NULL,

    fecha_alta DATE NOT NULL,

    CONSTRAINT chk_tipo_inmueble
        CHECK (
            tipo_inmueble IN (
                'Piso',
                'Casa',
                'Chalet',
                'Ático',
                'Local',
                'Estudio'
            )
        ),

    CONSTRAINT chk_metros_cuadrados
        CHECK (metros_cuadrados > 0),

    CONSTRAINT chk_habitaciones
        CHECK (habitaciones >= 0),

    CONSTRAINT chk_banos
        CHECK (banos >= 0),

    CONSTRAINT chk_planta
        CHECK (planta IS NULL OR planta >= 0),

    CONSTRAINT chk_estado_inmueble
        CHECK (
            estado_inmueble IN (
                'Nuevo',
                'Buen estado',
                'Reformado',
                'A reformar'
            )
        ),

    CONSTRAINT chk_precio_estimado
        CHECK (precio_estimado > 0)
);

-- Comprobación de la tabla Inmuebles
select * 
from dim_inmuebles

/* ============================================================
   TABLA DIMENSIÓN: CALENDARIO
   Granularidad: una fila por fecha
   ============================================================ */

DROP TABLE IF EXISTS dim_calendario CASCADE;

CREATE TABLE dim_calendario (

    fecha_id SERIAL PRIMARY KEY,

    fecha DATE NOT NULL UNIQUE,

    anio INTEGER NOT NULL,

    trimestre INTEGER NOT NULL,

    mes INTEGER NOT NULL,

    nombre_mes VARCHAR(20) NOT NULL,

    dia_mes INTEGER NOT NULL,

    dia_semana VARCHAR(20) NOT NULL,

    numero_dia_semana INTEGER NOT NULL,

    es_fin_semana BOOLEAN NOT NULL,

    CONSTRAINT chk_anio
        CHECK (anio BETWEEN 2020 AND 2035),

    CONSTRAINT chk_trimestre
        CHECK (trimestre BETWEEN 1 AND 4),

    CONSTRAINT chk_mes
        CHECK (mes BETWEEN 1 AND 12),

    CONSTRAINT chk_dia_mes
        CHECK (dia_mes BETWEEN 1 AND 31),

    CONSTRAINT chk_numero_dia_semana
        CHECK (numero_dia_semana BETWEEN 1 AND 7)
);

-- Comprobación de la tabla Calendario
select *
from dim_calendario
limit 10

/* ============================================================
   TABLA DE HECHOS: OPERACIONES
   Granularidad: una fila por operación comercial inmobiliaria

   Esta tabla conecta las dimensiones de clientes, inmuebles,
   agentes, oficinas y calendario.

   Permite analizar ventas, alquileres y reservas por fecha,
   oficina, agente, cliente, zona y tipo de inmueble.
   ============================================================ */

DROP TABLE IF EXISTS fact_operaciones CASCADE;

CREATE TABLE fact_operaciones (

    operacion_id SERIAL PRIMARY KEY,

    fecha_id INTEGER NOT NULL,

    cliente_id INTEGER NOT NULL,

    inmueble_id INTEGER NOT NULL,

    agente_id INTEGER NOT NULL,

    oficina_id INTEGER NOT NULL,

    tipo_operacion VARCHAR(30) NOT NULL,

    estado_operacion VARCHAR(30) NOT NULL DEFAULT 'En proceso',

    precio_publicado NUMERIC(12,2) NOT NULL,

    precio_cierre NUMERIC(12,2),

    comision_pct NUMERIC(5,2) NOT NULL DEFAULT 3.00,

    comision_importe NUMERIC(12,2),

    dias_en_mercado INTEGER,

    forma_pago VARCHAR(50),

    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Establecemos las conexiones

    CONSTRAINT fk_operacion_fecha
        FOREIGN KEY (fecha_id)
        REFERENCES dim_calendario(fecha_id),

    CONSTRAINT fk_operacion_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES dim_clientes(cliente_id),

    CONSTRAINT fk_operacion_inmueble
        FOREIGN KEY (inmueble_id)
        REFERENCES dim_inmuebles(inmueble_id),

    CONSTRAINT fk_operacion_agente
        FOREIGN KEY (agente_id)
        REFERENCES dim_agentes(agente_id),

    CONSTRAINT fk_operacion_oficina
        FOREIGN KEY (oficina_id)
        REFERENCES dim_oficinas(oficina_id),

    CONSTRAINT chk_tipo_operacion
        CHECK (
            tipo_operacion IN (
                'Venta',
                'Alquiler',
                'Reserva'
            )
        ),

    CONSTRAINT chk_estado_operacion
        CHECK (
            estado_operacion IN (
                'Cerrada',
                'En proceso',
                'Cancelada'
            )
        ),

    CONSTRAINT chk_precio_publicado
        CHECK (precio_publicado > 0),

    CONSTRAINT chk_precio_cierre
        CHECK (
            precio_cierre IS NULL
            OR precio_cierre > 0
        ),

    CONSTRAINT chk_comision_pct
        CHECK (comision_pct BETWEEN 0 AND 10),

    CONSTRAINT chk_comision_importe
        CHECK (
            comision_importe IS NULL
            OR comision_importe >= 0
        ),

    CONSTRAINT chk_dias_en_mercado
        CHECK (
            dias_en_mercado IS NULL
            OR dias_en_mercado >= 0
        ),

    CONSTRAINT chk_forma_pago
        CHECK (
            forma_pago IS NULL
            OR forma_pago IN (
                'Hipoteca',
                'Contado',
                'Mixto',
                'No aplica'
            )
        )
);

-- Comprobación de la tabla de hecho operaciones
select *
from fact_operaciones
limit 10


/* ============================================================
   ÍNDICES DEL MODELO

   Los índices se crean sobre campos usados con frecuencia en
   filtros, JOINs y agrupaciones analíticas.
   ============================================================ */

-- Índice para acelerar consultas temporales por fecha
CREATE INDEX IF NOT EXISTS idx_fact_operaciones_fecha
ON fact_operaciones(fecha_id);

-- Índice para acelerar análisis por oficina
CREATE INDEX IF NOT EXISTS idx_fact_operaciones_oficina
ON fact_operaciones(oficina_id);

-- Índice para rankings y análisis de rendimiento comercial por agente
CREATE INDEX IF NOT EXISTS idx_fact_operaciones_agente
ON fact_operaciones(agente_id);

-- Índice para filtrar operaciones cerradas, canceladas o en proceso
CREATE INDEX IF NOT EXISTS idx_fact_operaciones_estado
ON fact_operaciones(estado_operacion);

-- Índice para analizar ventas, alquileres y reservas por separado
CREATE INDEX IF NOT EXISTS idx_fact_operaciones_tipo
ON fact_operaciones(tipo_operacion);

-- Índice sobre zona y ciudad para análisis geográfico de inmuebles
CREATE INDEX IF NOT EXISTS idx_dim_inmuebles_zona_ciudad
ON dim_inmuebles(ciudad, zona);

-- Índice sobre oficina de los agentes para mejorar JOINs agente-oficina
CREATE INDEX IF NOT EXISTS idx_dim_agentes_oficina
ON dim_agentes(oficina_id);


/*===========================================
 * COMPROBAMOS QUE ESTÁN CREADOS LOS ÍNDICES
 ========================================== */

SELECT
    indexname,
    tablename
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;



/* =======================================
 * Vista 1: Resumen de ventas
======================================== */
DROP VIEW IF EXISTS vw_resumen_ventas;

CREATE VIEW vw_resumen_ventas AS

SELECT

    f.operacion_id,
    c.nombre_cliente,
    i.referencia,
    i.tipo_inmueble,
    o.nombre_oficina,
    a.nombre_agente,
    f.precio_cierre,
    f.comision_importe

FROM fact_operaciones f

INNER JOIN dim_clientes c
ON f.cliente_id = c.cliente_id

INNER JOIN dim_inmuebles i
ON f.inmueble_id = i.inmueble_id

INNER JOIN dim_oficinas o
ON f.oficina_id = o.oficina_id

INNER JOIN dim_agentes a
ON f.agente_id = a.agente_id

WHERE f.estado_operacion = 'Cerrada';

/* =======================================
 * Vista 2: Rendimiento de agentes
======================================== */
DROP VIEW IF EXISTS vw_rendimiento_agentes;

CREATE VIEW vw_rendimiento_agentes AS

SELECT

    a.agente_id,
    a.nombre_agente,
    COUNT(*) AS operaciones,
    SUM(f.comision_importe) AS comisiones

FROM fact_operaciones f

INNER JOIN dim_agentes a
ON f.agente_id = a.agente_id

WHERE f.estado_operacion = 'Cerrada'

GROUP BY
    a.agente_id,
    a.nombre_agente
order by comisiones desc;

/* =======================================
 * FUNCIÓN para calcular la comisión media
======================================== */
CREATE OR REPLACE FUNCTION fn_comision_media_agente(
    p_agente_id INTEGER
)
RETURNS NUMERIC
LANGUAGE SQL
AS
$$

SELECT AVG(comision_importe)

FROM fact_operaciones

WHERE agente_id = p_agente_id
AND estado_operacion = 'Cerrada';

$$;


-- Comprobación
SELECT fn_comision_media_agente(11);






