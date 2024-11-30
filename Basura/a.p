{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}
program e8;

const
	MinColumna = 'A';
	MaxColumna = 'J';
	MinFila = 1;
	MaxFila = 10;
	MaxBarcos = 100;
	MaxPalabra = 15;

type
	TipoEntrada = (Submarino, Dragaminas, Fragata, PortaAviones, Fin);
	TipoNombre = Submarino..PortaAviones;
	TipoOrientacion = (Horizontal, Vertical);
	TipoColumna = MinColumna..MaxColumna;
	TipoFila = MinFila..MaxFila;
	TipoCasilla = record
		columna: TipoColumna;
		fila: TipoFila;
	end;
	TipoBarco = record
		nombre: TipoNombre;
		orientacion: TipoOrientacion;
		proa: TipoCasilla; {TipoProa}
	end;

	TipoBarcos = array[1..MaxBarcos] of TipoBarco;

	TipoFlota = record
		barcos: TipoBarcos;
		numbarcos: integer;
	end;

	TipoDisparo = TipoCasilla;

	TipoPalabra = string[MaxPalabra];

	TipoQueLeo = (Bien, Mal, Delimitador, FinFichero);

	TipoResultadoDisparo = (Tocado, Agua);

procedure vaciarpalabra(var palabra: TipoPalabra);
begin
	setlength(palabra, 0); {palabra := '';}
end;

function esblanco(c: char): boolean;
begin
	result := (c = ' ') or (c = '	');
end;

procedure agregarcaracter(var palabra: TipoPalabra; c: char);
var
	n: integer;
begin
	n := length(palabra);
	n := n + 1;
	setlength(palabra, n);
	palabra[n] := c;
end;

procedure leerpalabra(var fichero: text; var palabra: TipoPalabra);
var
	haypalabra: boolean;
	c: char;
begin
	haypalabra := false;

	vaciarpalabra(palabra);
	while (not eof(fichero)) and (not haypalabra) do begin
		if eoln(fichero) then begin
			readln(fichero);
		end
		else begin
			read(fichero, c);
			haypalabra := not esblanco(c);
		end;
	end;

	while (haypalabra) and (length(palabra) <> MaxPalabra) do begin
		agregarcaracter(palabra, c);
		if (eof(fichero)) or (eoln(fichero)) then begin
			haypalabra := false;
		end
		else begin
			read(fichero, c);
			haypalabra := not esblanco(c);
		end;
	end;
end;

procedure leernombre(var fichero: text; var nombre: TipoNombre; var que: TipoQueLeo);
var
	palabra: TipoPalabra;
	entrada: TipoEntrada;
	resultado: integer;
begin
	leerpalabra(fichero, palabra);
	if palabra = '' then begin
		que := FinFichero;
	end
	else begin
		val(palabra, entrada, resultado);
		if resultado = 0 then begin
			if entrada <> Fin then begin
				que := Bien;
				nombre := entrada;
			end
			else begin
				que := Delimitador;
			end;
		end
		else begin
			que := Mal;
		end;
	end;
end;

procedure leerorientacion(var fichero: text; var orientacion: TipoOrientacion; var que: TipoQueLeo);
var
	palabra: TipoPalabra;
	resultado: integer;
begin
	leerpalabra(fichero, palabra);
	if palabra = '' then begin
		que := FinFichero;
	end
	else begin
		val(palabra, orientacion, resultado);
		if resultado = 0 then begin
			que := Bien;
		end
		else begin
			que := Mal;
		end;
	end;
end;

function escolumnaok(c: char): boolean;
begin
	result := (c >= MinColumna) and (c <= MaxColumna);
end;

procedure leercolumna(var fichero: text; var columna: TipoColumna; var que: TipoQueLeo);
var
	palabra: TipoPalabra;
begin
	leerpalabra(fichero, palabra);
	if palabra = '' then begin
		que := FinFichero;
	end
	else begin
		if (length(palabra) = 1) and (escolumnaok(palabra[1])) then begin
			que := Bien;
			columna := palabra[1];
		end
		else begin
			que := Mal;
		end;
	end;
end;

function esfilaok(n: integer): boolean;
begin
	result := (n >= MinFila) and (n <= MaxFila);
end;

procedure leerfila(var fichero: text; var fila: TipoFila; var que: TipoQueLeo);
var
	palabra: TipoPalabra;
	n, resultado: integer;
begin
	leerpalabra(fichero, palabra);
	if palabra = '' then begin
		que := FinFichero;
	end
	else begin
		val(palabra, n, resultado);
		if (resultado = 0) and (esfilaok(n)) then begin
			que := Bien;
			fila := n;
		end
		else begin
			que := Mal;
		end;
	end;
end;

procedure leercasilla(var fichero: text; var casilla: TipoCasilla; var que: TipoQueLeo);
begin
	leercolumna(fichero, casilla.columna, que);
	if que = Bien then begin
		leerfila(fichero, casilla.fila, que);
	end;
end;

