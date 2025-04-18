// Este archivo contiene los párrafos que se usan como bloque de ayuda a quien está escribiendo su informe de intro al trabajo de título.

#let guia(visible: true, body) = if visible [
    #set rect(width: 100%, stroke: black)
    #set par(justify: true, first-line-indent: 0pt)
    #block(breakable: false)[
      #stack(dir: ttb,
        rect(
          fill: black,
          radius: (top: 5pt, bottom: 0pt),
          text(
            fill: white,
            "Guía (deshabilitar antes de entregar)"
          )
        ),
        rect(
          fill: luma(230),
          radius: (top: 0pt, bottom: 5pt),
          body
        )
      )
    ]
  ] else []

#let guia_meta = [
Se debe quitar todas las guías (estas cajas grises) antes de entregar el documento.

Para ello, se debe cambiar el valor de la variable `mostrar_guias` a `false`.

Además, hay que reemplazar el diccionario de metadata que se entrega a la función `conf`.
Para ver los parámetros de este diccionario, ver el archivo `metadata.typ`.

Como aproximación, se espera que la propuesta sea de 5 a 10 páginas.

No es necesario poner texto antes de la introducción.]

#let guia_intro = [
Dar una introducción al contexto del tema.

Explicar, en términos generales, el problema abordado.

Motivar la necesidad, la importancia y/o el valor de tener una (mejor) solución al problema.

En el caso de la práctica extendida, incluir detalles de la organización, su quehacer, el equipo y el supervisor con los cuales se va a trabajar, la relevancia del problema a la organización, etc.

(1 a 2 páginas)]

#let guia_actual = [
Discutir las soluciones o recursos existentes relacionados con el problema. Justificar por qué es necesario un trabajo novedoso.

(1 a 2 páginas)]

#let guia_objetivos = [
Describir las _metas_ del trabajo. Hay que contestar acá: ¿_qué_ quieres lograr? (La sección que sigue contestará la pregunta: ¿_cómo_ lo vas a lograr?)

Ejemplos de metas: lograr que X sea (más) eficiente, usable, seguro, completo, preciso, barato, informativo, posible por primera vez, etc.

Ejemplos de _no_ metas: implementar algo en Javascript, aplicar modelo Y sobre los datos, etc. (Estas cosas van en la descripción de la *Solución propuesta*.)

Los objetivos deberían ser específicos, medibles, alcanzables y relevantes al problema (ver la clase 2). El plan de trabajo debería argumentar que sean acotados en tiempo (un semestre).

Al final del trabajo, debería ser factible saber si se ha logrado los objetivos enumerados acá, o saber cuán bien se han logrado, o no. Por ejemplo, si la meta es tener algo eficiente en términos de tiempo, debería haber una forma de evaluar o estudiar los tiempos. Acá tendrás que definir la forma general en que se podrá evaluar el trabajo.

(No hay que poner texto acá. Se puede empezar directamente con el objetivo general.)]

#let guia_objetivo_general = [
Un _resumen conciso_ (no más de un párrafo) de la meta principal del trabajo, es decir, qué quieres lograr con el trabajo (o qué significa \"éxito\" en el contexto del trabajo).

El objetivo debería ser específico, medible, alcanzable, relevante al problema, y acotado en tiempo.

(\"Titularse\" no es una repuesta válida. #emoji.face.sad)]

#let guia_objetivos_especificos = [
Una _lista_ de los hitos principales que se quieren lograr para (intentar) cumplir con el objetivo general. Divide el objetivo general en varios hitos que formarán las etapas del trabajo.
		
Cada objetivo debería ser específico, medible, alcanzable, relevante al problema, y acotado en tiempo.
		
No se debería escribir más de un párrafo por hito. 
		
Los objetivos específicos deberían \"sumar\" al objetivo general.
		
(Una lista de 3 a 7 párrafos)]

#let guia_evaluacion = [
Describe cómo vas a poder evaluar el trabajo en términos de cuán bien cumple con los objetivos planteados. Se pueden discutir los datos, las medidas, los usuarios, las técnicas, etc., utilizables para la evaluación.

(1 a 2 párrafos)]

#let guia_solucion = [
Una descripción general de la solución propuesta: los datos, las técnicas, las tecnologías, las herramientas, los lenguajes, los marcos, etc., que se usarán para intentar lograr los objetivos planteados. Aquí hay que contestar la pregunta: ¿_cómo_ vas a lograr los objetivos planteados? Aquí, sí, está muy bien hablar de Javascript, CNNs, Numpy, Django, índices invertidos, árboles wavelet, privacidad diferencial, PageRank, Diffie--Hellman, triangulaciones de Delaunay, CUDA, Postgres, etc.
    
(1 a 2 páginas)]

#let guia_plan = [
Aquí se puede dar una lista preliminar de los pasos que se van a seguir para desarrollar la solución propuesta. La lista debería contemplar la evaluación del trabajo y la escritura del informe final del trabajo de título (memoria o práctica extendida). Siendo un plan preliminar, su propósito es dar una mejor idea de la factibilidad del tema y el trabajo que implica, pero se pueden aplicar cambios al plan para el informe final de este curso.
    
(0.5 a 2 páginas)]