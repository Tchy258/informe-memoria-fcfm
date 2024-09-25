#import "conf.typ": conf, guia, pronombre
#let mostrar_guias = false
#show: conf.with(
    titulo: "Plataforma web para programación de sistemas embebidos",
    autor: (nombre: "Nicolás Escobar Zarzar", pronombre: pronombre.el),
    profesores: ((nombre: " Luciano Radrigan F.", pronombre: pronombre.el),),
    modalidad: "Memoria",
    anno: "2024",
    espaciado_titulo: 2fr,
    informe: false
)

#guia(visible: mostrar_guias)[Se debe quitar todas las guías (estas cajas grises) antes de entregar el documento.

Para ello, se debe cambiar el valor de la variable `mostrar_guias` a `false` en la segunda línea del archivo.

Además, hay que reemplazar los datos de la portada en los parámetros de la función `conf` en la línea 3 del archivo.

Los parámetros que acepta la función `conf` son:
- título: El título del tema.
- autor: Un diccionario con campos `nombre` y `pronombre`. Para los pronombres, importar el diccionario `pronombre` desde `conf.typ`. Los valores disponibles son `pronombre.el`, `pronombre.ella` y `pronombre.elle`.
- informe: `false` si es la propuesta de tema, `true` si es el informe final.
- codigo: Omitir si es la propuesta de tema. Si es el informe final, colocar el código del ramo. (CC6908 para malla v3, CC6907 para malla v5)
- modalidad: Puede ser \"Memoria\", \"Práctica extendida\", \"Titulación con Magíster\" o \"Doble Titulación de Dos Especialidades\"
- profesores: Lista de profesores guías. Cada elemento de la lista es un diccionario con campos `nombre` y `pronombre`. Si es un solo elemento, recordar poner una coma al final: `(dict_guia,)`
- supervisor: Información del supervisor en caso de práctica extendida. Es un diccionario con campos `nombre` y `pronombre`.
- anno: Año en que se entrega el informe. Por defecto se usa el año actual.
- espaciado_titulo: Espaciado extra antes del título y al rededor de autor. Por defecto es `1fr`. Se puede usar `2fr` para un espaciado doble, `3fr` para un espaciado triple, etc.

Como aproximación, se espera que la propuesta sea de 5 a 10 páginas.

No es necesario poner texto antes de la introducción.]


= Introducción

#guia(visible: mostrar_guias)[Dar una introducción al contexto del tema.

Explicar, en términos generales, el problema abordado.

Motivar la necesidad, la importancia y/o el valor de tener una (mejor) solución al problema.

En el caso de la práctica extendida, incluir detalles de la organización, su quehacer, el equipo y el supervisor con los cuales se va a trabajar, la relevancia del problema a la organización, etc.

(1 a 2 páginas)]

Los sistemas embebidos @DefEmbebidos cumplen un rol fundamental en una amplia gama de dispositivos, desde electrodomésticos hasta equipos de control industrial, vehículos y aparatos médicos, encargándose de diversas funciones como manejo de sensores de temperatura, movimiento, humedad, y otros tipos de componentes variados como motores pequeños, luces, alarmas, etc. Estos artefactos, que integran hardware y software, necesitan configuraciones y calibraciones precisas para asegurar su correcto funcionamiento. Sin embargo, su configuración suele ser un proceso complejo, ya que requiere conocimientos avanzados de programación, incluyendo el dominio de lenguajes de bajo nivel como C y C++ @EmbebidosC, y también nociones básicas de electrónica. 

El problema radica en que muchos de los entornos de desarrollo para sistemas embebidos actuales, si bien abstraen bastante la lógica a bajo nivel @FrameworksPaper @FFramework, son complejos y no cuentan con herramientas que simplifiquen el proceso de programación, configuración y prueba para personas sin conocimientos técnicos avanzados que requieran funcionalidades comunes. Sumado a esto, la ausencia de un método intuitivo para la simulación y verificación de estos aparatos en funcionamiento agrava la dificultad de evaluar el rendimiento de los mismos antes de su implementación en escenarios reales variados.

Uno de estos entornos de desarrollo está disponible en la página web de Tinkercad @Tinkercad, esta herramienta permite la configuración y simulación de un sistema embebido genérico con una gama muy amplia de componentes, pero debido a su baja especificidad, requiere de altos conocimientos técnicos para programar y simular un sistema concreto.

