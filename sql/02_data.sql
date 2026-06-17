/* ============================================================
   02_data.sql
   Carga de datos sintéticos para el modelo inmobiliario
   ============================================================ */

BEGIN;

INSERT INTO dim_oficinas (
    nombre_oficina,
    ciudad,
    zona,
    fecha_apertura,
    activa,
    numero_empleados
)
VALUES
('Ciudad Jardín', 'Córdoba', 'Ciudad Jardín', '2015-03-15', TRUE, 8),
('Santa Rosa', 'Córdoba', 'Santa Rosa', '2018-09-01', TRUE, 6),
('Levante', 'Córdoba', 'Avda. Barcelona', '2020-01-20', TRUE, 5),
('Fátima', 'Córdoba', 'Fátima', '2021-06-10', TRUE, 4),
('Arroyo del Moro', 'Córdoba', 'Poniente Norte', '2025-07-01', TRUE, 5),
('Málaga Centro', 'Málaga', 'Centro', '2024-04-12', TRUE, 7);

COMMIT;

-- Comprobación datos oficinas
SELECT *
FROM dim_oficinas;


/* ============================================================
   CARGA DE AGENTES
   ============================================================ */

BEGIN;

INSERT INTO dim_agentes (
    nombre_agente,
    email,
    telefono,
    oficina_id,
    fecha_alta,
    especialidad,
    activo
)
VALUES

('José Martínez', 'jmartinez@inmobiliaria.com', '600111111', 1, '2020-01-15', 'Residencial', TRUE),
('María López', 'mlopez@inmobiliaria.com', '600111112', 1, '2021-03-10', 'Obra nueva', TRUE),

('Antonio Ruiz', 'aruiz@inmobiliaria.com', '600111113', 2, '2019-05-20', 'Residencial', TRUE),
('Lucía Gómez', 'lgomez@inmobiliaria.com', '600111114', 2, '2022-07-01', 'Alquiler', TRUE),

('Carlos Pérez', 'cperez@inmobiliaria.com', '600111115', 3, '2020-11-12', 'Locales', TRUE),
('Elena Torres', 'etorres@inmobiliaria.com', '600111116', 3, '2021-09-18', 'Residencial', TRUE),

('David Sánchez', 'dsanchez@inmobiliaria.com', '600111117', 4, '2022-02-14', 'Generalista', TRUE),
('Sara Jiménez', 'sjimenez@inmobiliaria.com', '600111118', 4, '2023-01-10', 'Alquiler', TRUE),

('Miguel Romero', 'mromero@inmobiliaria.com', '600111119', 5, '2025-07-15', 'Residencial', TRUE),
('Paula Castro', 'pcastro@inmobiliaria.com', '600111120', 5, '2025-08-01', 'Obra nueva', TRUE),

('Javier Moreno', 'jmoreno@inmobiliaria.com', '600111121', 6, '2024-04-15', 'Inversión', TRUE),
('Ana Navarro', 'anavarro@inmobiliaria.com', '600111122', 6, '2024-05-10', 'Residencial', TRUE);

COMMIT;


-- Comprobación datos agentes
SELECT *
FROM dim_agentes
ORDER BY oficina_id, agente_id;



/* ============================================================
   CARGA DE CLIENTES
   ============================================================ */

BEGIN;

INSERT INTO dim_clientes (
    nombre_cliente,
    email,
    edad,
    provincia,
    tipo_cliente,
    fecha_alta,
    canal_origen
)
VALUES

('Juan García', 'juan.garcia@gmail.com', 42, 'Córdoba', 'Comprador', '2024-01-15', 'Web'),
('María Fernández', 'maria.fernandez@gmail.com', 35, 'Córdoba', 'Vendedor', '2024-02-10', 'Recomendación'),
('Antonio Ruiz', 'antonio.ruiz@gmail.com', 51, 'Málaga', 'Comprador', '2024-03-12', 'Portal Inmobiliario'),
('Lucía Moreno', 'lucia.moreno@gmail.com', 29, 'Córdoba', 'Comprador', '2024-04-18', 'Web'),
('Pedro Sánchez', 'pedro.sanchez@gmail.com', 47, 'Sevilla', 'Vendedor', '2024-05-22', 'Redes Sociales'),
('Elena Torres', 'elena.torres@gmail.com', 39, 'Córdoba', 'Comprador/Vendedor', '2024-06-01', 'Web'),
('David Romero', 'david.romero@gmail.com', 58, 'Málaga', 'Comprador', '2024-07-10', 'Recomendación'),
('Sara Jiménez', 'sara.jimenez@gmail.com', 31, 'Córdoba', 'Comprador', '2024-08-05', 'Portal Inmobiliario'),
('Miguel Castro', 'miguel.castro@gmail.com', 45, 'Jaén', 'Vendedor', '2024-09-15', 'Web'),
('Paula Navarro', 'paula.navarro@gmail.com', 37, 'Córdoba', 'Comprador', '2024-10-03', 'Redes Sociales'),

