import ManagerDeTurnos.*

import juego.*
import equipos.*
import auxiliares.*
import seleccionador.*
class Personaje { // clase base de personajes
 
  var property position 
  const property nombre
  var property puedeMover = false
  var property puedeAtacar = false
  var property equipo
  var property vida 
  const property vidaMaxima
  var property ataqueBase
  var property ataque = ataqueBase
  var property alcanceBase
  var property alcance = alcanceBase
  var property cooldownHabilidadClase = 0
  var property cooldownHabilidadPersonaje = 0
  var property vivo = true
  var property defensaBase 
  var property defensa = 1
  const property solido = true
  const property recolectable = false
  
  var property buffosActivos = []

  var property inventario = []
  var property indice = 0
  var property objetoEquipado = null

  method inicializarEstadisticas (){
    ataque =  ataqueBase
    defensa = defensaBase
    alcance = alcanceBase
    cooldownHabilidadClase = 0.max(cooldownHabilidadClase-1)
    cooldownHabilidadPersonaje = 0.max(cooldownHabilidadPersonaje-1)
  }

  method iniciarTurno (){
    self.inicializarEstadisticas()
    puedeMover = true
    puedeAtacar = true
  }

  method curarse(cantidad) {
    vida = vidaMaxima.min(vida + cantidad)
  }


  method objetivoElegible ()
  {
    return self.vivo() // despues puede que haya más condiciones
  }

  method mover(nuevaPosicion) {
  if(puedeMover and limitesTablero.contiene(nuevaPosicion) and
    not game.getObjectsIn(nuevaPosicion).any({objeto => objeto.solido()})){   // comprueba que no haya nada solido en el lugar al que se quiere mover (otro jugador o paredes)
    position = nuevaPosicion
    puedeMover = false
    seleccionador.cambiarCasillasDisponibles()  } // gasta el movimiento del turno
  }
  
  method atacar(objetivo){ 
   if (puedeAtacar and equipo != objetivo.equipo() ){ // comprueba si el personaje puede atacar y si el objetivo es de un equipo distinto
    objetivo.recibirDanio(ataque)
    puedeAtacar = false
    puedeMover = false
    seleccionador.quitarCasillasDisponibles()   // gasta el ataque del turno
   }}
  
  
   method recibirDanio (danio){ // reduce la vida en una cantidad de daño y en caso de reducir la vida  
     vida -= danio/defensa
     game.say(self,"vida:" + self.vida())
     if (vida <= 0){

        self.muerte()
     }}

  method muerte (){ 
    game.say(self,  "ha muerto")
    game.removeVisual(self)
    vivo = false
    
  }

  method buffarse(mejora,buffo){
    mejora.apply(self,buffo)
  }
 
 

  
  method agregarItemAlInventario(item){
     inventario.add(item)
     game.say(self,"consegui un:" + item.nombre())
     item.duenio(self)
  }

  method recorrerInventario() {return auxiliar.siguienteDeLaLista(inventario,self)}
  

  method recolectarAlgo(recompensa)  { self.agregarItemAlInventario(recompensa.generarRecompensa())}
  
  method equiparObjeto() 
   {objetoEquipado = inventario.get(indice)
     game.say(self,"me equipe con:" + objetoEquipado.nombre())}
  

  method usarObjeto() {
      if (objetoEquipado != null) {
          objetoEquipado.usarItem()
      } else {
          game.say(self, "¡No tengo nada equipado!")
      }
  }

  method gastarItem(){
    inventario.remove(objetoEquipado)
    objetoEquipado = null
    indice = 0
  }

  method curar(cantidad) { vida += cantidad }

  method image(){
    return nombre + equipo.sufijoImagen() + ".png"
  }

}



 

class Soldado inherits Personaje (){

  method habilidadClase(){
    if(puedeMover){
    const buffAlcance = {personaje,buffo => personaje.alcance(personaje.alcance() + buffo)}
    self.buffarse(buffAlcance,2)
    cooldownHabilidadClase = 2}
  }
}
class Tanque inherits Personaje (){

