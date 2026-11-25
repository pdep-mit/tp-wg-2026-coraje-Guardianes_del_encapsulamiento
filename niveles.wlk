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

const nivel1 = new Nivel(paredes = [game.at(6,5),game.at(6,4),game.at(6,3),game.at(6,0),game.at(6,9),game.at(6,10),game.at(6,11),game.at(6,14),game.at(6,15),game.at(18,5),game.at(18,4),game.at(18,2),game.at(17,2),game.at(18,9),game.at(18,10),game.at(18,11),game.at(18,12),game.at(17,12),game.at(16,12),game.at(16,2),game.at(15,2),game.at(15,12),game.at(7,3),game.at(10,3),game.at(7,11),game.at(10,2),game.at(10,1),game.at(10,0),game.at(10,12),game.at(10,13),game.at(10,14),game.at(18,3),game.at(10,11)],  
      spawnerDeCajas = [game.at(8,1),game.at(8,13),game.at(16,5),game.at(16,10),game.at(12,9),game.at(12,5)],  
      spawnerPersonajesAzul = [game.at(2,2),game.at(2,5),game.at(2,8),game.at(2,11)], 
      spawnerPersonajesRojo = [game.at(23,2),game.at(23,5),game.at(23,8),game.at(23,11)])

object generadorDeNiveles {
  
   method iniciar(nivel){
       
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