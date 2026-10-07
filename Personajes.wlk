
import Juego.*
import equipos.*
class Personaje { // clase base de personajes
 
  var property position 
  var property puedeMover = false
  var property puedeAtacar = false
  var property equipo
  var property vida 
  var property ataque
  var property alcance
  var property vivo = true
  const property solido = true

  

  method objetivoElegible ()
  {
    return self.vivo() // despues puede que haya más condiciones
  }

  method mover(nuevaPosicion) {
  if(puedeMover and not game.getObjectsIn(nuevaPosicion).any({objeto => objeto.solido()})){   // comprueba que no haya nada solido en el lugar al que se quiere mover (otro jugador o paredes)
    position = nuevaPosicion
    puedeMover = false } // gasta el movimiento del turno
  }
  
  method atacar(objetivo){ 
   if (puedeAtacar and equipo != objetivo.equipo() ){ // comprueba si el personaje puede atacar y si el objetivo es de un equipo distinto
    objetivo.recibirDanio(ataque)
    puedeAtacar = false // gasta el ataque del turno
   }}

  
   method recibirDanio (danio){ // reduce la vida en una cantidad de daño y en caso de reducir la vida  
     vida -= danio
     if (vida <= 0){
        self.muerte()
     }
  }

  method muerte (){ 
    game.removeVisual(self)
    vivo = false
  }

}

class HombreCalabaza inherits Personaje { // clase de personaje, faltan agregar habilidades y cosas que lo diferencien
 
 method image () { // decide la imagen del personaje dependiendo del equipo que es (probablemente haya que cambiarlo)
  if (equipo == "Azul"){
    return "Hombre_calabaza_Azul.png"
  } else return "Hombre_calabaza_Rojo.png"
 }
}





object seleccionador { 
  
  var property huesped = null
  const property solido = false
  var property position = game.center()
  const property objetivoElegible = false

  method mover(nuevaPosicion) { // mueve al seleccionador en una zona definida por un rombo con centro en el huesped
    if ((nuevaPosicion.x()  -huesped.position().x()).abs() + (nuevaPosicion.y() - huesped.position().y()).abs()  <= huesped.alcance() ) 
    { position = nuevaPosicion  }}
 
  
  method cambioDeHuesped (nuevoHuesped){  // cambia al huesped del seleccionador por otro
     huesped = nuevoHuesped
     position = nuevoHuesped.position()
  }

  method accionContextual() // decide que accion tomar dependiendo de varios factores(por ahora solo si hay un enemigo o no)
  {if (self.hayUnObjetivo(self.position()))  {self.seleccionarObjetivoDeAtaque()
  } else {self.moverHuesped()} 
  }

  method moverHuesped() =  self.huesped().mover(self.position()) // mueve al huesped a la posicion del seleccionador
  

  method hayUnObjetivo(posicion)  {return game.getObjectsIn(posicion).any({objeto=>objeto.objetivoElegible() })} // busca un objetivo elegible en la posicion del seleccionador
  

  method seleccionarObjetivoDeAtaque ()= self.huesped().atacar(game.getObjectsIn(self.position()).find({objeto => objeto.objetivoElegible()})) // manda al huesped a atacar al objetivo
  

  method image() = "Seleccionador.png"   
}

