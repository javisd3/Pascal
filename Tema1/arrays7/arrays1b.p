{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

{
Alumno: Javier San Martín Hurtado
1ºCurso 1ºCuatrimestre
Doble grado teleco y ade
}

program arrays;
var
    numFilas: integer;
    numColumnas: integer;
const
  MaxBarcos = 10;

type
  TipoEntrada = (Submarino, Dragaminas, Fragata, Portaaviones, FIN);
  TipoNombre = Submarino..Portaaviones;
  TipoOrientacion = (Horizontal, Vertical);
  TipoEstado = (Tocado, Hundido);

  TipoCasilla = record
    columna: integer;
    fila: integer;
  end;

  TipoBarco = record
    nombre: TipoNombre;
    proa: TipoCasilla;
    orientacion: TipoOrientacion;
    estado: TipoEstado;
    caracter: char;
  end;

  TipoBarcos = array[1..MaxBarcos] of TipoBarco;

function numeroALetra(num: integer): char;
begin
  if (num >= 1) and (num <= 26) then
    numeroALetra := chr(ord('A') + num - 1)
end;

function letraANumero(letra: char): integer;
begin
  if (letra >= 'A') and (letra <= 'Z') then
    letraANumero := ord(letra) - ord('A') + 1
end;

procedure leerDatos(var barco: TipoBarco; var hayBarco: boolean);
var
  entrada: TipoEntrada;
  proaChr: char;
begin
  hayBarco := false;
  readln(entrada);

  if entrada <> FIN then
  begin
    hayBarco := true;
    barco.nombre := entrada;

    readln(proaChr);
    barco.proa.columna := letraANumero(proaChr);
    readln(barco.proa.fila);

    readln(barco.orientacion);
    readln(barco.estado);
  end;
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
  popacolumna: integer;
  popafila: integer;
begin
  if barco.orientacion = Horizontal then
  begin
    popacolumna := barco.proa.columna + longitudbarco(barco) - 1;
    ubicacionBarco := (casilla.fila = barco.proa.fila) and
                        (casilla.columna >= barco.proa.columna) and
                        (casilla.columna <= popacolumna);
  end
  else
  begin
    popafila := barco.proa.fila + longitudbarco(barco) - 1;
    ubicacionBarco := (casilla.columna = barco.proa.columna) and
                        (casilla.fila >= barco.proa.fila) and
                        (casilla.fila <= popafila);
  end;
end;

procedure dibujartablero(miBarcos: TipoBarcos; numBarcos: integer);
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
        if ubicacionBarco(miBarcos[i], casilla) then
        begin
          hayBarco := true;
          if miBarcos[i].estado = Hundido then
            write('X', ' ')
          else
            write(InicialDelBarco(miBarcos[i]), ' ');
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
  miBarcos: TipoBarcos;
  numBarcos, numHundidos: integer;
  barco: TipoBarco;
  hayBarco: boolean;
begin
  numBarcos := 0;
  numHundidos := 0;

  writeln('Numero de filas');
  readln(numFilas);
  writeln('Numero de columnas');
  readln(numColumnas);

  repeat
    leerDatos(barco, hayBarco); 
    if hayBarco then
    begin
      numBarcos := numBarcos + 1;
      miBarcos[numBarcos] := barco;

      if barco.estado = Hundido then
        numHundidos := numHundidos + 1;
    end;
  until not hayBarco;

  writeln(numBarcos, ' barcos');
  writeln(numHundidos, ' hundidos');

  dibujartablero(miBarcos, numBarcos);
end.
