🏠 Proyecto SQL Inmobiliario - Data Warehouse y Análisis de Negocio

📌 Descripción

Este proyecto consiste en el diseño e implementación de un Data Warehouse inmobiliario utilizando PostgreSQL.

El objetivo es simular un entorno empresarial real mediante la construcción de un modelo dimensional, la carga de datos sintéticos, la creación de consultas analíticas y el desarrollo de vistas de negocio para facilitar el análisis comercial e inmobiliario.

El proyecto reproduce escenarios habituales en empresas del sector inmobiliario como:

* Gestión de clientes.
* Gestión de agentes comerciales.
* Gestión de oficinas.
* Gestión de inmuebles.
* Seguimiento de operaciones de venta y alquiler.
* Análisis de rendimiento comercial.
* Análisis de mercado inmobiliario.

⸻

🎯 Objetivos

* Diseñar un modelo dimensional tipo estrella (Star Schema).
* Implementar tablas de dimensiones y hechos.
* Aplicar buenas prácticas de modelado relacional.
* Crear datos sintéticos realistas.
* Realizar procesos básicos de limpieza y calidad del dato.
* Construir consultas SQL para análisis de negocio.
* Crear vistas reutilizables para herramientas BI.
* Preparar el modelo para su explotación en Power BI.

⸻

🏗️ Arquitectura del Proyecto

proyecto_sql_inmobiliaria
│
├── 01_schema.sql
├── 02_data.sql
├── 03_consultas.sql
├── 04_views.sql
├── 05_eda.sql
└── README.md

⸻

📊 Modelo Dimensional

Tablas de Dimensión

dim_clientes

Información de clientes compradores y vendedores.

dim_agentes

Información de agentes comerciales.

dim_oficinas

Información de oficinas inmobiliarias.

dim_inmuebles

Características de los inmuebles comercializados.

dim_calendario

Dimensión temporal para análisis por fechas.

⸻

Tabla de Hechos

fact_operaciones

Registro de operaciones de venta, alquiler, reserva y cancelación.

Incluye:

* Precio publicado.
* Precio de cierre.
* Comisión generada.
* Días en mercado.
* Estado de la operación.

⸻

🔑 Relaciones

dim_clientes
        │
        ├──────────────┐
        │              │
dim_agentes       fact_operaciones
        │              │
        ├──────────────┤
        │              │
dim_oficinas      dim_inmuebles
        │
        │
dim_calendario

⸻

⚙️ Tecnologías Utilizadas

* PostgreSQL 18
* DBeaver
* SQL
* Git
* GitHub

⸻

📈 Vistas de Negocio

vw_ventas_cerradas

Operaciones finalizadas con toda la información comercial.

vw_rendimiento_oficinas

Análisis de productividad por oficina.

vw_rendimiento_agentes

Análisis de rendimiento individual de agentes.

vw_inmuebles_zona

Análisis inmobiliario por zona y tipología.

vw_canales_captacion

Análisis de captación y conversión de clientes.

⸻

🔍 Exploratory Data Analysis (EDA)

El proyecto incorpora un fichero específico de análisis exploratorio que incluye:

* Calidad del dato.
* Clientes por provincia.
* Clientes por canal de captación.
* Precio medio por ciudad.
* Precio medio por tipología.
* Metros medios por inmueble.
* Ventas por oficina.
* Ventas por agente.
* Evolución temporal de ventas.
* Top zonas de venta.
* Descuento medio aplicado.
* Tiempo medio de comercialización.

⸻

📌 Ejemplos de SQL Utilizados

* INNER JOIN
* LEFT JOIN
* CASE
* CTE
* Subconsultas
* Funciones ventana
* GROUP BY
* HAVING
* Vistas
* Índices

⸻

🚀 Posibles Evoluciones

* Integración con Power BI.
* Automatización ETL.
* Generación masiva de datos sintéticos.
* Modelos predictivos de precios.
* Segmentación de clientes.
* Forecast de ventas.
* Dashboard ejecutivo inmobiliario.


____ 

## Resultados obtenidos

El modelo permite analizar:

- Rendimiento comercial por oficina.
- Rendimiento individual de agentes.
- Evolución temporal de ventas y alquileres.
- Rentabilidad por zona.
- Comisiones generadas.
- Descuentos aplicados sobre precio publicado.
- Tiempo medio de comercialización de inmuebles.

Se han implementado:
- 5 tablas de dimensión.
- 1 tabla de hechos.
- 5 vistas analíticas.
- Más de 20 consultas SQL avanzadas.
- Procesos básicos de calidad del dato.

⸻
## Dataset

| Elemento | Total |
|-----------|--------|
| Clientes | 13 |
| Agentes | 12 |
| Oficinas | 6 |
| Inmuebles | 20 |
| Operaciones | 30 |
| Vistas analíticas | 5 |

⸻
## Capturas


⸻

👨‍💻 Autor

Job Delgado

Proyecto desarrollado como práctica avanzada de SQL, modelado dimensional y análisis de datos orientado al sector inmobiliario.
