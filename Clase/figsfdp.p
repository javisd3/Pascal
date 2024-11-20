{$mode objfpc}{$H-}{$R+}{$T+}{$I+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

{
	Jugar con EOLN
	fpc -g -oa.out $% &&  a.out < datos.txt
}

program practfigs;

const
	Esp: char = ' ';
	Tab: char = '	';

	AnchoIni: integer = 10;
	AltoIni: integer = 10;
	PapelIni: char = '.';

	MaxCmds = 100;

type
	TipoPal = string;

	TipoTam = record
		x, y: integer;
	end;

	TipoInstr = (Punto, Rectangulo, Linea, Papel,
			AlReves, Borrar, Mover, Pantalla);

	TipoPos = record
		x,y: integer;
	end;

	TipoCmdPt = record
		car: char;
		pos: TipoPos;
	end;

	TipoCmdRect = record
		car: char;
		nw: TipoPos;
		se: TipoPos;
	end;

	TipoCmd = record
		instr: TipoInstr;
		pt: TipoCmdPt;
		rect: TipoCmdRect;
	end;

	TipoPant = record
		tam: TipoTam;
		papel: char;
	end;
	TipoArryCmds = array[1..MaxCmds] of TipoCmd;
	TipoCmds = record
		ncmds: integer;
		cmds: TipoArryCmds;
	end;
	TipoDib = record
		pant: TipoPant;
		figs: TipoCmds;
	end;


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

{si no hay pals, pal queda vacia }
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

procedure leerinstr(var fich: text; var instr: TipoInstr; var ok: boolean);
var
	pal: TipoPal;
	pos: integer;
begin
	leerpal(fich, pal);
	val(pal, instr, pos);
	ok := pos = 0;
end;

procedure leernum(var fich: text; var n: integer; var ok: boolean);
var
	pal: TipoPal;
	pos: integer;
begin
	leerpal(fich, pal);
	val(pal, n, pos);
	ok := pos = 0;
end;

procedure leercar(var fich: text; var c: char; var ok: boolean);
var
	pal: TipoPal;
begin
	leerpal(fich, pal);
	ok := length(pal) = 1;
	if ok then begin
		c := pal[1];
	end;
end;

procedure leerpos(var fich: text; var pos: TipoPos; var ok: boolean);
begin
	leernum(fich, pos.x, ok);
	if ok then begin
		leernum(fich, pos.y, ok);
	end;
end;

procedure leercmdpt(var fich: text; var pt: TipoCmdPt; var ok: boolean);
begin
	leercar(fich, pt.car, ok);
	if ok then begin
		leerpos(fich, pt.pos, ok);
	end;
end;
procedure leercmdrect(var fich: text; var rect: TipoCmdRect; var ok: boolean);
begin
	leercar(fich, rect.car, ok);
	if ok then begin
		leerpos(fich, rect.nw, ok);
	end;
	if ok then begin
		leerpos(fich, rect.se, ok);
	end;
end;

procedure leercmd(var fich: text; var cmd: TipoCmd; var ok: boolean);
begin
	leerinstr(fich, cmd.instr, ok);
	if ok then begin
		case cmd.instr of
		Punto:
			leercmdpt(fich, cmd.pt, ok);
		Rectangulo:
			leercmdrect(fich, cmd.rect, ok);
		end;
	end;
end;

procedure escrpos(pos: TipoPos);
begin
	write('[', pos.x, ',', pos.y, ']');
end;

procedure escrcmdpt(pt: TipoCmdPt);
begin
	write(' <', pt.car, '> ');
	escrpos(pt.pos);
end;

procedure escrcmdrect(rect: TipoCmdRect);
begin
	write(' <', rect.car, '> ');
	escrpos(rect.nw);
	write(' ');
	escrpos(rect.se);
end;

procedure escrcmd(cmd: TipoCmd);
begin
	write(cmd.instr);
	case cmd.instr of
	Punto:
		escrcmdpt(cmd.pt);
	Rectangulo:
		escrcmdrect(cmd.rect);
	end;
	writeln();
end;

procedure iniccmds(var cmds: TipoCmds);
begin
	cmds.ncmds := 0;
end;

procedure inicpant(var pant: TipoPant);
begin
	pant.tam.x := AnchoIni;
	pant.tam.y := AltoIni;
	pant.papel := PapelIni;
end;

procedure dibujarpant(pant: TipoPant);
var
	i, j: integer;
begin
	for i := 1 to pant.tam.y do begin
		for j := 1 to pant.tam.x do begin
			write(' ', pant.papel);
		end;
		writeln();
	end;
end;

procedure inicdib(var dib: TipoDib);
begin
	inicpant(dib.pant);
	iniccmds(dib.figs);
end;

procedure execmd(var dib: TipoDib; cmd: TipoCmd);
begin
	escrcmd(cmd);
end;

procedure dibujar(dib: TipoDib);
begin
	dibujarpant(dib.pant);
end;

var
	fich: text;
	dib: TipoDib;
	cmd: TipoCmd;
	ok: boolean;
	instr: TipoInstr;
begin
	assign(fich, 'datos.txt');
	reset(fich);
	inicdib(dib);
	while not eof(fich) do begin
		leercmd(fich, cmd, ok);
		if ok then begin
			execmd(dib, cmd);
			dibujar(dib);
		end;
	end;
	close(fich);
end.
