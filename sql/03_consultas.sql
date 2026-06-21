-- Detectar clientes con edad nula
SELECT *
FROM dim_clientes
WHERE edad IS NULL;

-- Detectar clientes sin canal de origen
SELECT *
FROM dim_clientes
WHERE canal_origen IS NULL;


/* LIMPIEZA */
UPDATE dim_clientes
SET edad = 35
WHERE edad IS NULL;

UPDATE dim_clientes
SET canal_origen = 'Desconocido'
WHERE canal_origen IS NULL;

/* ============================================================
   AGREGACIONES BÁSICAS DEL MODELO
   Objetivo: entender el volumen, valor medio y comisiones
   ============================================================ */

-- Total de operaciones registradas
SELECT
    COUNT(*) AS total_operaciones
FROM fact_operaciones;

-- Operaciones por estado
SELECT
    estado_operacion,
    COUNT(*) AS total_operaciones
FROM fact_operaciones
GROUP BY estado_operacion
ORDER BY total_operaciones DESC;

-- Operaciones por tipo: venta, alquiler o reserva
SELECT
    tipo_operacion,
    COUNT(*) AS total_operaciones
FROM fact_operaciones
GROUP BY tipo_operacion
ORDER BY total_operaciones DESC;

-- Métricas económicas generales de operaciones cerradas
SELECT
    COUNT(*) AS operaciones_cerradas,
    SUM(precio_cierre) AS volumen_total_cierre,
    AVG(precio_cierre) AS precio_medio_cierre,
    SUM(comision_importe) AS comision_total,
    AVG(comision_importe) AS comision_media
FROM fact_operaciones
WHERE estado_operacion = 'Cerrada';

-- Días medios en mercado por tipo de operación
SELECT
    tipo_operacion,
    AVG(dias_en_mercado) AS dias_medios_en_mercado
FROM fact_operaciones
GROUP BY tipo_operacion
ORDER BY dias_medios_en_mercado DESC;

-- Precio medio publicado y precio medio de cierre
SELECT
    AVG(precio_publicado) AS precio_medio_publicado,
    AVG(precio_cierre) AS precio_medio_cierre,
    AVG(precio_publicado - precio_cierre) AS descuento_medio
FROM fact_operaciones
WHERE precio_cierre IS NOT NULL;


/* == CASE Segmentación por edades == */
SELECT
    nombre_cliente,
    edad,
    CASE
        WHEN edad < 35 THEN 'Joven'
        WHEN edad < 50 THEN 'Adulto'
        ELSE 'Senior'
    END AS segmento
FROM dim_clientes;

/* == CTE Comisiones por zona == */
-- Zonas que generan más ingresos

WITH ventas AS (

    SELECT
        f.oficina_id,
        o.nombre_oficina,
        SUM(f.comision_importe) AS total_comisiones

    FROM fact_operaciones f

    INNER JOIN dim_oficinas o
        ON f.oficina_id = o.oficina_id

    WHERE f.estado_operacion = 'Cerrada'

    GROUP BY
        f.oficina_id,
        o.nombre_oficina

)

SELECT *
FROM ventas
ORDER BY total_comisiones DESC;


/* == CTE ENCADENADA: rendimiento por oficina - Ranking == */

WITH ventas_oficina AS (

    SELECT
        oficina_id,
        COUNT(*) AS total_operaciones,
        SUM(comision_importe) AS total_comisiones,
        AVG(precio_cierre) AS precio_medio_cierre
    FROM fact_operaciones
    WHERE estado_operacion = 'Cerrada'
    GROUP BY oficina_id

),

ranking_oficinas AS (

    SELECT
        o.nombre_oficina,
        v.total_operaciones,
        v.total_comisiones,
        v.precio_medio_cierre,
        RANK() OVER (
            ORDER BY v.total_comisiones DESC
        ) AS ranking_comisiones
    FROM ventas_oficina v
    INNER JOIN dim_oficinas o
        ON v.oficina_id = o.oficina_id

)

SELECT *
FROM ranking_oficinas;


/* == FUNCIÓN VENTANA - Ranking de agentes con más comisiones generadas == */
SELECT

    nombre_agente,

    SUM(comision_importe) AS total_comisiones,

    RANK() OVER(
        ORDER BY SUM(comision_importe) DESC
    ) ranking

FROM fact_operaciones f

INNER JOIN dim_agentes a
ON f.agente_id = a.agente_id

WHERE estado_operacion = 'Cerrada'

GROUP BY nombre_agente;


