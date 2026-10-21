import Personajes.*
import equipos.*
import juego.*
import seleccionador.*
import ManagerDeTurnos.*
import Items.*
import cajas.*

object partida {

    method iniciar(){
       
    
       equipoAzul.integrantes().get(0).position(game.at(3,2))
       equipoAzul.integrantes().get(1).position(game.at(3,4))
       equipoAzul.integrantes().get(2).position(game.at(3,6))
       equipoAzul.integrantes().get(3).position(game.at(3,8))
       equipoRojo.integrantes().get(0).position(game.at(18,2))
       equipoRojo.integrantes().get(1).position(game.at(18,4))
       equipoRojo.integrantes().get(2).position(game.at(18,6))
       equipoRojo.integrantes().get(3).position(game.at(18,8))

      
       equipoAzul.integrantes().forEach({integrante => game.addVisual(integrante)})
       equipoRojo.integrantes().forEach({integrante => game.addVisual(integrante)})
      
       seleccionador.cambioDeHuesped(equipoAzul.integrantes().get(0))
       game.addVisual(seleccionador)
       turnManager.inicioDeTurno(equipoAzul)

       keyboard.left().onPressDo({seleccionador.mover(seleccionador.position().left(1))})
       keyboard.right().onPressDo({seleccionador.mover(seleccionador.position().right(1))})
       keyboard.up().onPressDo({seleccionador.mover(seleccionador.position().up(1))})
       keyboard.down().onPressDo({seleccionador.mover(seleccionador.position().down(1))}) // añadimos los imputs de movimiento del seleccionador

       keyboard.enter().onPressDo({seleccionador.accionContextual()}) // dependiendo el contexto decide que accion realizar

       keyboard.alt().onPressDo({seleccionador.cambioDeHuesped(turnManager.turnoDe().recorrerIntegrantes(turnManager.turnoDe().integrantes()))}) // cambio de huesped del seleccionador

       keyboard.i().onPressDo({seleccionador.huesped().recorrerInventario()})

       keyboard.o().onPressDo({seleccionador.huesped().equiparObjeto()})

       keyboard.u().onPressDo({seleccionador.huesped().usarObjeto()})

       keyboard.c().onPressDo({generadorDeCajas.generarCaja()})

       keyboard.num1().onPressDo({seleccionador.activarHabilidadClase()})

       keyboard.num2().onPressDo({seleccionador.activarHabilidadPersonaje()})

       keyboard.num0().onPressDo({turnManager.pasoDeTurno()}) // pasamos turno de un equipo a otro


    }
}




