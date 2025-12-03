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

=== Malla poligonal
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

=== Polígono simple y no simple
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
Por otro lado, el algoritmo Polylla, busca generar una malla poligonal a partir de una triangulación de Delaunay, usando lo que denomina como _Terminal-edge regions_ o regiones de arista terminal, definidas según el _longest edge propagation path_ (camino de propagación de arista más larga o _Lepp_ @Lepp) de los triángulos, las cuales utiliza para generar una partición de la triangulación que se asemeja a un diagrama de Voronoi @Voronoi.

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

#capitulo(title: "Problema")[
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

Para reescribir Polylla-Mesh-DCEL brindándole más modularidad se propone un diseño basado en clases altamente genéricas utilizando tipos _template_ con sus _concepts_ asociados (vease @TemplateConceptDef).

La clase principal de este diseño es la clase 'PolygonalMesh', la cual hace uso extensivo del patrón de diseño _Strategy_@gamma1994strategy delegando las funciones de leer y escribir archivos geométricos, contener una malla y refinar la malla a clases dedicadas, siendo el tipo de la malla un tipo _template_ restringindo por un _concept_ utilizado como parámetro por todas ellas. Esta clase se muestra en la @UMLPMesh

#figure(
    caption: [Representación UML de la clase `PolygonalMesh`],
    image("imagenes/polygonalMeshUML.png")
) <UMLPMesh>

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

]

#capitulo(title: "Conclusión")[
    #lorem(100)
    #lorem(100)
    
    #lorem(100)
]

#show: end-doc

#apendice(title: "Diagrama completo de clases", label: label("Diag"))[
    En el siguiente enlace se encuentra un diagrama de clases completo de la solución en formato _svg_ para ser visualizado en un computador con el nivel de ampliación que se desee: #link("https://github.com/Tchy258/Delaunay-cavity/blob/main/diagrams/delaunay_cavity.svg")
]