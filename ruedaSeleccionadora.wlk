import Personajes.*
import auxiliares.*


class RuedaSeleccionadora {
  
    const imgHombreCalabaza = new ImagenPersonaje(nombre = "HombreCalabaza",position = position)
    const imgHombreZapallo = new ImagenPersonaje(nombre = "HombreZapallo",position = position)
    const imgGranjero = new ImagenPersonaje(nombre = "Granjero",position = position)
    const imgEspantaPajaros = new ImagenPersonaje(nombre = "EspantaPajaros",position = position)
    const imgVacaMedico = new ImagenPersonaje(nombre = "VacaMedico",position = position)
    const imgOvejaMedica = new ImagenPersonaje(nombre = "OvejaMedica",position = position)
    const imgLoboSniper = new ImagenPersonaje(nombre = "LoboSniper",position = position)
    const imgKillerBunny = new ImagenPersonaje(nombre = "KillerBunny",position = position) 
    
    const opciones = [imgHombreCalabaza,imgHombreZapallo, imgGranjero,imgEspantaPajaros,imgOvejaMedica,imgVacaMedico,imgLoboSniper,imgKillerBunny]

    
    var property indice = 0
    var property position 


    method inicializar(){
      game.removeVisual(opciones.get(indice))
      indice = 0
      game.addVisual(opciones.get(indice))
    }

    method seleccionar (){
       return opciones.get(indice)
    }
   
   method moverAbajo() {
       game.removeVisual(opciones.get(indice))
       game.addVisual(auxiliar.siguienteDeLaLista(opciones,self))
   }

   method moverArriba() {
       game.removeVisual(opciones.get(indice))
       game.addVisual(auxiliar.anteriorDeLaLista(opciones,self))
   }
}

class ImagenPersonaje {
  
  const property nombre 
  var property position

  method image(){
    return nombre + ".png"
  } 

}

const rueda1 = new RuedaSeleccionadora(position = game.at(6, 7))
const rueda2 = new RuedaSeleccionadora(position = game.at(10, 7))
const rueda3 = new RuedaSeleccionadora(position = game.at(14, 7))
const rueda4 = new RuedaSeleccionadora(position = game.at(18, 7))