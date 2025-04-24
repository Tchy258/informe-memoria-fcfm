#import "intro.typ": conf
#import "metadata.typ": example-metadata

// Aquí se importan las guías para ayudar a escribir.
// Se pueden desactivar cambiando el valor de la variable `mostrar_guias` a `false`.
#import "intro_guias.typ": *
#let mostrar_guias = false

#import "constants.typ": pronombre

#let data = (
    ..example-metadata,
    titulo: "GENERACIÓN DE MALLAS POLIGONALES A PARTIR DE CAVIDADES",
    autoria: (nombre: "Nicolás Escobar Zarzar", pronombre: pronombre.el),
    profesores: ((nombre: "Nancy Hitschfeld K.", pronombre: pronombre.ella),),
    coguias: ((nombre: "Sergio Salinas", pronombre: pronombre.el),)
)


#show: conf.with(metadata: data)

#guia(visible: mostrar_guias, guia_meta)

= Introducción

#guia(visible: mostrar_guias, guia_intro)

Las mallas poligonales son estructuras fundamentales en el modelado geométrico y la simulación computacional. Se definen como colecciones de vértices, aristas y caras que, en conjunto, representan la superficie de un objeto, generalmente mediante una subdivisión en triángulos. Esta representación es ampliamente utilizada en áreas como el diseño asistido por computador (CAD), gráficos por computadora, ingeniería estructural, biomecánica y videojuegos. La eficiencia y calidad de las mallas generadas influye directamente en la precisión de las simulaciones y en el rendimiento computacional de los sistemas que las utilizan.

Uno de los problemas recurrentes en este ámbito es la generación automática de mallas poligonales a partir de un conjunto discreto de puntos en el plano, también conocido como problema de triangulación. Si bien existen algoritmos eficientes como Triangle @TrianglePaper o Detri2 @Detri2 para formar una triangulación de Delaunay @Delaunay1934, la construcción de formas poligonales a partir de dichas triangulaciones sigue siendo un área de investigación activa. En particular, existe un interés creciente por encontrar métodos que generen mallas con mayor fidelidad geométrica, adaptabilidad local, y que mantengan cualidades deseables como ángulos adecuados y buena distribución de los elementos. Las triangulaciones de Delaunay son de particular importancia porque maximizan el tamaño del ángulo más pequeño de todos los triángulos que la componen, esto es relevante porque previene problemas de precisión que ocurren al tener ángulos muy agudos los cuales propician 'casos degenerados' donde los puntos de un triángulo son interpretados como colineales lo cual puede provocar cálculos erróneos e incluso que los programas que trabajen con las mallas resultantes que no sean lo suficientemente robustos fallen por completo en el peor de los casos. 

Este trabajo de memoria se enfoca en el desarrollo y análisis de una estrategia alternativa de generación de mallas en dos dimensiones, basada en el concepto de *cavidad* o _concavity_ como se describe en el artículo Triangle @TrianglePaper. La idea central es que, a partir de una triangulación de Delaunay (como la de la @ejemplo_delaunay), se seleccionan ciertos triángulos utilizando un criterio definido por el usuario. Luego, se calculan los circuncentros de estos triángulos, y se identifican los triángulos de la malla cuyo circuncírculo contiene alguno de estos puntos. La unión de estos triángulos vecinos forma una *cavidad*, y su cápsula convexa define un nuevo polígono. Este procedimiento permite generar regiones poligonales que pueden servir como base para construir mallas más estructuradas o adaptativas.


#figure(
    image("imagenes/Delaunay_circumcircles_vectorial.svg", width: 50%),
    caption: "Triangulación de Delaunay con circuncírculos compuesta por 10 vértices.",
) <ejemplo_delaunay>

A modo ilustrativo, en la @ejemplo_seleccion_triangulos se presenta una selección de triángulos a partir de la triangulación de la @ejemplo_delaunay.

#figure(
    image("imagenes/seleccion.png", width: 50%),
    caption: [Selección de triángulos para formar un polígono a partir de una cavidad.]
) <ejemplo_seleccion_triangulos>

En este ejemplo, se seleccionaron dos triángulos $t_0$ y $t_1$, cuyos respectivos circuncentros están representados por los puntos $p_0$ y $p_1$. Estos puntos están contenidos en los circuncírculos de varios triángulos vecinos, incluyendo aquellos que los generaron. La unión de estos triángulos conforma la cavidad, como se muestra en @ejemplo_poligono_cavidad.

