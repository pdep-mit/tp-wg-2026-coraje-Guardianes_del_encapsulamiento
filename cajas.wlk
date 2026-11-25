
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
  
  const posicionesLibres = posicionesPosibles.filter({posicion => not cajasActivas.any({caja => caja.position() == posicion}) 
       and not(game.getObjectsIn(posicion).any({objeto => objeto.solido()}))})

  if (cajasActivas.size() < 6 and not posicionesLibres.isEmpty()) {
      const caja = new CajaDeRecompensa(
      item = generadorDeItems.generarItem(),
      position = posicionesLibres.anyOne())
      cajasActivas.add(caja)
      game.addVisual(caja)
}}

method quitarCaja(caja) {
  cajasActivas.remove(caja)
}
}