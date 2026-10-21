import ruedaSeleccionadora.*
import juego.*
import creadorDePersonajes.*
import equipos.*
import partida.*
import auxiliares.*
import elementosVisuales.*
object menu {
var iteracionesMenu = 0
const ruedasSeleccionadoras = [rueda1,rueda2,rueda3,rueda4]
var property indice = 0
var ruedaActiva = rueda1

var elegidos = []
var contadorElegidos = 0



method iniciar(equipo){

const cartelExplicativo = new Cartel(text = "Elige los integrantes de tu equipo",position = game.center().up(3),textColor ="FFFFFF")
const cartelDeEquipo = new Cartel(text = "Equipo " + equipo.nombre(),position = game.center().up(2),textColor = "FFFFFF")
game.addVisual(cartelExplicativo)
game.addVisual(cartelDeEquipo)
game.addVisual(fondoDelMenu)
//Faltan agregar carteles con la informacion de los personajes: nombre,clase, estadisticas y si se puede una explicacion de su habilidad

self.inicializar()

ruedasSeleccionadoras.forEach({rueda => rueda.inicializar()})

keyboard.up().onPressDo({ruedaActiva.moverArriba()})
keyboard.down().onPressDo({ruedaActiva.moverAbajo()})

keyboard.enter().onPressDo({if(contadorElegidos <= 3 and contadorElegidos >= 0){self.elegir()} else self.finalizar(equipo) })
keyboard.c().onPressDo({self.cancelar()})

}

method siguienteRueda(){
    
    ruedaActiva = auxiliar.siguienteDeLaLista(ruedasSeleccionadoras,self)
}

method anteriorRueda(){
    ruedaActiva = auxiliar.anteriorDeLaLista(ruedasSeleccionadoras,self)
}

method elegir(){
  elegidos.add(ruedaActiva.seleccionar())
  self.siguienteRueda()
  contadorElegidos += 1
}
method cancelar()
{ 
 if (contadorElegidos > 0){ 
  elegidos.remove(elegidos.last())
  self.anteriorRueda()
  contadorElegidos -= 1}
}

method inicializar(){
  elegidos = []
  contadorElegidos = 0
  ruedaActiva = rueda1
  
}

method finalizar(equipo){
   elegidos.forEach({personaje => equipo.integrantes().add(generadorDePersonajes.crearNuevoPersonaje(personaje, equipo))})
   if(iteracionesMenu < managerDeEquipos.equipos().size()-1){
   iteracionesMenu += 1
   game.clear()
   self.iniciar(equipoRojo)
   } else {game.clear()
           partida.iniciar()}
}
}







