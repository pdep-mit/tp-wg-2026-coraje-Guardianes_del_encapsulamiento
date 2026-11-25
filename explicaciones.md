# Explicaciones teóricas

## 1. Polimorfismo
Dos o más objetos son polimórficos cuando comparten una interfaz (entienden los mismos mensajes) y quien se comunica con ellos puede tratarlos de forma indistinta, sin importar cómo resuelve cada uno su comportamiento ni si comparten una superclase en común. Esto reduce el grado de conocimiento que necesita un módulo acerca de otro para funcionar y nos evita cadenas de condicionales que pregunten por el tipo de cada objeto.

### Dónde y para qué lo aplicamos
Un caso donde aprovechamos polimorfismo sin herencia en común es el manejo de los objetivos atacables entre Personaje y Barrera / BloqueDeHeno:
- Ambas jerarquías son independientes, pero comparten el protocolo `objetivoElegible()`, `equipo()` y `recibirDanio(danio)`.
- Al atacar, ni `seleccionador.atacarObjetivo()`, ni `Personaje.atacar(objetivo)`, ni `Granada.aplicarEfectoA(afectado)` necesitan verificar si el objetivo es un enemigo o un bloque de heno en el mapa; simplemente le envían `recibirDanio(...)`.
- Cada receptor resuelve el mensaje según sus reglas: `Personaje` reduce el daño según su `defensa`, muestra su vida restante y evalúa si debe ejecutar `muerte()` (lo que además dispara `turnManager.verificarFinDeRonda()`), mientras que `Barrera` descuenta el daño directo y se elimina del tablero con `destruirse()` cuando su vida llega a 0.

```
// En Personaje (Personajes.wlk)
method atacar(objetivo) {
  if (puedeAtacar and equipo != objetivo.equipo()) {
    objetivo.recibirDanio(ataque)
    puedeAtacar = false
    puedeMover = false
    seleccionador.quitarCasillasDisponibles()
  }
}

// En Barrera (obstaculos.wlk)
method recibirDanio(danio) {
  vida -= danio
  if (vida <= 0) { self.destruirse() }
}
```

Ademas, todos los elementos visibles del tablero (`Personaje`, `Pared`, `Barrera`, `CajaDeRecompensa`, `CasillasDisponible` y `seleccionador`) entienden `solido()` y `objetivoElegible()`, lo que permite que `seleccionador` calcule casillas alcanzables y verifique la línea de ataque sin acoplarse a ninguna clase particular.

## 2. Encapsulamiento

El encapsulamiento consiste en reducir al minimo necesario la exposición del estado interno de los objetos: cada objeto es responsable de mantener y modificar sus propios atributos, mientras que el resto del sistema interactúa con él solo por medio de los mensajes de su interfaz.

### Dónde lo aplicamos y qué correcciones realizamos

**Corrección en el posicionamiento inicial (`partida.wlk` → `niveles.wlk`)**

En una versión anterior del proyecto, el inicio de la partida rompía el encapsulamiento modificando directamente el atributo `position` de cada personaje desde afuera:

```
// Antes (en partida.wlk): se modificaba directamente el estado interno del personaje
equipoAzul.integrantes().get(0).position(game.at(4,4))
equipoRojo.integrantes().get(0).position(game.at(20,4))
```

Para corregir esto, se movió la inicialización del mapa a `generadorDeNiveles` (`niveles.wlk`) y se reemplazó el acceso directo al setter por el envío del mensaje `mover(nuevaPosicion)`:

```
// Ahora (en generadorDeNiveles - niveles.wlk)
rango.forEach({indice => equipoAzul.get(indice).mover(spawnersAzul.get(indice))})
rango.forEach({indice => equipoRojo.get(indice).mover(spawnersRojo.get(indice))})
```

De esta manera, el generador de niveles desconoce cómo el personaje actualiza su posición; es el `Personaje` quien encapsula la lógica de desplazamiento, validando que la casilla esté dentro de los `limitesTablero`, que no haya elementos sólidos y actualizando su estado interno (`puedeMover` y las casillas disponibles).

**Protección del estado en el ciclo de turnos y combate**

El mismo criterio lo aplicamos en la coordinación entre `turnManager`, `Equipo` y `Personaje`:

- En vez de que `turnManager` modifique directamente los flags de cada equipo (`turnoActivo`) o reinicie manualmente las estadísticas y cooldowns de cada integrante, le envía `iniciarTurno()` y `finalizarTurno()` al equipo y este delega la actualización en cada uno de sus integrantes.
- Para detectar el fin de la ronda (`verificarFinDeRonda()`), `turnManager` consulta `equipo.estaEliminado()` en vez de inspeccionar la lista de integrantes y el estado `vivo` de cada uno desde afuera.
- Cuando hay un ataque o explosión, ningún objeto externo modifica `vida` ni marca `vivo = false`; todo pasa por `recibirDanio(danio)`, que garantiza aplicar la defensa y disparar la muerte correctamente.

## 3. Herencia y reutilización de comportamiento

La herencia permite abstraer en una superclase la estructura y lógica repetida entre distintas clases, dejando en cada subclase únicamente el comportamiento particular que la diferencia.

### Dónde y para qué lo aplicamos

Además de la jerarquía de `Personaje` (agrupados por rol en `Soldado`, `Tanque`, `Sniper` y `Medico`), el mayor provecho de la herencia lo vemos en `Items.wlk`, donde la jerarquía organiza el ciclo de vida de cualquier objeto utilizable aplicando un esquema de **Template Method** en dos niveles:

1. **Superclase `Items`**: define el algoritmo general en `usarItem()`, encargándose de verificar `puedeUsarse()`, descontar `usabilidad`, ejecutar el método abstracto `efecto()`, mostrar `mensajeDeUso()` en pantalla y avisar con `duenio.gastarItem()` cuando se agotan los usos.

```
// En Items (Items.wlk)
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
```

2. **Categorías intermedias (`Lanzable`, `Colocable`, `Consumible`)**: cada una redefine `efecto()` (y ganchos opcionales como `puedeUsarse()` o `mensajeDeUso()`) sin duplicar el flujo de `usarItem()`:
    - `Lanzable` resuelve el cálculo del área en rombo (`casillasAfectadas()`) y el filtrado de objetivos elegibles (`encontrarAfectados()`), delegando únicamente `aplicarEfectoA(afectado)` en `Granada` y `PocionCuracion`.
    - `Colocable` redefine el gancho `puedeUsarse()` para impedir colocar elementos sobre casillas con objetos sólidos y delega `crearElemento(posicion)` en `BarreraDesplegable`.
    - `Consumible` aplica el efecto sobre `duenio`, delegando `aplicarA(personaje)` en `Curacion` y en la subjerarquía `PowerUp` (`MejoraAtaque`, `MejoraAlcance`, `MejoraVida`).

Esta decisión nos evita repetir validaciones, feedback visual `(game.say())` y limpieza de inventario en más de diez ítems concretos, también facilita agregar nuevos ítems definiendo solo su efecto y que `Personaje.usarObjeto()` ejecute cualquier `objetoEquipado` solamente enviándole `usarItem()`.

# Diagramas

*Incluír al menos un diagrama para comunicar su solución*