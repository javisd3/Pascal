program lecturaControlada;

var
    numFilas: integer;
    numColumnas: integer;
const
  MaxBarcos = 10;

type
  TipoEntrada = (Submarino, Dragaminas, Fragata, Portaaviones, FIN);
  TipoNombre = Submarino..Portaaviones;
  TipoOrientacion = (Horizontal, Vertical);

  TipoCasilla = record
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

procedure leerbarco(var fich: text; var barco: Tipobarco; var ok: boolean);
var
	pal: TipoPal;
begin
	leerpal(fich, pal);
	val(pal, instr, pos);
	ok := pos = 0;
end;

procedure dibujartablero(Barcos: TipoBarcos; numBarcos: integer);
var
  fila: integer;
  columna: integer;
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
          break;
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
    if hayBarco then
    begin
      numBarcos := numBarcos + 1;
      Barcos[numBarcos] := barco;
    end;
  until not hayBarco;

  dibujartablero(Barcos, numBarcos);
end.