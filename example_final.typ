#import "final.typ": conf, resumen, dedicatoria, agradecimientos, start-doc, end-doc, capitulo, apendice
#import "metadata.typ": example-metadata
#import "constants.typ": pronombre
#let data = (
    ..example-metadata,
    titulo: "GENERACIÓN DE MALLAS POLIGONALES A PARTIR DE CAVIDADES",
    autoria: (nombre: "Nicolás Escobar Zarzar", pronombre: pronombre.el),
    profesores: ((nombre: "Nancy Hitschfeld K.", pronombre: pronombre.ella),),
    coguias: ((nombre: "Sergio Salinas", pronombre: pronombre.el),)
)

#show: conf.with(metadata: data)

#resumen(metadata: data)[
    #lorem(150)
    
    #lorem(100)
    
    #lorem(100)
]

//#dedicatoria[
//    Una dedicatoria especial para alguien especial.
//]

//#agradecimientos[
//    #lorem(150)
//    
//    #lorem(100)
//    
//    #lorem(100)
//]

#show: start-doc

#capitulo(title: "Introducción")[
== Introducción y Motivación
Las mallas poligonales son estructuras fundamentales en el modelado geométrico y la simulación computacional. Se definen como colecciones de vértices, aristas y caras que, en conjunto, representan la superficie de un objeto, generalmente mediante una subdivisión en triángulos. Esta representación es ampliamente utilizada en áreas como el diseño asistido por computador (CAD), gráficos por computadora, ingeniería estructural, biomecánica y videojuegos. La eficiencia y calidad de las mallas generadas influye directamente en la precisión de las simulaciones y en el rendimiento computacional de los sistemas que las utilizan.

Uno de los problemas recurrentes en este ámbito es la generación automática de mallas poligonales a partir de un conjunto discreto de puntos en el plano, también conocido como problema de triangulación. Si bien existen algoritmos eficientes disponibles en herramientas como Triangle @TrianglePaper o Detri2 @Detri2 para formar una triangulación de Delaunay @Delaunay1934, la construcción de formas poligonales a partir de dichas triangulaciones sigue siendo un área de investigación activa. En particular, existe un interés creciente por encontrar métodos que generen mallas con mayor fidelidad geométrica, adaptabilidad local, y que mantengan cualidades deseables como ángulos adecuados y buena distribución de los elementos.

Una triangulación de Delaunay se define como tal si cumple con la propiedad de que para todos los triángulos de la triangulación, se cumple que el circuncírculo del triángulo solo contiene a los vértices de su triángulo respectivo y no los vértices de cualquier otro (ver @ejemplo_delaunay). Estas son de particular importancia porque maximizan el tamaño del ángulo más pequeño de la triangulación. Está propiedad previene problemas de precisión que ocurren al tener ángulos muy agudos los cuales propician 'casos degenerados' donde los puntos de un triángulo son interpretados como colineales lo cual puede provocar cálculos erróneos e incluso que los programas que trabajen con las mallas resultantes que no sean lo suficientemente robustos fallen por completo en el peor de los casos. 

Este trabajo de memoria se enfoca en el desarrollo y análisis de una estrategia alternativa de generación de mallas en dos dimensiones, basada en el concepto de *cavidad* o _concavity_ como se describe en el artículo Triangle @TrianglePaper. La idea central es que, a partir de una triangulación de Delaunay (como la de la @ejemplo_delaunay), se seleccionan ciertos triángulos de la malla en un orden particular utilizando un criterio definido por el usuario. Luego, se calculan los circuncentros $p_i$ de estos triángulos, y se identifican los conjuntos de triángulos de la malla cuyo circuncírculo contiene alguno de estos puntos por separado. La unión de las aristas del borde de estos triángulos vecinos para un punto $p$ forma una *cavidad*, la cual define un nuevo polígono. Este procedimiento permite generar regiones poligonales que pueden servir como base para construir un nuevo tipo de mallas poligonales.


#figure(
    image("imagenes/Delaunay_circumcircles_vectorial.svg", width: 50%),
    caption: "Triangulación de Delaunay con circuncírculos compuesta por 10 vértices."
) <ejemplo_delaunay>

A modo ilustrativo, en la @ejemplo_seleccion_triangulos se presenta una selección de triángulos a partir de la triangulación de la @ejemplo_delaunay.

#figure(
    image("imagenes/seleccion.png", width: 50%),
    caption: [Selección de triángulos para formar un polígono a partir de una cavidad.]
) <ejemplo_seleccion_triangulos>

En este ejemplo, se seleccionaron dos triángulos $t_0$ y $t_1$, cuyos respectivos circuncentros están representados por los puntos $p_0$ y $p_1$. Estos puntos están contenidos en los circuncírculos de varios triángulos vecinos, incluyendo aquellos que los generaron. La unión de las aristas de borde de los triángulos que contienen a $p_0$ y la unión de las aristas de borde de los triángulos que contienen a $p_1$ forman cada uno una cavidad, las cuales se pueden ver en la @ejemplo_poligono_cavidad.

#figure(
    image("imagenes/resultado.png", width: 30%),
    caption: [Polígonos resultantes de las cavidades marcados en azul con los lados discontinuos borrados]
) <ejemplo_poligono_cavidad>


Este enfoque mediante cavidades no solo busca explorar una nueva forma de construir mallas, sino también comparar su rendimiento y características con métodos existentes. En particular, se contrastará esta técnica con el generador de mallas _*Polylla*_ @PolyllaPaper, un sistema moderno que emplea estructuras de datos avanzadas para lograr eficiencia y calidad en la generación de polígonos.

La necesidad de desarrollar nuevas estrategias para la generación de mallas responde a múltiples factores: mejorar la eficiencia de los algoritmos existentes, generar elementos con mejores propiedades geométricas, y adaptar las mallas a dominios complejos sin intervención manual.

== Objetivos
=== Objetivo General
Diseñar e implementar un algoritmo que permita generar polígonos a partir de una _cavidad_ desde una triangulación de Delaunay y comparar su desempeño con el generador de mallas Polylla en cuanto a tiempo, memoria, calidad de las mallas, número de vértices, aptitud para el VEM, entre otros criterios.

=== Objetivos Específicos
+ Investigar como funciona el algoritmo de mallas Polylla, sus estructuras de datos y métricas apropiadas para el VEM.
+ Definir escenarios de prueba para que el conjunto de polígonos que conforman la cavidad computada sean los correctos y generar un nuevo polígono a partir de ellos.
+ Comparar el desempeño del algoritmo basado en cavidades con el algoritmo de Polylla basado en regiones terminales en cuanto a eficiencia en tiempo y memoria.
+ Diseñar e implementar estrategias para seleccionar triángulos cuyo circuncentro se usará para definir cavidades.
+ Comparar la calidad de las mallas resultantes de ambos algoritmos bajo diversas métricas como calidad de la malla, número de aristas, cantidad de polígonos, etc.

== Contenido de la memoria

Los capítulos siguientes de esta memoria abordan lo siguiente:

En el capítulo 2 se describen los conceptos necesarios para comprender este trabajo de memoria, junto con un resumen del estado del arte listando herramientas existentes. En el capítulo 3 se plantea el problema a resolver, se explica el funcionamiento del algoritmo a adaptar (Polylla@PolyllaPaper), su diseño, un breve análisis de aspectos a mejorar y el diseño del algoritmo basado en cavidades junto con una explicación del mismo.

En el capítulo 4 se muestra la implementación de la solución, su estructura a nivel de código, algoritmos concretos y validaciones. En el capítulo 5 se presentan los resultados (mallas poligonales) de la ejecución del algoritmo en diversas configuraciones, detallando estadísticas obtenidas y tablas comparativas de calidad, tiempo y memoria tanto del algoritmo original, su reimplementación y el algoritmo de la solución.

Finalmente en el capítulo 6 se analizan los resultados obtenidos y un posible trabajo futuro.

]

#capitulo(title: "Marco Teórico")[

== Conceptos relevantes
A continuación se explican los conceptos relevantes utilizados a lo largo del trabajo de memoria.

=== Triangulación
Una triangulación es una forma de subdividir un objeto u espacio mediante el uso de triángulos, insertando puntos en su interior para formarlos de ser necesario. Una triangulación es un caso particular de una malla poligonal.

=== Planar Straight Line Graph (PLSG)
Un conjunto de vértices y segmentos que describen un polígono como el de la @PSLGGuitarra. Los segmentos de un PLSG describen una forma o borde concreto que puede no ser convexa como la del ejemplo.

=== Triangulación de Delaunay
Una triangulación de Delaunay cumple la propiedad de que para todo triángulo que conforma la triangulación, su _circuncirculo_, es decir, el círculo único cuya circunferencia pasa por sus 3 vértices, solo contiene a los vértices del mismo triángulo y ningún otro punto, como en la @ejemplo_delaunay. Como se mencionó anteriormente, las triangulaciones de Delaunay son particularmente útiles debido a que maximizan el ángulo más pequeño de la triangulación, cuya utilidad será explicada más adelante. Cuando una triangulación de Delaunay se utiliza para subdividir un objeto con un borde concreto, como el de uno descrito por un PLSG, se dice que la triangulación de Delaunay es restringida, ya que debe incluir dichas aristas y no tener aristas fuera del borde. Esta distinción se hace porque típicamente una triangulación de Delaunay suele triangular conjuntos de puntos sin un borde definido inicialmente, el cual termina siendo la cápsula convexa del conjunto.

=== Cápsula convexa
Dado un conjunto de puntos, su cápsula convexa es el menor polígono convexo (en cuanto a superficie o volumen) que contiene todos los puntos en su interior.

=== Diagrama de voronoi
Un diagrama de Voronoi es una partición de un dominio $P$ en regiones o 'celdas' $R_i$, de las cuales cada una contiene un punto $p_i$ llamado 'semilla' y los puntos $q_i$ contenidos en $R_i$ cumplen que $||q_i-p_i|| < ||q_i - p_j|| forall p_i, p_j in P, i != j$ donde $p_j$ es la semilla de cualquier otra celda distinta a $R_i$. El diagrama de Voronoi también se le conoce como el _dual_ de una triangulación de Delaunay, esto se debe a que, dada una triangulación de Delaunay, se puede obtener su diagrama de Voronoi equivalente si los circuncentros de los triángulos se convierten en puntos para las regiones de Voronoi (el circuncentro es el punto al centro del circuncírculo de un triángulo). Al unir los circuncentros mediante aristas, se forman las regiones del diagrama de Voronoi. En la @VoronoiExample y la @delaunay_voronoi_dual se puede ver un ejemplo de una triangulación de Delaunay con su diagrama de Voronoi respectivo superpuesto.

#figure(
    grid(
    columns: 3,
    gutter: auto,
    image("/imagenes/voronoidual2.png", width: 100%),
    image("/imagenes/voronoidual.png", width: 100%),
    image("/imagenes/voronoi.png", width: 100%),
    ),
    caption: [a) Triangulación de Delaunay y Diagrama de Voronoi superpuesto,\ b) Triangulación de Delaunay,\ c) Diagrama de Voronoi @PolyllaPaper]
) <VoronoiExample>

#figure(
    image("imagenes/delaunay_voronoi_dual.svg", width: 40%),
    caption: [Triangulación de Delaunay (en negro) junto a su diagrama de voronoi (en rojo). Fuente: Wikimedia@VoronoiSVG]
) <delaunay_voronoi_dual>

