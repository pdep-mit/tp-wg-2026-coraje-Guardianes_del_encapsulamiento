import equipos.*
import Juego.*
import Personajes.*
object turnManager{
 
   var turno = 1
  
  method inicioDeTurno(equipo){
      
    seleccionador.cambioDeHuesped(equipo.integrantesVivos(equipo.integrantes()).get(0)) // se cambia el seleccionador al primer integrante vivo del siguiente equipo
    equipo.turnoActivo(true) // se activa el turno del equipo
    equipo.integrantesVivos(equipo.integrantes()).forEach({jugador => jugador.puedeMover(true)}) 
    equipo.integrantesVivos(equipo.integrantes()).forEach({jugador => jugador.puedeAtacar(true)}) // se activa la capacidad de moverse y atacar de los integrantes vivos
  }

  method finDeTurno(equipo)
  { equipo.integrantes().forEach({jugador => jugador.puedeMover(false)}) 
    equipo.integrantes().forEach({jugador => jugador.puedeAtacar(false)}) // se cancela la capacidad de moverse y de atacar de cada integrante
    equipo.turnoActivo(false)}
    
  method pasoDeTurno() 
  {
    
   self.finDeTurno(self.turnoDe()) // se termina el turno del equipo activo
   self.inicioDeTurno(managerDeEquipos.recorrerEquipos()) // empieza el turno del siguiente equipo

   turno += 1
  }
  method turnoDe()
    {
     return managerDeEquipos.equipos().find({equipo => equipo.turnoActivo() }) // se busca en la lista de equipos el equipo que está activo en el turno

    }



}
