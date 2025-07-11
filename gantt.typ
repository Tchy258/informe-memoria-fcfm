#import "@preview/timeliney:0.3.0"

#timeliney.timeline(
  show-grid: true,
  {
    import timeliney: *
      
    headerline(group(([Semana], 15)))
    headerline(
      group(..range(15).map(n => str(n+1)))
    )
  
    
    taskgroup(title: [*Ajustes de código*], {
      task("Hacer refactor a polylla", (0, 3), style: (stroke: 2pt + gray))
      task("Integrar el código de cavidades", (0, 3), style: (stroke: 2pt + gray))
    })
    taskgroup(title: [*Pruebas de criterios*], {
      task("Probar criterios de selección", (3, 5), style: (stroke: 2pt + gray))
    })

    taskgroup(title: [*Comparación con polylla*], {
      task("Diseñar test comparativo", (5, 6), style: (stroke: 2pt + gray))
      task("Correr test comparativo", (5, 8), style: (stroke: 2pt + gray))
    })

    taskgroup(title: [*Comparación con otras apps*], {
      task("Elegir aplicaciones de mallas", (5, 8), style: (stroke: 2pt + gray))
      task("Diseñar test comparativo", (7, 8), style: (stroke: 2pt + gray))
      task("Correr test comparativo", (8, 11), style: (stroke: 2pt + gray))
    })
    taskgroup(title: [*Escribir la memoria*], {
      task("Desarrollo del documento", (5, 15), style: (stroke: 2pt + gray))
      task("Registro de resultados", (5, 11), style: (stroke: 2pt + gray))
      task("Análisis de resultados", (11, 15), style: (stroke: 2pt + gray))
    })
  }
)