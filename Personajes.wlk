
import juego.*
import equipos.*
import auxiliares.*
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
  const property recolectable = false

  var property inventario = []
  var property indice = 0
  var property objetoEquipado = null

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
     game.say(self,"vida:" + self.vida())
     if (vida <= 0){

        self.muerte()
     }}

  method muerte (){ 
    game.say(self,  "ha muerto")
    game.removeVisual(self)
    vivo = false
    
  }
  
  method agregarItemAlInventario(item){
     inventario.add(item)
     game.say(self,"consegui un:" + item)
     item.duenio(self)
  }

  method recorrerInventario() {return auxiliar.recorrerLista(inventario,self)}
  

  method recolectarAlgo(recompensa)  { self.agregarItemAlInventario(recompensa.generarRecompensa())}
  
  method equiparObjeto() 
   {objetoEquipado = inventario.get(indice)
     game.say(self,"me equipe con:" + objetoEquipado)}
  

  method usarItem() {
    if (objetoEquipado != null) {
        objetoEquipado.usarItem()
    } else {
        game.say(self, "No tengo nada equipado")
    }
  }

  method gastarItem(){
    inventario.remove(objetoEquipado)
    objetoEquipado = null
    indice = 0
  }

  method curar(cantidad) { vida += cantidad }
}

class HombreCalabaza inherits Personaje (vida = 150, ataque = 30, alcance = 3) { // clase de personaje, faltan agregar habilidades y cosas que lo diferencien
 

 method image () { // decide la imagen del personaje dependiendo del equipo que es (probablemente haya que cambiarlo)
  if (equipo == "Azul"){
    return "Hombre_calabaza_Azul.png"
  } else return "Hombre_calabaza_Rojo.png"
 }
}

class Granjero inherits Personaje (vida = 100, ataque = 25, alcance = 4) {

 method image () {
  if (equipo == "Azul"){
    return "Granjero_Azul.png"
  } else return "Granjero_Rojo.png"
 }


}

class EspantaPajaros inherits Personaje (vida = 80, ataque = 40, alcance = 6){
 method image () {
   if (equipo == "Azul"){
    return "espantaPajaros_Azul.png"
  } else return "espantaPajaros_rojo.png"
 }
}

class VacaMedico inherits Personaje (vida = 100, ataque = 20, alcance = 3 ) {
  
  method image( ){
   if (equipo == "Azul"){
    return "Vaca_Medico_Azul.png"
  } else return "Vaca_Medico_Rojo.png"
  }
}