/* == SUBQUERY Operaciones con precio de cierre no nulo == */
SELECT *

FROM fact_operaciones

WHERE precio_cierre >

(
    SELECT AVG(precio_cierre)
    FROM fact_operaciones
    WHERE precio_cierre IS NOT NULL
);

/* == LEFT JOIN Operación id con nombre de cliente relacionado == */
SELECT
    c.nombre_cliente,
    f.operacion_id
FROM dim_clientes c
LEFT JOIN fact_operaciones f
ON c.cliente_id = f.cliente_id;



/* ============================================================
   CONSULTAS ANALÍTICAS DE NEGOCIO
   ============================================================ */

/* 1. Ventas cerradas por oficina
 Insight: permite identificar qué oficina genera mayor volumen económico. */

SELECT
    o.nombre_oficina,
    COUNT(*) AS operaciones_cerradas,
    SUM(f.precio_cierre) AS volumen_ventas,
    SUM(f.comision_importe) AS comision_total
FROM fact_operaciones f
INNER JOIN dim_oficinas o
    ON f.oficina_id = o.oficina_id
WHERE f.estado_operacion = 'Cerrada'
GROUP BY o.nombre_oficina
ORDER BY volumen_ventas DESC;


/* 2. Rendimiento comercial por agente
Insight: permite comparar productividad y comisiones generadas por agente. */

SELECT
    a.nombre_agente,
    o.nombre_oficina,
    COUNT(*) AS operaciones_cerradas,
    SUM(f.comision_importe) AS comision_total,
    AVG(f.comision_importe) AS comision_media
FROM fact_operaciones f
INNER JOIN dim_agentes a
    ON f.agente_id = a.agente_id
INNER JOIN dim_oficinas o
    ON a.oficina_id = o.oficina_id
WHERE f.estado_operacion = 'Cerrada'
GROUP BY
    a.nombre_agente,
    o.nombre_oficina
ORDER BY comision_total DESC;


/* 3. Precio medio de cierre por zona
 Insight: permite detectar las zonas con mayor valor inmobiliario medio. */

SELECT
    i.ciudad,
    i.zona,
    COUNT(*) AS operaciones,
    ROUND(AVG(f.precio_cierre)) AS precio_medio_cierre
FROM fact_operaciones f
INNER JOIN dim_inmuebles i
    ON f.inmueble_id = i.inmueble_id
WHERE f.estado_operacion = 'Cerrada'
  AND f.tipo_operacion = 'Venta'
GROUP BY
    i.ciudad,
    i.zona
ORDER BY precio_medio_cierre DESC;


/* 4. Tipo de inmueble más vendido
 Insight: muestra qué producto inmobiliario tiene mayor rotación. */

SELECT
    i.tipo_inmueble,
    COUNT(*) AS total_operaciones
FROM fact_operaciones f
INNER JOIN dim_inmuebles i
    ON f.inmueble_id = i.inmueble_id
WHERE f.estado_operacion = 'Cerrada'
GROUP BY i.tipo_inmueble
ORDER BY total_operaciones DESC;


/* 5. Días medios en mercado según estado del inmueble
 Insight: permite comprobar si los inmuebles reformados o nuevos se venden más rápido. */

SELECT
    i.estado_inmueble,
    COUNT(*) AS operaciones,
    ROUND(AVG(f.dias_en_mercado)) AS dias_medios_mercado
FROM fact_operaciones f
INNER JOIN dim_inmuebles i
    ON f.inmueble_id = i.inmueble_id
WHERE f.estado_operacion = 'Cerrada'
GROUP BY i.estado_inmueble
ORDER BY dias_medios_mercado ASC;


/* 6. Descuento medio entre precio publicado y precio de cierre
 Insight: detecta zonas donde se negocia más el precio inicial. */

SELECT
    i.ciudad,
    i.zona,
    ROUND(AVG(f.precio_publicado - f.precio_cierre)) AS descuento_medio,
    ROUND(AVG(
        ((f.precio_publicado - f.precio_cierre) / f.precio_publicado)) * 100
    ) AS descuento_pct_medio
FROM fact_operaciones f
INNER JOIN dim_inmuebles i
    ON f.inmueble_id = i.inmueble_id
WHERE f.estado_operacion = 'Cerrada'
  AND f.precio_cierre IS NOT NULL
GROUP BY
    i.ciudad,
    i.zona
ORDER BY descuento_pct_medio DESC;


/* 7. Evolución mensual de operaciones cerradas
 Insight: permite observar estacionalidad y meses con mayor COMISIÓN. */

