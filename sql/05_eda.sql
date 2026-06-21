/*=====================================
 * CALIDAD DEL DATO
 ====================================== */

-- NULOS POR TABLA
SELECT
    COUNT(*) AS clientes_sin_edad
FROM dim_clientes
WHERE edad IS NULL;

-- CLIENTES SIN CANAL
SELECT
    COUNT(*) AS clientes_sin_canal
FROM dim_clientes
WHERE canal_origen IS NULL;

/* =====================================
 * ANÁLISIS DESCRIPTIVO
 ====================================== */

-- CLIENTES POR PROVINCIA
SELECT
    provincia,
    COUNT(*) AS total_clientes
FROM dim_clientes
GROUP BY provincia
ORDER BY total_clientes DESC;


-- CLIENTES POR CANAL
SELECT
    canal_origen,
    COUNT(*) AS total
FROM dim_clientes
GROUP BY canal_origen
ORDER BY total DESC;

/* =====================================
 * ANÁLISIS INMOBILIARIO
 ====================================== */


-- PRECIO MEDIO POR CIUDAD
SELECT
    ciudad,
    ROUND(AVG(precio_estimado),2) AS precio_medio
FROM dim_inmuebles
GROUP BY ciudad;

-- PRECIO MEDIO POR TIPO
SELECT
    tipo_inmueble,
    ROUND(AVG(precio_estimado),2) AS precio_medio
FROM dim_inmuebles
GROUP BY tipo_inmueble;

-- METROS MEDIOS POR TIPO
SELECT
    tipo_inmueble,
    ROUND(AVG(metros_cuadrados),2) AS metros_medios
FROM dim_inmuebles
GROUP BY tipo_inmueble;

/* =====================================
 * ANÁLISIS COMERCIAL
 ====================================== */

-- VENTAS POR OFICINAS
SELECT
    nombre_oficina,
    total_operaciones_cerradas,
    comision_total
FROM vw_rendimiento_oficinas
ORDER BY comision_total DESC;

-- VENTAS POR AGENTE
SELECT
    nombre_agente,
    total_operaciones_cerradas,
    comision_total
FROM vw_rendimiento_agentes
where total_operaciones_cerradas > 0
ORDER BY comision_total DESC;


/* =====================================
 * ANÁLISIS TEMPORAL
 ====================================== */

-- VENTAS POR AÑO
SELECT
    anio,
    COUNT(*) AS operaciones,
    SUM(comision_importe) AS comisiones
FROM vw_ventas_cerradas
GROUP BY anio
ORDER BY anio;

-- VENTAS POR MES
SELECT
    anio,
    mes,
    nombre_mes,
    COUNT(*) AS operaciones,
    SUM(comision_importe) AS comisiones
FROM vw_ventas_cerradas
GROUP BY anio, mes, nombre_mes
ORDER BY anio, mes;


/* =====================================
 * FORMAS DE PAGO
 ====================================== */

SELECT
    forma_pago,
    COUNT(*) AS total_operaciones,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS porcentaje_operaciones,
    SUM(precio_cierre) AS volumen_ventas,
    SUM(comision_importe) AS comision_total
FROM fact_operaciones
WHERE estado_operacion = 'Cerrada'
GROUP BY forma_pago
ORDER BY comision_total DESC;



/* =====================================
 * INSIGHT DE NEGOCIO
 ====================================== */

-- TOP ZONAS
SELECT
    zona,
    COUNT(*) AS ventas
FROM vw_ventas_cerradas
GROUP BY zona
ORDER BY ventas DESC;

-- DESCUENTO MEDIO APLICADO
SELECT
    ROUND(
        AVG(precio_publicado - precio_cierre),
        2
    ) AS descuento_medio
FROM vw_ventas_cerradas;

-- DÍAS MEDIOS EN MERCADO
SELECT
    ROUND(
        AVG(dias_en_mercado),
        2
    ) AS dias_medios
FROM vw_ventas_cerradas;


/* =====================================
 * RESUMEN EJECUTIVO
 ====================================== */

SELECT
    COUNT(*) AS operaciones_cerradas,
    SUM(precio_cierre) AS volumen_total_ventas,
    SUM(comision_importe) AS comision_total,
    ROUND(AVG(precio_cierre), 2) AS ticket_medio,
    ROUND(AVG(dias_en_mercado), 2) AS dias_medios_mercado
FROM vw_ventas_cerradas;







