
object seleccionador { 
  
  var property huesped = null
  const property solido = false
  var property position = game.center()
  const property objetivoElegible = false
  const property recolectable = false

  method mover(nuevaPosicion) { // mueve al seleccionador en una zona definida por un rombo con centro en el huesped
    if ((nuevaPosicion.x()  -huesped.position().x()).abs() + (nuevaPosicion.y() - huesped.position().y()).abs()  <= huesped.alcance() ) 
    { position = nuevaPosicion  }}
 
  
  method cambioDeHuesped (nuevoHuesped){  // cambia al huesped del seleccionador por otro
     huesped = nuevoHuesped
     position = nuevoHuesped.position()
  }

  method accionContextual() // decide que accion tomar dependiendo de varios factores(por ahora solo si hay un enemigo o no)
  {if (self.hayUnObjetivo(position))  {self.seleccionarObjetivoDeAtaque()
  } else {self.moverHuesped() 
      if (self.hayUnRecolectable(position))  {self.seleccionarObjetoRecolectable()}} 
  }

  method moverHuesped() =  self.huesped().mover(position) // mueve al huesped a la posicion del seleccionador
  

  method hayUnObjetivo(posicion)  {return game.getObjectsIn(posicion).any({objeto=>objeto.objetivoElegible() })} // busca un objetivo elegible en la posicion del seleccionador
  
  method hayUnRecolectable(posicion){return game.getObjectsIn(posicion).any({objeto=>objeto.recolectable()})}

  method seleccionarObjetoRecolectable(){self.huesped().recolectarAlgo(game.getObjectsIn(position).find({objeto => objeto.recolectable()}))}

  method seleccionarObjetivoDeAtaque ()= self.huesped().atacar(game.getObjectsIn(self.position()).find({objeto => objeto.objetivoElegible()})) // manda al huesped a atacar al objetivo
  

  method image() = "Seleccionador.png"   
}