Ante este panorama, surge la necesidad de una plataforma web que mejore la gestión de todo el ciclo de vida del desarrollo de manera centralizada y eficiente. Esta propuesta busca ofrecer una solución integral basada en lo que hace Tinkercad, pero con un microcontrolador en concreto que no solo haga más amena la programación para funcionalidades comunes, sino que también permita la simulación, prueba y calibración de dicho sistema, mejorando así la eficiencia, precisión y seguridad en la realización de estas tareas. Todo esto de una forma intuitiva y abstrayendo la mayor parte de la lógica en C y C++ al entorno de desarrollo, otorgando una interfaz interactiva con plantillas que permitan modificar parámetros específicos a componentes fijos que el usuario final necesite mediante el arrastre de bloques de código preparado con anterioridad para la arquitectura del microcontrolador, el cual se puede compilar para tener una configuración real idéntica a la simulada. 

Desarrollar esta plataforma no solo simplificaría el proceso para ingenieros y programadores, sino que también permitiría que un mayor número de personas, incluso aquellas con conocimientos limitados en el ámbito de la programación embebida, puedan trabajar de manera más accesible en el desarrollo de soluciones tecnológicas. Además, la integración de funciones de simulación y gestión de proyectos embebidos concretos ofrecerá una visión más clara del comportamiento del sistema antes de su despliegue en el mundo real, mitigando errores y optimizando el tiempo de desarrollo. Este punto es esencial, ya que esto permite que los usuarios finales reales de los sistemas embebidos sean quienes determinen como estos deben funcionar en su dominio específico.


= Situación Actual

#guia(visible: mostrar_guias)[Discutir las soluciones o recursos existentes relacionados con el problema. Justificar por qué es necesario un trabajo novedoso.

(1 a 2 páginas)]

Como fue mencionado en la introducción, existen muchos entornos de desarrollo de sistemas embebidos. En cuanto a herramientas para sistemas genéricos están Tinkercad @Tinkercad, y PlatformIO @Platformio, pero en su mayoría, estas son específicas al fabricante del microcontrolador en concreto que se intenta programar, como el de Espressif @Espressif o Arduino @Arduino.

Tinkercad posee una interfaz intuitiva en una plataforma web (ver @tinkercadimg), pero al tener demasiadas opciones para construir un sistema embebido, se puede dificultar el proceso de armar una configuración en concreto, sobre todo para alguien sin muchos conocimientos de programación o electrónica, puesto que requiere que el usuario elija que microcontrolador usar, sus componentes, como estos se conectan entre sí y el código con las instrucciones a seguir. Este código también es genérico y no permite convertir el sistema embebido simulado a uno real de manera inmediata a menos que se escoja el lenguaje particular del microcontrolador, pero esto ya requiere un cierto grado de conocimiento técnico.

#figure(
  image("imagenes/tinkercad.png", width: 100%),
  caption: [Plataforma de desarrollo de Tinkercad],
) <tinkercadimg>

PlatformIO brinda herramientas de alta ayuda para desarrolladores de sistemas embebidos, como un _debugger_ y analizador de código, pero estas no son de mucha utilidad a personas con pocos conocimientos técnicos que no necesariamente saben usarlas.

Espressif y otros fabricantes de microcontroladores brindan soluciones para sus productos, pero aún así sus entornos no son lo suficientemente específicos para usos concretos, ya que se centran más en brindar librerías e interfaces comunes a todos los chips que fabrican, las cuales deben ser estudiadas a profundidad si se requiere un sistema concreto.

Arduino incluso tiene su propio lenguaje de programación similar a C junto con un entorno de desarrollo integrado, pero al igual que con los equipos de otros fabricantes, su programación requiere conocimientos técnicos.

De las soluciones actuales mencionadas, no hay ninguna que sea de uso inmediato para personas no técnicas y a fin de facilitar el proceso de desarrollo para dichos usuarios se propone la plataforma web para un microcontrolador especifico con código preparado.

= Objetivos

#guia(visible: mostrar_guias)[Describir las _metas_ del trabajo. Hay que contestar acá: ¿_qué_ quieres lograr? (La sección que sigue contestará la pregunta: ¿_cómo_ lo vas a lograr?)

Ejemplos de metas: lograr que X sea (más) eficiente, usable, seguro, completo, preciso, barato, informativo, posible por primera vez, etc.

