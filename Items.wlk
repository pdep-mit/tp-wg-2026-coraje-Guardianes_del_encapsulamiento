import seleccionador.*
import Personajes.*
import obstaculos.*
class Items {
  var property usabilidad  
  var property duenio = null 
  var property calidad
  var property nombre
  


}

class Lanzable inherits Items () {
   var property danio
   var property area
  
   method efecto() 
   {
      self.encontrarAfectados().forEach({afectado => afectado.recibirDanio(danio)  })
   }

   method usarItem (){ usabilidad -= 1
        self.efecto()
        console.println("lanzaste una granada")
        if(usabilidad == 0){
         duenio.gastarItem()
        }}

   method encontrarAfectados (){
    
    const posicionesARevisar = self.casillasARevisar()
    const afectados = []
     posicionesARevisar.forEach({casilla => game.getObjectsIn(casilla).forEach({objeto=>if (objeto.objetivoElegible()){afectados.add(objeto)}})})
       return afectados
   } 
   method casillasARevisar (){
   const casillas = []
        (-area..area).forEach({ coordenada_x => (-area..area).forEach({ coordenada_y =>   if (coordenada_x.abs() + coordenada_y.abs() <= area){ casillas.add(game.at(seleccionador.position().x() + coordenada_x, seleccionador.position().y() + coordenada_y))}})})
          return casillas}
       
}




class BarreraDesplegable inherits Items () {
    const property crearBarrera

    method efecto(){
       const barrera = crearBarrera.apply(seleccionador.position())
       game.addVisual(barrera)  
       console.println("colocaste una barrera")
       }  
       
    method usarItem (){
         if(not game.getObjectsIn(seleccionador.position()).any({objeto => objeto.solido()})){
        usabilidad -= 1
        self.efecto()
        if(usabilidad == 0){
         duenio.gastarItem()
        }}}
}

class Consumible inherits Items () 
{
  const recuperacion
  
  
  method usarItem (){
        usabilidad -= 1
        self.efecto()
        console.println("Te curaste")
        if(usabilidad == 0){
         duenio.gastarItem()
        }
  }
  method efecto() 
   {
      duenio.vida(duenio.vida() + recuperacion) 
   }
}

class PowerUp inherits Items (usabilidad = 1) {
  const property aplicarMejora
  const property mejora

  method usarItem (){
    self.efecto()
    duenio.gastarItem()
    console.println("Te mejoraste")
  }
   method efecto(){
    aplicarMejora.apply(duenio,mejora)
   }
}


object generadorDeItems {
  
  
  const generadores = [
        { new PowerUp(nombre = "mejoraAtaque", calidad = 3, aplicarMejora = { personaje, valor => personaje.ataque(personaje.ataque() + valor) }, mejora = 10) },
        { new PowerUp(nombre = "mejoraAlcance" ,calidad = 3, aplicarMejora = { personaje, valor => personaje.alcance(personaje.alcance() + valor) }, mejora = 1) },
        { new Lanzable(nombre = "GranadaMazorca",usabilidad = 1, calidad = 4, area = 2, danio = 200) },
        { new Lanzable(nombre = "GranadaCereza",usabilidad = 1, calidad = 2, area = 3, danio = 25) },
        { new BarreraDesplegable(nombre = "BarreraDeHeno" , usabilidad = 2, calidad = 1, crearBarrera = { posicion => new BloqueDeHeno(position = posicion,equipo = seleccionador.huesped().equipo()) }) },
        { new Consumible(nombre = "Churrasco" , calidad = 2, usabilidad = 3, recuperacion = 40) }
    ]


  method generarItem(){
   const indiceAleatorio = 0.randomUpTo(generadores.size()-1).truncate(0)
   return generadores.get(indiceAleatorio).apply()
 
  }
  

}