   method habilidadClase(){
    const buffDefensa = {personaje, buffo => personaje.defensa(personaje.defensa() + buffo)}
    self.buffarse(buffDefensa,1)
    cooldownHabilidadClase = 2
   }
}

class Sniper inherits Personaje (){

   method habilidadClase(){
     if (puedeMover and puedeAtacar) {
      const buffAtaque = {personaje, buffo => personaje.ataque(personaje.ataque() + buffo) }
      self.buffarse(buffAtaque,10)
      puedeMover = false
     }
   }
}
class Medico inherits Personaje (){

   method habilidadClase(){
     if(self.hayUnCompaniero()) {
      const companiero = game.getObjectsIn(seleccionador.position()).find({objeto => objeto.vivo()})
      companiero.curarse(35)
      cooldownHabilidadClase = 2
     }
   }
   method hayUnCompaniero(){
       return game.getObjectsIn(seleccionador.position()).any({companiero => companiero.equipo() == equipo and companiero != self})
   }
}






class HombreCalabaza inherits Tanque (nombre = "HombreCalabaza",vida = 140, vidaMaxima = 140, ataqueBase = 20, alcanceBase = 2, defensaBase = 1) { // clase de personaje, faltan agregar habilidades y cosas que lo diferencien

 method habilidadPersonaje(){
  const apuntado = seleccionador.seleccionarObjetivo()
  if((apuntado.position().x()  -position.x()).abs() + (apuntado.position().y() - position.y()).abs()  <= 1){
    apuntado.recibirDanio(ataque*3)
    puedeAtacar = false
  }
 }


}

class HombreZapallo inherits Tanque (nombre = "HombreZapallo",vida = 160, vidaMaxima = 160, ataqueBase = 15, alcanceBase = 2, defensaBase = 1 ){

  method habilidadPersonaje(){

  }
}

 
class Granjero inherits Soldado (nombre = "Granjero",vida = 100, vidaMaxima = 100, ataqueBase = 25, alcanceBase = 3,defensaBase = 1) {
  var usoHabilidad = 2

 method habilidadPersonaje(){
   const objetivo = seleccionador.seleccionarObjetivo()
   objetivo.recibirDanio(ataque-10)
   puedeAtacar = false
   usoHabilidad -= 1
   if (usoHabilidad < 1){cooldownHabilidadPersonaje = 2  usoHabilidad = 2}
 }
}

class EspantaPajaros inherits Soldado (nombre = "EspantaPajaros",vida = 110, vidaMaxima = 110, ataqueBase = 25, alcanceBase = 3, defensaBase = 1){
 
 method habilidadPersonaje(){
   
 }

 

}

class LoboSniper inherits Sniper(nombre = "LoboSniper",vida = 80, vidaMaxima = 80, ataqueBase = 40, alcanceBase = 4,defensaBase = 1){
   
   method habilidadPersonaje(){



   }
}


class KillerBunny inherits Sniper(nombre = "KillerBunny",vida = 90, vidaMaxima = 90, ataqueBase = 35, alcanceBase = 4,defensaBase = 1)

{
  method habilidadPersonaje(){  }

}

class VacaMedico inherits Medico (nombre = "VacaMedico",vida = 100, vidaMaxima = 100, ataqueBase = 20, alcanceBase = 3,defensaBase = 1 ) {
  
  method habilidadPersonaje(){
   if(self.hayUnCompaniero()) {
   const companiero =  seleccionador.seleccionarObjetivo()
   companiero.buffarse(companiero.ataque(),15)
   cooldownHabilidadPersonaje = 2
   }
 }


}

class OvejaMedica inherits Medico(nombre = "OvejaMedica",vida = 100, vidaMaxima = 100, ataqueBase = 15, alcanceBase = 4, defensaBase = 1) {

   method habilidadPersonaje(){}

  
}