Ejemplos de _no_ metas: implementar algo en Javascript, aplicar modelo Y sobre los datos, etc. (Estas cosas van en la descripción de la *Solución propuesta*.)

Los objetivos deberían ser específicos, medibles, alcanzables y relevantes al problema (ver la clase 2). El plan de trabajo debería argumentar que sean acotados en tiempo (un semestre).

Al final del trabajo, debería ser factible saber si se ha logrado los objetivos enumerados acá, o saber cuán bien se han logrado, o no. Por ejemplo, si la meta es tener algo eficiente en términos de tiempo, debería haber una forma de evaluar o estudiar los tiempos. Acá tendrás que definir la forma general en que se podrá evaluar el trabajo.

(No hay que poner texto acá. Se puede empezar directamente con el objetivo general.)]
	

== Objetivo General

#guia(visible: mostrar_guias)[
Un _resumen conciso_ (no más de un párrafo) de la meta principal del trabajo, es decir, qué quieres lograr con el trabajo (o qué significa \"éxito\" en el contexto del trabajo).

El objetivo debería ser específico, medible, alcanzable, relevante al problema, y acotado en tiempo.

(\"Titularse\" no es una repuesta válida. :\))]

El objetivo principal de este trabajo es crear una plataforma web que le de facilidades a usuarios, tanto técnicos como no técnicos, para la programación, simulación y verificación de sistemas embebidos que pueden ser utilizados en un entorno real con un comportamiento idéntico al simulado. Esta plataforma facilitará el desarrollo y la personalización de soluciones embebidas, mejorando la eficiencia y precisión en la implementación de estos sistemas.

== Objetivos Específicos

#guia(visible: mostrar_guias)[
Una _lista_ de los hitos principales que se quieren lograr para (intentar) cumplir con el objetivo general. Divide el objetivo general en varios hitos que formarán las etapas del trabajo.
		
Cada objetivo debería ser específico, medible, alcanzable, relevante al problema, y acotado en tiempo.
		
No se debería escribir más de un párrafo por hito. 
		
Los objetivos específicos deberían \"sumar\" al objetivo general.
		
(Una lista de 3 a 7 párrafos)]


+ Diseñar e implementar una interfaz intuitiva y fácil de usar para la plataforma web, permitiendo a los usuarios programar en C y C++ de manera abstracta, configurar y calibrar sistemas embebidos eficientemente. 
+ Desarrollar módulos que permitan la simulación y prueba de código embebido, proporcionando a los usuarios información detallada y relevante sobre el rendimiento y comportamiento del sistema en diferentes entornos.
+ Diseñar el _backend_ del sistema, utilizando una arquitectura robusta que permita compilar las plantillas de código solicitadas por los usuarios de manera segura y eficiente.
+ Integrar funcionalidades que faciliten la gestión de proyectos embebidos, permitiendo la creación, modificación y almacenamiento de configuraciones, calibraciones y códigos fuente.
+ Implementar mecanismos de seguridad robustos para garantizar la confidencialidad, integridad y disponibilidad de los datos y configuraciones almacenados en la plataforma web, en conformidad con los estándares de seguridad de la información.
+ Realizar pruebas de validación del sistema. 


== Evaluación

#guia(visible: mostrar_guias)[
Describe cómo vas a poder evaluar el trabajo en términos de cuán bien cumple con los objetivos planteados. Se pueden discutir los datos, las medidas, los usuarios, las técnicas, etc., utilizables para la evaluación.

(1 a 2 párrafos)]

El éxito de este trabajo se mide según que tan satisfechos queden los usuarios finales con el sistema embebido final, es decir, que tan útil fue la simulación y programación del aparato al aplicarlo en un entorno real. También es importante la usabilidad de la plataforma, que los usuarios finales entiendan como usarla de manera intuitiva.

= Solución Propuesta

#guia(visible: mostrar_guias)[
Una descripción general de la solución propuesta: los datos, las técnicas, las tecnologías, las herramientas, los lenguajes, los marcos, etc., que se usarán para intentar lograr los objetivos planteados. Aquí hay que contestar la pregunta: ¿_cómo_ vas a lograr los objetivos planteados? Aquí, sí, está muy bien hablar de Javascript, CNNs, Numpy, Django, índices invertidos, árboles wavelet, privacidad diferencial, PageRank, Diffie--Hellman, triangulaciones de Delaunay, CUDA, Postgres, etc.
    