-- Casos para limpieza posterior

('Cliente Sin Edad', 'cliente1@gmail.com', NULL, 'Córdoba', 'Comprador', '2024-11-01', 'Web'),

('Cliente Sin Canal', 'cliente2@gmail.com', 40, 'Córdoba', 'Comprador', '2024-11-05', NULL),

('Cliente Duplicado', 'duplicado@gmail.com', 33, 'Málaga', 'Comprador', '2024-11-10', 'Web');

COMMIT;

-- Comprobación datos clientes
SELECT *
FROM dim_clientes
ORDER BY cliente_id;


/* ============================================================
   CARGA DE INMUEBLES
   ============================================================ */

BEGIN;

INSERT INTO dim_inmuebles (
    referencia,
    tipo_inmueble,
    ciudad,
    provincia,
    zona,
    metros_cuadrados,
    habitaciones,
    banos,
    planta,
    ascensor,
    estado_inmueble,
    precio_estimado,
    fecha_alta
)
VALUES

('COR001','Piso','Córdoba','Córdoba','Ciudad Jardín',85,3,2,2,TRUE,'Buen estado',185000,'2024-01-15'),
('COR002','Piso','Córdoba','Córdoba','Santa Rosa',95,4,2,3,TRUE,'Reformado',225000,'2024-01-20'),
('COR003','Casa','Córdoba','Córdoba','Fátima',140,4,3,NULL,FALSE,'Buen estado',295000,'2024-02-01'),
('COR004','Ático','Córdoba','Córdoba','Poniente Norte',120,3,2,6,TRUE,'Reformado',320000,'2024-02-15'),
('COR005','Local','Córdoba','Córdoba','Centro',90,0,1,0,FALSE,'Buen estado',130000,'2024-03-01'),

('COR006','Piso','Córdoba','Córdoba','Ciudad Jardín',78,2,1,1,TRUE,'Buen estado',165000,'2024-03-10'),
('COR007','Chalet','Córdoba','Córdoba','Brillante',220,5,3,NULL,FALSE,'Nuevo',550000,'2024-03-25'),
('COR008','Piso','Córdoba','Córdoba','Levante',88,3,2,4,TRUE,'A reformar',140000,'2024-04-05'),
('COR009','Casa','Córdoba','Córdoba','Santa Rosa',135,4,2,NULL,FALSE,'Buen estado',250000,'2024-04-15'),
('COR010','Estudio','Córdoba','Córdoba','Centro',45,1,1,1,TRUE,'Reformado',98000,'2024-05-01'),

('MAL001','Piso','Málaga','Málaga','Centro',82,3,2,5,TRUE,'Reformado',315000,'2024-05-10'),
('MAL002','Ático','Málaga','Málaga','Teatinos',130,4,2,8,TRUE,'Nuevo',480000,'2024-05-20'),
('MAL003','Piso','Málaga','Málaga','Huelin',76,2,1,2,TRUE,'Buen estado',240000,'2024-06-01'),
('MAL004','Casa','Málaga','Málaga','Pedregalejo',180,4,3,NULL,FALSE,'Reformado',620000,'2024-06-10'),
('MAL005','Local','Málaga','Málaga','Centro',110,0,2,0,FALSE,'Buen estado',210000,'2024-06-20'),

