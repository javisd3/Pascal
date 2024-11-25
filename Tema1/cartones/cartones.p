//leer, calcular media, ordenar y escribir
program cartones;

type 
    TCarton = record 
        color: array[1..3] of string; 
        numeros: array[1..3, 1..5] of integer; 
        media: real; 
    end;

var 
    cartones: array of TCarton;
    fichero: TextFile;
    i, j, k, numCartones: integer;


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
