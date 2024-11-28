
Unit unit1;

Interface

Uses crt;

Const 
  LIMITE = 10;

Type tablero = array[1..LIMITE, 1..LIMITE] Of byte;

Procedure leer_posicion(Var fila, columna:byte);
Procedure dibujar_tablero(titulo: String; tablero: tablero);

Implementation




(*leer_posicion
 Lee una cadena de dos caracteres y guarda en dos variables las posiciones
que representa dicha cadena. Por ejemplo: a5 -> fila 5 columna 1
 
fila byte Una variable donde guardar la fila obtenida (por referencia)
columna byte Una variable donde guardar la columna (por referencia)*)
Procedure leer_posicion(Var fila, columna:byte);

Var valido: boolean;
  posicion: string;
Begin
  Repeat
    readln(posicion); { Pido coordenada }

    posicion := upcase(posicion); { Hago mayuscula }
    valido := false;

    If (length(posicion) = 2)
       {length da la cantidad de elementos que tiene la variable}
       And (ord(posicion[1]) >= 49) And (ord(posicion[1]) <= 58)
       {el primer caracter es un numero del 1 al 8 }
       And (ord(posicion[2]) >= 64) And (ord(posicion[2]) <= 74) Then
      {el segundo una letra}





{*La función ord en Pascal se utiliza para obtener el valor ordinal de un carácter. 
En otras palabras, toma un carácter como entrada y devuelve 
su código ASCII correspondiente, que es un valor entero.*}
      Begin





{ Genero la posicion  del numero, y le resto 48 Porque los numeros en la tabla ascii van del 49 al 58, por lo que si les resto 48 me queda un numero del 1 al 9 }
        fila := ord(posicion[1])-48; { Guardo la fila en la variable indicada }

        columna := ord(posicion[2])-64;
        { Guardo la columna en la variable indicada }
{ Como se cumplieron las condiciones, es una coordenada valida }
        valido := true;
      End
    Else
{ Con este if repito el proceso}
      If (length(posicion) = 2)
         And (ord(posicion[2]) >= 49) And (ord(posicion[2]) <= 58)
         And (ord(posicion[1]) >= 65) And (ord(posicion[1]) <= 74) Then
        Begin
          fila := ord(posicion[2])-48;
          columna := ord(posicion[1])-64;
          valido := true;
        End
    Else
 { En caso de que no se cumpla alguna condicion, da un aviso y repite el ciclo }
      write('Por favor, ingrese una posicion valida: ');
  Until (valido = true);
  { Se repetira el ingreso hasta que se ingrese una coordenada valida }
End;



(*dibujar_tablero
 
Toma un array tablero y lo dibuja tiernamente  Antecede antes un titulo.
Los puntos desconocidos (0, 1) se marcan con Â·, los atacados (2) con o, los alcanzados (3) con x
Limpia la pantalla antes de dibujar.
 
@ titulo string Una cadena de texto con el titulo del tablero
@ tablero tablero Un array tablero bidimensional*)
Procedure dibujar_tablero(titulo: String; tablero: tablero);

Var i, j: byte;
Begin
  clrscr;
  writeln('Batalla Naval Grupo 4');
  writeln(titulo);
  writeln;
  writeln(' --------------------------');
  { Esta es la parte de arriba del tablero }
  For i:= 1 To LIMITE Do
    Begin { Por cada fila... }
      If (i< 10) Then
        write(' ', i, '| ')
        { Primero escribo el numero de fila y despues una barrita }
      Else
        write(i, '| ');
      { Primero escribo el numero de fila y despues una barrita }
      For j := 1 To LIMITE Do { Y ahora, por cada columna... }
        Case tablero[i, j] Of 
          0: write('. '); { Si el tablero tiene un 0, dibujo un puntito }
          1: write('. ');
          { Si tiene un 1 (tiene un barco), tambien dibujo un puntito }
          2: write('o ');
          { Si es una posicion ya atacada (un 2) dibujo un circulo }
          3: write('x '); { Si es un barco alcanzado (un 3) va una cruz }
        End;
      writeln('|'); { Dibujo la barrita al final del tablero (lado derecho) }
    End;
  writeln(' --------------------------');
  { Dibujo la parte de abajo del tablero }
  writeln('    A B C D E F G H I J'); { Y las letras }
End;

End.