('MAL006','Piso','Málaga','Málaga','Teatinos',92,3,2,3,TRUE,'Buen estado',290000,'2024-07-01'),
('MAL007','Chalet','Málaga','Málaga','El Limonar',250,5,4,NULL,FALSE,'Nuevo',890000,'2024-07-10'),
('MAL008','Piso','Málaga','Málaga','Carretera de Cádiz',85,3,2,4,TRUE,'A reformar',215000,'2024-07-20'),
('MAL009','Casa','Málaga','Málaga','Churriana',160,4,2,NULL,FALSE,'Buen estado',370000,'2024-08-01'),
('MAL010','Estudio','Málaga','Málaga','Centro',40,1,1,2,TRUE,'Reformado',125000,'2024-08-15');

COMMIT;

-- Comprobación conteo inmuebles
SELECT COUNT(*)
FROM dim_inmuebles;


/* ============================================================
   CARGA DE CALENDARIO
   Generación automática de fechas
   ============================================================ */

BEGIN;

INSERT INTO dim_calendario (
    fecha,
    anio,
    trimestre,
    mes,
    nombre_mes,
    dia_mes,
    dia_semana,
    numero_dia_semana,
    es_fin_semana
)

SELECT

    fecha_generada,

    EXTRACT(YEAR FROM fecha_generada)::INTEGER,

    EXTRACT(QUARTER FROM fecha_generada)::INTEGER,

    EXTRACT(MONTH FROM fecha_generada)::INTEGER,

    TO_CHAR(fecha_generada, 'Month'),

    EXTRACT(DAY FROM fecha_generada)::INTEGER,

    TO_CHAR(fecha_generada, 'Day'),

    EXTRACT(ISODOW FROM fecha_generada)::INTEGER,

    CASE
        WHEN EXTRACT(ISODOW FROM fecha_generada) IN (6,7)
        THEN TRUE
        ELSE FALSE
    END

FROM generate_series(
        '2024-01-01'::DATE,
        '2025-12-31'::DATE,
        '1 day'
     ) AS fecha_generada;

COMMIT;


-- Comprobación conteo de datos calendario
SELECT COUNT(*)
FROM dim_calendario;


-- Comprobación de filas
SELECT *
FROM dim_calendario
LIMIT 10;


/* ============================================================
   CARGA DE OPERACIONES
   Tabla de hechos
   ============================================================ */

BEGIN;

INSERT INTO fact_operaciones (
    fecha_id,
    cliente_id,
    inmueble_id,
    agente_id,
    oficina_id,
    tipo_operacion,
    estado_operacion,
    precio_publicado,
    precio_cierre,
    comision_pct,
    comision_importe,
    dias_en_mercado,
    forma_pago
)
VALUES

(15, 1, 1, 1, 1, 'Venta', 'Cerrada', 185000, 178000, 3.00, 5340, 42, 'Hipoteca'),
(38, 2, 2, 3, 2, 'Venta', 'Cerrada', 225000, 220000, 3.00, 6600, 35, 'Hipoteca'),
(59, 3, 11, 11, 6, 'Venta', 'Cerrada', 315000, 305000, 3.00, 9150, 28, 'Mixto'),
(75, 4, 6, 2, 1, 'Reserva', 'En proceso', 165000, NULL, 3.00, NULL, 18, 'No aplica'),
(92, 5, 8, 5, 3, 'Venta', 'Cancelada', 140000, NULL, 3.00, NULL, 60, 'No aplica'),

(110, 6, 4, 9, 5, 'Venta', 'Cerrada', 320000, 312000, 3.00, 9360, 31, 'Hipoteca'),
(128, 7, 14, 12, 6, 'Venta', 'Cerrada', 620000, 600000, 3.50, 21000, 55, 'Contado'),
(145, 8, 10, 4, 2, 'Alquiler', 'Cerrada', 850, 820, 1.00, 820, 15, 'No aplica'),
(167, 9, 7, 1, 1, 'Venta', 'Cerrada', 550000, 535000, 3.00, 16050, 70, 'Mixto'),
(188, 10, 12, 11, 6, 'Venta', 'Cerrada', 480000, 470000, 3.00, 14100, 44, 'Hipoteca'),

(205, 11, 3, 7, 4, 'Venta', 'En proceso', 295000, NULL, 3.00, NULL, 25, 'No aplica'),
(220, 12, 5, 5, 3, 'Alquiler', 'Cerrada', 1200, 1150, 1.00, 1150, 20, 'No aplica'),
(244, 13, 9, 3, 2, 'Venta', 'Cerrada', 250000, 242000, 3.00, 7260, 37, 'Hipoteca'),
(261, 1, 13, 12, 6, 'Venta', 'Cerrada', 240000, 232000, 3.00, 6960, 33, 'Hipoteca'),
(284, 2, 15, 11, 6, 'Alquiler', 'Cerrada', 1600, 1500, 1.00, 1500, 22, 'No aplica'),

