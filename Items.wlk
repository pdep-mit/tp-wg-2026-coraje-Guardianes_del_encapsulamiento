import Personajes.*
import obstaculos.*
import seleccionador.*

class Items {
  const property solido = false
  var property usabilidad  
  var property duenio = null 
  var property calidad
  var property nombre
  //usar item
  method efecto()
  //Cuando se puede usar
  method puedeUsarse() = true
  //mensaje
  method mensajeDeUso() = "usaste " + nombre
  //objetivo
  method posicionObjetivo() = seleccionador.position()
  
  method usarItem() {
    if (self.puedeUsarse()) {
      usabilidad -= 1
      self.efecto()
      game.say(duenio, self.mensajeDeUso())
      if (usabilidad <= 0) {
        duenio.gastarItem()
      }
    }
}
}

//LANZABLES
class Lanzable inherits Items () {
   var property area
  
   method aplicarEfectoA(afectado)

   override method efecto() {
    self.encontrarAfectados().forEach({ afectado => self.aplicarEfectoA(afectado) })
  }

   override method mensajeDeUso() = "lanzaste " + nombre

  method encontrarAfectados() {
    const afectados = []
    self.casillasAfectadas().forEach({ casilla =>
      game.getObjectsIn(casilla).forEach({ objeto =>
        if (objeto.objetivoElegible()) {
          afectados.add(objeto)
        }
      })
    })
    return afectados
  }

  method casillasAfectadas() {
    const centro = self.posicionObjetivo()
    const rango = (-area..area)
    const casillas = []
    rango.forEach({ dx =>
      rango.forEach({ dy =>
        if (dx.abs() + dy.abs() <= area) {
          casillas.add(game.at(centro.x() + dx, centro.y() + dy))
        }
      })
    })
    return casillas
  }
}

class Granada inherits Lanzable {
  const property danio

  override method aplicarEfectoA(afectado) {
    afectado.recibirDanio(danio)
  }
}

class PocionCuracion inherits Lanzable {
  const property cantidad

  override method aplicarEfectoA(afectado) {
    afectado.curarse(cantidad)
  }
}


//COLOCABLES

class Colocable inherits Items {
  method crearElemento(posicion)

  // Redefinición del gancho: solo se puede colocar en una casilla sin nada sólido.
  override method puedeUsarse() =
    not game.getObjectsIn(self.posicionObjetivo()).any({ objeto => objeto.solido() })

  override method efecto() {
    game.addVisual(self.crearElemento(self.posicionObjetivo()))
  }

  override method mensajeDeUso() = "colocaste " + nombre
}

class BarreraDesplegable inherits Colocable {
 //Que tipo de barrera se crea
  const property fabrica

  override method crearElemento(posicion) = fabrica.apply(posicion, duenio.equipo())
}

//Consumibles
class Consumible inherits Items {
  method aplicarA(personaje)

  override method efecto() {
    self.aplicarA(duenio)
  }
}
class Curacion inherits Consumible {
  const property cantidad

  override method aplicarA(personaje) {
    personaje.curarse(cantidad)
  }

  override method mensajeDeUso() = "te curaste " + cantidad + " con " + nombre
}

class PowerUp inherits Consumible(usabilidad = 1) {
  const property mejora

  override method mensajeDeUso() = "te mejoraste con " + nombre
}

class MejoraAtaque inherits PowerUp {
  override method aplicarA(personaje) {
    personaje.ataque(personaje.ataque() + mejora)
    personaje.ataqueBase(personaje.ataque())
  }
}

class MejoraAlcance inherits PowerUp {
  override method aplicarA(personaje) {
    personaje.alcance(personaje.alcance() + mejora)
    personaje.alcanceBase(personaje.alcance())
  }
}

class MejoraVida inherits PowerUp {
  override method aplicarA(personaje) {
    personaje.vida(personaje.vida() + mejora)
  }
}

//GENERADOR
object generadorDeItems {

  const generadores = [
    
    { new Curacion(nombre = "Churrasco", calidad = 2, usabilidad = 2, cantidad = 40) },
    { new Curacion(nombre = "Mate", calidad = 1, usabilidad = 5, cantidad = 15) },
    { new Curacion(nombre = "Botiquin", calidad = 3, usabilidad = 1, cantidad = 80) },

    
    { new MejoraAtaque(nombre = "MejoraAtaque", calidad = 3, mejora = 10) },
    { new MejoraAlcance(nombre = "MejoraAlcance", calidad = 3, mejora = 1) },
    { new MejoraVida(nombre = "MejoraVida", calidad = 3, mejora = 30) },

    
    { new Granada(nombre = "GranadaMazorca", usabilidad = 1, calidad = 4, area = 2, danio = 200) },
    { new Granada(nombre = "GranadaCereza", usabilidad = 1, calidad = 2, area = 3, danio = 25) },
    { new Granada(nombre = "GranadaZapallo", usabilidad = 1, calidad = 3, area = 1, danio = 80) },

    
    { new PocionCuracion(nombre = "PocionDeLeche", usabilidad = 1, calidad = 2, area = 2, cantidad = 30) },
    { new PocionCuracion(nombre = "PocionGrande", usabilidad = 1, calidad = 3, area = 1, cantidad = 60) },
    { new PocionCuracion(nombre = "PocionChica", usabilidad = 1, calidad = 1, area = 3, cantidad = 15) },

    
    { new BarreraDesplegable(nombre = "BarreraDeHeno", usabilidad = 2, calidad = 1,
        fabrica = { posicion, equipo => new BloqueDeHeno(position = posicion, equipo = equipo) }) }
  ]

  method generarItem() = generadores.anyOne().apply()
}