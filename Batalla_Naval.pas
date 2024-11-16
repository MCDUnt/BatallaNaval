program Batalla_Naval;
uses crt;
Const
  LIMITE = 10;
type tablero = array[1..LIMITE, 1..LIMITE] of byte;
 
var tablero1, tablero2: tablero;
fila, columna, ganador: byte;
i, j, opcion: byte;
 
(*leer_posicion
 Lee una cadena de dos caracteres y guarda en dos variables las posiciones
que representa dicha cadena. Por ejemplo: a5 -> fila 5 columna 1
 
fila byte Una variable donde guardar la fila obtenida (por referencia)
columna byte Una variable donde guardar la columna (por referencia)*)
procedure leer_posicion(var fila, columna:byte);
var valido: boolean;
posicion: string;
begin
repeat
readln(posicion); { Pido coordenada }
 
posicion := upcase(posicion); { Hago mayuscula }
valido := false; 
 
if (length(posicion) = 2) {length da la cantidad de elementos que tiene la variable}
and (ord(posicion[1]) > 48) and (ord(posicion[1]) < 57) {el primer caracter es un numero del 1 al 8 }
and (ord(posicion[2]) > 64) and (ord(posicion[2]) < 73) then {el segundo una letra}

{*La función ord en Pascal se utiliza para obtener el valor ordinal de un carácter. 
En otras palabras, toma un carácter como entrada y devuelve 
su código ASCII correspondiente, que es un valor entero.*}
begin
{ Genero la posicion  del numero, y le resto 48 Porque los numeros en la tabla ascii van del 49 al 58, por lo que si les resto 48 me queda un numero del 1 al 9 }
fila := ord(posicion[1])-48; { Guardo la fila en la variable indicada }

columna := ord(posicion[2])-64; { Guardo la columna en la variable indicada }
{ Como se cumplieron las condiciones, es una coordenada valida }
valido := true;
end
else
{ Con este if repito el proceso}
if (length(posicion) = 2)
and (ord(posicion[2]) > 48) and (ord(posicion[2]) < 57)
and (ord(posicion[1]) > 64) and (ord(posicion[1]) < 73) then
begin
fila := ord(posicion[2])-48;
columna := ord(posicion[1])-64;
valido := true;
end
else { En caso de que no se cumpla alguna condicion, da un aviso y repite el ciclo }
write('Por favor, ingrese una posicion valida: ');
until (valido = true); { Se repetira el ingreso hasta que se ingrese una coordenada valida }
end;
 
(*dibujar_tablero
 
Toma un array tablero y lo dibuja tiernamente  Antecede antes un titulo.
Los puntos desconocidos (0, 1) se marcan con Â·, los atacados (2) con o, los alcanzados (3) con x
Limpia la pantalla antes de dibujar.
 
@ titulo string Una cadena de texto con el titulo del tablero
@ tablero tablero Un array tablero bidimensional*)
procedure dibujar_tablero(titulo: string; tablero: tablero);
var i, j: byte;
begin
clrscr;
writeln(titulo); { Escribo el titulo... }
writeln;
writeln(' -----------------'); { Esta es la parte de arriba del tablero }
for i:= 1 to LIMITE do begin { Por cada fila... }
write(' ', i, '| '); { Primero escribo el numero de fila y despues una barrita }
for j := 1 to LIMITE do { Y ahora, por cada columna... }
case tablero[i, j] of
0: write('Â· '); { Si el tablero tiene un 0, dibujo un puntito }
1: write('Â· '); { Si tiene un 1 (tiene un barco), tambien dibujo un puntito }
2: write('o '); { Si es una posicion ya atacada (un 2) dibujo un circulo }
3: write('x '); { Si es un barco alcanzado (un 3) va una cruz }
end;
writeln('|'); { Dibujo la barrita al final del tablero (lado derecho) }
end;
writeln(' -----------------'); { Dibujo la parte de abajo del tablero }
writeln(' A B C D E F G H '); { Y las letras }
end;
 
