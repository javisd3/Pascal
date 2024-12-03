{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}
{
Alumno: Javier San Martín Hurtado
1ºCurso 1ºCuatrimestre
}

program cartones;

const
  MaxCartones = 10;
  Esp: char = ' ';
  Tab: string = '   ';
  FIN = 'FIN';

type
  TipoPal = string;
  TipoColor = (rojo, verde, azul, amarillo);
  TipoNumero = 1..100;  
  TipoJugador = array[1..3] of TipoCarton;  

  TipoFila = record
    Color: TipoColor;
    Numeros: array[1..5] of TipoNumero;
  end;

  TipoCarton = record
    Filas: array[1..3] of TipoFila;
  end;
  
var
  ListaCartones: array[1..MaxCartones] of TipoCarton;  
  numCartones: Integer;
  fich: TextFile;
  ok: Boolean;
  i, j: Integer;
  jugador: Integer; 

function espacios(c: char): boolean;
begin
  espacios := (c = Esp) or (c = Tab);  
end;

procedure addcar(var pal: TipoPal; c: char);
var
  n: Integer;
begin
  n := length(pal);
  n := n + 1;
  setlength(pal, n);
  pal[n] := c;
end;

procedure leerpal(var fich: text; var pal: TipoPal);
var
  c: char;
  haypal: boolean;
begin
  haypal := False;
  pal := '';
  while not eof(fich) and not haypal do begin
    if eoln(fich) then begin
      readln(fich);
    end
    else begin
      read(fich, c);
      haypal := not espacios(c);
      if haypal then begin
        addcar(pal, c);
      end;
    end;
  end;
  while haypal and not eof(fich) and not eoln(fich) do begin
    read(fich, c);
    haypal := not espacios(c);
    if haypal then begin
      addcar(pal, c);
    end;
  end;
end;

procedure leercolor(var fich: text; var color: TipoColor; var ok: boolean);
var
  pal: TipoPal;
  pos: Integer;
begin
  leerpal(fich, pal);
  val(pal, color, pos);
  ok := pos = 0;
end;

procedure leernumero(var fich: Text; var numero: TipoNumero; var ok: Boolean);
var
  pal: TipoPal;
  pos: Integer;
  num: Integer;
begin
  leerpal(fich, pal);
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
    if pal = FIN then begin
    jugador := jugador + 1
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

begin
  assign(fich, 'datos.txt');
  reset(fich);
  numCartones := 0;
  jugador := 1; 
  
  while not eof(fich) and (numCartones < MaxCartones) do
  begin
    leerCarton(fich, ListaCartones[numCartones + 1], ok);
    if ok then
      numCartones := numCartones + 1;
    end;
  end;
  close(fich);

  for i := 1 to jugador do begin
    writeln('Jugador ', i, ':');
    for j := 1 to numCartones do
    begin
      escribirCarton(ListaCartones[j]);
    end;
  end;
end.