(1 a 2 páginas)]

Para la solución propuesta se usará como base la placa disponible en la @placa fabricada a la medida por el profesor Luciano Radrigan:

#figure(
  image("imagenes/placa.jpg", width: 100%),
  caption: "Diagrama de placa con microcontrolador para simulación e implementación de sistemas embebidos"
) <placa>

A esta placa se le podrán modificar diversos parámetros en una interfaz muy similar a la de Tinkercad@Tinkercad, que se implementará usando el _framework_ React@React. Se escoge esta tecnología en particular por su abundancia de documentación y características, las que facilitarán el desarrollo de los módulos más complejos, como la simulación del sistema. Además se utilizará el lenguaje Typescript@Typescript el cual, gracias a su sistema de tipos, prevendrá muchos tipos de errores comunes que se cometen al utilizar JavaScript@Javascript corriente.

En cuanto al _backend_ se propone usar el lenguaje Kotlin@Kotlin y el _framework_ Ktor@Ktor, principalmente por familiaridad con el lenguaje y la característica de ser un lenguaje compilado hacia la Java Virtual Machine (JVM)@JVM, esto lo hace eficiente y permite llevar el backend a cualquier plataforma que soporte Java@Java. Al solicitar compilación de código de parte de los usuarios, el servidor recibirá los parámetros a modificar en las plantillas de código que tiene disponibles, realizará los cambios correspondientes y delegará la tarea de compilación a la herramienta CMake@CMake, que tendrá todas las instrucciones para construir los archivos binarios finales, los cuales serán escritos a un archivo temporal que posteriormente será enviado al usuario. Este archivo compilado permanecerá en el sistema por un plazo máximo de 24 horas durante las cuales el usuario puede solicitar modificaciones que serán procesadas de manera inmediata gracias a la propiedad de CMake de ser un sistema de ensamblaje incremental.

Para almacenar los datos de los usuarios incluyendo sus credenciales de acceso y sus simulaciones se utilizará el motor de base de datos relacional PostgreSQL@Postgresql, este se elije porque ya se sabe de antemano que tipo de componentes estarán disponibles en el sistema para fabricar las simulaciones, lo que permitirá indexar las tablas agilizando en gran medida cualquier consulta que se realice.

= Plan de Trabajo (Preliminar)

#guia(visible: mostrar_guias)[
Aquí se puede dar una lista preliminar de los pasos que se van a seguir para desarrollar la solución propuesta. La lista debería contemplar la evaluación del trabajo y la escritura del informe final del trabajo de título (memoria o práctica extendida). Siendo un plan preliminar, su propósito es dar una mejor idea de la factibilidad del tema y el trabajo que implica, pero se pueden aplicar cambios al plan para el informe final de este curso.
    
(0.5 a 2 páginas)]

+ Investigar y aprender a profundidad las tecnologías a usar para desarrollar el trabajo (React y Ktor) [Oct-Dic 2024]
+ Diseñar un diagrama que describa una historia de usuario, mostrando todo lo que un usuario puede hacer en la plataforma. [Oct-Nov 2024]
+ Diseñar un diagrama de flujo que describa todas las funcionalidades que posee el backend, mostrando las posibles respuestas que este puede dar a diversas solicitudes. [Oct-Nov 2024] 
+ Diseñar un mockup de la interfaz de usuario de la plataforma [Nov 2024]
+ Programar la vista principal de la plataforma, mostrando la placa y sus componentes (solo _frontend_) [Nov-Dic 2024]
+ Diseñar un esquema de la base de datos de la plataforma [Nov-Dic 2024]
+ Programar el módulo de simulaciones con abstracciones de código (solo _frontend_)  [Mar-Abr 2025]
+ Ajustar el diagrama de base de datos e implementarlo en Ktor según las vistas hechas [Abr-May 2025]
+ Crear _endpoints_ que permitan el inicio de sesión, almacenamiento de configuraciones y solicitudes de compilación de código por parte de usuarios finales [Abr-Jun 2025]
+ Probar a cabalidad la plataforma con usuarios y los sistemas embebidos resultantes de su uso [Jun-Jul 2025]
#pagebreak()

#bibliography(
    "bibliografia.yml",
    title: "Referencias",
    style: "ieee",
)