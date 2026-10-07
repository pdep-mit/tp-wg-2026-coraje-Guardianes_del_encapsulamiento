
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

  method destruirse () {

    game.removeVisual(self)
  }

  method image() = "caja.png"
}

object generadorDeCajas{

method generarCaja(){
  const caja = new CajaDeRecompensa(item = generadorDeItems.generarItem(),position = game.center())
  game.addVisual(caja)
}
}