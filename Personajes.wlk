import ManagerDeTurnos.*

import juego.*
import equipos.*
import auxiliares.*
import seleccionador.*
import Items.*
class Personaje { // clase base de personajes
 
  var property position 
  const property nombre
  var property puedeMover = true
  var property puedeAtacar = true
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

  method finalizarTurno(){
    puedeAtacar = false
    puedeMover = false
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
    turnManager.verificarFinDeRonda()
  }

  method buffarse(mejora,buffo){
    mejora.apply(self,buffo)
  }
 
 

  
  method agregarItemAlInventario(item){
     inventario.add(item)
     game.say(self,"consegui un:" + item.nombre())
     item.duenio(self)
  }

  method recorrerInventario() { 
     auxiliar.siguienteDeLaLista(inventario,self)
     if(not inventario.isEmpty()){
     game.say(self,"Item: " + inventario.get(indice).nombre())}else{game.say(self,"Mi inventario está vacio")}      }
  

  method recolectarAlgo(recompensa)  { self.agregarItemAlInventario(recompensa.generarRecompensa())}
  
  method equiparObjeto() 
   {objetoEquipado = inventario.get(indice)
     game.say(self,"Me equipé con:" + objetoEquipado.nombre())}
  

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
    cooldownHabilidadClase = 2
    game.say(self,"Subi mi alcance en 2")}
  
  }
}
class Tanque inherits Personaje (){
    const buffDefensa = {personaje, buffo => personaje.defensa(personaje.defensa() + buffo)}

   method habilidadClase(){
  
    self.buffarse(buffDefensa,1)
    cooldownHabilidadClase = 2
    game.say(self,"Subi mi defensa en 1")
   }
}

class Sniper inherits Personaje (){

   const buffAtaque = {personaje, buffo => personaje.ataque(personaje.ataque() + buffo) }
   
   method habilidadClase(){
     if (puedeMover and puedeAtacar) {
      self.buffarse(buffAtaque,10)
      puedeMover = false
      game.say(self,"Subi mi ataque en 10")
     }
   }
}
class Medico inherits Personaje (){

   method habilidadClase(){
     if(self.hayUnCompaniero()) {
      const companiero = game.getObjectsIn(seleccionador.position()).find({objeto => objeto.vivo()})
      companiero.curarse(35)
      cooldownHabilidadClase = 2
      game.say(self,"Cure a mi compañero en 35")
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
    cooldownHabilidadPersonaje = 2

  }
 }


}

class HombreZapallo inherits Tanque (nombre = "HombreZapallo",vida = 160, vidaMaxima = 160, ataqueBase = 15, alcanceBase = 2, defensaBase = 1 ){
   const aliados = equipo.integrantesVivos()
   
  method habilidadPersonaje(){
       aliados.forEach({aliado =>  aliado.buffarse(buffDefensa,1)})
       cooldownHabilidadPersonaje = 4
       game.say(self,"Todos mis compañeros subieron 1 de defensa")
  }
}

 
class Granjero inherits Soldado (nombre = "Granjero",vida = 100, vidaMaxima = 100, ataqueBase = 25, alcanceBase = 3,defensaBase = 1) {
  
  var usoHabilidad = 2

 method habilidadPersonaje(){
   const objetivo = seleccionador.seleccionarObjetivo()
   objetivo.recibirDanio(ataque-10)
   puedeAtacar = false
   usoHabilidad -= 1
   if (usoHabilidad == 1){
   game.say(self,"Usé mi primer ataque, ¡Aún me queda uno más!")}
   else (usoHabilidad < 1){cooldownHabilidadPersonaje = 2  usoHabilidad = 2  seleccionador.quitarCasillasDisponibles()}
 }
}

class EspantaPajaros inherits Soldado (nombre = "EspantaPajaros",vida = 110, vidaMaxima = 110, ataqueBase = 25, alcanceBase = 3, defensaBase = 1){
 
  const granadaDeBolsillo = new Granada(nombre = "granadaDeBolsillo",danio = 20, area = 2,usabilidad = 1,calidad = 1)

 method habilidadPersonaje(){
     objetoEquipado = granadaDeBolsillo
     self.usarObjeto()
     cooldownHabilidadPersonaje = 3
     game.say(self,"Lancé mi confiable granada de bolsillo")
 }

 

}

class LoboSniper inherits Sniper(nombre = "LoboSniper",vida = 90, vidaMaxima = 90, ataqueBase = 35, alcanceBase = 4,defensaBase = 1){
   
   method habilidadPersonaje() {
    const objetivo = seleccionador.seleccionarObjetivo()
    if (puedeAtacar and objetivo != null and objetivo.equipo() != equipo) {
      objetivo.recibirDanio((ataque+10) * objetivo.defensa()  )
      puedeAtacar = false
      puedeMover = false
      seleccionador.quitarCasillasDisponibles()
      cooldownHabilidadPersonaje = 3
      game.say(self,"Acerté un disparo certero")
    }
  }
}


class KillerBunny inherits Sniper(nombre = "KillerBunny",vida = 80, vidaMaxima = 80, ataqueBase = 40, alcanceBase = 4,defensaBase = 1)

{
  method habilidadPersonaje(){ 
         const apuntado = seleccionador.seleccionarObjetivo()
  if((apuntado.position().x()  -position.x()).abs() + (apuntado.position().y() - position.y()).abs()  <= 1){
    apuntado.recibirDanio(vida*3)
    self.recibirDanio(vida)
    game.say(self,"Nos fuimo")
  }

   }

}

class VacaMedico inherits Medico (nombre = "VacaMedico",vida = 100, vidaMaxima = 100, ataqueBase = 20, alcanceBase = 3,defensaBase = 1 ) {
  
  method habilidadPersonaje(){
   if(self.hayUnCompaniero()) {
   const companiero =  seleccionador.seleccionarObjetivo()
   companiero.buffarse(companiero.ataque(),15)
   cooldownHabilidadPersonaje = 2
   game.say(self,"Subi el ataque de mi compañero en 15")
   }
 }


}

class OvejaMedica inherits Medico(nombre = "OvejaMedica",vida = 100, vidaMaxima = 100, ataqueBase = 15, alcanceBase = 4, defensaBase = 1) {

   method habilidadPersonaje(){
       if(self.hayUnCompaniero()) {
   const companiero =  seleccionador.seleccionarObjetivo()
   companiero.buffarse(companiero.alcance(),1)
   cooldownHabilidadPersonaje = 2
   game.say(self,"Subí el alcance de mi compañero en 1") }
   }

  
}