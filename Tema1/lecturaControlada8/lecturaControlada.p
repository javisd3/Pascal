program practfigs;
   
const
  numFilas = 10;
  numColumnas = 10;
  MaxBarcos = 10;
  Esp: char = ' ';
	Tab: char = '   ';

type
  TipoPal = string;
  TipoEntrada = (Submarino, Dragaminas, Fragata, Portaaviones, FIN);
  TipoNombre = Submarino..Portaaviones;
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
	result := (c = Esp) or (c = Tab);
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

procedure leerhorientacion(var fich: text; var horientacion: TipoOrientacion; var ok: boolean);
var
	pal: TipoPal;
	pos: integer;
begin
	leerpal(fich, pal);
	val(pal, horientacion, pos);
	ok := pos = 0;
end;

procedure leercolumna(var fich: text; var c: char; var ok: boolean);
var
	pal: TipoPal;
	pos: integer;
begin
	leerpal(fich, pal);
	val(pal, c, pos);
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

procedure leerpos(var fich: text; var casilla: TipoCasilla; var ok: boolean);
begin
	leercolumna(fich, casilla.columna, ok);
	if ok then begin
		leerfila(fich, casilla.fila, ok);
	end;
end;

function letraANumero(c: char): integer;
begin
  if (c >= 'A') and (c <= 'Z') then
    letraANumero := ord(c) - ord('A') + 1
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

procedure dibujartablero(Barcos: TipoBarcos; numBarcos: integer);
var
  casilla: TipoCasilla;
  i: integer;
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
      end;

      if not hayBarco then
        write('.', ' ');
    end;
    writeln;
  end;
end;

var
  Barcos: TipoBarcos;
  barco: TipoBarco;
  hayBarco: boolean;
begin

  repeat
    leerDatos(barco, hayBarco);
    dibujartablero(Barcos, numBarcos);
end.