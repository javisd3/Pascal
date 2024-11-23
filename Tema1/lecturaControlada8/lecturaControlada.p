program practfigs;
//primera coordenada tiene que ser letra
//error de entrada
// disapros
const
  numFilas = 10;
  numColumnas = 10;
  MaxBarcos = 10;
  Esp: char = ' ';
  Tab: string = '   ';

type
  TipoPal = string;
  TipoEntrada = (FIN);  
  TipoNombre = (Submarino, Dragaminas, Fragata, Portaaviones);
  TipoOrientacion = (Horizontal, Vertical);

  TipoCasilla = record
    columna: integer;
    fila: integer;
  end;

  TipoDisparo = record
    columna: integer;
    fila: integer;
  end;

  TipoBarco = record
    nombre: TipoNombre;
    proa: TipoCasilla;
    orientacion: TipoOrientacion;
    caracter: char;
  end;

  TipoBarcos = array[1..MaxBarcos] of TipoBarco;

function esblanco(c: char): boolean;
begin
  esblanco := (c = Esp) or (c = Tab);  
end;

procedure addcar(var pal: TipoPal; c: char);
var
  n: integer;
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
      haypal := not esblanco(c);
      if haypal then begin
        addcar(pal, c);
      end;
    end;
  end;
  while haypal and not eof(fich) and not eoln(fich) do begin
    read(fich, c);
    haypal := not esblanco(c);
    if haypal then begin
      addcar(pal, c);
    end;
  end;
end;

procedure leernombre(var fich: text; var nombre: TipoNombre; var ok: boolean);
var
  pal: TipoPal;
  pos: integer;
begin
  leerpal(fich, pal);
  val(pal, nombre, pos);
  ok := pos = 0;
end;

procedure leerorientacion(var fich: text; var orientacion: TipoOrientacion; var ok: boolean);
var
  pal: TipoPal;
  pos: integer;
begin
  leerpal(fich, pal);
  val(pal, orientacion, pos);
  ok := pos = 0;
end;

procedure leercolumna(var fich: text; var x: integer; var ok: boolean);
var
  pal: TipoPal;
  pos: integer;
  
begin
  leerpal(fich, pal);
  val(pal, x, pos);
  ok := pos = 0;
end;

procedure leerfila(var fich: text; var f: integer; var ok: boolean);
var
  pal: TipoPal;
  pos: integer;
begin
  leerpal(fich, pal);
  val(pal, f, pos);
  ok := pos = 0;
end;

procedure leerproa(var fich: text; var barco: TipoBarco; var ok: boolean);
begin
  leercolumna(fich, barco.proa.columna, ok);
  if ok then begin
    leerfila(fich, barco.proa.fila, ok);
  end;
end;

function letraANumero(letra: char): integer;
begin
  if (letra >= 'A') and (letra <= 'Z') then
    letraANumero := ord(letra) - ord('A') + 1
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
  leerNombre(fich, barco.nombre, ok);
  if ok then begin
    leerorientacion(fich, barco.orientacion, ok);
    if ok then begin
      leerproa(fich, barco, ok);
    end;
  end;
end;

function ubicacionBarco(barco: TipoBarco; casilla: TipoCasilla): boolean;
var
  procolumna: integer;
  proafila: integer;
begin
  if barco.orientacion = Horizontal then
  begin
    procolumna := barco.proa.columna + longitudbarco(barco) - 1;
    ubicacionBarco :=   (casilla.fila = barco.proa.fila) and
                        (casilla.columna >= barco.proa.columna) and
                        (casilla.columna <= procolumna);
  end
  else
  begin
    proafila := barco.proa.fila + longitudbarco(barco) - 1;
    ubicacionBarco :=   (casilla.columna = barco.proa.columna) and
                        (casilla.fila >= barco.proa.fila) and
                        (casilla.fila <= proafila);
  end;
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
      begin
        if ubicacionBarco(Barcos[i], casilla) then
        begin
          hayBarco := true;
          write(InicialDelBarco(Barcos[i]), ' ');
        end;
      end;

      if not hayBarco then
        write('.', ' ');
    end;
    writeln;
  end;
end;

var
  fich: text;
  Barcos: TipoBarcos;
  numBarcos: integer;
  barco: TipoBarco;
  ok: boolean;
  entrada: string;
begin
  assign(fich, 'datos.txt');
  reset(fich);
  numBarcos := 0;

  while not eof(fich) do
  begin
    leerpal(fich, entrada);  
    if entrada <> 'FIN' then
    begin
      leerbarco(fich, barco, ok);
      if ok then
      begin
        numBarcos := numBarcos + 1;
        Barcos[numBarcos] := barco;
      end;
    end;
  end;

  close(fich);

  dibujartablero(Barcos, numBarcos);
end.