El diagrama de Voronoi es otro caso particular de malla poligonal.

=== Malla poligonal <malladef>
Una malla poligonal, o malla geométrica, es una forma de describir un objeto o un espacio como una colección de polígonos adyacentes. Estos polígonos se denotan según sus vértices y aristas que unen dichos vértices para formarlos (sus caras). Dichos polígonos pueden existir en un espacio en dos, tres o incluso más dimensiones dependiendo del caso de uso. Este trabajo de memoria solo se centrará en aplicaciones a mallas geométricas en 2D. 

Una malla se puede representar de varias formas, siendo la más común una basada en caras, en que se guarda la información de los vértices que componen la malla y qué vértices forman cada cara, siendo las aristas guardadas de manera implícita en las caras. En la solución propuesta se hace uso de esta representación al recibir una malla como entrada contenida en uno o más archivos de texto, ya sea en formato `.node`, `.ele` y opcionalmente `.neigh` que guardan vértices, aristas (en forma de caras) e información de adyacencia respectivamente o en formato `.off` que guarda información de vértices y aristas, pero no de adyacencia. También se escribirán las mallas resultantes en formato `.off` o en el formato `.ale`, el cual puede convertirse al formato binario `.mat` utilizado principalmente por MATLAB u otro software científico para usar la malla en una solución numérica de una ecuación diferencial en derivadas parciales.

=== Estructura _Half-Edge_ <HalfEdgeStructDef>
Además de la representación basada en caras, se hará uso de la estructura _Half-Edge_@HalfEdgeStruct@weiler1986topological , la cual guarda los vértices y divide las aristas de cada polígono en dos, una arista en sentido horario (abreviado como _CW_ por _clockwise_ del inglés) y otra en sentido antihorario (abreviado como _CCW_ por _counter clockwise_). Por convención, una arista en sentido antihorario, se considera como una arista interna a un polígono y un polígono cualquiera se representa como el bucle completo que inicia desde una arista en sentido CCW y vuelve a la misma. Cada arista posee la siguiente información: un vértice de origen (_origin_), un vértice objetivo (_target_), su arista siguiente y anterior (según su orientación, llamadas también _next_ y _prev_ respectivamente), y su arista 'gemela' (_twin_), la cual representa la misma arista en el sentido contrario. En la @EjemploHE se puede ver un ejemplo de esta estructura.

#figure(
    image("imagenes/Dcel-halfedge-connectivity.svg", width:45%),
    caption: [Ejemplo de estructura _half-edge_@HESVG]
) <EjemploHE>

La estructura _Half-Edge_ brinda una enorme versatilidad al momento de recorrer mallas, ya que, dada la orientación de sus aristas, es posible saber cuando se recorrió un polígono completo si se visitan las aristas _next_ en un bucle hasta volver a la arista original. Dentro de una malla también se definen otras operaciones de recorrido que se pueden derivar directamente de los atributos existentes, estas son: _CWEdgeToVertex_ y _CCWEdgeToVertex_, las cuales permiten encontrar la arista 'siguiente' de la actual en sentido horario y antihorario respectivamente. En la @EjemploHE2 es posible notar que partiendo desde el vértice `vertex`, la arista siguiente en sentido horario de aquella marcada como `halfedge`, es el _next_ de su _twin_, y la arista siguiente en sentido antihorario de `halfedge`, es el _twin_ de su _prev_.

#figure(
    image("imagenes/halfedge.jpg"),
    caption: [Segundo ejemplo de estructura _half-edge_]
) <EjemploHE2>

Haciendo uso de las operaciones anteriores también es posible determinar el 'grado' de un vértice, donde el 'grado' (o _degree_) de un vértice se entiende como la cantidad de aristas cuyo origen es este vértice.

=== Mallas triangulares
Las mallas poligonales se suelen describir como conjuntos de triángulos, ya que al ser el polígono con menos aristas permite hacer una discretización, es decir, una división en partes concretas, del objeto o espacio a modelar con mayor precisión y más flexibilidad en caso de necesitar aplicar alguna transformación lineal a un subconjunto de los polígonos (rotación, traslación, reflexión, entre otros). Las mallas basadas en triángulos son particularmente útiles para describir objetos en sistemas CAD usualmente usados como planos para algún tipo de objeto concreto en 3D afecto a fenómenos físicos como la distribución de fuerzas, cuya simulación es más fiel a la realidad en un objeto descrito con el mayor nivel de detalle que sea razonable utilizar. Estas mallas también son ampliamente utilizadas en videojuegos por las mismas razones.

=== Mallas de polígonos arbitrarios
Otro uso de las mallas poligonales es en el cálculo de una solución numérica en la resolución de ecuaciones diferenciales en derivadas parciales, que describen diversos fenómenos como transferencia de calor o sonido en un espacio u objeto, las cuales no son calculables de manera exacta con un procedimiento analítico. Esta solución numérica se puede aproximar mediante el uso del _Virtual Element Method_@VEM (VEM). Para el VEM son de particular importancia las mallas poligonales basadas en polígonos arbitrarios que cumplen ciertas propiedades de calidad, como tener polígonos simples, mayormente convexos, con ángulos no muy grandes ni muy pequeños, entre otras. Si la malla a utilizar parte desde una triangulación de Delaunay, algunas de estas propiedades son más fáciles de alcanzar. El uso de mallas basadas en polígonos arbitrarios permite un cálculo más rápido para el VEM y con un margen de error aceptable.

=== _Finite Element Method_ (FEM) y _Virtual Element Method_ (VEM)
Como fue mencionado anteriormente, el VEM@VEM es un método numérico para resolver ecuaciones diferenciales haciendo uso de las mallas poligonales arbitrarias, pero antes de que existiese el VEM, existía el FEM@FEMOverview@FEMOg, estos métodos numéricos tienen el mismo objetivo, pero se diferencian en la flexibilidad permitida de los datos de entrada, siendo el FEM mucho más rígido respecto a la malla de entrada, en particular, el FEM no permite polígonos no convexos y solo acepta polígonos de un solo tipo particular como entrada, ya sean triángulos, cuadriláteros, u otros, pero siendo todos del mismo tipo, lo que no lo hace viable para algoritmos como el desarrollado en este tema de memoria.

=== Polígono simple y no simple <simpledef>
Un polígono se define como simple, si sus aristas forman un bucle cerrado, es decir, sin aristas internas. Por otro lado, un polígono no simple, es aquel que posee aristas internas (ver @nosimple). Estos últimos son problemáticos en prácticamente cualquier caso de uso, ya que no permiten 'recorrer' los polígonos de la malla de manera regular y se tratan de eliminar de la malla de alguna manera en caso de que estén presentes.

#figure(
    image("imagenes/nonsimple.svg", width: 35%),
    caption: "Ejemplo de polígono no simple"
) <nosimple>

=== Cavidad <DefCavidad>
En la explicación de la solución se dará a entender como cavidad el polígono resultante de aplicar el algoritmo propuesto, es decir, dado un triángulo $t_i$ con circuncentro $p_i$, la cavidad será el polígono formado por la unión de las aristas de borde del conjunto de triángulos $t$ cuyo circuncírculo contiene al circuncentro $p_i$ en su interior. Ver @ejemplo_poligono_cavidad.

=== C++20
Para este trabajo de memoria se hace uso del lenguaje de programación C++ en su estándar C++20 (el estándar actual al momento de escribir este documento es C++23). C++ es un lenguaje que en sus orígenes, introdujo clases y programación orientada a objetos al lenguaje C, pero hoy en día es un lenguaje multi-paradigma que permite características propias de lenguajes funcionales, como el uso de funciones lambda.

Se escogió este lenguaje por su alto rendimiento y por el hecho de que la implementación de Polylla@RepoPolylla en la que se basará este trabajo fue escrita en este lenguaje. La versión específica del estándar se escoge para asegurar mejor compatibilidad y por la introducción de _concepts_@ConceptSource@Concepts2  al lenguaje.

=== Tipos _Template_ y _Concept_ (C++) <TemplateConceptDef>
En C++ es posible declarar una 'plantilla' (o _template_@CppReferenceTemplates) de una clase 'A' otorgándole un parámetro de tipo que en principio puede ser cualquier cosa, generalmente a este tipo genérico se le llama '`T`', y dentro de la clase se puede operar con variables declaradas con un tipo '`T`' sin hacer ninguna verificación preliminar. Una vez que la clase se utiliza efectivamente dentro del código es cuando este tipo genérico `T` se debe declarar explícitamente como algún tipo concreto particular, y es solo entonces cuando el compilador genera el código máquina relevante para que la clase 'A' *donde 'T' es dicho tipo concreto*, exista. Es en este momento en que se verifica que la clase `A<T>` para ese tipo `T` concreto sea válida, es decir, verificar que toda variable de tipo `T` tenga todos los métodos que se solicitan de ella (si es que se utilizó alguno) y si `T` es utilizado dentro de métodos que reciben algo distinto de `T`, que `T` sea _convertible_ a dicho tipo, por ejemplo, si el método pide un tipo `int` y `T` es algún otro tipo numérico convertible a `int`, entonces `A<T>` es válida, pero si `T` es `std::string`, el código no compilará.

Si bien los tipos _template_@CppReferenceTemplates proveen una muy alta flexibilidad, también son muy propensos a errores, ya que una clase declarada con un tipo _template_, no es realmente una clase hasta el momento en que es instanciada, y si alguna condición para que la clase sea válida no se cumple, el mensaje de error del compilador suele ser muy largo y engorroso, y a menudo indicando errores en lugares no relacionados como funciones de la biblioteca estándar.

Para remediar esto, C++20 introduce los _concept_\s@ConceptSource@Concepts2, similar a la función que cumple una `interface` en el lenguaje Java@OracleJavaInterfaceTutorial para especificar que una clase debe implementar sus métodos para ser válida, un `concept` permite indicar una serie de requerimientos o restricciones que un tipo _template_ debe cumplir para siquiera ser un candidato a tipo dentro de una clase, y esto no solo está restringido a la implementación de métodos, sino que también se pueden especificar atributos que el tipo o clase `T` debe tener, ya sean estáticos o no. Esto es de especial utilidad para este trabajo debido a que permite definir un _alias_ para otro tipo dentro de `T` cuya existencia está asegurada por el `concept`, añadiendo una capa de abstracción que prescinde de detalles específicos relacionados con tipos concretos que un `T` pueda definir dentro de él, otorgando mayor flexibilidad a que cada `T` opere como desee con sus tipos alias indistintamente de quien sea la clase que utilice a `T` como tipo _template_.

Cuando un tipo `T` está restringido por un `concept` y este no se cumple, el mensaje que brinda el compilador es claro, y especifica qué es lo que no se cumple de manera directa, facilitando la tarea de depurar errores relacionados.

== Estado del arte

Existen muchos algoritmos para generación de mallas poligonales, siendo los más relevantes para este trabajo Triangle @TrianglePaper, Detri2 @Detri2 y Polylla @PolyllaPaper.

=== Triangle
El algoritmo Triangle @TrianglePaper se basa en el algoritmo de Ruppert @RuppertPaper y consta de 4 etapas, de las cuales las primeras 2 son exactamente las mismas que las de Ruppert, estas involucran triangular un PSLG como el de la @PSLGGuitarra, y posteriormente insertar los segmentos originales de la triangulación como se ve en la @PSLGGuitarraTriangulada y la @PSLGGuitarraConstrained.

