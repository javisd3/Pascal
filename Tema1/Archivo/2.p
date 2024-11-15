program juego_barcos_archivo;

const
    MaxFilas = 10;
    MaxColumnas = 10;
    MaxBarcos = 10;

type
    TipoBarco = (Submarino, Dragaminas, Fragata, PortaAviones);
    TipoOrientacion = (Horizontal, Vertical);
    TipoEstado = (Intacto, Tocado, Hundido);
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
    TipoTablero = array[1..MaxFilas, 'A'..'J'] of char;
    TipoFlota = array[1..MaxBarcos] of TipoBarcoTotal;

var
    Tablero: TipoTablero;
    Flota: TipoFlota;
    NumBarcos: integer;
    NumHundidos: integer;
    entrada, salida: Text;

procedure InicializarTablero(var T: TipoTablero);
var
    f: integer;
    c: char;
begin
    for f := 1 to MaxFilas do
        for c := 'A' to 'J' do
            T[f, c] := '.';
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

procedure LeerFlota(var Flota: TipoFlota; var NumBarcos: integer);
var
    tipoBarco, orientacion: string;
    i: integer;
    columna: char;
    fila: integer;
begin
    NumBarcos := 0;
    i := 1;
    while i <= MaxBarcos do
    begin
        readln(entrada, tipoBarco);
        if tipoBarco = 'FIN' then
            break;

        if tipoBarco = 'Submarino' then
            Flota[i].barco := Submarino
        else if tipoBarco = 'Dragaminas' then
            Flota[i].barco := Dragaminas
        else if tipoBarco = 'Fragata' then
            Flota[i].barco := Fragata
        else if tipoBarco = 'PortaAviones' then
            Flota[i].barco := PortaAviones
        else
        begin
            writeln(salida, 'error en la entrada');
            continue;
        end;

        readln(entrada, orientacion);
        if orientacion = 'Horizontal' then
            Flota[i].orientacion := Horizontal
        else if orientacion = 'Vertical' then
            Flota[i].orientacion := Vertical
        else
        begin
            writeln(salida, 'error en la entrada');
            continue;
        end;

        readln(entrada, columna);
        readln(entrada, fila);

        if (fila < 1) or (fila > MaxFilas) or (columna < 'A') or (columna > 'J') then
        begin
            writeln(salida, 'error en la entrada');
            continue;
        end;

        Flota[i].proa.c := columna;
        Flota[i].proa.f := fila;
        Flota[i].estado := Intacto;
        i := i + 1;
    end;
    NumBarcos := i - 1;
end;

procedure ColocarBarco(var T: TipoTablero; Barco: TipoBarcoTotal);
var
    i, longitud: integer;
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
            T[f, chr(ord(c) + i)] := inicial
        else
            T[f + i, c] := inicial;
    end;
end;

procedure ProcesarDisparo(var T: TipoTablero);
var
    disparoCol: char;
    disparoFil: integer;
begin
    while not eof(entrada) do
    begin
        read(entrada, disparoCol);
        readln(entrada, disparoFil);

        if (disparoFil < 1) or (disparoFil > MaxFilas) or (disparoCol < 'A') or (disparoCol > 'J') then
        begin
            writeln(salida, 'error en la entrada');
            continue;
        end;

        if T[disparoFil, disparoCol] = '.' then
            writeln(salida, 'agua')
        else
            writeln(salida, 'tocado');
    end;
end;

var
    i: integer;

begin
    Assign(entrada, 'entrada.txt');
    Assign(salida, 'salida.txt');
    Reset(entrada);
    Rewrite(salida);

    InicializarTablero(Tablero);
    LeerFlota(Flota, NumBarcos);

    for i := 1 to NumBarcos do
        ColocarBarco(Tablero, Flota[i]);

    ProcesarDisparo(Tablero);

    Close(entrada);
    Close(salida);
end.
