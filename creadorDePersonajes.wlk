import Personajes.*

class CreadorDePersonajes {
  const property nombre
  const property creador

}

object generadorDePersonajes{
    
const nuevoHombreCalabaza = new CreadorDePersonajes(nombre = "HombreCalabaza",creador = {nuevoEquipo => new HombreCalabaza(position = game.center(), equipo = nuevoEquipo )})
const nuevoHombreZapallo = new CreadorDePersonajes(nombre = "HombreZapallo",creador = {nuevoEquipo => new HombreZapallo(position = game.center(), equipo = nuevoEquipo )})
const nuevoGranjero = new CreadorDePersonajes(nombre = "Granjero",creador = {nuevoEquipo => new Granjero(position = game.center(), equipo = nuevoEquipo )})
const nuevoEspantaPajaros = new CreadorDePersonajes(nombre = "EspantaPajaros",creador = {nuevoEquipo => new EspantaPajaros(position = game.center(), equipo = nuevoEquipo )})
const nuevaVacaMedico = new CreadorDePersonajes(nombre = "VacaMedico",creador = {nuevoEquipo => new VacaMedico(position = game.center(), equipo = nuevoEquipo )})
const nuevaOvejaMedica = new CreadorDePersonajes(nombre = "OvejaMedica",creador = {nuevoEquipo => new OvejaMedica(position = game.center(), equipo = nuevoEquipo )})
const nuevoKillerBunny = new CreadorDePersonajes(nombre = "KillerBunny",creador = {nuevoEquipo => new KillerBunny(position = game.center(), equipo = nuevoEquipo )})
const nuevoLoboSniper = new CreadorDePersonajes(nombre = "LoboSniper",creador = {nuevoEquipo => new LoboSniper(position = game.center(), equipo = nuevoEquipo )})
const generadores = [nuevoHombreCalabaza,nuevoHombreZapallo,nuevoGranjero,nuevoEspantaPajaros,nuevaVacaMedico,nuevaOvejaMedica,nuevoKillerBunny,nuevoLoboSniper]


method crearNuevoPersonaje(personaje,equipo)
{  const nuevoPersonaje = generadores.find({generador => generador.nombre() == personaje.nombre()}).creador().apply(equipo)
   return nuevoPersonaje
}}