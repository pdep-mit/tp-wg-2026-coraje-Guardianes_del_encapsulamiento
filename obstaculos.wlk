class Pared {
  const property objetivoElegible = false
  const property solido = true
  var property position 
  
  var property equipo = "Neutral" 
  
  method recibirDanio(danio) {}
}



class Barrera {
  const property objetivoElegible = true
  const property solido = true
  var property position
  var property equipo
  var property vida

  method recibirDanio(danio){
    vida -= danio
   if(vida <= 0){self.destruirse()}
  }
  method destruirse() {
    game.removeVisual(self)
  }
}

class BloqueDeHeno inherits Barrera (vida = 50) {

  method image() = "bloque_De_Heno.png"
   
  method curar(cantidad) { }
}