procedure leerbarco(var fichero: text; var barco: TipoBarco; var que: TipoQueLeo);
begin
	leernombre(fichero, barco.nombre, que);
	if que = Bien then begin
		leerorientacion(fichero, barco.orientacion, que);
	end;
	if que = Bien then begin
		leercasilla(fichero, barco.proa, que);
	end;
end;

procedure agregarbarco(var flota: TipoFlota; barco: TipoBarco);
begin
	flota.numbarcos := flota.numbarcos + 1;
	flota.barcos[flota.numbarcos] := barco;
end;

procedure leerflota(var fichero: text; var flota: TipoFlota; var hayfinfichero: boolean);
var
	barco: TipoBarco;
	que: TipoQueLeo;
begin
	hayfinfichero := false;

	flota.numbarcos := 0;
	repeat
		leerbarco(fichero, barco, que);
		if que = Bien then begin
			agregarbarco(flota, barco);
		end
		else if que = Mal then begin
			writeln('error en la entrada');
		end
		else if que = FinFichero then begin
			hayfinfichero := true;
		end;
	until (que = Delimitador) or (hayfinfichero) or (flota.numbarcos = MaxBarcos);
end;

function longitudbarco(barco: TipoBarco): integer;
begin
	case barco.nombre of
	Submarino: result := 1;
	Dragaminas: result := 2;
	Fragata: result := 3;
	PortaAviones: result := 4;
	end;
end;

function estaubicadoen(barco: TipoBarco; casilla: TipoCasilla): boolean;
var
	columnapopa: char;
	filapopa: integer;
begin
	if barco.orientacion = Horizontal then begin
		columnapopa := chr(ord(barco.proa.columna) + longitudbarco(barco) - 1);
		result := (barco.proa.fila = casilla.fila) and 
			((casilla.columna >= barco.proa.columna) and (casilla.columna <= columnapopa));
	end
	else begin
		filapopa := barco.proa.fila + longitudbarco(barco) - 1;
		result := (barco.proa.columna = casilla.columna) and
			((casilla.fila >= barco.proa.fila) and (casilla.fila <= filapopa));
	end;
end;

procedure formaparte(flota: TipoFlota; casilla: TipoCasilla; var encontrado: boolean; var barco: TipoBarco);
var
	i: integer;
begin
	encontrado := false;
	i := 1;
	while (not encontrado) and (i <= flota.numbarcos) do begin
		if estaubicadoen(flota.barcos[i], casilla) then begin
			encontrado := true;
			barco := flota.barcos[i];
		end;
		i := i + 1;
	end;
end;

function inicialbarco(barco: TipoBarco): char;
begin
	case barco.nombre of
	Submarino: result := 'S';
	Fragata: result := 'F';
	Dragaminas: result := 'D';
	PortaAviones: result := 'P';
	end;
end;

procedure dibujarbarco(barco: TipoBarco);
begin
	write(inicialbarco(barco));
end;

procedure dibujartablero(flota: TipoFlota);
var
	fila: integer;
	columna: char;
	casilla: TipoCasilla;
	encontrado: boolean;
	barco: TipoBarco;
begin
	for fila := MinFila to MaxFila do begin
		for columna := MinColumna to MaxColumna do begin
			casilla.columna := columna;
			casilla.fila := fila;
			formaparte(flota, casilla, encontrado, barco);
			if encontrado then begin
				dibujarbarco(barco);
			end
			else begin
				write('.');
			end;
		end;
		writeln;
	end;
end;

{
procedure leerdisparo(var disparo: TipoDisparo; var que: TipoQueLeo);
begin
	leercolumna(disparo.columna, que);
	if que = Bien then begin
		leerfila(disparo.fila, que);
	end;
end;
}

function disparar(flota: TipoFlota; disparo: TipoDisparo): TipoResultadoDisparo;
var
	i: integer;
	encontrado: boolean;
begin
	encontrado := false;
	i := 1;
	while (not encontrado) and (i <= flota.numbarcos) do begin
		if estaubicadoen(flota.barcos[i], disparo) then begin
			encontrado := true;
		end;
		i := i + 1;
	end;

	if encontrado then begin
		result := Tocado;
	end
	else begin
		result := Agua;
	end;
end;

procedure jugar(var fichero: text; flota: TipoFlota);
var
	disparo: TipoDisparo;
	que: TipoQueLeo;
begin
	repeat
		leercasilla(fichero, disparo, que);
		if que = Bien then begin
			writeln(disparar(flota, disparo));
			{
			if disparar(flota, disparo) then begin
				writeln('tocado');
			end
			else begin
				writeln('agua');
			end;
			}
			{
			formaparte(flota, disparo, encontrado, barco);
			if encontrado then begin
				writeln('tocado');
			end
			else begin
				writeln('agua');
			end;
			}
		end
		else if que = Mal then begin
			writeln('error en la entrada');
		end;
	until que = FinFichero;
end;

var
	fichero: text;
	flota: TipoFlota;
	hayfinfichero: boolean;
begin
	assign(fichero, 'datos.txt');
	reset(fichero);
	leerflota(fichero, flota, hayfinfichero);
	dibujartablero(flota);
	if not hayfinfichero then begin
		jugar(fichero, flota);
	end;
	close(fichero);
end.













