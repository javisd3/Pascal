const
    MaxFilas = 10;
    MaxColumnas = 10;
    MaxBarcos = 10;

type
    TipoBarco = (Submarino, Dragaminas, Fragata, PortaAviones);
    TipoOrientacion = (Horizontal, Vertical);
    TipoCasilla = record
        f: integer;
        c: char;
    end;
    TipoBarcoTotal = record
        barco: TipoBarco;
        orientacion: TipoOrientacion;
        proa: TipoCasilla;
    end;
    TipoTablero = array[1..MaxFilas, 'A'..'J'] of char;
    TipoFlota = array[1..MaxBarcos] of TipoBarcoTotal;

var
    Tablero: TipoTablero;
    Flota: TipoFlota;
    NumBarcos: integer;
    archivo: text;

procedure InicializarTablero(var T: TipoTablero);
var
    f: integer;
    c: char;
begin
    for f := 1 to MaxFilas do
        for c := 'A' to 'J' do
            T[f, c] := '.';
end;

procedure LeerFlota(var Flota: TipoFlota; var NumBarcos: integer; var archivo: text);
var
    palabra: string;
    tipoBarco, orientacion: string;
    i: integer;
    columna: char;
    fila: integer;
begin
    NumBarcos := 0;
    i := 1;

    while not eof(archivo) do
    begin
        read(archivo, palabra);
        writeln('Leyendo palabra: ', palabra);  // Mensaje de depuración

        // Ignorar palabras no relevantes (comienzan con letras que no son de barcos)
        if palabra = 'FIN' then
            break;

        // Identificar tipo de barco
        if (palabra = 'Submarino') or (palabra = 'Dragaminas') or
           (palabra = 'Fragata') or (palabra = 'PortaAviones') then
        begin
            tipoBarco := palabra;
            writeln('Tipo de barco: ', tipoBarco);  // Depuración

            // Leer orientación
            read(archivo, palabra);
            if palabra = 'Horizontal' then
                orientacion := palabra
            else if palabra = 'Vertical' then
                orientacion := palabra
            else
            begin
                writeln('Error: orientación no válida');
                continue;
            end;
            writeln('Orientación: ', orientacion);  // Depuración

            // Leer columna
            read(archivo, palabra);
            if length(palabra) = 1 then
                columna := palabra[1]
            else
            begin
                writeln('Error: columna no válida');
                continue;
            end;
            writeln('Columna: ', columna);  // Depuración

            // Leer fila
            read(archivo, palabra);
            val(palabra, fila);
            if (fila < 1) or (fila > MaxFilas) then
            begin
                writeln('Error: fila no válida');
                continue;
            end;
            writeln('Fila: ', fila);  // Depuración

            // Asignar el tipo de barco
            if tipoBarco = 'Submarino' then
                Flota[i].barco := Submarino
            else if tipoBarco = 'Dragaminas' then
                Flota[i].barco := Dragaminas
            else if tipoBarco = 'Fragata' then
                Flota[i].barco := Fragata
            else if tipoBarco = 'PortaAviones' then
                Flota[i].barco := PortaAviones;

            // Asignar la orientación
            if orientacion = 'Horizontal' then
                Flota[i].orientacion := Horizontal
            else if orientacion = 'Vertical' then
                Flota[i].orientacion := Vertical;

            // Asignar la posición de la proa
            Flota[i].proa.c := columna;
            Flota[i].proa.f := fila;

            // Aumentar el índice de barcos
            i := i + 1;
        end;
    end;
    NumBarcos := i - 1;
    writeln('Número de barcos cargados: ', NumBarcos);  // Mensaje de depuración
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

procedure ColocarBarco(var T: TipoTablero; Barco: TipoBarcoTotal);
var
    i, longitud: integer;
    f: integer;
    c: char;
    inicial: char;
begin
    longitud := CasillasBarco(barco.barco);
    f := Barco.proa.f;
    c := Barco.proa.c;
    inicial := InicialDelBarco(barco.barco);

    for i := 0 to longitud - 1 do
    begin
        if Barco.orientacion = Horizontal then
            T[f, chr(ord(c) + i)] := inicial
        else
            T[f + i, c] := inicial;
    end;
end;

procedure MostrarTablero(T: TipoTablero);
var
    f: integer;
    c: char;
begin
    writeln('Tablero actual:');
    for f := 1 to MaxFilas do
    begin
        for c := 'A' to 'J' do
            write(T[f, c], ' ');
        writeln;
    end;
end;

procedure ProcesarDisparo(var T: TipoTablero; var archivo: text);
var
    disparoCol: char;
    disparoFil: integer;
begin
    while not eof(archivo) do
    begin
        read(archivo, disparoCol);
        readln(archivo, disparoFil);

        if (disparoFil < 1) or (disparoFil > MaxFilas) or (disparoCol < 'A') or (disparoCol > 'J') then
        begin
            writeln('Error: coordenada no válida');
            continue;
        end;

        if T[disparoFil, disparoCol] = '.' then
            writeln('agua')
        else
            writeln('tocado');
    end;
end;

var
    i: integer;

begin
    assign(archivo, 'datos.txt');
    reset(archivo);

    InicializarTablero(Tablero);
    LeerFlota(Flota, NumBarcos, archivo);

    // Verificación de la flota cargada
    writeln('Número de barcos cargados: ', NumBarcos);
    for i := 1 to NumBarcos do
    begin
        writeln('Barco ', i, ': ', Flota[i].barco, ' en ', Flota[i].proa.f, ' ', Flota[i].proa.c);
    end;

    // Colocar los barcos en el tablero
    for i := 1 to NumBarcos do
        ColocarBarco(Tablero, Flota[i]);

    // Mostrar el tablero con los barcos colocados
    MostrarTablero(Tablero);

    // Procesar disparos
    ProcesarDisparo(Tablero, archivo);

    close(archivo);
end.
