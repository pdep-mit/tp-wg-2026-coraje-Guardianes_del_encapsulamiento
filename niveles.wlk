import obstaculos.*
import cajas.*
import Personajes.*
import equipos.*


class Nivel {
  const property paredes
  const property spawnerDeCajas 
  const property spawnerPersonajesAzul 
  const property spawnerPersonajesRojo 
}

const nivel1 = new Nivel(paredes = [game.at(4,5),game.at(4,3),game.at(4,6),game.at(4,7)], 
                         spawnerDeCajas = [game.at(1,1),game.at(10,10),game.at(5,5)], 
                         spawnerPersonajesAzul = [game.at(2,2),game.at(2,4),game.at(2,6),game.at(2,8)], 
                         spawnerPersonajesRojo = [game.at(12,10),game.at(12,8),game.at(12,6),game.at(12,4)])

object generadorDeNiveles {
  
   method iniciar(nivel,equipos){
       
   self.generarParedes(nivel.paredes())
   self.generarSpawnerCajas(nivel.spawnerDeCajas())
   self.generarPersonajes(nivel.spawnerPersonajesAzul(),nivel.spawnerPersonajesRojo(),equipoAzul.integrantes(),equipoRojo.integrantes())  
   }

   method generarParedes(paredes){
      paredes.forEach({casilla => const pared = new Pared(position = casilla) game.addVisual(pared) })

   }
    method generarSpawnerCajas(spawnersCajas){
      spawnersCajas.forEach({casilla => generadorDeCajas.posicionesPosibles().add(casilla)  })
   }

 method generarPersonajes(spawnersAzul,spawnersRojo,equipo1,equipo2){
      const rango = (0..3)
      rango.forEach({indice => equipo1.get(indice).mover(spawnersAzul.get(indice))})
      rango.forEach({indice => equipo2.get(indice).mover(spawnersRojo.get(indice))})
      equipo1.forEach({integrante => game.addVisual(integrante)})
      equipo2.forEach({integrante => game.addVisual(integrante)})
     
   }

}