(301, 3, 16, 12, 6, 'Venta', 'Cerrada', 290000, 282000, 3.00, 8460, 41, 'Mixto'),
(322, 4, 17, 11, 6, 'Venta', 'En proceso', 890000, NULL, 3.50, NULL, 52, 'No aplica'),
(344, 5, 18, 12, 6, 'Venta', 'Cerrada', 215000, 198000, 3.00, 5940, 80, 'Hipoteca'),
(365, 6, 19, 11, 6, 'Venta', 'Cerrada', 370000, 360000, 3.00, 10800, 48, 'Mixto'),
(390, 7, 20, 12, 6, 'Alquiler', 'Cerrada', 950, 900, 1.00, 900, 17, 'No aplica'),

(410, 8, 1, 2, 1, 'Venta', 'Cerrada', 185000, 181000, 3.00, 5430, 29, 'Hipoteca'),
(432, 9, 2, 3, 2, 'Venta', 'Cerrada', 225000, 218000, 3.00, 6540, 39, 'Hipoteca'),
(455, 10, 4, 10, 5, 'Venta', 'Cerrada', 320000, 310000, 3.00, 9300, 34, 'Mixto'),
(477, 11, 6, 1, 1, 'Reserva', 'En proceso', 165000, NULL, 3.00, NULL, 12, 'No aplica'),
(499, 12, 8, 6, 3, 'Venta', 'Cancelada', 140000, NULL, 3.00, NULL, 95, 'No aplica'),

(520, 13, 11, 11, 6, 'Venta', 'Cerrada', 315000, 308000, 3.00, 9240, 26, 'Hipoteca'),
(541, 1, 12, 12, 6, 'Venta', 'Cerrada', 480000, 462000, 3.00, 13860, 57, 'Contado'),
(566, 2, 14, 11, 6, 'Venta', 'Cerrada', 620000, 610000, 3.50, 21350, 46, 'Contado'),
(590, 3, 18, 12, 6, 'Venta', 'Cerrada', 215000, 202000, 3.00, 6060, 68, 'Hipoteca'),
(620, 4, 20, 11, 6, 'Alquiler', 'Cerrada', 950, 920, 1.00, 920, 14, 'No aplica');

COMMIT;


-- Comprobación conteo OperacionesHechos
SELECT COUNT(*)
FROM fact_operaciones;


-- Comprobación Relaciones y Joins entre tablas que confluyen en OperacionesHechos

SELECT
    f.operacion_id,
    c.nombre_cliente,
    i.referencia,
    a.nombre_agente,
    o.nombre_oficina,
    f.tipo_operacion,
    f.estado_operacion,
    f.precio_cierre
FROM fact_operaciones f
INNER JOIN dim_clientes c
    ON f.cliente_id = c.cliente_id
INNER JOIN dim_inmuebles i
    ON f.inmueble_id = i.inmueble_id
INNER JOIN dim_agentes a
    ON f.agente_id = a.agente_id
INNER JOIN dim_oficinas o
    ON f.oficina_id = o.oficina_id
ORDER BY f.operacion_id;




/* ==================================================
 CREACIÓN DE CLIENTES SIN OPERACIONES PARA LA CONSULTA EN EL EDA 
Incluí clientes sin operaciones para demostrar el uso 
de LEFT JOIN y detectar oportunidades comerciales pendientes de seguimiento. 
====================================================== */

-- Clientes sin operaciones 

BEGIN;

INSERT INTO dim_clientes (
    nombre_cliente,
    email,
    edad,
    provincia,
    tipo_cliente,
    fecha_alta,
    canal_origen
)
VALUES
('Cliente Sin Operaciones 1', 'sinoperaciones1@gmail.com', 44, 'Córdoba', 'Comprador', '2025-01-10', 'Web'),
('Cliente Sin Operaciones 2', 'sinoperaciones2@gmail.com', 52, 'Málaga', 'Vendedor', '2025-01-12', 'Recomendación');

COMMIT;