object auxiliar{
  
  
   method siguienteDeLaLista(lista,objeto){
 if (objeto.indice() < lista.size()-1){
     objeto.indice(objeto.indice() + 1) 
     return lista.get(objeto.indice())
     } else{
      objeto.indice(0)
      return lista.get(objeto.indice())}
    }
  
  method anteriorDeLaLista(lista,objeto){
 if (objeto.indice() > 0){
     objeto.indice(objeto.indice() - 1) 
     return lista.get(objeto.indice())
     } else{
      objeto.indice(lista.size()-1)
      return lista.get(objeto.indice())}
    }}

object limitesTablero{
  const ancho = 25
  const alto = 15

  method contiene(posicion){
    return posicion.x() >= 0 and posicion.x() < ancho and
      posicion.y() >= 0 and posicion.y() < alto
  }
}