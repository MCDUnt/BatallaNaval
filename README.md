PROGRAMA FUNSIONAL
Program Batalla_Naval;

Uses crt;

Const 
  LIMITE = 10;

Type tablero = array[1..LIMITE, 1..LIMITE] Of byte;

Var tablero1, tablero2: tablero;
  fila, columna, ganador: byte;
  i, j, opcion: byte;
  cont: word;

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


(*ingreso_barcos
 
Toma un array tablero y pide consecutivamente el ingreso de coordenadas
para ubicar los barcos. Los barcos ubicados se muestran con x.
 
@ titulo string Una cadena de texto con el titulo del tablero
@ tablero tablero Un array tablero bidimensional (por referencia)*)
Procedure ingreso_barcos(titulo: String; Var tablero: tablero);

Var fila, columna: byte;
Begin;
  { Se repite el ingreso para 4 barquitos }
  For i := 1 To 4 Do
    Begin
      dibujar_tablero(titulo, tablero);
      { Primero dibujo el tablero del jugador }

      writeln;
      write('Escribe la posicion del barco ', i, ': ');
      leer_posicion(fila, columna);
      { Leo la coordenada ingresada y obtengo las posiciones en el tablero }

    { Si ya hay algo ahi, se repite el ingreso hasta tener un lugar vacio }
      While tablero[fila, columna] = 3 Do
        Begin
          write('Ya hay un barco ahi. Escriba otra posicion: ');
          leer_posicion(fila, columna);
        End;

      tablero[fila, columna] := 3;
      { Inserto un 3 (temporalmente) en la posicion }
    End;

  dibujar_tablero(titulo, tablero);
  { Una vez ingresada la coordenada, muestro de nuevo el tablero actualizado }
  writeln;
  writeln('Presiona <enter> para continuar...'); {comentable para no apretar enter entra turnos}
  readln;
  clrscr;
End;


(*atacar
 
Cambia el estado de una posicion dada en el tablero dado.
Si esa posicion es 0 (no hay barco), la reemplaza por 2 (atacado).
Si la posicion es 1 (hay barco), la reemplaza por 3 (alcanzado).
Si es 2 o 3 (atacado o alcanzado) pide ingreso nuevamente.
 
@ fila byte Fila de la coordenada
@ columna byte Columna de la coordenada
@ tablero tablero Un array tablero bidimensional (por referencia)*)
Procedure atacar(fila, columna:byte; Var tablero: tablero);
Begin

{ Si la posicion que se quiere atacar es diferente de 0 o 1, si ya fue atacada, por lo que repite el ingreso de coordenada }
  While tablero[fila, columna] > 1 Do
    Begin
      write('Ya atacaste esa posicion, elige otra: ');
      leer_posicion(fila, columna);
    End;


  If tablero[fila, columna] = 0 Then
    Begin
      tablero[fila, columna] := 2;
      dibujar_tablero('Fallaste! Muerto!', tablero);
    End;

  If tablero[fila, columna] = 1 Then
    Begin
      tablero[fila, columna] := 3;
      dibujar_tablero('Le diste a un barco! Pura suerte', tablero);
    End;
End;


(*realizar_ataque
 
Lee una coordenada y llama a ataque() en la posicion dada del tablero dado.
 
@ titulo string Titulo para la accion
@ tablero tablero Un array tablero bidimensional (por referencia)*)
Procedure realizar_ataque(titulo:String; Var tablero: tablero);

Var fila, columna: byte;
Begin;
  dibujar_tablero(titulo, tablero);
  { Muestro el tablero, y pido coordenada para atacar }
  writeln;
  write('Ingrese una posicion para atacar: ');
  leer_posicion(fila, columna);
  { Transformo la coordenada en posiciones del tablero }
  atacar(fila, columna, tablero);
  { Llamo al procedimiento de arriba con las posiciones obtenidas }
  writeln;
  writeln('Presiona <enter> para continuar...');
  readln;
End;


(*
tablero_completo
 
Recorre un tablero contando la cantidad de alcanzados (3). Si cuenta 4
alcanzados, devuelve true, sino false.
 
@ tablero tablero Un array tablero bidimensional
*)
Function tablero_completo(tablero: tablero): boolean;

Var i, j, c: byte;
Begin
  { Esto es facil, un contador en dos ciclos anidados para recorrer la matriz }
  { Si no se entiende como funciona, recursen Elementos de Programacion > }
  c := 0;
  For i := 1 To LIMITE Do
    For j := 1 To LIMITE Do
      If tablero[i, j] = 3 Then c := c + 1;

  { Si se encontraron 4 posiciones con el numero 3 (alcanzado), devuelve true }
  If c = 4 Then tablero_completo := true
  Else tablero_completo := false; { Sino false... }
End;


