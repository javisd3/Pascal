{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

{
Alumno: Javier San Martín Hurtado
1ºCurso 1ºCuatrimestre
Doble grado teleco y ade
}

program lecturaControlada;

const
  numFilas = 10;
  numColumnas = 10;
  MaxBarcos = 10;
  MaxDisparos = 10;
  MaxPalabra = 20;
  Esp: char = ' ';
  Tab: string = '   ';

type
  TipoPal = string;
  TipoPalabra = string[MaxPalabra];
  TipoNombre = (Submarino, Dragaminas, Fragata, Portaaviones, FIN);
  TipoOrientacion = (Horizontal, Vertical);

  TipoCasilla = record
    columna: integer;
    fila: integer;
  end;

  TipoDisparo = TipoCasilla;

  TipoBarco = record
    nombre: TipoNombre;
    proa: TipoCasilla;
    orientacion: TipoOrientacion;
    caracter: char;
  end;

  TipoBarcos = array[1..MaxBarcos] of TipoBarco;
  TipoDisparos = array[1..MaxDisparos] of TipoDisparo;

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

procedure leernombre(var fich: text; var nombre: TipoNombre; var ok: boolean);
var
  pal: TipoPal;
  pos: integer;
begin
  leerpalabra(fich, pal);
  val(pal, nombre, pos);
  ok := pos = 0;
end;

procedure leerorientacion(var fich: text; var orientacion: TipoOrientacion; var ok: boolean);
var
  pal: TipoPal;
  pos: integer;
begin
  leerpalabra(fich, pal);
  val(pal, orientacion, pos);
  ok := pos = 0;
end;

procedure letraANumero(pal: string; var c: integer; var ok: boolean);
begin
  if (length(pal) = 1) and (pal[1] in ['A'..'J']) then
  begin
    c := ord(pal[1]) - ord('A') + 1;
    ok := true;
  end
    else if not ok then begin
      writeln('Error al leer un barco');
  end;
end;

procedure leercolumna(var fich: text; var c: integer; var ok: boolean);
var
  pal: TipoPal;
  pos: integer;
begin
  leerpalabra(fich, pal);
  val(pal, c, pos);  
  if pos <> 0 then
    letraANumero(pal, c, ok)
end;

procedure leerfila(var fich: text; var f: integer; var ok: boolean);
var
  pal: TipoPal;
  pos: integer;
begin
  leerpalabra(fich, pal);
  val(pal, f, pos);
  ok := pos = 0;
end;

procedure leerproa(var fich: text; var barco: TipoBarco; var ok: boolean);
begin      
  leercolumna(fich, barco.proa.columna, ok);
  if ok then
    leerfila(fich, barco.proa.fila, ok);
end;

function longitudbarco(barco: TipoBarco): integer;
begin
  case barco.nombre of
    Submarino: longitudbarco := 1;
    Dragaminas: longitudbarco := 2;
    Fragata: longitudbarco := 3;
    Portaaviones: longitudbarco := 4;
  end;
end;

function InicialDelBarco(barco: TipoBarco): char;
begin
  case barco.nombre of
    Submarino: InicialDelBarco := 'S';
    Dragaminas: InicialDelBarco := 'D';
    Fragata: InicialDelBarco := 'F';
    Portaaviones: InicialDelBarco := 'P';
  end;
end;

procedure leerbarco(var fich: text; var barco: TipoBarco; var ok: boolean);
begin
  leernombre(fich, barco.nombre, ok);
  if ok and (barco.nombre <> FIN) then
  begin
    leerorientacion(fich, barco.orientacion, ok);
    if ok then
      leerproa(fich, barco, ok);
  end
  else begin
    ok := false;
  end;
end;

function ubicacionBarco(barco: TipoBarco; casilla: TipoCasilla): boolean;
begin
  if barco.orientacion = Horizontal then
    ubicacionBarco := (casilla.fila = barco.proa.fila) and
                      (casilla.columna >= barco.proa.columna) and
                      (casilla.columna <= barco.proa.columna + longitudbarco(barco) - 1)
  else
    ubicacionBarco := (casilla.columna = barco.proa.columna) and
                      (casilla.fila >= barco.proa.fila) and
                      (casilla.fila <= barco.proa.fila + longitudbarco(barco) - 1);
end;

procedure dibujartablero(Barcos: TipoBarcos; numBarcos: integer);
var
  casilla: TipoCasilla;
  i, fila, columna: integer;
  hayBarco: boolean;
begin
  for fila := 1 to numFilas do
  begin
    for columna := 1 to numColumnas do
    begin
      casilla.columna := columna;
      casilla.fila := fila;
      hayBarco := false;
      for i := 1 to numBarcos do
        if ubicacionBarco(Barcos[i], casilla) then
        begin
          hayBarco := true;
          write(InicialDelBarco(Barcos[i]), ' ');
          break;
        end;
      if not hayBarco then
        write('.', ' ');
    end;
    writeln;
  end;
end;

procedure leerDisparo(var fich: text; var disparo: TipoDisparo; var ok: boolean);
begin
  leercolumna(fich, disparo.columna, ok);
  if ok then
    leerfila(fich, disparo.fila, ok);
end;

procedure realizarDisparo(disparo: TipoDisparo; Barcos: TipoBarcos; numBarcos: integer);
var
  casilla: TipoCasilla;
  i: integer;
  tocado: boolean;
begin
  tocado := False;
  casilla := disparo;
  for i := 1 to numBarcos do
    if ubicacionBarco(Barcos[i], casilla) then
    begin
      tocado := True;
      writeln('Tocado');
    end;
  if not tocado then 
    writeln('Agua');
end;

procedure leerBarcos(var fich: text; var Barcos: TipoBarcos; var numBarcos: integer; var llegoFin: boolean);
var
  barco: TipoBarco;
  ok: boolean;
begin
  numBarcos := 0;
  llegoFin := false;
  while not eof(fich) do
  begin
    leerbarco(fich, barco, ok);
    if barco.nombre = FIN then
    begin
      llegoFin := true;
      break;
    end;
    if ok then
    begin
      numBarcos := numBarcos + 1;
      Barcos[numBarcos] := barco;
    end
    else if not ok then begin
      writeln('Error al leer un barco');
    end;
  end;
end;

procedure leerDisparos(var fich: text; var disparos: TipoDisparos; var numDisparos: integer; var hayDisparos: boolean);
var
  disparo: TipoDisparo; 
  ok: boolean;
begin
  numDisparos := 0;
  hayDisparos := false;
  while not eof(fich) do
  begin
    leerDisparo(fich, disparo, ok);
    if ok then
    begin
      hayDisparos := true;
      numDisparos := numDisparos + 1;
      disparos[numDisparos] := disparo;
    end
    else if not ok and (disparo.fila <> 0) then begin
      writeln('Error al leer un disparo');
    end;
  end;
end;

var
  fich: text;
  Barcos: TipoBarcos;
  disparos: TipoDisparos;
  numBarcos, numDisparos, i: integer;
  llegoFin, hayDisparos, puedeContinuar: boolean;

begin
  assign(fich, 'datos.txt');
  reset(fich);

  leerBarcos(fich, Barcos, numBarcos, llegoFin);
  puedeContinuar := llegoFin;

  if puedeContinuar then
  begin
    leerDisparos(fich, disparos, numDisparos, hayDisparos);
  end;

  close(fich);

  begin
    dibujartablero(Barcos, numBarcos);
    for i := 1 to numDisparos do
      realizarDisparo(disparos[i], Barcos, numBarcos);
  end;
end.