#figure(
    image("imagenes/resultado.png", width: 30%),
    caption: [Polígono resultante de una cavidad con capsula convexa en azul]
) <ejemplo_poligono_cavidad>


Este enfoque mediante cavidades no solo busca explorar una nueva forma de construir mallas, sino también comparar su rendimiento y características con métodos existentes. En particular, se contrastará esta técnica con el generador de mallas _*Polylla*_ @PolyllaPaper, un sistema moderno que emplea estructuras de datos avanzadas para lograr eficiencia y calidad en la generación de polígonos.

La necesidad de desarrollar nuevas estrategias para la generación de mallas responde a múltiples factores: mejorar la eficiencia de los algoritmos existentes, generar elementos con mejores propiedades geométricas, y adaptar las mallas a dominios complejos sin intervención manual.


= Situación Actual

#guia(visible: mostrar_guias, guia_actual)

//_Mencionar algoritmos que generen cavidades_
Existen muchos algoritmos para generación de mallas poligonales, siendo los más relevantes para este trabajo Triangle @TrianglePaper y Polylla @PolyllaPaper.
En la actualidad existe poca investigación relacionada con la _generación_ de mallas a partir de cavidades, pero sí hay información sobre como _quitar_ cavidades durante el proceso de una triangulación inicial de un conjunto de vértices. En el artículo Triangle @TrianglePaper, se definen las cavidades como triángulos que no pertenecen al polígono real cuya malla se desea generar, ya sea porque están fuera de su cápsula convexa (_concavities_) o rellenan un agujero (_hole_) en su interior, los cuales aparecen al intentar la triangulación de los vértices uniendo segmentos entre todos ellos. Cabe destacar que Triangle es capaz de saber de manera sencilla qué triángulos pertenecen realmente al polígono y cuáles no dado que su entrada es un _planar straight line graph_ (o PSLG), el cual se define como una colección de vértices y segmentos donde las puntas de cada segmento son los mismos vértices (ver @PSLGGuitarra).

#figure(
    image("/imagenes/pslg.png", width: 80%),
    caption: [PSLG de una guitarra electrica @TrianglePaper]
) <PSLGGuitarra>

_No estoy muy seguro de con que más rellenar esta parte... ¿Debería simplemente hablar de como funciona polylla?_

= Objetivos

#guia(visible: mostrar_guias, guia_objetivos)

== Objetivo General

#guia(visible: mostrar_guias, guia_objetivo_general)

Implementar un algoritmo que permita generar polígonos a partir de una _cavidad_ formada por triángulos de una triangulación de Delaunay y comparar su desempeño con el generador de mallas Polylla.

== Objetivos Específicos

#guia(visible: mostrar_guias, guia_objetivos_especificos)

//Entender como aplicar las estructuras de polylla al problema

//Usar dichas estructuras para generar cavidades

//Corroborar que la cavidad está bien hecha

//Comparar con polylla

+ Investigar como funciona el algoritmo de mallas Polylla y sus estructuras de datos.
+ Utilizar correctamente las estructuras de datos de Polylla para definir cavidades a través de código.
+ Corroborar que el conjunto de triángulos que conforman la cavidad computada sean los correctos y generar un nuevo polígono a partir de ellos.
+ Comparar el desempeño del algoritmo basado en cavidades con el algoritmo de Polylla basado en regiones terminales.

== Evaluación

#guia(visible: mostrar_guias, guia_evaluacion)

//_Desempeño en tiempo y correctitud de la malla y comparación con polylla_

Para evaluar este trabajo es necesario comparar cualitativamente la malla poligonal resultante del algoritmo basado en cavidades con el algoritmo de Polylla. Se deben evaluar criterios como:
+ La correctitud de la malla poligonal generada. ¿Se ajusta realmente al objeto que se desea modelar?
+ La cantidad de triángulos finales. ¿Genera menos triángulos para representar el mismo polígono?
+ Los ángulos internos de dichos triángulos. ¿Los ángulos de los triángulos siguen cumpliendo con la propiedad de Delaunay?
+ El tiempo de ejecución. ¿Es más rápido el algoritmo basado en cavidades para generar el mismo polígono que Polylla?
+ El costo en espacio. ¿Utiliza igual o menos memoria que Polylla para generar la misma malla?
= Solución Propuesta



#guia(visible: mostrar_guias, guia_solucion)

