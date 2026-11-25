import equipos.*
import juego.*
import Personajes.*
import seleccionador.*
import cajas.*
import menu.*
object turnManager{
 
   var turno = 1
   var rondaFinalizada = false
  
  method inicioDeTurno(equipo){
    equipo.integrantesVivos(equipo.integrantes()).forEach({jugador => jugador.iniciarTurno()}) 
    seleccionador.cambioDeHuesped(equipo.integrantesVivos(equipo.integrantes()).get(0)) // se cambia el seleccionador al primer integrante vivo del siguiente equipo
    equipo.turnoActivo(true) // se activa el turno del equipo
   
  }

  method finDeTurno(equipo)
  { equipo.integrantes().forEach({jugador => jugador.puedeMover(false)}) 
    equipo.integrantes().forEach({jugador => jugador.puedeAtacar(false)}) // se cancela la capacidad de moverse y de atacar de cada integrante
    equipo.turnoActivo(false)}
    
  method pasoDeTurno() 
  {
   if (not rondaFinalizada) {
   self.finDeTurno(self.turnoDe()) // se termina el turno del equipo activo
   self.inicioDeTurno(managerDeEquipos.recorrerEquipos()) // empieza el turno del siguiente equipo

   turno += 1
   game.say(seleccionador,"turno:" + turno)
   if (turno % 2 == 0) {
     generadorDeCajas.generarCaja() //generamos una caja aleatoria cada 4 turnos
   }
   }
  }
  method turnoDe()
    {
     return managerDeEquipos.equipos().find({equipo => equipo.turnoActivo() }) // se busca en la lista de equipos el equipo que está activo en el turno
    }

  method verificarFinDeRonda() {
    if (not rondaFinalizada and managerDeEquipos.equipos().size() > 1) {
      const equipoEliminado = managerDeEquipos.equipos().find({equipo => equipo.estaEliminado()})
      if (equipoEliminado != null) {
        const equipoGanador = managerDeEquipos.equipos().find({equipo => not equipo.estaEliminado()})
        if (equipoGanador != null) {
          self.finalizarRonda(equipoEliminado, equipoGanador)
        }
      }
    }
  }

  method finalizarRonda(equipoEliminado, equipoGanador) {
    rondaFinalizada = true
    game.say(seleccionador,
      "Equipo " + equipoEliminado.nombre() + " Eliminado, Equipo Ganador: " + equipoGanador.nombre())
    game.schedule(3000, {self.reiniciarPartida()})
  }

  method reiniciarPartida() {
    turno = 1
    managerDeEquipos.reiniciar()
    menu.reiniciar()
    rondaFinalizada = false
  }



}