#figure(
    image("/imagenes/pslg.png", width: 80%),
    caption: [PSLG de entrada una guitarra electrica como se ilustra en Triangle @TrianglePaper]
) <PSLGGuitarra>

#figure(
    image("/imagenes/pslgtriangulation.png", width: 80%),
    caption: [Triangulación del PSLG de la @PSLGGuitarra con segmentos originales faltantes @TrianglePaper]
) <PSLGGuitarraTriangulada>

Dado que esta malla no describe precisamente al polígono original del PLSG, puesto que está incluida la cápsula convexa del conjunto de puntos y otras aristas fuera del borde, la segunda etapa consta de reintroducir los segmentos originales del PLSG, esto se puede hacer de 2 maneras posibles según preferencia del usuario. La primera es insertar un nuevo vértice que corresponda al punto medio de alguno de los segmentos que no aparezcan en la triangulación anterior y usar el algoritmo incremental de Lawson @LawsonAlgo para obtener una nueva triangulación de Delaunay basada en la anterior con el vértice adicional. Esto genera que el segmento original se divida en 2 y la nueva triangulación podría tener el segmento original formado por estos 2 sub segmentos. En caso de que los sub segmentos aún no formen un arco en la triangulación, el proceso de insertar un vértice del punto medio se repite recursivamente para los sub segmentos hasta que el segmento original exista como una secuencia de segmentos lineales. La manera alternativa de insertar los segmentos originales, y la que se utiliza por defecto, es convertir la triangulación a una triangulación de Delaunay restringida, en la cual los segmentos originales deben aparecer. Esto se logra eliminando los triángulos que intersequen el segmento que se desea agregar y luego re triangulando las regiones a cada lado del segmento insertado, resultando en la @PSLGGuitarraConstrained.


#figure(
    image("/imagenes/pslgconstrained.png", width: 80%),
    caption: [Triangulación restringida del PSLG de la @PSLGGuitarra @TrianglePaper]
) <PSLGGuitarraConstrained>

La tercera etapa difiere del algoritmo de Ruppert y consiste en remover los triángulos extra que están fuera del borde definido por el PSLG original, como aquellos presentes en zonas que originalmente eran no convexas, a las cuales Shewchuk llama concavidades, y los presentes en agujeros (como los del interior del cuerpo de la guitarra en el ejemplo). Esto se ilustra en la @PSLGGuitarraDeleted.

#figure(
    image("/imagenes/pslgdeletedextra.png", width: 80%),
    caption: [Triangulación restringida del PSLG de la @PSLGGuitarra con triangulos extra removidos @TrianglePaper]
) <PSLGGuitarraDeleted>

La última etapa del algoritmo consiste en el refinamiento de la malla insertando vértices y re triangulando con el algoritmo incremental de Lawson @LawsonAlgo hasta que las restricciones de ángulo mínimo y área máxima de triángulo definidas por el usuario se cumplan. Esta inserción se hace siguiendo 2 reglas, la regla de _segmentos encerrados_ y la de los _triángulos malos_ dándole siempre prioridad a la primera:
- El _círculo diametral_ de un segmento es el círculo único más pequeño que contiene el segmento como su diámetro. Un segmento se dice que está _encerrado_ si un punto que no es un extremo del segmento está dentro de su círculo diametral. Cualquier segmento encerrado que aparezca se separa insertando un vértice en su punto medio. Los dos sub segmentos resultantes tienen círculos diametrales más pequeños y podrían estar o no estar encerrados. El proceso se repite hasta que no queden segmentos encerrados como se ve en la @DiametralCircle.
- Un triángulo se dice que es _malo_ dependiendo de algún criterio, por ejemplo si tiene un ángulo que es muy pequeño o un área que es muy grande para satisfacer las restricciones impuestas por el usuario. Un triángulo malo se destruye insertando un vértice en su circuncentro. Está asegurado que el triángulo malo será eliminado como se ve en la @CavityDeletion para mantener la propiedad de Delaunay. Si el vértice insertado encierra un segmento (como se define en la regla del círculo diametral), este será removido deshaciendo la inserción y los segmentos que encerraba se separarán según la regla del círculo diametral.

#figure(
    image("/imagenes/diametralcircle.png", width: 80%),
    caption: [Segmentos divididos según su círculo diametral @TrianglePaper]
) <DiametralCircle>

#figure(
    image("/imagenes/cavity.png", width: 80%),
    caption: [Triángulo separado según su circuncentro @TrianglePaper]
) <CavityDeletion>

Para el ejemplo de la @PSLGGuitarra, la malla resultante generada por Triangle es la que se ilustra en la @TriangleComplete.

#figure(
    image("/imagenes/trianglecomplete.png", width: 80%),
    caption: [Malla poligonal final resultante de aplicar el algoritmo Triangle @TrianglePaper]
) <TriangleComplete>

Esta última parte del algoritmo es de particular importancia, ya que el criterio del circuncírculo es análogo al de la cavidad, sin embargo, en este caso solo se utiliza para refinar la malla y re triangular las cavidades. Este trabajo de memoria busca explorar más a fondo este proceso y utilizar las cavidades para generar mallas de polígonos generales. 

El algoritmo Triangle posee una implementación escrita en lenguaje C@TriangleCodigo de la cual se adaptó código.

=== Detri2
El software Detri2@Detri2 permite generar triangulaciones a partir de nubes de vértices aleatorios, y utilizar distintos criterios para refinar la triangulación a través de una interfaz gráfica que permite una gran variedad de opciones y resulta muy útil para generar o verificar geometrías. Además de la triangulación de un conjunto de puntos, Detri2 también permite visualizar su diagrama de Voronoi.
En la @VoronoiExample mostrada anteriormente y la @Detri2Example se puede ver una triangulación de Delaunay, su diagrama de Voronoi equivalente, y ambos superpuestos. La @Detri2Example muestra un ejemplo hecho en Detri2.


#figure(
    grid(
    columns: 3,
    gutter: auto,
    image("/imagenes/detri2malla.png", width: 100%),
    image("/imagenes/detri2voronoi.png", width: 100%),
    image("/imagenes/detri2mallayvoronoi.png", width: 100%)
    ),
    caption: [Triangulación de Delaunay y su Diagrama de Voronoi dual en el software Detri2]
) <Detri2Example>


=== Polylla <AlgoPolylla>
Por otro lado, el algoritmo Polylla, busca generar una malla poligonal a partir de una triangulación arbitraria, usando lo que denomina como _Terminal-edge regions_ o regiones de arista terminal, definidas según el _longest edge propagation path_ (camino de propagación de arista más larga o _Lepp_ @Lepp) de los triángulos, las cuales utiliza para generar una partición de la triangulación que se asemeja a un diagrama de Voronoi @Voronoi.

El _Lepp_ o camino de propagación de arista más larga de un triángulo se define de la siguiente manera: Por cada triángulo $t_i$ en cualquier triangulación $Omega$,
el $L e p p(t_i)$ es la lista ordenada de todos los triángulos $t_0,t_1,t_2, ..., t_(l-1), t_l$ con $l in NN$,
tal que $t_i$ es el triángulo vecino de $t_(i-1)$ a través de la arista más larga de $t_(i-1)$, para $i = 1,2,...,l$.
Si una arista más larga es compartida por $t_(l-1)$ y $t_l$ esta se define como una arista terminal donde termina el Lepp y $t_(l-1)$ y $t_l$ son triángulos terminales. Una región de arista terminal se define como la unión de los triángulos $t$ tal que $L e p p (t)$ termina en la misma arista terminal. En la @LeppExample se puede ver un ejemplo de región de arista terminal.

#figure(
    image("/imagenes/lepp.png", width: 100%),
    caption: [Región de arista terminal. a) $L e p p (t_0)$ donde la arista roja es la arista terminal. b) Cuatro Lepps con la misma arista terminal: $L e p p (t_a)$, $L e p p (t_b)$, $L e p p (t_c)$, $L e p p (t_d)$. c) Región de arista terminal generada por la unión de los Lepp de b) @PolyllaPaper]
) <LeppExample>


Además de las aristas terminales, Polylla @PolyllaPaper define los siguientes tipos de aristas. Dada una arista $e$ y dos triángulos $t_1$ y $t_2$ que comparten $e$:
- _Frontier-edge_ o Arista frontera: $e$ no es la arista más larga ni de $t_1$ ni de $t_2$.
- _Internal-edge_ o Arista interna: $e$ es la arista más larga de $t_1$, pero no de $t_2$ o viceversa.
- _Boundary edge_ o Arista de borde: $e$ pertenece a un solo triángulo. Se manejan como aristas frontera.
- _Barrier edge_ o Arista barrera: Arista frontera que queda adentro de una región terminal (y no es el borde).

Polylla consiste de tres fases: Primero etiqueta las aristas de la triangulación de entrada según las categorías anteriores para formar regiones terminales y además designa un _triángulo semilla_ en cada región de arista terminal para construir las regiones. Luego, a partir de cada triángulo semilla, hace un recorrido en sentido antihorario o _counter clockwise_ (CCW en inglés) de la región de arista terminal para encontrar aristas frontera las cuales formaran la región. Algunas regiones pueden terminar como polígonos no simples, es decir, que tienen puntos colineales o aristas que se intersecan entre sí, por lo que hace una fase de reparación donde las aristas barrera se particionan en polígonos simples. En la @TerminalPartition se puede ver una partición de un polígono generada por regiones de arista terminal que presenta una región con un polígono no simple en verde.

#figure(
    image("/imagenes/terminalpartition.png", width: 80%),
    caption: [a) Colección de vértices aleatorios, b) Triangulación de Delaunay donde las líneas sólidas son aristas frontera, las líneas punteadas negras son aristas internas y las aristas punteadas rojas son aristas terminales. c) Partición a partir de regiones de arista terminal @PolyllaPaper]
) <TerminalPartition>

En la @Pikachu se puede ver una triangulación de Delaunay y la malla generada por Polylla a partir de ella.

#figure(
    grid(
        columns: 2,
        image("/imagenes/pikachutriangulization.png", width: 90%),
        image("/imagenes/pikachuPolylla.png", width:90%)
    ),
    caption: [Triangulación de Delaunay y su malla Polylla respectiva @RepoPolylla]
) <Pikachu>

El algoritmo Polylla destaca por sobre otros algoritmos debido a su gran simplicidad y eficiencia en comparación a algoritmos convencionales de construcción de diagramas de Voronoi restringidos, ya que toma bastante menos tiempo en construir con una cantidad de polígonos 3 veces menor y la mitad de vértices que una malla poligonal de un diagrama de Voronoi hecho a partir de la misma triangulación. A esto se le suma también la utilidad de las mallas Polylla en simulaciones de diversos fenómenos que hacen uso del VEM@VEM mencionado anteriormente para encontrar una solución numérica. El algoritmo de construcción de mallas basado en cavidades se muestra como una alternativa a Polylla y mallas basadas en el diagrama de Voronoi que permite explorar el alcance de una nueva estrategia, sus propiedades generativas y de escalabilidad.