La solución propuesta involucra adoptar las estructuras de datos de Polylla@RepoPolylla escritas en\ C++ y aplicarlas a este problema para generar una malla de manera eficiente. Son de especial interés 2 estructuras de datos fundamentales, la estructura `vertex` y la estructura `halfEdge`@HalfEdgeStruct.

La estructura `vertex` (@codigovertex) define las coordenadas `x` e `y` de los puntos de la malla poligonal final, además clasifica a los puntos según si son parte del borde del polígono o no, lo cual será útil al momento de representar la cápsula convexa de la malla final. También se encarga de guardar cuál `halfEdge` incide en este vértice.

La estructura `halfEdge` (@codigohalfedge) representa las aristas del polígono de una forma particular, no solo es el segmento que une un vértice $v_i$ con otro vértice $v_j$, sino que también guarda información relevante a la hora de recorrer el polígono, como por ejemplo, cuál es su vértice de origen (la 'cola' del `halfEdge`), cuál es el siguiente `halfEdge` del triángulo (o cara) actual en orientación antihoraria (o CCW del inglés _counter clockwise_), el `halfEdge` anterior de este triángulo y además cuál es su `halfEdge` `twin`, es decir, el `halfEdge` que une a los mismos vértices en CCW pero para el triángulo vecino. Al igual que los vértices, también guarda la información de si está en el borde o no.

Se puede ver una representación gráfica de estas estructuras en la @fighalfedge.

#figure(
    image("/imagenes/halfedge.jpg", width: 50%),
    caption: [Representación de estructuras `vertex` y `halfEdge`]
) <fighalfedge>

#figure(
    caption: [Estructura vertex],
    box(
        fill: rgb("#d3d3d3"),
        inset: 8pt,
        radius: 4pt,
```cpp
struct vertex {
    double x;
    double y;
    bool is_border = false;
    int incident_halfedge; // <- indice a un array de halfedges
};
    ```        
    )
) <codigovertex>

#figure(
    caption: [Estructura halfEdge],
    box(
        fill: rgb("#d3d3d3"),
        inset: 8pt,
        radius: 4pt,
```cpp
// Todos sus atributos son índices al objeto relevante
struct halfEdge {
    int origin;
    int twin; 
    int next;
    int prev;
    int is_border;
};
```        
    )
) <codigohalfedge>
Teniendo estas estructuras de datos se procederá de la manera siguiente:
+ Similar a Polylla, se recibirá como entrada una triangulación de Delaunay en un conjunto de 3 archivos, un archivo `.node` con los vértices y marcador de borde, un archivo `.ele` con los triángulos de las triangulaciones (qué vértices forman cuáles triángulos) y un archivo `.neigh` con las listas de adyacencia de cada triángulo (sus vecinos).
+ A partir de estos archivos, se creará un objeto `Triangulation`@RepoPolylla encargado de almacenar estos datos en listas de `vertex` y `halfEdge` en vectores de `C++`.
+ Utilizando algún criterio a definir según experimentación, se seleccionará un subconjunto de los triángulos recibidos y se les calculará su circuncentro $p_i$ usando un método por determinar#footnote("Es necesario probar distintos métodos hasta encontrar uno que sea lo suficientemente eficiente")<tbd>
+ Crear una lista (vector) de índices para almacenar los triángulos que forman parte de la cavidad.
+ Por cada triángulo de la malla, revisar si su circuncírculo contiene a cualquiera de los $p_i$ calculados anteriormente usando un método por determinar@tbd y en caso de contener alguno, agregar este triángulo como parte de la cavidad.
+ Retornar el polígono resultante del proceso anterior.


= Plan de Trabajo (Preliminar)

#guia(visible: mostrar_guias, guia_plan)

+ Investigar distintos métodos para calcular el circuncentro y circuncírculo de un triángulo de manera eficiente o en su defecto, algo que permita responder la pregunta _¿El circuncentro del triángulo $t_i$ contiene al punto $p_j$?_ [Abril-Mayo]
+ Estudiar a cabalidad Polylla para utilizar sus clases y estructuras de datos para la generación de mallas a partir de cavidades. (Trabajo a adelantar hasta aquí). [Junio-Agosto]
+ Programar la implementación de los métodos investigados para formar la cavidad y guardar el registro de los resultados a medida que se escribe el informe final [Septiembre-Octubre].
+ Seleccionar los mejores métodos, comparar su desempeño con la generación de mallas de Polylla y registrar los datos en el informe final [Noviembre-Diciembre]

#bibliography(
    "bibliografia.yml",
    title: "Referencias",
    style: "ieee",
)