(*ingreso_barcos
 
Toma un array tablero y pide consecutivamente el ingreso de coordenadas
para ubicar los barcos. Los barcos ubicados se muestran con x.
 
@ titulo string Una cadena de texto con el titulo del tablero
@ tablero tablero Un array tablero bidimensional (por referencia)*)
procedure ingreso_barcos(titulo: string; var tablero: tablero);
var fila, columna: byte;
begin;
{ Se repite el ingreso para 4 barquitos }
for i := 1 to 4 do begin
dibujar_tablero(titulo, tablero); { Primero dibujo el tablero del jugador }
 
writeln; write('Escribe la posicion del barco ', i, ': ');
leer_posicion(fila, columna); { Leo la coordenada ingresada y obtengo las posiciones en el tablero }
 
{ Si ya hay algo ahi, se repite el ingreso hasta tener un lugar vacio }
while tablero[fila, columna] = 3 do begin
write('Ya hay un barco ahi. Escriba otra posicion: ');
leer_posicion(fila, columna);
end;
 
tablero[fila, columna] := 3; { Inserto un 3 (temporalmente) en la posicion }
end;
 
dibujar_tablero(titulo, tablero); { Una vez ingresada la coordenada, muestro de nuevo el tablero actualizado }
writeln; writeln('Presiona <enter> para continuar...');
readln;
clrscr;
end;
 
(*atacar
 
Cambia el estado de una posicion dada en el tablero dado.
Si esa posicion es 0 (no hay barco), la reemplaza por 2 (atacado).
Si la posicion es 1 (hay barco), la reemplaza por 3 (alcanzado).
Si es 2 o 3 (atacado o alcanzado) pide ingreso nuevamente.
 
@ fila byte Fila de la coordenada
@ columna byte Columna de la coordenada
@ tablero tablero Un array tablero bidimensional (por referencia)*)
procedure atacar(fila, columna:byte; var tablero: tablero);
begin
{ Si la posicion que se quiere atacar es diferente de 0 o 1, si ya fue atacada, por lo que repite el ingreso de coordenada }
while tablero[fila, columna] > 1 do begin
write('Ya atacaste esa posicion, elige otra: ');
leer_posicion(fila, columna);
end;
 

if tablero[fila, columna] = 0 then begin
tablero[fila, columna] := 2;
dibujar_tablero('Fallaste! Muerto!', tablero);
end;
 
if tablero[fila, columna] = 1 then begin
tablero[fila, columna] := 3;
dibujar_tablero('Le diste a un barco! Pura suerte', tablero);
end;
end;
 
(*realizar_ataque
 
Lee una coordenada y llama a ataque() en la posicion dada del tablero dado.
 
@ titulo string Titulo para la accion
@ tablero tablero Un array tablero bidimensional (por referencia)*)
procedure realizar_ataque(titulo:string; var tablero: tablero);
var fila, columna: byte;
begin;
dibujar_tablero(titulo, tablero); { Muestro el tablero, y pido coordenada para atacar }
writeln; write('Ingrese una posicion para atacar: ');
leer_posicion(fila, columna); { Transformo la coordenada en posiciones del tablero }
atacar(fila, columna, tablero); { Llamo al procedimiento de arriba con las posiciones obtenidas }
writeln; writeln('Presiona <enter> para continuar...');
readln;
end;
 
(*
tablero_completo
 
Recorre un tablero contando la cantidad de alcanzados (3). Si cuenta 4
alcanzados, devuelve true, sino false.
 
@ tablero tablero Un array tablero bidimensional
*)
function tablero_completo(tablero: tablero): boolean;
var i, j, c: byte;
begin
{ Esto es facil, un contador en dos ciclos anidados para recorrer la matriz }
{ Si no se entiende como funciona, recursen Elementos de Programacion > }
c := 0;
for i := 1 to LIMITE do
for j := 1 to LIMITE do
if tablero[i, j] = 3 then c := c + 1;
 
{ Si se encontraron 4 posiciones con el numero 3 (alcanzado), devuelve true }
if c = 4 then tablero_completo := true
else tablero_completo := false; { Sino false... }
end;
 
