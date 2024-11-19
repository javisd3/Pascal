{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

{
Alumno: Javier San Martín Hurtado
1ºCurso 1ºCuatrimestre
Doble grado teleco y ade
}

program Arrays;

const
    MaxBarcos = 10;
    MaxFilas = 20;
    MaxColumnas = 20;

type
    TipoBarco = (Submarino, Dragaminas, Fragata, PortaAviones);
    TipoOrientacion = (Horizontal, Vertical);
    TipoEstado = (Tocado, Hundido);
    TipoCasilla = record
        f: integer;
        c: char;
    end;
    TipoBarcoTotal = record
        barco: TipoBarco;
        orientacion: TipoOrientacion;
        proa: TipoCasilla;
        estado: TipoEstado;
    end;
    TipoTablero = array[1..MaxFilas * MaxColumnas] of char; // Array unidimensional
    TipoFlota = array[1..MaxBarcos] of TipoBarcoTotal;

var
    Tablero: TipoTablero;
    Flota: TipoFlota;
    Filas, Columnas, NumBarcos: integer;
    NumHundidos: integer;

function posicion(f: integer; c: char; columnas: integer): integer;
begin
    posicion := (f - 1) * columnas + (ord(c) - ord('A') + 1);
end;

procedure InicializarTablero(var T: TipoTablero; filas, columnas: integer);
var
    i: integer;
begin
    for i := 1 to filas * columnas do
        T[i] := '.';
end;

procedure LeerFlota(var Flota: TipoFlota; var NumBarcos: integer);
var
    i: integer;
    tipoBarco: string;
begin
    NumBarcos := 0;
    i := 1;

    while i <= MaxBarcos do
    begin
        writeln('Tipo de barco (Submarino, Dragaminas, Fragata, PortaAviones):');
        readln(tipoBarco);

        if tipoBarco = 'FIN' then
        begin
            NumBarcos := i - 1;  
            Break;
        end;

        if tipoBarco = 'Submarino' then
            Flota[i].barco := Submarino
        else if tipoBarco = 'Dragaminas' then
            Flota[i].barco := Dragaminas
        else if tipoBarco = 'Fragata' then
            Flota[i].barco := Fragata
        else
            Flota[i].barco := PortaAviones;

        writeln('Orientacion:');
        readln(Flota[i].orientacion);
        
        writeln('Columna de la proa:');
        readln(Flota[i].proa.c);

        writeln('Fila de la proa:');
        readln(Flota[i].proa.f);

        writeln('Estado del barco:');
        readln(Flota[i].estado);

        i := i + 1;
    end;
end;

function CasillasBarco(barco: TipoBarco): integer;
begin
    case barco of
        Submarino: CasillasBarco := 1;
        Dragaminas: CasillasBarco := 2;
        Fragata: CasillasBarco := 3;
        PortaAviones: CasillasBarco := 4;
    end;
end;

function InicialDelBarco(barco: TipoBarco): char;
begin
    case barco of
        Submarino: InicialDelBarco := 'S';
        Dragaminas: InicialDelBarco := 'D';
        Fragata: InicialDelBarco := 'F';
        PortaAviones: InicialDelBarco := 'P';
    end;
end;

procedure ColocarBarco(var T: TipoTablero; Barco: TipoBarcoTotal; columnas: integer);
var
    i, longitud, pos: integer;
    f: integer;
    c: char;
    inicial: char;
begin
    longitud := CasillasBarco(Barco.barco);
    f := Barco.proa.f;
    c := Barco.proa.c;
    inicial := InicialDelBarco(Barco.barco);  

    for i := 0 to longitud - 1 do
    begin
        if Barco.orientacion = Horizontal then
            pos := posicion(f, chr(ord(c) + i), columnas)
        else
            pos := posicion(f + i, c, columnas);

        if Barco.estado = Tocado then
            T[pos] := inicial
        else
            T[pos] := 'x';
    end;
end;

procedure ColocarFlota(var T: TipoTablero; Flota: TipoFlota; NumBarcos: integer; var NumHundidos: integer; columnas: integer);
var
    i: integer;
begin
    NumHundidos := 0;
    for i := 1 to NumBarcos do
    begin
        ColocarBarco(T, Flota[i], columnas);
        if Flota[i].estado = Hundido then
            NumHundidos := NumHundidos + 1;
    end;
end;

procedure MostrarTablero(T: TipoTablero; filas, columnas: integer);
var
    f, c, pos: integer;
begin
    for f := 1 to filas do
    begin
        for c := 1 to columnas do
        begin
            pos := (f - 1) * columnas + c;
            write(T[pos], ' ');
        end;
        writeln;
    end;
end;

begin
    writeln('Numero de filas del tablero:');
    readln(Filas);
    writeln('Numero de columnas del tablero:');
    readln(Columnas);

    InicializarTablero(Tablero, Filas, Columnas);

    LeerFlota(Flota, NumBarcos);
    ColocarFlota(Tablero, Flota, NumBarcos, NumHundidos, Columnas);

    writeln(NumBarcos, ' barcos');
    writeln(NumHundidos, ' hundidos');

    MostrarTablero(Tablero, Filas, Columnas);
end.