SELECT
    c.anio,
    c.mes,
    TRIM(c.nombre_mes) AS nombre_mes,
    COUNT(*) AS operaciones_cerradas,
    SUM(f.comision_importe) AS comision_total
FROM fact_operaciones f
INNER JOIN dim_calendario c
    ON f.fecha_id = c.fecha_id
WHERE f.estado_operacion = 'Cerrada'
GROUP BY
    c.anio,
    c.mes,
    TRIM(c.nombre_mes)
ORDER BY
    c.anio,
	comision_total DESC;


/* 8. Ranking de agentes por comisión generada
 Insight: identifica los agentes con mayor aportación económica. */

SELECT
    a.nombre_agente,
    o.nombre_oficina,
    SUM(f.comision_importe) AS comision_total,
    RANK() OVER (
        ORDER BY SUM(f.comision_importe) DESC
    ) AS ranking_agente
FROM fact_operaciones f
INNER JOIN dim_agentes a
    ON f.agente_id = a.agente_id
INNER JOIN dim_oficinas o
    ON a.oficina_id = o.oficina_id
WHERE f.estado_operacion = 'Cerrada'
GROUP BY
    a.nombre_agente,
    o.nombre_oficina;


/* 9. Comparativa de operaciones por canal de origen del cliente
 Insight: muestra qué canales generan más operaciones cerradas. */

SELECT
    c.canal_origen,
    COUNT(*) AS operaciones_cerradas,
    SUM(f.comision_importe) AS comision_total,
    AVG(f.precio_cierre) AS precio_medio_cierre
FROM fact_operaciones f
INNER JOIN dim_clientes c
    ON f.cliente_id = c.cliente_id
WHERE f.estado_operacion = 'Cerrada'
GROUP BY c.canal_origen
ORDER BY comision_total DESC;


/* 10. Clientes sin operaciones mediante LEFT JOIN
 Insight: permite detectar clientes registrados que todavía no han generado operaciones. */

SELECT
    c.cliente_id,
    c.nombre_cliente,
    c.canal_origen,
    COUNT(f.operacion_id) AS operaciones_asociadas
FROM dim_clientes c
LEFT JOIN fact_operaciones f
    ON c.cliente_id = f.cliente_id
GROUP BY
    c.cliente_id,
    c.nombre_cliente,
    c.canal_origen
HAVING COUNT(f.operacion_id) = 0;


/* 11. Operaciones por encima del precio medio de cierre
 Insight: identifica operaciones de alto valor mediante subquery. */

SELECT
    f.operacion_id,
    i.referencia,
    i.tipo_inmueble,
    i.zona,
    f.precio_cierre
FROM fact_operaciones f
INNER JOIN dim_inmuebles i
    ON f.inmueble_id = i.inmueble_id
WHERE f.precio_cierre > (
    SELECT AVG(precio_cierre)
    FROM fact_operaciones
    WHERE precio_cierre IS NOT NULL
)
ORDER BY f.precio_cierre DESC;


/* 12. CTE encadenada para ranking de oficinas
 Insight: compara oficinas por comisiones y precio medio de cierre. */

WITH ventas_oficina AS (

    SELECT
        oficina_id,
        COUNT(*) AS total_operaciones,
        SUM(comision_importe) AS total_comisiones,
        AVG(precio_cierre) AS precio_medio_cierre
    FROM fact_operaciones
    WHERE estado_operacion = 'Cerrada'
    GROUP BY oficina_id

),

ranking_oficinas AS (

    SELECT
        o.nombre_oficina,
        v.total_operaciones,
        v.total_comisiones,
        v.precio_medio_cierre,
        RANK() OVER (
            ORDER BY v.total_comisiones DESC
        ) AS ranking_comisiones
    FROM ventas_oficina v
    INNER JOIN dim_oficinas o
        ON v.oficina_id = o.oficina_id

)

SELECT *
FROM ranking_oficinas;


/* =======================================
 * CONSULTA FORMAS DE PAGO DE LAS VENTAS CERRADAS
======================================== */
SELECT
    forma_pago,
    COUNT(*) AS total_operaciones,
    SUM(precio_cierre) AS volumen_ventas,
    SUM(comision_importe) AS comision_total,
    ROUND(AVG(precio_cierre), 2) AS precio_medio_cierre
FROM fact_operaciones
WHERE estado_operacion = 'Cerrada'
GROUP BY forma_pago
ORDER BY comision_total DESC;
