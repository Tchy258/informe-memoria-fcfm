#import "intro.typ": conf
#import "metadata.typ": example-metadata

// Aquí se importan las guías para ayudar a escribir.
// Se pueden desactivar cambiando el valor de la variable `mostrar_guias` a `false`.
#import "intro_guias.typ": *
#let mostrar_guias = true

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

Una malla poligonal se define como una colección de vértices, aristas y caras que describen la forma que tiene la superficie de un objeto, usualmente subdividido en triángulos. Las mallas poligonales son usadas extensivamente en todo tipo de aplicaciones que requieran una simulación gráfica de un objeto real en el computador, por ejemplo, simulaciones físicas para analizar la integridad estructural de un edificio, cómo las componentes de un objeto interactúan entre sí para propósitos de ensamblaje, gráficos en videojuegos, entre otros.

Para generar una malla poligonal, el requisito mínimo es el conjunto de vértices que describen la forma del objeto, ya sea en dos o tres dimensiones, a partir del cual se debe realizar una triangulación, es decir, unir estos vértices mediante aristas que forman caras triangulares. En este trabajo solo se considerarán mallas en dos dimensiones.

En este trabajo se desea explorar una nueva estrategia que genera polígonos a partir del concepto de cavidad. Dada una triangulación de Delaunay@Delaunay1934 para una malla poligonal, es decir, formada por triángulos donde ningún punto se encuentra dentro del circuncírculo de cualquier triángulo de la triangulación (ver @ejemplo_delaunay), se seleccionan algunos triángulos con algún criterio, luego, por cada triángulo $t$ de los escogidos, se calcula el centro del circuncírculo $p$. El polígono asociado estará formado por la unión de los triángulos que incluyen $p$ en su interior.

#figure(
    image("imagenes/Delaunay_circumcircles_vectorial.svg"),
    caption: "Triangulación de Delaunay con circuncírculos",
) <ejemplo_delaunay>

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