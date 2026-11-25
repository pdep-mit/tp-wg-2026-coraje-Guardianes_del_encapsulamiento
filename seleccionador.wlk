import Personajes.*
import auxiliares.*

object seleccionador { 
  
  var property huesped = null
  const property solido = false
  var property position = null
  const property objetivoElegible = false
  const property recolectable = false
  var casillas = #{}
  const casillasDisponibles = []
 
 
  method mover(nuevaPosicion) { // mueve al seleccionador en una zona definida por un rombo con centro en el huesped
    if (limitesTablero.contiene(nuevaPosicion) and
      (nuevaPosicion.x()  -huesped.position().x()).abs() + (nuevaPosicion.y() - huesped.position().y()).abs()  <= huesped.alcance() and
      self.puedeSeleccionar(nuevaPosicion))
    { position = nuevaPosicion  }}
 
  method mostrarCasillasDisponibles(){
    casillas = self.casillasDisponibles()
    casillas.forEach({casilla => const casillaDisponible = new CasillasDisponible(position = casilla)  game.addVisual(casillaDisponible)  casillasDisponibles.add(casillaDisponible)})
  }
  method quitarCasillasDisponibles(){
     casillas.forEach({casilla => casillas.remove(casilla)})
     casillasDisponibles.forEach({casillaDisponible => game.removeVisual(casillaDisponible) casillasDisponibles.remove(casillaDisponible) })
  }

  method casillasDisponibles (){

        (-huesped.alcance()..huesped.alcance()).forEach({ coordenada_x => (-huesped.alcance()..huesped.alcance()).forEach({ coordenada_y =>
          const casilla = game.at(self.position().x() + coordenada_x, self.position().y() + coordenada_y)
          if (coordenada_x.abs() + coordenada_y.abs() <= huesped.alcance() and
            limitesTablero.contiene(casilla) and
            self.puedeSeleccionar(casilla)){ casillas.add(casilla)}
        })})
          return casillas}

//metodo para que el selecc. distinga entre casillas que puede seleccionar y casillas que no puede seleccionar (por ejemplo, si hay un enemigo en la casilla, no puede seleccionarla)
  method puedeSeleccionar(casilla) {
    return not game.getObjectsIn(casilla).any({objeto =>
      objeto.solido() and not objeto.objetivoElegible() and objeto != huesped
    })
  }

  method cambiarCasillasDisponibles(){
      self.quitarCasillasDisponibles()
      if(huesped.puedeAtacar()){
        self.mostrarCasillasDisponibles()
        game.removeVisual(self)
        game.addVisual(self)}
     
  }

  method cambioDeHuesped (nuevoHuesped){  // cambia al huesped del seleccionador por otro
  
     huesped = nuevoHuesped
     position = nuevoHuesped.position()
     self.cambiarCasillasDisponibles()
  }

  method accionContextual() // decide que accion tomar dependiendo de varios factores(por ahora solo si hay un enemigo o no)
  { if (self.hayUnObjetivo(position))  {self.atacarObjetivo()
  } else {self.moverHuesped() 
       if (self.hayUnRecolectable(position))  {self.seleccionarObjetoRecolectable()}} 
  }

  method moverHuesped() = self.huesped().mover(position) // mueve al huesped a la posicion del seleccionador
  

  method hayUnObjetivo(posicion)  {return game.getObjectsIn(posicion).any({objeto=>objeto.objetivoElegible() and objeto != huesped})} // busca un objetivo elegible en la posicion del seleccionador
  
  method hayUnRecolectable(posicion){return game.getObjectsIn(posicion).any({objeto=>objeto.recolectable()})}

  method seleccionarObjetoRecolectable(){self.huesped().recolectarAlgo(game.getObjectsIn(position).find({objeto => objeto.recolectable()}))}

  method atacarObjetivo(){
    const objetivo  = self.seleccionarObjetivo()
    if (objetivo != null and self.hayLineaDeAtaque(objetivo)) {
      huesped.atacar(objetivo)
    }
  }

  method seleccionarObjetivo (){ 
      const objetivo = game.getObjectsIn(self.position()).find({objeto => objeto.objetivoElegible() and objeto != huesped})
      if (objetivo != null){return objetivo} else
      return null}

  method hayLineaDeAtaque(objetivo) {
    const origen = huesped.position()
    const destino = objetivo.position()
    return (origen.x() == destino.x() and
      not self.hayParedEntre(origen.x(), origen.y(), destino.y(), true)) or
      (origen.y() == destino.y() and
      not self.hayParedEntre(origen.y(), origen.x(), destino.x(), false)) or
      (origen.x() != destino.x() and origen.y() != destino.y())
  }

  method hayParedEntre(coordenadaFija, inicio, fin, ejeVertical) {
    const desde = inicio.min(fin) + 1
    const hasta = inicio.max(fin) - 1
    if (ejeVertical) {
      return (desde..hasta).any({ coordenada =>
        self.hayParedEn(game.at(coordenadaFija, coordenada))
      })
    }
    return (desde..hasta).any({ coordenada =>
      self.hayParedEn(game.at(coordenada, coordenadaFija))
    })
  }

  method hayParedEn(casilla) {
    return game.getObjectsIn(casilla).any({objeto => objeto.solido() and not objeto.objetivoElegible()})
  }
       
  method activarHabilidadClase(){
     if(huesped.cooldownHabilidadClase() == 0){
      huesped.habilidadClase()
     }}

    method activarHabilidadPersonaje(){
     if(huesped.cooldownHabilidadPersonaje() == 0){
      huesped.habilidadPersonaje()
     }   

  }

  method image() = "Seleccionador.png"   
}

class CasillasDisponible{
var property position = null 
const property recolectable = false
const property objetivoElegible = false
const property solido = false

 method image() =  "Casilla_Disponible.png"
 
}