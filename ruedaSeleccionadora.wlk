import Personajes.*
import auxiliares.*


class RuedaSeleccionadora {
  
   const imgHombreCalabaza = new ImagenPersonaje(
      nombre = "HombreCalabaza",
      clase = "Tanque",
      estadisticas = "Vida: 140 | Atq: 20 | Alc: 2 | Def: 1",
      habilidadClase = "Endurecer (+1 Def, CD: 2)",
      habilidad = "Golpe pesado (3x daño cuerpo a cuerpo, CD: 2)",
      position = position
    )
    const imgHombreZapallo = new ImagenPersonaje(
      nombre = "HombreZapallo",
      clase = "Tanque",
      estadisticas = "Vida: 160 | Atq: 15 | Alc: 2 | Def: 1",
      habilidadClase = "Endurecer (+1 Def, CD: 2)",
      habilidad = "Escudo grupal (+1 Def a aliados, CD: 4)",
      position = position
    )
    const imgGranjero = new ImagenPersonaje(
      nombre = "Granjero",
      clase = "Soldado",
      estadisticas = "Vida: 100 | Atq: 25 | Alc: 3 | Def: 1",
      habilidadClase = "Agilizar (+1 Alc, CD: 2)",
      habilidad = "Doble disparo (2 usos antes de CD: 2)",
      position = position
    )
    const imgEspantaPajaros = new ImagenPersonaje(
      nombre = "EspantaPajaros",
      clase = "Soldado",
      estadisticas = "Vida: 110 | Atq: 25 | Alc: 3 | Def: 1",
      habilidadClase = "Agilizar (+1 Alc, CD: 2)",
      habilidad = "Granada de bolsillo (Daño en area: 20, rango: 2, CD: 3)",
      position = position
    )
    const imgVacaMedico = new ImagenPersonaje(
      nombre = "VacaMedico",
      clase = "Medico",
      estadisticas = "Vida: 100 | Atq: 20 | Alc: 3 | Def: 1",
      habilidadClase = "Curar (+40 Vida a un aliado,CD: 3)",
      habilidad = "Esteroides (+15 Atq a un aliado, CD: 2)",
      position = position
    )
    const imgOvejaMedica = new ImagenPersonaje(
      nombre = "OvejaMedica",
      clase = "Medico",
      estadisticas = "Vida: 100 | Atq: 15 | Alc: 4 | Def: 1",
      habilidadClase = "Curar (+40 Vida a un aliado,CD: 3)",
      habilidad = "Inyectable dudoso (+1 Alc a un aliado, CD: 2)",
      position = position
    )
    const imgLoboSniper = new ImagenPersonaje(
      nombre = "LoboSniper",
      clase = "Sniper",
      estadisticas = "Vida: 90 | Atq: 35 | Alc: 4 | Def: 1",
      habilidadClase = "Enfocar (Mantiene posicion, +10 ataque, CD:2)",
      habilidad = "Tiro perforante (Ignora defensa, CD: 3)",
      position = position
    )
    const imgKillerBunny = new ImagenPersonaje(
      nombre = "KillerBunny",
      clase = "Sniper",
      estadisticas = "Vida: 80 | Atq: 40 | Alc: 4 | Def: 1",
      habilidadClase = "Enfocar (Mantiene posicion, +10 ataque, CD:2)",
      habilidad = "Ataque suicida (3x vida como daño cuerpo a cuerpo)",
      position = position
    )
    
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
  const property clase
  const property estadisticas
  const property habilidadClase
  const property habilidad 
  var property position

  method image(){
    return nombre + ".png"
  } 

}

const rueda1 = new RuedaSeleccionadora(position = game.at(6, 7))
const rueda2 = new RuedaSeleccionadora(position = game.at(10, 7))
const rueda3 = new RuedaSeleccionadora(position = game.at(14, 7))
const rueda4 = new RuedaSeleccionadora(position = game.at(18, 7))