{ Arranca el juego paa! Activision, Blizzard, Valve, EA, agarrense padaso de gatos }
Begin
  { Va todo dentro de un repeat, para poder jugar varias veces }
  { Aunque no creo que nadie lo juegue mas de una vez porque es un embole  }
  Repeat
  cont:=0;
    clrscr; { Muestro un menu recontraremil fachero }
    writeln('----------------------------------- ');
    writeln('|         1 - Jugar               |');
    writeln('|         0 - Salir               |');
    writeln('----------------------------------- ');
    writeln;
    //writeln('|~) _ _|_ _ || _ | | _ _ | Â· | ');
    //writeln('|_)(_| | (_|||(_| | |(_|/(_|| Â· |_/');
    readln(opcion);
  { Si se ingresa una opcion invalida, repite el ingreso hasta que sea valida }
    While (opcion <> 1) And (opcion <> 0) Do
      Begin
        writeln(
          'Ingresa una opcion valida o arderas en el infierno jajja mentira pa.'
        );
        readln(opcion);
      End;

{ Si la opcion fue jugar... }
    If opcion = 1 Then
      Begin
        clrscr;
{ Explicaciones varias }
        writeln('Comienza la etapa de posicionamiento.');
        writeln(
            'Indica la posicion donde ubicar los barcos mediante su coordenada.'
        );
        writeln('Por ejemplo: "G3"');
        writeln;
        writeln('Presiona <enter> para continuar...');
        readln;
        clrscr;

        writeln('Turno del jugador 1');
        writeln;
        writeln('Presiona <enter> para continuar...');
        readln;
{ Llamo el procedimiento ingreso_barcos de mas arriba }
{ Le paso "Jugador 1" como titulo, y tablero1 es el array que se va a llenar }
        ingreso_barcos('Jugador 1', tablero1);

        writeln('Turno del jugador 2');
        writeln;
        writeln('Presiona <enter> para continuar...');
        readln;
{ Idem pal tablero del jugador 2 }
        ingreso_barcos('Jugador 2', tablero2);

{ Explicaciones varias... }
       // writeln('Los barcos fueron ubicados.');
       // writeln('Ahora comienza la etapa de ataque.');
       // writeln('Indica la posicion a atacar mediante su coordenada.');
       // writeln('Por ejemplo: "A1"');
       // writeln;
        // writeln('Presiona <enter> para continuar...');
        // readln;

{ La funcion ingreso_barcos pone un 3 en la posicion que van los barcos }
{ Ahora cambio esos "3" por "1" que es lo que corresponde para que no se vean }
        For i := 1 To LIMITE Do
          For j := 1 To LIMITE Do
            Begin
              If tablero1[i, j] = 3 Then tablero1[i, j] := 1;
              If tablero2[i, j] = 3 Then tablero2[i, j] := 1;
            End;

{ Todo esto se va a repetir hasta que un jugador gane: }

// repeat //cambiar repeat por while para sacar el break y con condicio de salir
        // clrscr;
        // writeln('Turno del jugador 1');
        // writeln; writeln('Presiona <enter> para continuar...');
        // readln;


// { Llamo la funcion realizar_ataque (que pedia las coordenadas y cambiaba las posiciones }

// { Por atacado o alcanzado segun corresponda) indicando que modifique el tablero2 }
        // realizar_ataque('Turno de ataque: jugador 1', tablero2);

 // { Una vez hecho el ataque, verifica si ya hay 4 "alcanzados" en el tablero }
        // if tablero_completo(tablero2) = true then
        // begin 
        // clrscr;
        // writeln('El jugador 1 ha ganado!');
        // { BREAK: lo que hace es "romper" o "salir" del ciclo repeat }

   // { sin importar que falte ejecutar algo, o que la condicion no se cumpla. }
        // { Si quedan dudas pregunten  }
        // break;
        // end;

        clrscr;
        writeln('-------- Iniciando el juego --------');
        // writeln;
        writeln('Presiona <enter> para continuar...');
        readln;

        While (Not tablero_completo(tablero2)) AND (Not tablero_completo(tablero1))  Do
          Begin
            if (cont mod 2 = 0) then
              realizar_ataque('Turno de ataque: jugador 1', tablero2)
            else
              realizar_ataque('Turno de ataque: jugador 2', tablero1);
            inc(cont);
          End;
        
        If tablero_completo(tablero2) Then
          Begin
            clrscr;
            writeln('El jugador 1 ha ganado!');
          End
        else if tablero_completo(tablero1) then
          begin
            clrscr;
            writeln('El jugador 2 ha ganado!');
          end;

        // clrscr;
        // writeln('Turno del jugador 2');
        // writeln;
        writeln('Presiona <enter> para ir al menu');
        readln;

{ Lo mismo para el jugador 2: pide coordenadas, ataca, verifica si gano }
        // While Not tablero_completo(tablero2) Do
        //   Begin
        //     realizar_ataque('Turno de ataque: jugador 2', tablero2);
        //   End;
        // If tablero_completo(tablero2) Then
        //   Begin
        //     clrscr;
        //     writeln('El jugador 2 ha ganado!');
        //   End;

        //until (false);
{ Aca uso "false" como condicion para que el ciclo se detenga }
{ Esto quiere decir que no se va a detener nunca por si solo, porque }
{ No hay variables en la condicion que se modifiquen dentro del ciclo }

{ La unica forma de detener el ciclo es con un break; adentro (el que uso cuando un jugador gana) }
      //   writeln;
      //   writeln('Presiona <enter> para continuar...');
      //   readln;
      End;
{ Y todo esto se va a repetir hasta que el jugador decida salir en el menu }
  Until (opcion = 0);
End.