{ Arranca el juego paa! Activision, Blizzard, Valve, EA, agarrense padaso de gatos }
begin
{ Va todo dentro de un repeat, para poder jugar varias veces }
{ Aunque no creo que nadie lo juegue mas de una vez porque es un embole  }
repeat
clrscr; { Muestro un menu recontraremil fachero }
writeln(' _ _ ');
writeln(' |~) _ _|_ _ || _ | | _ _ | Â· | ');
writeln(' |_)(_| | (_|||(_| | |(_|/(_|| Â· |_/');
writeln;
writeln(' 1 - Jugar');
writeln(' 0 - Salir');
writeln;
readln(opcion);
{ Si se ingresa una opcion invalida, repite el ingreso hasta que sea valida }
while (opcion <> 1) and (opcion <> 0) do begin
writeln('Ingresa una opcion valida o arderas en el infierno jajja mentira pa.');
readln(opcion);
end;
 
{ Si la opcion fue jugar... }
if opcion = 1 then begin
clrscr;
{ Explicaciones varias }
writeln('Comienza la etapa de posicionamiento.');
writeln('Indica la posicion donde ubicar los barcos mediante su coordenada.');
writeln('Por ejemplo: "G3"');
writeln; writeln('Presiona <enter> para continuar...');
readln;
clrscr;
 
writeln('Turno del jugador 1');
writeln; writeln('Presiona <enter> para continuar...');
readln;
{ Llamo el procedimiento ingreso_barcos de mas arriba }
{ Le paso "Jugador 1" como titulo, y tablero1 es el array que se va a llenar }
ingreso_barcos('Jugador 1', tablero1);
 
writeln('Turno del jugador 2');
writeln; writeln('Presiona <enter> para continuar...');
readln;
{ Idem pal tablero del jugador 2 }
ingreso_barcos('Jugador 2', tablero2);
 
{ Explicaciones varias... }
writeln('Los barcos fueron ubicados.');
writeln('Ahora comienza la etapa de ataque.');
writeln('Indica la posicion a atacar mediante su coordenada.');
writeln('Por ejemplo: "A1"');
writeln; writeln('Presiona <enter> para continuar...');
readln;
 
{ La funcion ingreso_barcos pone un 3 en la posicion que van los barcos }
{ Ahora cambio esos "3" por "1" que es lo que corresponde para que no se vean }
for i := 1 to LIMITE do
for j := 1 to LIMITE do
begin
if tablero1[i, j] = 3 then tablero1[i, j] := 1;
if tablero2[i, j] = 3 then tablero2[i, j] := 1;
end;
 
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
writeln('Turno del jugador 1');
writeln; writeln('Presiona <enter> para continuar...');
readln; 

while not tablero_completo(tablero2) do 
begin 
  realizar_ataque('Turno de ataque: jugador 1', tablero2);
end; 
if tablero_completo(tablero2) then
begin 
  clrscr; 
  writeln('El jugador 1 ha ganado!');
end;
 
clrscr;
writeln('Turno del jugador 2');
writeln; writeln('Presiona <enter> para continuar...');
readln;
 
{ Lo mismo para el jugador 2: pide coordenadas, ataca, verifica si gano }
while not tablero_completo(tablero2) do 
begin 
  realizar_ataque('Turno de ataque: jugador 2', tablero2);
end; 
if tablero_completo(tablero2) then
begin 
  clrscr; 
  writeln('El jugador 2 ha ganado!');
end;
 
//until (false);
{ Aca uso "false" como condicion para que el ciclo se detenga }
{ Esto quiere decir que no se va a detener nunca por si solo, porque }
{ No hay variables en la condicion que se modifiquen dentro del ciclo }
{ La unica forma de detener el ciclo es con un break; adentro (el que uso cuando un jugador gana) }
writeln; writeln('Presiona <enter> para continuar...');
readln;
end;
{ Y todo esto se va a repetir hasta que el jugador decida salir en el menu }
until (opcion = 0);
end.