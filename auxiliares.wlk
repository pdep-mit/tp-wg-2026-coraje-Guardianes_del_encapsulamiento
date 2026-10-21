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