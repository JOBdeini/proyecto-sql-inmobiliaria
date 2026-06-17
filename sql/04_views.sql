/* ============================================================
   04_views.sql
   Vistas de negocio para análisis inmobiliario
   ============================================================ */


/* ============================================================
-- VISTA 1: VENTAS CERRADAS
-- Objetivo: tener una vista limpia de operaciones finalizadas.
-- ============================================================ */

DROP VIEW IF EXISTS vw_ventas_cerradas;

CREATE VIEW vw_ventas_cerradas AS

SELECT
    f.operacion_id,
    cal.fecha,
    cal.anio,
    cal.mes,
    TRIM(cal.nombre_mes) AS nombre_mes,

    c.cliente_id,
    c.nombre_cliente,
    c.tipo_cliente,
    c.provincia AS provincia_cliente,
    c.canal_origen,

    i.inmueble_id,
    i.referencia,
    i.tipo_inmueble,
    i.ciudad AS ciudad_inmueble,
    i.provincia AS provincia_inmueble,
    i.zona,
    i.metros_cuadrados,
    i.habitaciones,
    i.banos,
    i.estado_inmueble,

    a.agente_id,
    a.nombre_agente,
    a.especialidad,

    o.oficina_id,
    o.nombre_oficina,
    o.ciudad AS ciudad_oficina,

    f.tipo_operacion,
    f.precio_publicado,
    f.precio_cierre,
    f.comision_pct,
    f.comision_importe,
    f.dias_en_mercado,
    f.forma_pago

FROM fact_operaciones f

INNER JOIN dim_calendario cal
    ON f.fecha_id = cal.fecha_id

INNER JOIN dim_clientes c
    ON f.cliente_id = c.cliente_id

INNER JOIN dim_inmuebles i
    ON f.inmueble_id = i.inmueble_id

INNER JOIN dim_agentes a
    ON f.agente_id = a.agente_id

INNER JOIN dim_oficinas o
    ON f.oficina_id = o.oficina_id

WHERE f.estado_operacion = 'Cerrada';



/* ============================================================
-- VISTA 2: RENDIMIENTO DE OFICINAS
-- Objetivo: comparar oficinas por volumen, comisión y ticket medio.
-- ============================================================ */

DROP VIEW IF EXISTS vw_rendimiento_oficinas;

CREATE VIEW vw_rendimiento_oficinas AS

SELECT
    o.oficina_id,
    o.nombre_oficina,
    o.ciudad,
    o.zona,

    COUNT(f.operacion_id) AS total_operaciones_cerradas,
    SUM(f.precio_cierre) AS volumen_total_cierre,
    ROUND(AVG(f.precio_cierre), 2) AS precio_medio_cierre,
    SUM(f.comision_importe) AS comision_total,
    ROUND(AVG(f.comision_importe), 2) AS comision_media,
    ROUND(AVG(f.dias_en_mercado), 2) AS dias_medios_mercado

FROM dim_oficinas o

LEFT JOIN fact_operaciones f
    ON o.oficina_id = f.oficina_id
   AND f.estado_operacion = 'Cerrada'

GROUP BY
    o.oficina_id,
    o.nombre_oficina,
    o.ciudad,
    o.zona;



/* ============================================================
-- VISTA 3: RENDIMIENTO DE AGENTES
-- Objetivo: analizar productividad comercial individual.
-- ============================================================ */

DROP VIEW IF EXISTS vw_rendimiento_agentes;

CREATE VIEW vw_rendimiento_agentes AS

SELECT
    a.agente_id,
    a.nombre_agente,
    a.especialidad,
    o.nombre_oficina,

    COUNT(f.operacion_id) AS total_operaciones_cerradas,
    SUM(f.precio_cierre) AS volumen_total_cierre,
    SUM(f.comision_importe) AS comision_total,
    ROUND(AVG(f.comision_importe), 2) AS comision_media,
    ROUND(AVG(f.dias_en_mercado), 2) AS dias_medios_mercado

FROM dim_agentes a

INNER JOIN dim_oficinas o
    ON a.oficina_id = o.oficina_id

LEFT JOIN fact_operaciones f
    ON a.agente_id = f.agente_id
   AND f.estado_operacion = 'Cerrada'

GROUP BY
    a.agente_id,
    a.nombre_agente,
    a.especialidad,
    o.nombre_oficina;



/* ============================================================
-- VISTA 4: ANÁLISIS DE INMUEBLES POR ZONA
-- Objetivo: detectar zonas y tipologías con mayor rendimiento.
-- ============================================================ */

DROP VIEW IF EXISTS vw_inmuebles_zona;

CREATE VIEW vw_inmuebles_zona AS

SELECT
    i.ciudad,
    i.zona,
    i.tipo_inmueble,
    i.estado_inmueble,

    COUNT(f.operacion_id) AS operaciones_cerradas,
    ROUND(AVG(f.precio_cierre), 2) AS precio_medio_cierre,
    ROUND(AVG(f.precio_publicado - f.precio_cierre), 2) AS descuento_medio,
    ROUND(AVG(f.dias_en_mercado), 2) AS dias_medios_mercado

FROM dim_inmuebles i

LEFT JOIN fact_operaciones f
    ON i.inmueble_id = f.inmueble_id
   AND f.estado_operacion = 'Cerrada'

GROUP BY
    i.ciudad,
    i.zona,
    i.tipo_inmueble,
    i.estado_inmueble;



/* ============================================================
-- VISTA 5: CANALES DE CAPTACIÓN
-- Objetivo: analizar qué canales generan operaciones y comisiones.
-- ============================================================ */

DROP VIEW IF EXISTS vw_canales_captacion;

CREATE VIEW vw_canales_captacion AS

SELECT
    c.canal_origen,

    COUNT(f.operacion_id) AS operaciones_cerradas,
    SUM(f.precio_cierre) AS volumen_total_cierre,
    SUM(f.comision_importe) AS comision_total,
    ROUND(AVG(f.precio_cierre), 2) AS precio_medio_cierre

FROM dim_clientes c

LEFT JOIN fact_operaciones f
    ON c.cliente_id = f.cliente_id
   AND f.estado_operacion = 'Cerrada'

GROUP BY c.canal_origen;





/* ================================
-- 1. ANÁLISIS DE VENTAS CERRADAS
-- ================================ */
SELECT *
FROM vw_ventas_cerradas

-- Ranking por año y oficina
SELECT
    anio,
    nombre_oficina,
    COUNT(*) AS operaciones,
    SUM(comision_importe) AS comision_total,
    SUM(precio_cierre) AS volumen_ventas
FROM vw_ventas_cerradas
GROUP BY
    anio,
    nombre_oficina
ORDER BY
    comision_total DESC;

/* ================================
-- 2. RENDIMIENTO OFICINAS
-- ================================ */

SELECT *
FROM vw_rendimiento_oficinas;


/* ================================
-- 3. RENDIMIENTO AGENTES
-- ================================ */

SELECT *
FROM vw_rendimiento_agentes;

-- Ranking de agentes por año
SELECT
    anio,
    nombre_agente,
    COUNT(*) AS operaciones,
    SUM(comision_importe) AS comision_total
FROM vw_ventas_cerradas
GROUP BY
    anio,
    nombre_agente
ORDER BY
    anio,
    comision_total DESC;


/* ================================
-- 4. ANÁLISIS DE INMUEBLES POR ZONA
-- ================================ */

SELECT *
FROM vw_inmuebles_zona


/* ============================
-- 5. CANALES DE CAPTACIÓN
-- ============================ */

select *
from vw_canales_captacion


