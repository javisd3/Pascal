program practfigs;

const
  numFilas = 10;
  numColumnas = 10;
  MaxBarcos = 10;
  Esp: char = ' ';
  Tab: string = '   ';

type
  TipoPal = string;
  TipoNombre = (Submarino, Dragaminas, Fragata, Portaaviones);
  TipoOrientacion = (Horizontal, Vertical);

  TipoCasilla = record
    columna: integer;
    fila: integer;
  end;

  TipoBarco = record
    nombre: TipoNombre;
    proa: TipoCasilla;
    orientacion: TipoOrientacion;
  end;

  TipoBarcos = array[1..MaxBarcos] of TipoBarco;

function esblanco(c: char): boolean;
begin
  esblanco := (c = Esp) or (c = Tab[1]);
end;

procedure addcar(var pal: TipoPal; c: char);
begin
  pal := pal + c;
end;

procedure leerpal(var fich: text; var pal: TipoPal);
var
  c: char;
begin
  pal := '';
  while not eof(fich) do
  begin
    read(fich, c);
    if not esblanco(c) then
    begin
      addcar(pal, c);
    end
    else if pal <> '' then
      exit;
  end;
end;

procedure leernombre(var fich: text; var nombre: TipoNombre; var ok: boolean);
var
  pal: TipoPal;
begin
  leerpal(fich, pal);
  case pal of
    'Submarino': nombre := Submarino;
    'Dragaminas': nombre := Dragaminas;
    'Fragata': nombre := Fragata;
    'Portaaviones': nombre := Portaaviones;
  else
    ok := false;
    exit;
  end;
  ok := true;
end;

procedure leerorientacion(var fich: text; var orientacion: TipoOrientacion; var ok: boolean);
var
  pal: TipoPal;
begin
  leerpal(fich, pal);
  if pal = 'Horizontal' then
    orientacion := Horizontal
  else if pal = 'Vertical' then
    orientacion := Vertical
  else
    ok := false;
  ok := true;
end;

procedure leerproa(var fich: text; var casilla: TipoCasilla; var ok: boolean);
var
  columna: char;
  fila: integer;
begin
  leerpal(fich, columna);
  leerpal(fich, fila);
  casilla.columna := ord(columna) - ord('A') + 1;
  casilla.fila := fila;
  ok := (casilla.columna >= 1) and (casilla.columna <= numColumnas) and
        (casilla.fila >= 1) and (casilla.fila <= numFilas);
end;

procedure leerbarco(var fich: text; var barco: TipoBarco; var ok: boolean);
begin
  leernombre(fich, barco.nombre, ok);
  if not ok then exit;
  leerproa(fich, barco.proa, ok);
  if not ok then exit;
  leerorientacion(fich, barco.orientacion, ok);
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

function ubicacionBarco(barco: TipoBarco; casilla: TipoCasilla): boolean;
var
  finalColumna, finalFila: integer;
begin
  if barco.orientacion = Horizontal then
  begin
    finalColumna := barco.proa.columna + longitudbarco(barco) - 1;
    ubicacionBarco := (casilla.fila = barco.proa.fila) and
                      (casilla.columna >= barco.proa.columna) and
                      (casilla.columna <= finalColumna);
  end
  else
  begin
    finalFila := barco.proa.fila + longitudbarco(barco) - 1;
    ubicacionBarco := (casilla.columna = barco.proa.columna) and
                      (casilla.fila >= barco.proa.fila) and
                      (casilla.fila <= finalFila);
  end;
end;

procedure dibujartablero(Barcos: TipoBarcos; numBarcos: integer);
var
  fila, columna, i: integer;
  casilla: TipoCasilla;
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
          write(InicialDelBarco(Barcos[i]), ' ');
          hayBarco := true;
          break;
        end;
      end;
      if not hayBarco then
        write('. ');
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
begin
  assign(fich, 'datos.txt');
  reset(fich);
  numBarcos := 0;

  while not eof(fich) do
  begin
    leerbarco(fich, barco, ok);
    if ok then
    begin
      numBarcos := numBarcos + 1;
      Barcos[numBarcos] := barco;
    end;
  end;

  close(fich);
  dibujartablero(Barcos, numBarcos);
end.
