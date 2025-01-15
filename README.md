# Proyecto de Gestión de Conductores, Vehículos y Multas

![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/Dansoru/Vehiculos-Sistemas/total?style=plastic)
![Static Badge](https://img.shields.io/badge/Idioma-%F0%9F%87%AA%F0%9F%87%B8-%23f44336?style=plastic&link=https%3A%2F%2Fgithub.com%2FDansoru%2FVehiculos-Sistemas%2Freleases?)
![GitHub Release](https://img.shields.io/github/v/release/dansoru/Vehiculos-Sistemas?style=plastic)
[![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2FDansoru%2FVehiculos-Sistemas&label=Visitas&labelColor=%235e5e5e&countColor=%2375e6f7&style=plastic)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2FDansoru%2FVehiculos-Sistemas)

Este proyecto es un **ejercicio práctico de clase de Sistemas** desarrollado en Batch, cuyo objetivo es gestionar la información de conductores, vehículos, relaciones entre ellos y las multas que puedan recibir. El proyecto simula una gestión automatizada de los datos mediante scripts de procesamiento de archivos y comandos en el sistema operativo Windows.

El sistema incluye la automatización de la apertura y posicionamiento de ventanas CMD, validación de datos en archivos CSV, y la ejecución de filtros y cálculos en base a los datos disponibles.

---

## **Características del Proyecto**

1. **Automatización de ventanas CMD**:
    - Se abren y posicionan dos ventanas CMD de manera automatizada para diferentes tareas de gestión.
    - La disposición de las ventanas permite trabajar con las herramientas necesarias de forma eficiente.
  
2. **Gestión de Conductores**:
    - Se procesan datos de conductores desde un archivo CSV (`Base de datos/conductores.csv`).
    - Se permite buscar conductores por su antigüedad en el carnet de conducir, y se muestra un listado con la información de aquellos que cumplen con los requisitos establecidos.

3. **Gestión de Vehículos**:
    - Se maneja un archivo de vehículos (`Base de datos/vehiculos.csv`) que contiene información sobre los vehículos asociados a cada conductor.
    - Se vinculan conductores con vehículos para realizar operaciones de búsqueda y consulta.

4. **Gestión de Multas**:
    - El sistema también permite gestionar multas, asociándolas a los conductores y sus vehículos.
    - Se pueden filtrar las multas y asociar información adicional como fecha y tipo de infracción.

5. **Relaciones entre Conductores, Vehículos y Multas**:
    - El sistema permite establecer relaciones entre conductores, vehículos y multas para realizar consultas más completas.
    - Estas relaciones están basadas en los datos almacenados en los archivos CSV.

---

## **Cómo Ejecutar el Proyecto**

1. **Requisitos previos**:
    - Sistema operativo Windows.
    - Archivos CSV con la información de conductores (`Base de datos/conductores.csv`), vehículos (`Base de datos/vehiculos.csv`) y multas (`Base de datos/multas.csv`).
  
2. **Ejecución**:
    - Ejecuta el archivo `start.bat` para iniciar el sistema. Este script abrirá las ventanas CMD necesarias, procesará los datos y realizará las consultas de acuerdo a los parámetros definidos.

3. **Interacción con el usuario**:
    - El usuario podrá introducir valores de búsqueda, como el número mínimo de años de carnet de los conductores o el DNI para buscar información específica.

---

## **Funcionamiento Detallado**

### **1. Automatización de las Ventanas CMD**
- El sistema abre dos ventanas CMD, cada una encargada de ejecutar un script diferente (`editor.bat` y `monitor.bat`).

### **2. Procesamiento de Archivos CSV**
- Los archivos CSV contienen información sobre conductores, vehículos y multas.
- El script Batch procesa estos archivos línea por línea, extrayendo y validando los datos.

### **3. Filtro por Antigüedad de los Conductores**
- El sistema solicita al usuario que introduzca el número mínimo de años de carnet.
- Luego, filtra los conductores que cumplen con este criterio, mostrando los resultados en la consola y en un archivo de registro (`control.txt`).

### **4. Relaciones entre Conductores, Vehículos y Multas**
- Se asocia cada conductor con un vehículo específico y se gestionan las multas que pueden haber recibido.
- Los datos de multas se validan y se filtran en función de los criterios establecidos.

---

## **Estructura del Proyecto**

```text
.
├── Base de datos/
│   ├── conductores.csv     # Archivo de datos de los conductores
│   ├── vehiculos.csv       # Archivo de datos de los vehículos
│   └── multas.csv           # Archivo de datos de las multas
├── control.txt             # Registro de las consultas realizadas
├── start.bat               # Script principal para iniciar el sistema
├── editor.bat              # Script secundario para edición de datos
├── monitor.bat             # Script secundario para monitoreo de datos
└── arrange.vbs             # Script VBS para la automatización de la posición de las ventanas