=== CGAL
La librería CGAL@CGAL (_Computational Geometry Algorithms Library_) es un proyecto de código abierto escrito en C++ que aloja una basta colección de algoritmos geométricos y estructuras de datos eficientes y robustos. Su propósito es facilitar tareas geométricas complejas que aparecen en dominios tan variados como sistemas de información geográfica, diseño asistido por computador, biología molecular, imágenes médicas, gráficos por computador o robótica.

Dentro de sus módulos más utilizados destacan los dedicados a la generación de mallas y a las estructuras basadas en subdivisiones del plano. CGAL provee triangulaciones de Delaunay en 2D completamente funcionales, incluyendo variantes con restricciones y mecanismos de refinamiento, que facilitan producir mallas de alta calidad. A partir de estas mismas triangulaciones, la biblioteca permite obtener de forma directa el diagrama de Voronoi correspondiente, aprovechando la relación dual entre ambas estructuras. Estas capacidades hacen de CGAL una base sólida para desarrollar, comparar o extender nuevos algoritmos de generación y procesamiento de mallas.

Sin embargo, para este trabajo no se hace uso de CGAL debido a su complejidad y generalidad. Dado que CGAL es una librería enorme, no se utilizaría una cantidad considerable de sus utilidades. Prescindir de CGAL también permite mayor control sobre la implementación.
/*
    #lorem(100)
    
    #lorem(50)

    #figure(
        table(
            columns: 3,
            "Campo 1", "Campo 2", "Num",
            "Valor 1a", "Valor 2a", "3",
            "Valor 1b", "Valor 2b", "3",
        ),
        caption: "Tabla 1",
    )

    #figure(
        table(
            columns: 3,
            "Campo 1", "Campo 2", "Num",
            "Valor 1a", "Valor 2a", "3",
            "Valor 1b", "Valor 2b", "3",
        ),
        caption: "Tabla 2",
    )
    
    #lorem(100)
*/
]

#capitulo(title: "Problema", label: label("cap3"))[
Como se mencionó en la introducción, este trabajo de memoria busca implementar de manera eficiente un algoritmo que permita refinar mallas poligonales basándose en el concepto de cavidad (véase @DefCavidad, @ejemplo_delaunay, @ejemplo_seleccion_triangulos y @ejemplo_poligono_cavidad), basándose en las estructuras de datos presentes en Polylla@PolyllaPaper, comparando las mallas resultantes de los dos algoritmos en términos de calidad, uso de memoria, aptitud para el VEM@VEM, entre otros. Adicionalmente, también se busca reescribir la implementación actual de Polylla basada en _half-edges_@RepoPolylla (_Polylla-Mesh-DCEL_) para integrarla en un programa modular que pueda procesar triangulaciones de Delaunay, ya sea haciendo uso de Polylla, del algoritmo basado en cavidades o algún otro que se añada en el futuro. 

A continuación se describirá a modo general como funciona esta implementación particular de Polylla y por qué existe la necesidad de reescribirla para integrarla en un programa más general.

== Polylla-Mesh-DCEL@RepoPolylla

Esta implementación de Polylla (@AlgoPolylla) escrita en C++, a diferencia de la implementación original basada en caras@PolyllaPaper, usa _half-edges_ (@HalfEdgeStructDef). Polylla-Mesh-DCEL hace uso de 2 estructuras de datos y 2 clases esenciales, siendo estas: `vertex`, `halfEdge`, `Triangulation` y `Polylla`. Estas son utilizadas dentro de una función `main`.

#figure(
    caption: [Estructura `vertex` de Polylla-Mesh-DCEL],
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

La estructura `vertex` describe un punto, o vértice, de la malla conteniendo sus coordenadas _x_ e _y_. También posee un booleano que indica si el vértice es parte del borde de la malla y un número entero que representa un índice hacia algún `halfEdge` que tiene a este vértice como origen dentro de un objeto de la clase `Triangulation` en un `vector` (arreglo de tamaño dinámico) de C++.

