{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program jugarBingo;

const 
    MaxCartones = 10;
    numeroTachado: integer = 100;
    maxExtracciones = 50;
    espacio: string = ' ';
    tabulador: string = '	';
    
type
    TipoNumero = 1..100;
    TipoColor = (rojo, azul, amarillo, verde, FIN);
    TipoFilas = record
        color: TipoColor;
        numeros: array[1..5] of TipoNumero;
        cantidadNumeros: integer;
    end;
    TipoCarton = record
        Filas: array[1..3] of TipoFilas;
        cantidadFilas: integer;
    end;
    TipoJugador = record
        cartones: array[1..MaxCartones] of TipoCarton;
        cantidadCartones: integer;
    end;
    TipoEstado = (Jugando, Error, Ganador, Empate);
    TipoJuego = record 
        jugadores: array[1..3] of TipoJugador;
        cantidadJugadores: integer;
        estado: TipoEstado;
        numeroGanador: integer;
    end;
    TipoExtraccion = record
        numero: TipoNumero;
        color: TipoColor;
    end;
    ResultExtraccion = (Nada, Tachado, Bingo);
    ResultExtracciones = array[1..3] of ResultExtraccion;

    TipoListaExtracciones = record
        extracciones: array[1..maxExtracciones] of TipoExtraccion;
        cantidadExtracciones: integer;
    end;

function espacios(caracter: char): boolean;
begin
    result := (caracter = espacio) or (caracter = tabulador);
end;

procedure vaciarCadena(var cadena: string);
begin
    cadena := ''; 
end;

procedure agregarCaracter(var cadena: string; caracter: char);
begin
    cadena := cadena + caracter;
end;

function leerCadena(var fich: text): string;
var 
    cadena: string = '';
    caracter: char;
    hayCadena: boolean = false;
begin
    vaciarCadena(cadena);
    while not eof(fich) and not hayCadena do begin
        if eoln(fich) then 
            readln(fich)
        else begin
            read(fich, caracter);
            hayCadena := not espacios(caracter);
        end;
    end;
    while hayCadena do begin
        agregarCaracter(cadena, caracter);
        if eof(fich) or eoln(fich) then 
            hayCadena := false
        else begin
            read(fich, caracter);
            hayCadena := not espacios(caracter);
        end;
    end;
    result := cadena;
end;

function comprobarEsFin(cadena: string): boolean;
var
    color: TipoColor;
    posicion: integer;
begin
    val(cadena, color, posicion);
    result := (posicion = 0) and (color = FIN);
end;

function comprobarColor(cadena: string; var color: TipoColor): boolean;
var 
    posicion: integer;
begin
    val(cadena, color, posicion);
    result := (posicion = 0);
end;

function comprobarNumero(cadena: string; var numero: TipoNumero): boolean;
var
    posicion: integer;
begin
    val(cadena, numero, posicion);
    result := (posicion = 0);
end;

procedure leerFila(var fich: text; var Fila: TipoFilas; var esFin: boolean);
var 
    cadena: string;
    color: TipoColor;
    numero: TipoNumero;
    esNumero: boolean = false;
    i: integer;
begin
    cadena := leerCadena(fich);
    if comprobarEsFin(cadena) then begin
        esFin := true;
    end 
    else if comprobarColor(cadena, color) then begin
        Fila.color := color;
        Fila.cantidadNumeros := 5;
        for i := 1 to Fila.cantidadNumeros do begin
            cadena := leerCadena(fich);
            esNumero := comprobarNumero(cadena, numero);
            if esNumero then begin
                Fila.numeros[i] := numero;
            end 
            else begin
                writeln('Error en el numero');
                halt();
            end;
        end;
    end 
    else begin
        writeln('Error en el color');
        halt();
    end;
end;

procedure leerCarton(var fich: text; var carton: TipoCarton; var esFin: boolean);
var
    i: integer;
begin
    carton.cantidadFilas := 3;
    for i := 1 to carton.cantidadFilas do begin
        leerFila(fich, carton.Filas[i], esFin);
        if esFin then begin
            break;
        end;
    end;
end;

procedure leerJugador(var fich: text; var jugador: TipoJugador);
var
    esFin: boolean = false;
    carton: TipoCarton;
begin
    jugador.cantidadCartones := 0;
    while not esFin do begin
        leerCarton(fich, carton, esFin);
        if not esFin then begin
            jugador.cartones[jugador.cantidadCartones + 1] := carton;
            jugador.cantidadCartones := jugador.cantidadCartones + 1;
        end;
    end;
end;

procedure leerFaseConfiguracion(var fich: text; var juego: TipoJuego);
var 
    i: integer;
begin
    for i := 1 to 3 do begin
        leerJugador(fich, juego.jugadores[i]);
    end;
end;

procedure ordenarNumeros(var fila: TipoFilas);
var
  i, j, num: Integer;
begin
  for i := 1 to 4 do begin
    for j := i + 1 to 5 do begin
      if fila.Numeros[i] > fila.Numeros[j] then begin
        num := fila.Numeros[i];
        fila.Numeros[i] := fila.Numeros[j];
        fila.Numeros[j] := num;
      end;
    end;
  end;
end;

procedure escribirCarton(carton: TipoCarton);
var
    i, j: integer;
    Fila: TipoFilas;
begin
    for i := 1 to 3 do begin
        ordenarNumeros(carton.Filas[i]);
        Fila := carton.Filas[i];
        writeln();
        write(Fila.color);
        for j := 1 to 5 do begin
            write(' ');
            if Fila.numeros[j] = numeroTachado then begin
                write('XX')
            end 
            else begin
                write(Fila.numeros[j]);
            end;
        end;
    end;
end;

procedure escribirCartonesJugador(jugador: TipoJugador; numeroJugador: integer);
var 
    i: integer;
begin
    for i := 1 to jugador.cantidadCartones do begin
        writeln();
        write('Jugador ', numeroJugador, ' Cartón ', i);
        escribirCarton(jugador.cartones[i]);
    end;
end;

procedure escribirCartonesJugadores(juego: TipoJuego);
var 
    i: integer;
begin
    for i := 1 to juego.cantidadJugadores do begin
        writeln();
        escribirCartonesJugador(juego.jugadores[i], i);
    end;
end;

function leerExtraccion(var fich: text; var hayError: boolean): TipoExtraccion;
var
    cadena: string;
    color: TipoColor;
    numero: TipoNumero;
begin
    cadena := leerCadena(fich);
    if comprobarColor(cadena, color) then begin
        result.color := color;
        cadena := leerCadena(fich);
        if comprobarNumero(cadena, numero) then begin
            result.numero := numero;
        end 
        else begin
            hayError := true;
        end;
    end 
    else begin
        hayError := true;
    end;
end;

function comprobarBingoJugador(jugador: TipoJugador): boolean;
var
    i, j, k: integer;
    carton: TipoCarton;
    Fila: TipoFilas;
    numero: TipoNumero;
    esBingo: boolean;
begin
    result := false;
    for i := 1 to jugador.cantidadCartones do begin
        esBingo := true;
        carton := jugador.cartones[i];
        for j := 1 to carton.cantidadFilas do begin
            Fila := carton.Filas[j];
            for k := 1 to Fila.cantidadNumeros do begin
                numero := Fila.numeros[k];
                if numero <> numeroTachado then begin
                    esBingo := false;
                end;
            end;
        end;
        if esBingo then begin
            result := true;
            exit;
        end;
    end;
end;

function resultadoExtraccionJugador(extraccion: TipoExtraccion; var jugador: TipoJugador): ResultExtraccion;
var
    i, j, k: integer;
    carton: TipoCarton;
    Fila: TipoFilas;
    numero: TipoNumero;
begin
    result := Nada;
    for i := 1 to jugador.cantidadCartones do begin
        carton := jugador.cartones[i];
        for j := 1 to carton.cantidadFilas do begin
            Fila := carton.Filas[j];
            if Fila.color = extraccion.color then begin
                for k := 1 to Fila.cantidadNumeros do begin
                    numero := Fila.numeros[k];
                    if extraccion.numero = numero then begin
                        jugador.cartones[i].Filas[j].numeros[k] := numeroTachado;
                        result := Tachado;
                    end;
                end;
            end;
        end;
    end;
    if comprobarBingoJugador(jugador) then begin
        result := Bingo;
    end;
end;

procedure mostrarResultados(resultados: ResultExtracciones);
var
    i: integer;
begin
    for i := 1 to 3 do begin
        writeln();
        write('Jugador ', i, ': ', resultados[i], '.');
    end;
end;

function resultadoExtraccionJugadores(extraccion: TipoExtraccion; var juego: TipoJuego): ResultExtracciones;
var
    i: integer;
    numeroGanadores: integer = 0;
begin
    for i := 1 to juego.cantidadJugadores do begin
        result[i] := resultadoExtraccionJugador(extraccion, juego.jugadores[i]);
        if result[i] = Bingo then begin
            numeroGanadores := numeroGanadores + 1;
            juego.numeroGanador := i;
        end;
    end;
    if numeroGanadores = 1 then begin
        juego.estado := Ganador;
    end 
    else if numeroGanadores > 1 then begin
        juego.estado := Empate;
    end;
end;

procedure terminarJuego(juego: TipoJuego; listaExtracciones: TipoListaExtracciones);
var 
    extraccion: TipoExtraccion;
    i: integer;
begin
    for i := 1 to listaExtracciones.cantidadExtracciones do begin
        extraccion := listaExtracciones.extracciones[i];
        writeln();
        write(extraccion.color, ' ', extraccion.numero);
    end;
    writeln();
    case juego.estado of
        Error:
            write('Error');
        Ganador:
            write('Ganador: Jugador ', juego.numeroGanador);
        Empate:
            write('Empate');
    end;
end;

procedure noHayBingo(juego:TipoJuego; listaExtracciones: TipoListaExtracciones; numeroGanadores: integer);
begin
    if (juego.estado <> Error) and (juego.estado <> Ganador) and 
    (juego.estado <> Empate) and (numeroGanadores = 0) then begin
        write('Empate');
    end;
end;

procedure leerFaseExtracciones(var fich: text; var juego: TipoJuego);
var
    extraccion: TipoExtraccion;
    resultados: ResultExtracciones;
    listaExtracciones: TipoListaExtracciones;
    numeroGanadores: integer = 0;
    hayError: boolean = false;
begin
    listaExtracciones.cantidadExtracciones := 0;
    while not eof(fich) and (juego.estado = Jugando) do begin
        escribirCartonesJugadores(juego);
        extraccion := leerExtraccion(fich, hayError);
        if hayError then begin
            juego.estado := Error;
        end 
        else begin
            listaExtracciones.extracciones[listaExtracciones.cantidadExtracciones + 1] := extraccion;
            listaExtracciones.cantidadExtracciones := listaExtracciones.cantidadExtracciones + 1;
            resultados := resultadoExtraccionJugadores(extraccion, juego);
            mostrarResultados(resultados);
        end;
    end;
    terminarJuego(juego, listaExtracciones);
    noHayBingo(juego, listaExtracciones, numeroGanadores);
end;

var 
    juego: TipoJuego;
    fich: TextFile;
begin
    assign(fich, 'datos.txt');
    reset(fich);

    juego.cantidadJugadores := 3;

    leerFaseConfiguracion(fich, juego);

    leerFaseExtracciones(fich, juego);

    close(fich);
end.
