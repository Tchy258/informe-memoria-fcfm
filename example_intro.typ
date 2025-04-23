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

Uno de los problemas recurrentes en este ámbito es la generación automática de mallas poligonales a partir de un conjunto discreto de puntos en el plano, también conocido como problema de triangulación. Si bien existen algoritmos clásicos y eficientes como la triangulación de Delaunay @Delaunay1934, la construcción de formas poligonales a partir de dichas triangulaciones sigue siendo un área de investigación activa. En particular, existe un interés creciente por encontrar métodos que generen mallas con mayor fidelidad geométrica, adaptabilidad local, y que mantengan propiedades deseables como ángulos adecuados y buena distribución de los elementos.

Este trabajo de memoria se enfoca en el desarrollo y análisis de una estrategia alternativa de generación de mallas en dos dimensiones, basada en el concepto de *cavidad*. La idea central es que, a partir de una triangulación de Delaunay (como la de la @ejemplo_delaunay), se seleccionan ciertos triángulos utilizando un criterio definido por el usuario. Luego, se calculan los circuncentros de estos triángulos, y se identifican los triángulos de la malla cuyo circuncírculo contiene alguno de estos puntos. La unión de estos triángulos vecinos forma una *cavidad*, y su capsula convexa define un nuevo polígono. Este procedimiento permite generar regiones poligonales que pueden servir como base para construir mallas más estructuradas o adaptativas.

Este enfoque no solo busca explorar una nueva forma de construir mallas, sino también comparar su rendimiento y características con métodos existentes. En particular, se contrastará esta técnica con el generador de mallas **Polylla** @PolyllaPaper, un sistema moderno que emplea estructuras de datos avanzadas para lograr eficiencia y calidad en la generación de polígonos.


#figure(
    image("imagenes/Delaunay_circumcircles_vectorial.svg", width: 50%),
    caption: "Triangulación de Delaunay con circuncírculos compuesta por 10 vértices.",
) <ejemplo_delaunay>

A modo ilustrativo, en la @ejemplo_seleccion_triangulos se presenta una selección de triángulos a partir de la triangulación anterior.

#figure(
    image("imagenes/seleccion.png", width: 50%),
    caption: [Selección de triángulos para formar un polígono a partir de una cavidad.]
) <ejemplo_seleccion_triangulos>

En este ejemplo, se seleccionaron dos triángulos $t_0$ y $t_1$, cuyos respectivos circuncentros están representados por los puntos $p_0$ y $p_1$. Estos puntos están contenidos en los circuncírculos de varios triángulos vecinos, incluyendo aquellos que los generaron. La unión de estos triángulos conforma la cavidad, como se muestra en @ejemplo_poligono_cavidad.

#figure(
    image("imagenes/resultado.png", width: 30%),
    caption: [Polígono resultante con capsula convexa en azul generado a partir de la cavidad en @ejemplo_seleccion_triangulos.]
) <ejemplo_poligono_cavidad>


La necesidad de desarrollar nuevas estrategias para la generación de mallas responde a múltiples factores: mejorar la eficiencia de los algoritmos existentes, generar elementos con mejores propiedades geométricas, y adaptar las mallas a dominios complejos sin intervención manual.


= Situación Actual

#guia(visible: mostrar_guias, guia_actual)

_Mencionar algoritmos que generen cavidades_

= Objetivos

#guia(visible: mostrar_guias, guia_objetivos)

== Objetivo General

_Implementar el algoritmo de cavidades y compararlo con polylla_

#guia(visible: mostrar_guias, guia_objetivo_general)

== Objetivos Específicos

#guia(visible: mostrar_guias, guia_objetivos_especificos)

_Entender como aplicar las estructuras de polylla al problema_

_Usar dichas estructuras para generar cavidades_

_Corroborar que la cavidad está bien hecha_

_Comparar con polylla_

+ ...
+ ...

== Evaluación

#guia(visible: mostrar_guias, guia_evaluacion)

_Desempeño en tiempo y correctitud de la malla y comparación con polylla_

= Solución Propuesta



#guia(visible: mostrar_guias, guia_solucion)

= Plan de Trabajo (Preliminar)

#guia(visible: mostrar_guias, guia_plan)

+ ...
+ ...

#bibliography(
    "bibliografia.yml",
    title: "Referencias",
    style: "ieee",
)