#figure(
    caption: [Estructura `halfEdge` de Polylla-Mesh-DCEL],
    box(
        fill: rgb("#d3d3d3"),
        inset: 8pt,
        radius: 4pt,
```cpp
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

La estructura `halfEdge` contiene toda la información que compone a un _half-edge_ como se mencionó en la @HalfEdgeStructDef. Todos estos atributos son índices a vectores dentro de la clase `Triangulation` resumida a continuación.

#figure(
    caption: [Clase `Triangulation` de Polylla-Mesh-DCEL@RepoPolylla (abreviada)],
    box(
        fill: rgb("#d3d3d3"),
        inset: 8pt,
        radius: 4pt,
```cpp
class Triangulation
{
private:
    std::vector<vertex> Vertices;
    std::vector<halfEdge> HalfEdges;
    void read_nodes_from_file(std::string name);
    std::vector<int> read_triangles_from_file(std::string name);
    void construct_interior_halfEdges_from_faces(std::vector<int> &faces);
    std::vector<int>  read_neigh_from_file(std::string name);
    void construct_interior_halfEdges_from_faces(std::vector<int> &faces);
    void construct_interior_halfEdges_from_faces_and_neighs(std::vector<int> &faces, std::vector<int> &neighs);
    void construct_exterior_halfEdges();
    std::vector<int> read_OFFfile(std::string name);
    // Y otros atributos
public:
    Triangulation(); // <- sin uso real
    Triangulation(std::string node_file, std::string ele_file, std::string neigh_file);
    Triangulation(std::string OFF_file);
    Triangulation(const Triangulation &t); //<- constructor de copia
    Triangulation(int size); //<- constructor de malla aleatoria
    ~Triangulation();
    int origin(int e);
    int target(int e);
    int next(int e);
    int prev(int e);
    int twin(int e);
    int CW_edge_to_vertex(int e);
    int CCW_edge_to_vertex(int e);
    int degree(int v);
    // Y otros métodos
}
```
    )
)

La clase `Triangulation`, posee 2 miembros de tipo `vector` que contienen objetos `vertex` y objetos `halfEdge` respectivamente. Además, define los métodos necesarios para recorrer la malla haciendo uso de los índices definidos en `vertex` y `halfEdge`. Estos incluyen todas las operaciones definidas en la @HalfEdgeStructDef como _next_, _prev_, _origin_, _target_ y _twin_. Notar que no hay un atributo _target_ en la estructura `halfEdge`, ya que este está guardado de forma implícita como el atributo `origin` del `halfEdge` apuntado por `twin`.

Uno de los constructores de la clase `Triangulation` lee archivos de texto con información geométrica para generar la malla, en particular, aquellos generados por Triangle@TrianglePaper, los cuales consisten en:
- `.node`: Contiene todos los vértices de la malla junto con sus coordenadas.
- `.ele` : Contiene todos los triángulos presentes en la malla como listas de vértices (representación basada en caras).
- `.neigh`: Contiene información sobre los vecinos de los triángulos. Esta es de gran utilidad al momento de construir la malla basada en _half-edges_.

También tiene un constructor para leer archivos en formato `.off`, extensamente utilizado en aplicaciones de computación gráfica, que también guarda una representación basada en caras.

La clase `Triangulation` es extensamente utilizada dentro de la clase `Polylla`:
#figure(
    caption: [Clase `Polylla` de Polylla-Mesh-DCEL@RepoPolylla (abreviada)],
    box(
        fill: rgb("#d3d3d3"),
        inset: 8pt,
        radius: 4pt,
```cpp
class Polylla
{
private:
    typedef std::vector<int> _polygon; 
    typedef std::vector<char> bit_vector; 


    Triangulation *mesh_input; 
    Triangulation *mesh_output;
    std::vector<int> output_seeds; 

    bit_vector max_edges; 
    bit_vector frontier_edges; 
    std::vector<int> seed_edges;

    std::vector<int> triangle_list;
    bit_vector seed_bet_mark;
    // Y otros atributos
public:
    Polylla() {}; //<- sin uso real
    Polylla(Triangulation *input_mesh);
    Polylla(std::string off_file);
    Polylla(std::string node_file, std::string ele_file, std::string neigh_file);
    Polylla(int size);
    ~Polylla();
    void construct_Polylla();
    void print_stats(std::string filename);
    void print_ALE(std::string filename);
    void print_OFF(std::string filename);
private:
    bool is_seed_edge(int e);
    int label_max_edge(const int e);
    bool is_frontier_edge(const int e);
    int search_frontier_edge(const int e);
    bool has_BarrierEdgeTip(int e_init);
    int travel_triangles(const int e);
    int calculate_middle_edge(const int v);
    void barrieredge_tip_reparation(const int e);
    int generate_repaired_polygon(const int e, bit_vector &seed_list);
```)
)

La clase `Polylla` implementa en su totalidad el algoritmo descrito en la @AlgoPolylla. Esta recibe como argumento en su constructor un objeto de la clase `Triangulation` o los argumentos necesarios para generar uno. Posterior a ello llama al método `construct_Polylla()` que realiza todas las etapas del algoritmo para refinar la malla: etiquetado de aristas máximas (vector `max_edges`) y aristas frontera (vector `frontier_edges`) para posteriormente etiquetar aristas semilla (vector `seed_edges`) para formar las regiones terminales, recorrer dichas regiones terminales para corroborar si forman un polígono simple y si no, repararlo.

Si bien las clases de Polylla-Mesh-DCEL cumplen adecuadamente la implementación del algoritmo Polylla@PolyllaPaper, estas poseen diversos problemas de diseño que las hacen difíciles de extender para otros usos y enormemente complejas de entender sin un estudio profundo del código debido al uso excesivo de tipos primitivos como `int`, que si bien son esencialmente índices, varios métodos reciben como argumento una variable de tipo `int`, pero el tipo de índice al que esta variable se refiere depende del método y la única forma de saber a cuál corresponde es tener conocimiento de como funciona la estructura _half-edge_ y nombres de variables muy poco descriptivos tales como _e_ o _v_. También su documentación es escasa y a veces poco clara. Esto hace muy propenso a errores cualquier modificación que se le realice al código.

Además, estas clases cumplen demasiadas funciones y están altamente restringidas a la configuración actual, principalmente:
- La clase `Triangulation` depende directamente de archivos con formatos específicos y opera con ellos cuando esto no debería ser su responsabilidad.
- La función de procesado de archivos está repartida entre `Triangulation` y `Polylla` de manera independiente cuando esto podría ser manejado por otras clases.
- Las clases `vertex` y `halfEdge` no están definidas en su propio archivo, sino que están definidas en el mismo _header_ que la clase `Triangulation` (`triangulation.hpp`@RepoPolylla).
- Hay una dependencia fuerte entre `Polylla` y `Triangulation`, cuando `Polylla` podría depender de una interfaz que implemente los métodos de `Triangulation`.

Esta implementación de Polylla fue hecha considerando la mayor eficiencia posible, pero es extremadamente rígida, por lo que se propone el siguiente esquema.

== Diseño propuesto

Para reescribir Polylla-Mesh-DCEL brindándole más modularidad se propone un diseño basado en clases altamente genéricas utilizando tipos _template_ con sus _concepts_ asociados (vease @TemplateConceptDef), disponible en #link("https://github.com/Tchy258/Delaunay-cavity")

La clase principal de este diseño es la clase 'PolygonalMesh', la cual hace uso extensivo del patrón de diseño _Strategy_@gamma1994strategy delegando las funciones de leer y escribir archivos geométricos, contener una malla y refinar la malla a clases dedicadas, siendo el tipo de la malla un tipo _template_ restringindo por un _concept_ utilizado como parámetro por todas ellas. Esta clase se muestra en la @UMLPMesh. La iconografía de esta figura y otras representaciones UML está disponible en el @PUMLSyn, mientras que el diagrama completo está disponible en el @Diag.

#figure(
    caption: [Representación UML de la clase `PolygonalMesh`],
    image("imagenes/polygonalMeshUML.png")
) <UMLPMesh>

De manera similar a como la clase `Polylla` mantenía dos punteros a objetos `Triangulation`, la clase `PolygonalMesh` mantiene punteros a variables de tipo `Mesh`, el cual es un parámetro _template_ de la clase, restringido por el _concept_ `MeshData`. Esto desacopla el detalle de qué tipo de malla específica se desea utilizar sin el costo adicional que involucra tener una clase virtual de C++@driesen1996direct independientemente de las optimizaciones que el compilador pueda hacer al respecto@padlewski2020vptr.

El _concept_ `MeshData` a su vez está compuesto de 8 otros _concepts_ específicos, cada uno definiendo distintas características que un tipo genérico debe respetar para ser considerado viable como una malla:
- `MeshAccessors`: Define _getters_ que toda malla debiese tener, incluyendo _getters_ para vértices, aristas, polígonos y datos relacionados como la cantidad de cada uno o la cantidad de aristas de un polígono.
- `MeshEdges` y `MeshVertices`: Declaran que toda malla debe definir un _alias_ con la instrucción _using_@cppreference_using para sus vértices y aristas. Esto asegura correctitud al momento de llamar métodos de una malla que operan o retornan con vértices o aristas de la misma, puesto que gracias al alias, en tiempo de compilación es inequívoco con qué tipo de vértice o arista se está trabajando.
- `MeshIndices`: Declaran que toda malla debe definir un _alias_ con la instrucción _using_@cppreference_using para 'tipos índice', esto con la finalidad de diferenciar cuándo se está trabajando con un índice que representa un vértice, una arista, una cara o 'un índice de salida', donde este último debe ser alguno de los anteriores. Este atributo es un detalle de la implementación concreta, ya que una 'salida' es un índice de cara para una representación basada en caras, pero un índice de arista para una representación basada en _half-edges_. En la práctica, todos estos índices pueden perfectamente ser `int` o cualquier otro tipo de entero que se pueda usar para indexar (haciendo uso de un _concept_ auxiliar llamado `PrimitiveIntegral` que se asegura de ello), la ventaja, es que al momento de escribir o usar código que opere o retorne dichos índices, es evidente a que se refieren, porque en vez de estar declarados como simplemente `int`, están declarados como el tipo de índice específico que la malla declara dentro de sí para el método, como `VertexIndex`, `EdgeIndex`, `FaceIndex` u `OutputIndex`. Adicionalmente, este _concept_ también declara la existencia de un miembro estático constante llamado `invalidIndexValue`, este símbolo es de particular utilidad para invalidar índices de salida de forma clara y explícita en vez de usar un valor literal como `-1` en múltiples lugares para ese propósito.
- `MeshSetters`: Declara la existencia de _setters_ generales para mutar el estado o características de la malla, incluyendo setters para el número efectivo de vértices, polígonos y aristas, junto con métodos para unir dos polígonos, deshacer una unión y un tipo interno declarado por la malla con un 'respaldo de conectividad' (`ConnectivityBackupT`) para deshacer dicha unión de ser necesario, por ejemplo, si la unión entre dos polígonos no da un resultado deseado.
- `MeshTopology`: Declara métodos genéricos para consultar información topológica sobre la malla, por ejemplo: quienes son los vecinos de un polígono dado, cuáles son los vértices o aristas de un triángulo dado (asumiendo que sigue siendo triangular), si es que una arista es parte del borde de la malla, la arista o aristas compartidas entre 2 triángulos o 2 polígonos respectivamente, el largo al cuadrado de una arista, si es un polígono es convexo y por último si un polígono es simple (@simpledef).
- `MeshConstructible`: Declara constructores que una malla debe tener junto con sus argumentos, en particular, una malla debe ser capaz de recibir un `vector` de vértices, un `vector` de aristas y un `vector` de índices de cara como mínimo para ser válida. También debe tener un constructor de copia. Estos vértices, aristas e índices de cara son un detalle de la malla misma definidos según los _concepts_ anteriores. Este constructor se define con estos argumentos con la idea de que los datos de la malla vienen en una representación basada en caras, permitiendo que la implementación de malla particular reorganice estos datos como estime conveniente.
- `MeshMemory`: _Concept_ de utilidad que declara métodos para calcular el uso de memoria de una malla, usado para medir rendimiento.


Como se puede notar, estos _concepts_ se basan muy fuertemente en la definición de malla que brindaba la clase `Triangulation`, pero delegan la tarea de leer los vértices hacia otra clase, eliminando la restricción de solo poder leer mallas no aleatorias desde archivos. La clase que se adhiere a estos _concepts_ y es un reemplazo directo a `Triangulation` es la clase `HalfEdgeMesh` de la @HEMeshUML.

#figure(
    caption: [Representación UML de la clase `HalfEdgeMesh`],
    image("imagenes/hemeshuml.png")
) <HEMeshUML>

Esta clase implementa la estructura _half-edge_ haciendo uso de los _structs_ `HEVertex` y `HalfEdge` de la @HEdgesUML, adaptados de Polylla-Mesh-DCEL. Notar que en C++, la única diferencia entre _struct_ y _class_ es que la visibilidad por defecto es distinta, siendo `public` en el primero y `private` en el segundo, pero en realidad ambos son clases capaces de definir atributos y métodos.

#figure(
    caption: [Representación UML de las clases `Vertex`, `HEVertex` y `HalfEdge`],
    image("imagenes/umlhedges.png")
) <HEdgesUML>

Además de los atributos que poseían los _struct_ `vertex` y `halfEdge` de Polylla-Mesh-DCEL, se hace una distinción entre un vértice genérico (`Vertex`) y un vértice especializado para _half-edges_ (`HEVertex`), puesto que en la mayoría de los casos es suficiente operar con un vértice tratandolo como un `Vertex` con las operaciones que este define, son de particular utilidad sus métodos públicos:
- `operator*,+,-,==`: Azúcar sintáctica que permite escribir en código operaciones como $v_1 + v_2$ que suma cada coordenada por separado, como se esperaría al operar con puntos en un plano en dos dimensiones.
- `cross2d`: Dados 3 vértices $v_1$, $v_2$, y $v_3$, `v1.cross2d(v2,v3)` retorna el valor de la coordenada $z$ al hacer un producto cruz entre los vectores formados por $v_2 - v_1$ y $v_3 - v_1$. Esta operación permite determinar la orientación en la que se encuentran los vértices, horario o antihorario, según su signo, donde un valor positivo representa una orientación en sentido antihorario, y un valor negativo, una orientación en sentido horario. Este valor también equivale a la mitad del área de un triángulo formado por estos 3 vértices, lo cual se puede extender para calcular el área de cualquier polígono arbitrario.
- `dot`: Operación de producto punto entre 2 vectores, útil al calcular el largo de una arista entre vértices $v_1$ y $v_2$, ya que el producto punto de un vector consigo mismo equivale al cuadrado de su norma euclidiana.
- `findCircumcenter` e `inCircle`: Adaptando la lógica de Triangle@TriangleCodigo, estos métodos permiten encontrar el circuncírculo de un triángulo y determinar si un punto está $P$ está en el interior del círculo descrito por los puntos $A$, $B$ y $C$ usando un método basado en determinantes@Circumcircle. Estos métodos son cruciales para la formación de cavidades.

Continuando con otros miembros de la clase `PolygonalMesh` de la @UMLPMesh, se tienen variables con clase `std::unique_ptr<MeshReader>` y `std::unique_ptr<MeshWriter>`, estos objetos son los llamados _smart pointers_@stroustrup2013cpp de C++, los cuales, a diferencia de punteros estándar, saben como manejar su memoria en el _heap_, con un costo leve de rendimiento. Para estos dos miembros se prefiere el uso de _smart pointers_ porque, como mucho, se necesitan una sola vez cada uno para leer y escribir la malla a archivos, siendo despreciable el costo de rendimiento asociado comparado a la función que estos objetos realizan (entrada y salida de archivos). Los objetos de tipo `Mesh` en cambio, son usados múltiples veces a lo largo de distintas de clases, por lo que convertirlos en _smart pointers_ resultaría en una disminución considerable de rendimiento. 
//Los objetos `Mesh` en realidad no necesitaban ser punteros y podrían haber sido valores pasados por referencia a lo largo del programa

`MeshReader` y `MeshWriter`, son clases virtuales (o abstractas) que definen la interfaz común que una clase que lee y escribe de mallas debe definir respectivamente. Estos miembros de `PolygonalMesh` deben ser virtuales y no _templates_, ya que le permiten polimorfismo de clases en tiempo de ejecución (recordar que los tipos _template_ son fijos una vez declarados), otorgándole la capacidad de leer y escribir mallas en distintos formatos de archivo en una misma ejecución del programa si así se quisiera. Estas clases se pueden ver en la @UMLReader y la @UMLWriter.

#figure(
    caption: [Representación UML de la clase abstracta `MeshReader`],
    image("imagenes/mesh_reader_uml.png")
) <UMLReader>

#figure(
    caption: [Representación UML de la clase abstracta `MeshWriter`],
    image("imagenes/mesh_writer_uml.png")
) <UMLWriter>

A diferencia de la clase `Triangulation` que recibe objetos de tipo `string` representando nombres de archivo, las clases que extienden `MeshReader` y `MeshWriter` utilizan un `vector` de objetos tipo `filesystem::path` de manera explícita, dando entender inmediatamente que estos parámetros hacen referencia a rutas en el sistema de archivos y no a cualquier `string`. Además, el hecho de que el argumento sea un `vector` le da más flexibilidad para que formatos que lean o escriban múltiples archivos tengan una interfaz uniforme. El método `isWhitespace` de `MeshReader` era una función libre declarada en el archivo `triangulation.hpp`@RepoPolylla, pero que no era parte de `Triangulation`, este método es usado para leer mallas correctamente.

La clase `MeshReader` tiene 2 implementaciones concretas: `NodeEleReader` y `OffReader` que leen los formatos mencionados en la @malladef, siendo estos `.node`, `.ele` y `.neigh` para el primero y `.off` para el segundo. Estas clases se pueden ver en la @UmlReaders

#figure(
    image("imagenes/uml_readers.png"),
    caption: [Representación UML de las clases `NodeEleReader` y `OffReader`]
) <UmlReaders>

La clase `MeshWriter` también tiene 2 implementaciones concretas: `OffWriter` y `AleWriter`, que escriben en formato `.off` y `.ale` respectivamente. Su representación UML se puede ver en la @UmlWriters

#figure(
    grid(
        columns: 1,
        [#image("imagenes/uml_off_writer.png")],
        [#image("imagenes/uml_ale_writer.png")]
    ),
    caption: [Representación UML de las clases `OffWriter` y `AleWriter`]
) <UmlWriters>

    /*#lorem(100)
    
    #lorem(50)

    #figure(
        image("imagenes/institucion/fcfm.svg", width: 20%),
        caption: "Logo de la facultad",
    )
    
    #lorem(100)
    */
]

#capitulo(title: "Solución")[
== Algoritmo de refinado basado en cavidades
El algoritmo de refinado basado en cavidades consta de 5 etapas: Selección y ordenamiento de triángulos, cálculo de circuncentro, computo de cavidades, inserción de cavidades y un paso opcional de postprocesado.
=== Selección y ordenamiento de triángulos según criterios
Además de la malla triangular de input, el algoritmo también necesita comparadores y criterios refinado, los cuales están descritos por los _concepts_ `TriangleComparator` y `RefinementCriterion`, es según estos comparadores y criterios el cómo se decide el orden en que las cavidades serán calculadas y posteriormente insertadas. 

Durante el semestre se desarrollaron los siguientes comparadores de triángulos, los cuales pueden ordenar de forma ascendente o descendente si es que aplica:
- `AngleComparator`: Ordena según ángulo mínimo o máximo.
- `AreaComparator`: Ordena según área o doble del área.
- `EdgeLengthComparator`: Ordena según largo mínimo o máximo de las aristas.
- `NullComparator`: No cambia el orden de los triángulos y este se mantiene según como vienen en la malla.
- `RandomComparator`: Revuelve los triángulos con un generador psuedoaleatorio _mersenne twister_@MatsumotoNishimura1998 con un objeto del tipo `std::mt19937` de C++. La semilla es configurable por el usuario.

También se desarrollaron los siguientes criterios de refinado que priorizan triángulos que cumplen con alguna característica deseada o indeseada, para que sean los primeros en considerarse como parte de una cavidad:
- `MinAngleCriterion`: Prioriza triángulos donde el coseno cuadrado del ángulo mínimo esté por debajo de un umbral. Se prefiere usar coseno cuadrado por su eficiencia, de la misma forma que se hace en el código de Triangle@TriangleCodigo. Su correctitud está asegurada mientras se trabaje con ángulos agudos.
- `MinAngleCriterionRobust`: Similar al anterior pero calcula los ángulos reales mediante la función arco coseno, computacionalmente caro.
- `MinAreaCriterion`: Prioriza triángulos donde el área esté por debajo de un umbral.
- `MinArea2Criterion`: Similar al anterior, pero ahorra una operación al utilizar el doble del área, resultado directo de un producto cruz en 2 dimensiones.
- `NullRefinementCriterion`: No prioriza ningún triángulo y permite al comparador ordenar la totalidad de ellos.

Inicialmente se planteaba la capacidad de componer estos criterios de refinado con pequeños funtores simulando algebra booleana para tener criterios arbitrariamente complejos, los cuales existen, pero dada la cantidad infinita de formas en que estos pueden ser compuestos, no fueron utilizados durante pruebas:
- `NotCriterion`: Invierte un criterio, es decir, prioriza aquellos que no son priorizados por un criterio particular.
- `AndCriteria`: Dados dos criterios (incluyendose a si mismo como 'un criterio'), solo prioriza un triángulo si este es priorizado por ambos criterios. Cumple la función de un _y_ lógico.
- `OrCriteria`: Similar al anterior, pero le basta con que sea priorizado por un critero o ambos. Cumple la función de un _o_ lógico.


Esta parte del algoritmo sigue los pasos del siguiente pseudocódigo:
#table(columns: 100%,)[Etapa 1: Selección de triángulos][Entrada: Malla inicial $M$, Comparador $O$, Criterio de refinado $R$][Salida: Conjunto de triángulos ordenados antes del cómputo de cavidades]
#figure(
    caption: [Algoritmo de selección de triangulos],
    [#box(
        fill: rgb("#d3d3d3"),
        inset: 8pt,
        radius: 4pt,
```
L ← Lista de triangulos de M
if R y O no son nulos then
    L ← Ordenar L ubicando los triángulos escogidos por R primero
    P ← Indice del primer triángulo no escogido por R
    L ← Ordenar L desde P en adelante usando el comparador O
else if R es criterio nulo y O no then
    L ← Ordenar L completo usando el comparador o
else if O es comparador nulo y R no then
    L ← Ordenar L ubicando los triángulos escogidos por R primero
end if
return L
```
)
])
Notar que en la implementación actual, tanto el comparador como el criterio de refinado preservan el orden relativo de los triángulos, haciendo uso de las funciones de la librería estándar de C++ `std::stable_sort` y `std::stable_partition`.

La implementación de estas funciones varía levemente según el compilador, siendo el algoritmo _merge sort_@libstdcxx-stable_sort@libstdcxx-stable_sort-details@libcxx-stable_sort-source@msvc-stl-stable_sort@cppreference-stable_sort la base común para `std::stable_sort` y alguna variación de _divide and conquer_@libstdcxx-stable_partition@libstdcxx-constexpr-stable_partition-2025@libcxx-stable_partition-source@cppreference-stable_partition para `std::stable_partition`.

También cabe destacar que, dado que tanto el comparador como el criterio de refinado son parámetros _template_, todos los `if` de este paso se resuelven en tiempo en compilación usando la instrucción `if constexpr`@Libroconstexpr  introducida en C++17, la cual, de manera similar a una macro, permite descartar o incluir ramas completas del código máquina presentes en el archivo ejecutable final. Se diferencia de una macro en el hecho de que es capaz de usar características de reflexión intrínsecas del lenguaje (además de revisarse después de haber procesado macros), incluyendo validaciones de _concepts_ para asegurar una correctitud más rigurosa que no compromete la eficiencia del programa final por no necesitar hacer validaciones en tiempo de ejecución.

=== Cálculo del circuncentro
En este paso se lleva a cabo el cálculo del circuncentro de todos los triángulos de la malla. Esto se hace mediante el siguiente método basado en determinantes@Circumcircle:

Sean $A$, $B$ y $C$ los vértices de un triángulo en orientación CCW, primero, para simplificar cálculos y sin pérdida de generalidad, se aplica una traslación a estos vértices de modo que $A$, $B$ o $C$ quede en el origen, por simplicidad, se asumirá que $A$ se traslada al origen y se definen los siguientes nuevos vértices:
$ A' = A - A = (0,0) $
$ B' = B - A $
$ C' = C - A $
También se computará un valor $D$ que corresponde al cuádruple del área del triángulo desplazado:
$ D = 2[(A' times B')_z + (B' times C')_z + (C' times A')_z] $
$ D = 2 (B' times C')_z $
$ D = 2(B'_x C'_y - B'_y C'_x) $

Luego las coordenadas del circuncentro desplazado $U'$ serán
$ U'_x = 1/D [C'_y (B'_x^2 + B'_y^2) - B'_y (C'_x^2 + C'_y^2)] $
$ U'_y = 1/D [B'_x (C'_x^2 + C'_y^2) - C'_x (B'_x^2 + B'_y^2)] $

Se debe tener precaución al calcular $D$, ya que este podría ser cero, indicando la presencia de un 'caso degenerado', pero estos triángulos también serán eliminados como parte de la cavidad. Esto podría ocurrir por errores de precisión en los datos.

Finalmente, las coordenadas del circuncentro real estarán ubicadas en:
$ U = U' + A $
Con esta información, esta etapa del algoritmo se describe de la manera siguiente:
#table(columns: 100%,)[Etapa 2: Cálculo de circuncentros][Entrada: Malla inicial $M$][Salida: Conjunto de pares $(c,t)$ que representan un circuncentro $c$ con su triángulo $t$]
#figure(
    caption: [Algoritmo de computo de circuncentros],
    [#box(
        fill: rgb("#d3d3d3"),
        inset: 8pt,
        radius: 4pt,
```
C ← {∅}
for cada triángulo tᵢ ∈ M do
    V₁,V₂,V₃ ← Vértices de tᵢ
    V₀ ← Vértice auxiliar que representa el orígen (0,0)
    V₂',V₃' ← Vértices V₂ y V₃ desplazados al origen según V₁
    D ← Determinante basado en producto cruz del origen con V₂' y V₃'
    c'← Circuncentro de tᵢ desplazado en V₁
    c ← Circuncentro de tᵢ
    C ← C ∪ {{c,tᵢ}}
end for
return C
```
)
])

=== Cómputo de cavidades

Para esta etapa del algoritmo, se recorre la malla poligonal usando el algoritmo _Breadth First Search_@moore1959 (o _BFS_) utilizando la malla como un grafo considerando a cada triángulo individual como un nodo de este. El primer triángulo $t_i$ presente en la lista de circuncentros según el orden del paso 1, debe ser parte de la primera cavidad y se debe utilizar como el nodo de partida de un recorrido _BFS_ manteniendo una cola de triángulos a visitar. Esta cola añade triángulos vecinos si su circuncírculo contiene al circuncentro del triángulo inicial, luego por cada vecino que se va quitando de la cola, se hace la misma verificación para sus vecinos, deteniéndose cuando la cola esté vacía.

Al remover un triángulo de la cola, este se marca como parte de la cavidad, posteriormente, se revisa si es un triángulo de borde de la malla, ya que de ser el caso, una de sus aristas debe preservarse en la cavidad. Luego se revisa cada uno de sus vecinos verificando tres condiciones en orden:
+ Si el triángulo vecino ya fue visitado en este recorrido, se procede al vecino siguiente sin hacer nada más.
+ Si no fue visitado, se marca como visitado, luego se verifica si es que la estrategia de unión de polígonos considera a este triángulo vecino como un candidato 'válido' para formar parte de la cavidad. En la implementación actual, un triángulo vecino es un candidato válido si no pertenece a otra cavidad previamente calculada, pero es posible extender esto a futuro para imponer cualquier otra restricción arbitraria.
+ Si el triángulo vecino es un candidato válido, se debe verificar que su circuncírculo contiene el circuncentro de $t_i$, en caso de cumplirse, entonces este triángulo se añade a la cola.

Finalmente, si el triángulo vecino no fue previamente visitado y no es válido o su circuncírculo no contiene al circuncentro del triángulo inicial, significa que la arista compartida entre este triángulo vecino y el triángulo actual es un borde de la cavidad y debe preservarse.
Estas aristas de borde se guardan por separado, ya que serán las únicas aristas presentes en el output descartando todas las demás.

Una vez que se hace el recorrido completo de un triángulo según el orden del paso 1, se inicia un nuevo recorrido _BFS_ tomando como punto de partida el triángulo siguiente si y solo sí este no forma parte de una cavidad previamente computada, de lo contrario, el recorrido no se realiza desde este triángulo pasando al siguiente hasta haber intentado iniciar un recorrido por todos los triángulos de la malla.

A continuación se presentan estos mismos pasos en forma de pseudocódigo:


#table(columns: 100%,)[Paso 3: Cómputo de cavidades][Entrada: Malla inicial $M$, Conjunto de circuncentros $C$][Salida: Conjunto de cavidades $D$ ]
#set page(flipped: true)
#figure(
    caption: [Algoritmo de cómputo de cavidades],
    grid( columns: (50%, 50%),
    [
    #box(
        fill: rgb("#d3d3d3"),
        inset: 8pt,
        radius: 4pt,
```
D ← {∅}
V ← Arreglo de booleanos para marcar triangulos visitados
I ← Arreglo auxiliar para marcar triángulos que ya forman parte de una cavidad

for cada par (cᵢ,tᵢ) ∈ C do
  if I[tᵢ] = True then
    continue
  end if

  Q ← Cola de triángulos vecinos para BFS
  d ← Objeto de cavidad vacío
  Tᵢ ← Triángulos interiores de d
  Tₒ ← Triángulos de borde de d
  T ← Triángulos totales de d
  Eᵣ ← Aristas de borde de d
  Q.push(tᵢ)
  V[tᵢ] ← True
  T ← T ∪ {tᵢ}
  while not Q.empty() do
    tₙ ← Q.pop()
    I[tₙ] ← True
    N ← Triángulos vecinos de tₙ en M
    E ← Aristas de tₙ en M
    b ← False # True si tₙ ∈ Borde de M
    if cantidadDeVecinos(tₙ) < 3 then
      for cada arista e ∈ E do
        if e ∈ borde de M then
          b ← True si tₙ != tᵢ
          Eᵣ ← Eᵣ ∪ {e}
        end if
      end for
    end if
```
)], [
    #show raw.where(block: true): code => {
    grid(
        columns: (auto, auto),
        column-gutter: 1em,
        row-gutter: par.leading,
        align: (right, raw.align),
        ..for line in code.lines {
        (
            text(fill: gray)[#calc.abs(line.number + 31)],
            line.body,
        )
        },
    )
    }
    #box(
        fill: rgb("#d3d3d3"),
        inset: 8pt,
        radius: 4pt,
```
    for cada vecino n ∈ N do
      if V[n] = True then
        continue
      end if 
      if candidatoValido(n) and cᵢ ∈ circuncirculo de n then
        V[n] ← True
        Q.push(n)
        T ← T ∪ {tᵢ}
      else if tₙ = tᵢ then
        for cada arista e ∈ E do
            if e ∈ tₙ and e ∈ n then
              Eᵣ ← Eᵣ ∪ {e}
            end if
        end for
      else then
        b ← True
        s ← Arista compartida entre tₙ y n
        Eᵣ ← Eᵣ ∪ {s}
      end if
    end for

    if b = True then
      Tₒ ← Tₒ ∪ {tₙ}
    else then
      Tᵢ ← Tᵢ ∪ {tₙ}
    end if
  end while

  Ordenar y deduplicar elementos de d
  Reiniciar V a False
  D ← D ∪ {d}
end for
return D
```
)]
))
#show raw.where(block: true): code => {
    grid(
        columns: (auto, auto),
        column-gutter: 1em,
        row-gutter: par.leading,
        align: (right, raw.align),
        ..for line in code.lines {
        (
            text(fill: gray)[#line.number],
            line.body,
        )
        },
    )
    }
#set page(flipped: false)
=== Inserción de Cavidades
Con la información del paso anterior es posible hacer efectiva la mutación de la malla para convertir los conjuntos de triángulos que forman las cavidades en polígonos arbitrarios formados por sus aristas de borde. 

Actualmente, este paso es el único que no fue generalizado para cualquier tipo de malla, ya que el cómo se unen polígonos y que representa a cada uno es un detalle de implementación, en este caso particular, la inserción de cada cavidad se hace asumiendo que la malla usa una representación basada en _half edges_, haciendo uso de la clase auxiliar `MeshHelper`, la cual es un esqueleto que define operaciones que el refinador desea hacer sobre la malla, pero que la malla misma no necesita implementar por separado, ya que se logra mediante combinaciones de operaciones existentes que le incumben al refinador.
Esta implementación se detalla a continuación:

+ Se marca que aristas de la totalidad de la malla pertenecen al borde de la cavidad actual, esto para permitir una búsqueda inmediata al momento de formar el polígono final.
+ Se toma una arista de borde, en este caso la primera que aparezca en el objeto `Cavity` (puede ser cualquiera) y se calcula su arista `next`, luego, utilizando el método `CCWEdgeToVertex` se hace un barrido en sentido antihorario desde esta arista `next` buscando la siguiente arista que si es parte del borde de la cavidad, cuando esta es encontrada, se reconecta con la arista anterior y esta pasa a ser la siguiente arista a reconectar con otra arista de borde. Este proceso sigue hasta volver a la primera arista de borde tomada.

Hecho esto, se actualiza también el conteo de aristas y polígonos que la malla reporta para que estos sean coherentes con la malla de salida, detalle importante al momento de escribir la malla a un archivo.

A continuación se presenta este proceso en forma de pseudocódigo:
#table(columns: 100%,)[Paso 4: Inserción de cavidades][Entrada: Malla inicial $M$, Conjunto de cavidades $D$][Salida: Malla mutada $M'$ y arreglo de polígonos de salida $P$ ]

#figure(
    caption: [Algoritmo de inserción de cavidades],
    [#box(
        fill: rgb("#d3d3d3"),
        inset: 8pt,
        radius: 4pt,
```
P ← {∅}
M' ← Copia de M
p ← Cantidad de poligonos de M'
a ← Cantidad de aristas de M'
for cada cavidad dᵢ ∈ D do
    B ← Arreglo de booleanos para aristas de borde en la malla
    for cada arista e ∈ dᵢ.aristasDeBorde do
        B[e] ← True
    end for
    p ← p - size(dᵢ.triangulosTotales) - 1
    a ← a - size(dᵢ.triangulosTotales) * 3 + size(dᵢ.aristasDeBorde)
    f ← Primera arista en dᵢ.aristasDeBorde
    P ← P ∪ {f}
    h ← f
    do while h != f
        c ← M.CCWEdgeToVertex(h)
        while B[c] = False do
            c ← M.CCWEdgeToVertex(c)
        end while
        M'.setNext(h,c)
        M'.setPrev(c,h)
        h ← c
    end while
end for
return M', P
```
)
])

Notar que el arreglo $P$ guarda aristas, ya que en la representación basada en _half edges_, los polígonos se identifican con un solo _half edge_ de su interior. Aquí es cuando cobra particular importancia la distinción de qué es una salida como se mencionó en el capítulo anterior, y la claridad que brindan los _concepts_ de C++, ya que a modo general $P$ es un arreglo de `OutputIndex`, no importandole al refinador ni otras clases la malla subyacente a pesar de que el proceso de inserción si lo sea. En este caso `OutputIndex = EdgeIndex`.

En la @cavidadsvg se muestran ilustraciones paso por paso del cómputo e inserción de una cavidad, en a) se pueden ver 3 triángulos que forman una malla, luego, en b) se escoge el triángulo en rojo como semilla para iniciar el recorrido _BFS_ y se agregan los vecinos a la cola, en c), se revisa un vecino verificando que su circuncírculo contenga al circuncentro del triángulo rojo, dado que en este ejemplo si lo contiene, su arista compartida se marca para ser eliminada en d). Los pasos e) y f) siguen esta misma lógica con otro vecino, y en caso de que estos triángulos tuviesen otros vecinos, se hace la misma verificación siempre con el circuncentro del mismo triángulo semilla, deteniendo el recorrido.

#figure(
    [#grid(
        columns: (30%,30%,30%),
        [#image("imagenes/step1.svg")a) Malla original],[#image("imagenes/step2.svg")b) Circuncentro del\ triángulo semilla en rojo],[#image("imagenes/step3.svg")c) Circuncírculo del vecino conteniendo al punto rojo],[#image("imagenes/step4.svg")d) Marcado de\ arista compartida],
        [#image("imagenes/step5.svg")e) Circuncírculo de otro\ vecino conteniendo al\ punto rojo],[#image("imagenes/step6.svg")f) Marcado de arista compartida y fin del recorrido]
    )
    #image("imagenes/step7.svg",width: 30%)g) Cavidad final tras reconexión de aristas
    ],
    caption: [Pasos de la inserción de una cavidad]
) <cavidadsvg>

=== Postprocesado
Del mismo modo en que la primera etapa es altamente personalizable según el criterio de refinamiento y comparador escogido, la etapa de postprocesado posee una gran variedad de alternativas y posibilidad de extensión según el resultado deseado. Durante el trabajo de memoria se desarrolló una etapa de postprocesado centrada en eliminar todos los triángulos restantes de la malla (`MergeTrianglesStrategy`), uniéndolos con alguno de sus vecinos según alguna política (`PolygonMergingPolicy`) de fusión de polígonos. Las políticas existentes que unen polígonos con alguno de sus vecinos al momento de escribir el documento son las siguientes:
- `EdgeLengthBasedMergingPolicy`: Une según la arista compartida con un vecino que tenga el mayor o menor largo según preferencia del usuario.
- `SizeBasedNeighborMergingPolicy`: Une según la cantidad de lados de los vecinos, escogiendo el vecino con más o menos lados según preferencia del usuario.
- `MaximizeConvexityMergingPolicy`: Intenta unir con un vecino de manera que el polígono resultante sea convexo, si no lo es, prueba con el vecino siguiente, si ninguna fusión resulta en un polígono convexo, no une los polígonos. Se considera que el polígono resultante es convexo si el signo del producto cruz entre 3 vértices consecutivos en una orientación en particular, ya sea horaria o antihoraria, tiene el mismo signo para todos los tripletes de vértices.
- `NullPolygonMergingPolicy`: Clase auxiliar para ejecuciones del programa donde no se desea hacer postprocesado.

La etapa de postprocesado hace uso de una estructura de datos _union find_@tarjan1975uf para mantener un registro de quienes son los representantes válidos de los polígonos. Dado que esta etapa también es altamente dependiente de detalles de la malla, esta estructura guarda índices de aristas _half edge_ como representantes. Una vez construida la estructura _union find_, se escoge el polígono a unir mediante la estrategia (`MergingStrategy`) con una política (`PolygonMergingPolicy`) particular.

El procedimiento para fusionar un polígono con uno de sus vecinos en una malla basada en _half edges_ es el siguiente:
+ Se cuenta cuantas aristas tiene el polígono a unir, asegurándose de que efectivamente sean aristas compartidas con un vecino y no bordes de la malla.
+ Se recorren todas las aristas del polígono tratando de mantener el invariante de que ninguna arista compartida de polígono vecino sea la arista representante del vecino, si esta condición no se cumple, entonces se actualiza la arista representante en la estructura _union find_ con otra del mismo polígono recorriendo su borde. Adicionalmente, se reemplaza el índice de salida en el arreglo de salida $P$ de la etapa anterior.
+ Se delega a la política de fusión particular la decisión de elegir a qué vecino se une el polígono, y si es que esta fusión tiene éxito o no.
+ Si la fusión tiene éxito, se invalida el índice del polígono fusionado en $P$, y se actualiza la arista representante de todas las aristas que forman el nuevo polígono fusionado para que apunten a una arista válida en la estructura _union find_.
+ Una vez terminado el proceso, se eliminan los índices invalidados en $P$.

Es importante destacar que el invariante del paso 2 es esencial para mantener coherencia topológica en la malla, puesto que, de no cumplirse, habrá aristas inválidas en la salida que no realizan un bucle completo a lo largo del borde de un polígono si se recorren con `next`.

Esta etapa se puede describir con el siguiente pseudocódigo:
#pagebreak()
#table(columns: 100%,)[Paso 5: Postprocesado][Entrada: Malla mutada $M'$, Conjunto de salidas $P$, Estrategia de unión $S$, Política de unión $J$][Salida: Malla final $M'$ y arreglo de polígonos de salida $P$ ]

#figure(
    caption: [Algoritmo de fusión de polígonos],
    [#box(
        fill: rgb("#d3d3d3"),
        inset: 8pt,
        radius: 4pt,
```
U ← Union-Find de aristas con sus representantes de polígono
for cada índice de salida pᵢ ∈ P do
  if S escoge a pᵢ then
    Eᵢ ← Aristas de vecinos de pᵢ, inicialmente vacío
    Nᵢ ← Aristas representantes de los vecinos en Eᵢ
    f ← Arista representante de pᵢ
    h ← f
    do while h != f
      if twin(h) ∉ borde de M' then
        Eᵢ ← Eᵢ ∪ {{Aristas compartidas por pᵢ y twin(h)}}
        rᵢ ← Representante del vecino a través de h
        oᵢ ← Copia de rᵢ
        if rᵢ = twin(h) then
          rᵢ ← M'.next(rᵢ) u otra arista
        end if
        if rᵢ != oᵢ then
          Actualizar U con el nuevo representante rᵢ 
          P.replace(oᵢ, rᵢ)
        end if
        Nᵢ ← Nᵢ ∪ {rᵢ}
      end if
      h ← M'.next(h)
    end while
    rᵤ ← J.fusionar(M', pᵢ, Nᵢ, Eᵢ)
    if rᵤ es un representante válido then
      i ← índice inválido de la malla, actualmente -1
      P.replace(pᵢ, i)
      Actualizar U con el representante rᵤ para sus aristas
    end if
  end if
end for
return M', P
```
)
])


Al momento de realizar la fusión en la línea 24 se muta nuevamente la malla y es el momento en que se utiliza la clase `ConnectivityBackupT` interna a la malla particular que permite deshacer una unión de polígonos si la política no la determina apta. Por ejemplo, si `MaximizeConvexityMergingPolicy` determina que el polígono final es no convexo, utiliza la información de `ConnectivityBackupT` para reescribir los atributos `next` y `prev` de cada _half edge_ involucrado para que vuelvan a su estado original.

== Reescritura de Polylla
El algoritmo Polylla se movió a la clase `PolyllaRefiner` la cual extiende a `MeshRefiner` y puede ser usada en `PolygonalMesh` al igual que `DelaunayCavityRefiner`.

La lógica del algoritmo es exactamente la misma, solo se hicieron cambios 'estéticos' como renombrado de métodos, variables y uso de _alias_ en lugar de tipos primitivos cuando se trabaja con índices que representan cosas distintas.

La gran diferencia que tiene esta implementación, es que recibe el tipo de malla como parámetro _template_, desacoplando levemente el refinador de detalles de la malla. Sin embargo, esta separación no puede hacerse por completo, ya que prácticamente todas las operaciones de Polylla dependen de la malla, pero esto queda encapsulado en una tercera clase, la clase `MeshHelper` (distinto _namespace_ que la clase `MeshHelper` del otro refinador), la cual tiene una especialización para _half edges_ con el código original adaptado.

]

#capitulo(title: "Resultados")[
El código se probó con el compilador _g++_ provisto por el entorno _mingw-64_ y también por el compilador _clang_ provisto por _Visual Studio_, ambos en Windows 11. Los resultados mostrados son aquellos producidos por el código compilado con _g++_ en una máquina con las siguientes características relevantes:
- Sistema Operativo: Windows 11 25H2
- CPU: Intel Core i5-10400 @ 2.90GHz, 6 _Cores_, 12 _Threads_
- RAM: 16 GB DDR4 a 2666 MT/s
- Almacenamiento: SSD ADATA SU630 500GB

En este capítulo se incluyen los resultados con una configuración de parámetros que produjo buenos valores experimentales:
- Criterio de refinado: `NullRefinementCriterion`
- Comparador de triángulos: `EdgeLengthComparator` por arista más pequeña en orden ascendente.
- Estrategia de unión: `MergeTriangles`
- Política de unión: `EdgeLengthBasedMergingPolicy` según la arista más larga.

Las mallas utilizadas se generaron utilizando los scripts `10000x10000RandomPoints.py` y `datagenerator.sh` presentes en el repositorio de Polylla-Mesh-DCEL@RepoPolylla, el cual genera vértices en un cuadrado de 10000 por 10000 y luego hace que Triangle@TriangleCodigo genere una triangulación de Delaunay a partir de ellos. Se generaron 5 mallas de cada tamaño con semillas: 139, 68, 70, 14 y 43. Luego, de forma paralela se ejecuto una instancia del programa con cada semilla para cada número de vértices, considerando que el algoritmo como tal es completamente secuencial y que el procesador de la máquina utilizada posee 6 núcleos, cada ejecución no debería afectar a ninguna otra.

Las tablas siguientes muestran el promedio de estas 5 mallas por cada tamaño para distintas métricas:

// RELLENAR!
#figure(
    caption: [Tabla comparativa de cantidad de polígonos],
    table(
        columns: (auto, auto, auto, auto),
        [Cantidad de vertices],[Malla original],[Refinador de cavidades],[Polylla],
        [10],[10],[3,2],[3,6],
        [$10^2$],[173,2],[51,6],[35,8],
        [$10^3$],[1920,4],[585,8],[319,4],
        [$10^4$],[19748],[6020,6],[3228],
        [$10^5$],[199194,6],[60583,6],[32280,8],
        [$10^6$],[1997479],[607874,6],[322388,2],
    )
)

#figure(
    caption: [Tabla comparativa de tiempo de ejecución total en milisegundos],
    table(
        columns: (auto, auto, auto, auto),
        [Cantidad de vertices],[Polylla Original],[Refinador de cavidades],[Polylla nuevo],
        [10],[0.02226],[0.03668],[10],
        [$10^2$],[0.08548],[0.27742],[10],
        [$10^3$],[0.70592],[4.39034],[10],
        [$10^4$],[6.62932],[82.1314],[10],
        [$10^5$],[89.7205],[3273.302],[10],
        [$10^6$],[983.45302],[734807],[10],
    )
)

#figure(
    caption: [Tabla comparativa de uso de memoria total en bytes],
    table(
        columns: (auto, auto, auto, auto),
        [Cantidad de vertices],[Polylla Original],[Refinador de cavidades],[Polylla nuevo],
        [10],[2395],[4050],[10],
        [$10^2$],[30870],[61419],[10],
        [$10^3$],[325164],[594373],[10],
        [$10^4$],[3294688],[5634252],[10],
        [$10^5$],[33061784],[66042541],[10],
        [$10^6$],[331880341],[610940823],[10],
    )
)

#figure(
    caption: [Tabla comparativa de porcentaje de convexidad],
    table(
        columns: (auto, auto, auto,),
        [Cantidad de vertices],[Polylla Original],[Refinador de cavidades],
        [10],[61,1%],[75%],
        [$10^2$],[41,3%],[70,5%],
        [$10^3$],[39,69%],[72,8%],
        [$10^4$],[39,44%],[72,4%],
        [$10^5$],[39,44%],[72,8%],
        [$10^6$],[39,42%],[72,8%],
    )
)

#figure(
    caption: [Tabla comparativa de ángulo mínimo y máximo en grados],
    table(
        columns: (auto, auto, auto,auto, auto),
        table.cell(stroke: none)[],table.cell(colspan:2)[Ángulos Polylla Original],table.cell(colspan:2)[Ángulos Refinador de cavidades],
        [Cantidad de vertices],[Mínimo],[Máximo],[Mínimo],[Máximo],[10],[43,68],[206,97],[35,25],[207,96],
        [$10^2$],[21,11],[278,76],[11,70],[290,46],
        [$10^3$],[14,69],[290,22],[6,53],[305,70],
        [$10^4$],[6,16],[303,04],[1,66],[335,42],
        [$10^5$],[< 0,01],[311,10],[0,30],[340,92],
        [$10^6$],[< 0,01],[330,59],[0,26],[350,07]
    )
)

Estos datos se obtuvieron a partir de múltiples ejecuciones de cada programa con la opción para escribir datos a formato `.json`, junto con el _script_ `count_edges.py` en el repositorio del proyecto disponible en #link("https://github.com/Tchy258/Delaunay-cavity").

A continuación se presentan múltiples gráficos mostrando la distribución promedio de cantidad de polígonos según su cantidad de aristas en las mismas ejecuciones anteriores:
#pagebreak()
#set page(flipped: true)
#figure(
    [#image("imagenes/concave_convex_10.svg") ],
    caption: "Distribución promedio de polígonos según cantidad de aristas con 10 vértices"
)
#figure(
    [#image("imagenes/concave_convex_100.svg") ],
    caption: "Distribución promedio de polígonos según cantidad de aristas con 100 vértices"
)
#figure(
    [#image("imagenes/concave_convex_1000.svg") ],
    caption: "Distribución promedio de polígonos según cantidad de aristas con 1000 vértices"
)
#figure(
    [#image("imagenes/concave_convex_10000.svg") ],
    caption: "Distribución promedio de polígonos según cantidad de aristas con 10000 vértices"
)
#figure(
    [#image("imagenes/concave_convex_100000.svg") ],
    caption: "Distribución promedio de polígonos según cantidad de aristas con 100000 vértices"
)
#figure(
    [#image("imagenes/concave_convex_1000000.svg") ],
    caption: "Distribución promedio de polígonos según cantidad de aristas con 1000000 de vértices"
)
#set page(flipped: false)
//Hablar de uso en VEM

]

#capitulo(title: "Conclusión")[
    #lorem(100)
    #lorem(100)
    
    #lorem(100)
]

#show: end-doc

#apendice(title: "PlantUML y Clang-UML", label: label("PUMLSyn"))[
    El diagrama de clases completo del @Diag mostrado parcialmente a lo largo del @cap3 fue generado utilizando _Clang-UML_, un programa escrito en C++ que permite generar diagramas de proyectos escritos en C++, disponible en:\ 
    #link("https://github.com/bkryza/clang-uml").
     
    La salida de _Clang-UML_, en esta ocasión, es un archivo de texto en _PlantUML_, un lenguaje de marcado para declarar diagramas de clases: \
    #link("https://plantuml.com/es/")

    El significado de cada uno de los símbolos se puede ver en detalle en el siguiente enlace:\ 
    #link("https://plantuml.com/es/class-diagram")

    A modo de resumen, los íconos y distintos formatos de texto tienen el siguiente significado:
    #figure(
        caption: [Iconografía de PlantUML],
        table(
        columns: (33%,33%,33%),
        align: auto,
        table.header[*Icono para atributo*][*Icono para método*][*Visbilidad*],
        [#image("imagenes/private-field.png")], [#image("imagenes/private-field.png")], [`private`],
        [#image("imagenes/protected-field.png")],[#image("imagenes/protected-method.png")], [`protected`],
        [#image("imagenes/public-field.png")], [#image("imagenes/public-method.png")], [`public`],
    )
    )
    
    Los atributos o métodos #underline("subrayados") son estáticos, mientras que los que están escritos en _cursiva_, son abstractos.

]

#apendice(title: "Diagrama completo de clases", label: label("Diag"))[
    En el siguiente enlace se encuentra un diagrama de clases completo de la solución en formato _svg_ para ser visualizado en un computador con el nivel de ampliación que se desee: #link("https://github.com/Tchy258/Delaunay-cavity/blob/main/diagrams/delaunay_cavity.svg")

    Dado su enorme tamaño no es adecuado para mostrarse completo en el informe.
]