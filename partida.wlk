import Personajes.*
import equipos.*
import juego.*
import seleccionador.*
import ManagerDeTurnos.*
import Items.*
import cajas.*
import obstaculos.*
import niveles.*
object partida {

    method iniciar(){
       
       seleccionador.cambioDeHuesped(equipoAzul.integrantes().get(0))
       console.println("gola")
       generadorDeNiveles.iniciar(nivel1,managerDeEquipos.equipos())
       console.println("gola")
       console.println("gola")
       turnManager.inicioDeTurno(equipoAzul)

      self.configurarTeclas()


    }
      
      
    method configurarTeclas (){

       keyboard.left().onPressDo({seleccionador.mover(seleccionador.position().left(1))})
       keyboard.right().onPressDo({seleccionador.mover(seleccionador.position().right(1))})
       keyboard.up().onPressDo({seleccionador.mover(seleccionador.position().up(1))})
       keyboard.down().onPressDo({seleccionador.mover(seleccionador.position().down(1))}) // añadimos los imputs de movimiento del seleccionador

       keyboard.enter().onPressDo({seleccionador.accionContextual()}) // dependiendo el contexto decide que accion realizar

       keyboard.alt().onPressDo({seleccionador.cambioDeHuesped(turnManager.turnoDe().recorrerIntegrantes(turnManager.turnoDe().integrantes()))}) // cambio de huesped del seleccionador

       keyboard.i().onPressDo({seleccionador.huesped().recorrerInventario()})

       keyboard.o().onPressDo({seleccionador.huesped().equiparObjeto()})

       keyboard.u().onPressDo({seleccionador.huesped().usarObjeto()})

       keyboard.num1().onPressDo({seleccionador.activarHabilidadClase()})

       keyboard.num2().onPressDo({seleccionador.activarHabilidadPersonaje()})

       keyboard.space().onPressDo({turnManager.pasoDeTurno()}) // pasamos turno de un equipo a otro   
      }
}

