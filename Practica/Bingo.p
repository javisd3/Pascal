{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program bingo;

const
  MaxCartones = 10;
  MaxPalabra = 20;
  Esp: char = ' ';
  Tab: string = '   ';
  FIN = 'FIN';

type
  TipoPal = string;
  TipoColor = (rojo, verde, azul, amarillo);
  TipoNumero = 1..100;  

  TipoFila = record
    Color: TipoColor;
    Numeros: array[1..5] of TipoNumero;
  end;

  TipoCarton = record
    Filas: array[1..3] of TipoFila;
  end;
  
function espacios(c: char): boolean;
begin
  espacios := (c = Esp) or (c = Tab);  
end;

procedure addCaracter(var pal: TipoPal; c: char);
var
  n: Integer;
begin
  n := length(pal);
  n := n + 1;
  setlength(pal, n);
  pal[n] := c;
end;

procedure borrar(var pal: TipoPal);
begin
  pal := '';
end;

procedure leerpalabra(var fich: text; var pal: TipoPal);
var
  haypalabra: boolean;
  c: char;
begin
  haypalabra := false;
  borrar(pal);

  while (not eof(fich)) and (not haypalabra) do
  begin
    if eoln(fich) then
      readln(fich)
    else
    begin
      read(fich, c);
      if not espacios(c) then
      begin
        haypalabra := true;
        addCaracter(pal, c);
      end;
    end;
  end;

  while (haypalabra) and (length(pal) <> MaxPalabra) do
  begin
    if (eof(fich)) or (eoln(fich)) then
      haypalabra := false
    else
    begin
      read(fich, c);
      if not espacios(c) then
        addCaracter(pal, c)
      else
        haypalabra := false;
    end;
  end;
end;

procedure leercolor(var fich: text; var color: TipoColor; var ok: boolean);
var
  pal: TipoPal;
  pos: Integer;
begin
  leerpalabra(fich, pal);
  val(pal, color, pos);
  ok := pos = 0;
end;

procedure leernumero(var fich: Text; var numero: TipoNumero; var ok: Boolean);
var
  pal: TipoPal;
  pos: Integer;
  num: Integer;
begin
  leerpalabra(fich, pal);
  Val(pal, num, pos);
  ok := (pos = 0) and (num in [1..100]);
  if ok then
    numero := num;
end;

procedure leerfila(var fich: text; var fila: TipoFila; var ok: boolean);
var
  i: Integer;
begin
  leercolor(fich, fila.Color, ok);  
  if ok then begin
    for i := 1 to 5 do begin  
      leernumero(fich, fila.Numeros[i], ok);
      if not ok then
        break; 
    end;
  end;
end;

procedure leerCarton(var fich: text; var carton: TipoCarton; var ok: boolean);
var
  i: Integer;
begin
  ok := True;
  for i := 1 to 3 do begin
    leerfila(fich, carton.Filas[i], ok);
    if not ok then begin
      while not eoln(fich) do readln(fich); 
      break;
    end;
  end;
end;

procedure escribirCarton(carton: TipoCarton);
var
  i, j: Integer;
begin
  for i := 1 to 3 do begin
    write(carton.Filas[i].Color, ' ');
    for j := 1 to 5 do begin
      write(carton.Filas[i].Numeros[j], ' ');
    end;
    writeln;
  end;
  writeln;
end;

procedure ordenarNumeros(var fila: TipoFila);
var
  i, j, num: Integer;
begin
  for i := 1 to 4 do begin
    for j := i + 1 to 5 do begin
      if fila.Numeros[i] > fila.Numeros[j] then begin
        num := fila.Numeros[i];
        fila.Numeros[i] := fila.Numeros[j];
        fila.Numeros[j] := num;
      end;
    end;
  end;
end;

procedure asignarCartonAJugador(var fich: TextFile; var ListaCartones: array of TipoCarton; var numCartones: Integer; var jugadorActual: Integer);
var
  palabra: TipoPal;
  ok: Boolean;
begin
  leerCarton(fich, ListaCartones[numCartones + 1], ok);
  if ok then
  begin
    numCartones := numCartones + 1;
    writeln('Jugador ', jugadorActual, ', Carton ', numCartones, ':');
    escribirCarton(ListaCartones[numCartones]);
    leerpalabra(fich, palabra);
    if palabra = FIN then
    begin
      numCartones := 0;
      if jugadorActual < 3 then
        jugadorActual := jugadorActual + 1;
    end;
  end;
end;

var
  ListaCartones: array[1..MaxCartones] of TipoCarton;  
  numCartones: Integer;
  fich: TextFile;
  jugadorActual: Integer;
begin
  assign(fich, 'datos.txt');
  reset(fich);
  numCartones := 0;
  jugadorActual := 1;

  while not eof(fich) and (numCartones < MaxCartones) do
  begin
    asignarCartonAJugador(fich, ListaCartones, numCartones, jugadorActual);
  end;
  
  close(fich);
end.