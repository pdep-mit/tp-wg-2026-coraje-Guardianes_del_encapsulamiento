import auxiliares.*
import seleccionador.*

class Equipo {
  var property integrantes = []
  var property indice = 0 
  var property turnoActivo = false 
  const property nombre

  method sufijoImagen() = nombre
  
  method iniciarTurno(){
    self.integrantesVivos(integrantes).forEach({jugador => jugador.iniciarTurno()}) 
    const primero = self.integrantesVivos(integrantes).get(0)
    seleccionador.cambioDeHuesped(primero)
    turnoActivo = true // se activa el turno del equipo
  }

  method finalizarTurno(){
    integrantes.forEach({jugador => jugador.finalizarTurno()}) // se cancela la capacidad de moverse y de atacar de cada integrante
    turnoActivo = false}

  

  method agregarPersonajeaEquipo (persona) { // agrega un personaje a un equipo
   integrantes.add(persona)
  }

  method integrantesVivos(equipo) {  
    return equipo.filter({guacho => guacho.vivo()}) // se filtra los integrantes vivos del equipo
  }

  method estaEliminado() {
    return self.integrantesVivos(integrantes).isEmpty()
  }

  method reiniciar() {
    integrantes = []
    indice = 0
    turnoActivo = false
  }

  method recorrerIntegrantes(equipo)  {  // recorre la lista de integrantes vivos del equipo dando la vuelta al primer integrante cuando ya no hay más
    const vivos = self.integrantesVivos(equipo) // tomamos solo los integrantes activos 

   return auxiliar.siguienteDeLaLista(vivos,self)
}}




object managerDeEquipos {
  var property equipos = []
  var property indice = 0
  method agregarEquipo (equipoNuevo) { // agrega un equipo
    equipos.add(equipoNuevo)
}
  method recorrerEquipos (){ // recorre la lista de equipos y vuelve al primer equipo cuando no hay más
   return auxiliar.siguienteDeLaLista(equipos,self)
}

  method reiniciar() {
    equipos.forEach({equipo => equipo.reiniciar()})
    indice = 0
  }
}

 const equipoAzul = new Equipo(nombre = "Azul") 
  const equipoRojo = new Equipo(nombre = "Rojo")  // creamos los equipos
