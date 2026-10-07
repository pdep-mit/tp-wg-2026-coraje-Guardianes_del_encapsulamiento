import auxiliares.*

class Equipo {
  var property integrantes = []
  var property indice = 0 
  var property turnoActivo = false 
  
  method agregarPersonajeaEquipo (persona) { // agrega un personaje a un equipo
   integrantes.add(persona)
  }

  method integrantesVivos(equipo) {  
    return equipo.filter({guacho => guacho.vivo()}) // se filtra los integrantes vivos del equipo
  }

  method recorrerIntegrantes(equipo)  {  // recorre la lista de integrantes vivos del equipo dando la vuelta al primer integrante cuando ya no hay más
    const vivos = self.integrantesVivos(equipo) // tomamos solo los integrantes activos 

   return auxiliar.recorrerLista(vivos,self)
}}


object managerDeEquipos {
  var property equipos = []
  var property indice = 0
  method agregarEquipo (equipoNuevo) { // agrega un equipo
    equipos.add(equipoNuevo)
}
  method recorrerEquipos (){ // recorre la lista de equipos y vuelve al primer equipo cuando no hay más
   return auxiliar.recorrerLista(equipos,self)
}

}