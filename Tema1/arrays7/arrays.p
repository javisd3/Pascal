{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program arrays;

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
    TipoTablero = array[1..MaxFilas, 'A'..'T'] of char;
    TipoFlota = array[1..MaxBarcos] of TipoBarcoTotal;

var
    Tablero: TipoTablero;
    Flota: TipoFlota;
    Filas, Columnas, NumBarcos: integer;
    NumHundidos: integer;

procedure InicializarTablero(var T: TipoTablero);
var
    f: integer;
    c: char;
begin
    for f := 1 to MaxFilas do
        for c := 'A' to 'T' do
            T[f, c] := '.';
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
        writeln('Introduce el tipo de barco (Submarino, Dragaminas, Fragata, PortaAviones) o escribe "FIN" para terminar:');
        readln(tipoBarco);

        if tipoBarco = 'FIN' then
        begin
            NumBarcos := i - 1;  
            Break;
        end;

        if (tipoBarco <> 'Submarino') and (tipoBarco <> 'Dragaminas') and
           (tipoBarco <> 'Fragata') and (tipoBarco <> 'PortaAviones') then
        begin
            writeln('Tipo de barco no valido. Intenta de nuevo.');
            continue;
        end;

        if tipoBarco = 'Submarino' then
            Flota[i].barco := Submarino
        else if tipoBarco = 'Dragaminas' then
            Flota[i].barco := Dragaminas
        else if tipoBarco = 'Fragata' then
            Flota[i].barco := Fragata
        else
            Flota[i].barco := PortaAviones;

        writeln('Introduce la orientacion (Horizontal/Vertical):');
        readln(Flota[i].orientacion);
        
        writeln('Introduce la columna de la proa (A-T):');
        readln(Flota[i].proa.c);

        writeln('Introduce la fila de la proa (1-20):');
        readln(Flota[i].proa.f);

        writeln('Introduce el estado del barco (Tocado/Hundido):');
        readln(Flota[i].estado);

        i := i + 1;
    end;
end;

function CasillasBarco(barco: TipoBarco): integer;
begin
    case barco of
        Submarino: Result := 1;
        Dragaminas: Result := 2;
        Fragata: Result := 3;
        PortaAviones: Result := 4;
    end;
end;

function InicialDelBarco(barco: TipoBarco): char;
begin
    case barco of
        Submarino: Result := 'S';
        Dragaminas: Result := 'D';
        Fragata: Result := 'F';
        PortaAviones: Result := 'P';
    end;
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
        begin
            if Barco.estado = Tocado then
                T[f, chr(ord(c) + i)] := inicial  
            else
                T[f, chr(ord(c) + i)] := 'x'; 
        end
        else
        begin
            if Barco.estado = Tocado then
                T[f + i, c] := inicial  
            else
                T[f + i, c] := 'x';  
        end;
    end;
end;

procedure ColocarFlota(var T: TipoTablero; Flota: TipoFlota; NumBarcos: integer; var NumHundidos: integer);
var
    i: integer;
begin
    NumHundidos := 0;
    for i := 1 to NumBarcos do
    begin
        ColocarBarco(T, Flota[i]);
        if Flota[i].estado = Hundido then
            NumHundidos := NumHundidos + 1;
    end;
end;

procedure MostrarTablero(T: TipoTablero; Filas, Columnas: integer);
var
    f: integer;
    c: char;
begin
    for f := 1 to Filas do
    begin
        for c := 'A' to chr(ord('A') + Columnas - 1) do
            write(T[f, c], ' ');
        writeln;
    end;
end;

var
    i: integer;

begin
    writeln('Introduce el numero de filas del tablero:');
    readln(Filas);
    writeln('Introduce el numero de columnas del tablero:');
    readln(Columnas);

    InicializarTablero(Tablero);

    LeerFlota(Flota, NumBarcos);
    ColocarFlota(Tablero, Flota, NumBarcos, NumHundidos);

    writeln(NumBarcos, ' barcos');
    writeln(NumHundidos, ' hundidos');

    MostrarTablero(Tablero, Filas, Columnas);
end.
