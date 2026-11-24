# Wollok Game: Riego Cruzado
**Grupo:** Guardianes del Encapsulamiento

**Integrantes:**
- Rodrigo Maximiliano Flor
- José Manuel Varela
- Juan Francisco Aldaco
- Julio Enrique Patiño Parra
- Federico Agustín Gigena

## Consignas

Todo lo que necesitan saber está explicado en [este documento](https://docs.google.com/document/d/1KoB12RIZk_xPhmnOJ-EfLIPNwkETD_EaYMp2srDu9QY/edit?tab=t.0#heading=h.wnm2lu4cls8j). Para todo lo demás, aseguren prestar atención a los comunicados por Discord.

Revisen los archivos de base y cambien lo que quieran para ajustarlo a sus necesidades. Lo primero que deberían hacer es actualizar 

Recuerden que para cada checkpoint hay [expectativas mínimas](https://docs.google.com/document/d/1KoB12RIZk_xPhmnOJ-EfLIPNwkETD_EaYMp2srDu9QY/edit?tab=t.0#heading=h.56t0qdv908v3) respecto a los conceptos aplicados. Procuren:
- Validar su idea con el equipo docente que corresponda por su canal de Discord
- Para cada checkpoint, asegurar que implementaron lo necesario para esa instancia, y crear un **tag** en el repositorio para facilitar la comparación entre versiones final e intermedias.
- Para la demo final, crear un nuevo tag **demo** y actualizar este README con todo lo necesario.

# Cómo jugar

## Objetivo

Riego Cruzado es un juego multijugador 1vs1 de estrategia por turnos, en el que el objetivo es ganarle a tu rival derrotando a todos sus personajes. 

--[Menu de selección de personajes]--

Al comenzar el juego cada uno de los jugadores eligirá su equipo de 4 de una lista de 8 personajes, los cuales se dividen en 4 clases distintas: Soldado, Tanque, Sniper y Medico. Cada una de estas clases tienen estadisticas acorde a su función, además de esto cada personaje tiene tanto una habilidad por su clase como una habilidad unica de su personaje

--[ Partida ]--

Una vez comenzada la partida cada equipo se turna para manejar a sus personajes, estos pueden moverse y atacar en un rombo que delimita su alcance, finalizadas sus acciones presionas la tecla Alt para cambiar al siguiente personaje y manejarlo, cuando ya no queden personajes por mover pasas el turno con la barra espaciadora.

Los personajes tambien pueden recolectar cajas de items, las cuales generaran una recompensa aleatoria, variando entre consumibles que recuperan salud a granadas que causan un gran daño a todos los que esten en su radio de explosión. Para usar estos items el personaje se lo guarda en un inventario que puede recorrer con la tecla I, equiparse un item con la tecla O y luego usarlos cuando quieras con la tecla U

Para finalizar la partida uno de los equipos debe eliminar a todos los personajes del equipo rival, con lo cual se determina al ganador del juego


## Controles

--[Menu de selección de personajes]--

Flecha Arriba: Anterior Personaje

Flecha Abajo: Siguiente Personaje

Enter: Confirmación de elección

C: Retroceder en la selección

--[ Partida ]--

WASD: Mover el cursor 

Enter: Confirmar acción (mover personaje,atacar,uso de habilidad)

Alt: Cambio de personaje

Barra de espacio: Pasar Turno

Numero 1: Habilidad de personaje

Numero 2: Habilidad de Clase

I: Recorrer inventario

O: Seleccionar Item

U: Utilizar Item

# Explicaciones

Las explicaciones teóricas y diagramas van a encontrarse en [explicaciones.md](explicaciones.md) a partir del Checkpoint #2.