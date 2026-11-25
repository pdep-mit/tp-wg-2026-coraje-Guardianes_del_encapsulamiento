
import Items.*

class CajaDeRecompensa {
  var property item 
  const property solido = false
  const property objetivoElegible = false
  const property recolectable = true
  const property position
  
  method agregarItem(itemNuevo){
    item = itemNuevo
  }

  method generarRecompensa(){
    self.destruirse()
    return item
  }

//metodo para que las cajas se destruyan cuando se recolectan, para que no queden en el tablero
  method destruirse () {
    generadorDeCajas.quitarCaja(self)
    game.removeVisual(self)
  }

  method image() = "caja.png"
}

object generadorDeCajas{

const property posicionesPosibles = []
const cajasActivas = []

method generarCaja(){
  if (cajasActivas.size() >= 6) {
    return null //no puede haber mas de 6 cajas activas al mismo tiempo
  }
  const posicionesLibres = posicionesPosibles.filter({posicion =>
    not cajasActivas.any({caja => caja.position() == posicion})
  })
  if (posicionesLibres.isEmpty()) {
    return null
  }
  const caja = new CajaDeRecompensa(
    item = generadorDeItems.generarItem(),
    position = posicionesLibres.anyOne())
  cajasActivas.add(caja)
  game.addVisual(caja)
  return caja
}

method quitarCaja(caja) {
  cajasActivas.remove(caja)
}
}