# Informe de Progreso del Práctica 1 - Curso 23/24

## SEMANA DEL 9 - 15 DE OCTUBRE

Durante esta semana, comenzamos nuestra práctica de Interfaces Gráficas para Aplicaciones de Escritorio. Las actividades clave incluyen:

- **Diseño de la Aplicación:** Iniciamos el proyecto realizando un diseño detallado de la aplicación. Combinamos las ideas de cada miembro del equipo para lograr un diseño que abordara varios casos de uso sin complicar excesivamente la aplicación.

- **Implementación Inicial:** Inicialmente, comenzamos la implementación del código siguiendo la arquitectura Modelo-Vista-Controlador (MVC). Sin embargo, nos dimos cuenta de que el código estaba volviéndose engorroso y decidimos cambiar nuestra estrategia para utilizar Glade, una herramienta de diseño de interfaces gráficas.

- **Trabajo en Glade:** Empezamos a trabajar en Glade para construir la parte de la vista de la aplicación. En su mayoría, esta tarea fue liderada por Alberto y Raúl, mientras que Adrián se dedicó a investigar cómo se implementaría el modelo y el controlador, así como cómo integraríamos la parte de la API para la base de datos.

- **Implementación Conjunta:** Posteriormente, trabajamos juntos para llevar a cabo la implementación completa de Glade, utilizando el patrón Modelo-Vista-Controlador para asegurar la ejecución efectiva del código en GTK y Python.

## SEMANA DEL 16 - 22 DE OCTUBRE

En la segunda semana del proyecto, nos dimos cuenta de ciertos errores en nuestra arquitectura. Las acciones clave incluyeron:

- **Refinamiento de la Arquitectura:** Identificamos que estábamos procesando datos JSON en la vista, lo que no era una buena práctica. Decidimos pasar estos datos al modelo para que la vista obtuviera directamente los datos necesarios. También observamos que el modelo estaba haciendo peticiones a la API, lo que debería ser responsabilidad del controlador. Por lo tanto, redirigimos estas peticiones a la API al controlador, que procesaría los datos en el modelo y los entregaría a la vista.

- **Gestión Temprana de Errores:** Aunque la gestión de errores era parte de la siguiente tarea, comenzamos a considerar posibles errores, como problemas de conexión o la falta de resultados, y realizamos una implementación temprana para abordarlos.

- **Entrega de la Primera Tarea:** Finalizamos y entregamos la primera tarea del proyecto.

- **Investigación de Concurrencia:** Comenzamos a investigar cómo implementar la concurrencia en la aplicación. Alberto se centró en la investigación, mientras que Raúl y Adrián comenzaron la implementación de la concurrencia.

## SEMANA 23 - 29 DE OCTUBRE

Durante la tercera semana del proyecto, continuamos trabajando en las tareas planificadas:

- **Entrega de la Segunda Tarea:** Finalizamos y entregamos la segunda tarea, que incluía la implementación de la concurrencia.

- **Desarrollo de Internacionalización:** Trabajamos en equipo para estudiar y aplicar la internacionalización en la aplicación. Alberto se centró en la investigación, mientras que Raúl y Adrián llevaron a cabo las traducciones y su implementación en el código. También investigamos cómo funcionan las bibliotecas gettext y los locales, así como el uso de programas como Poedit para la internacionalización (I18N).

## SEMANA 30 DE OCTUBRE A 5 DE NOVIEMBRE

En la última semana del proyecto, finalizamos las tareas pendientes y realizamos ajustes finales:

- **Entrega de la Última Tarea:** Finalizamos y entregamos la última tarea, corrigiendo errores que no se habían tenido en cuenta anteriormente.

El proyecto se encuentra en su fase final, y estamos preparados para realizar la defensa del trabajo y revisar el contenido del repositorio en GitHub para garantizar su correcto funcionamiento.
