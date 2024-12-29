{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program jugarBingo;

const 
    MaxCartones = 100;
    tabulador: string = '	';
    numeroTachado: integer = 101;
    espacio: string = ' ';
    maxExtracciones = 401;

type
    TipoNumero = 1..101;
    TipoColor = (Rojo, Azul, Amarillo, Verde, FIN);
    TipoLinea = record
        color: TipoColor;
        numeros: array[1..5] of TipoNumero;
        cantidadNumeros: integer;
    end;
    TipoCarton = record
        lineas: array[1..3] of TipoLinea;
        cantidadLineas: integer;
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
    TipoResultadoExtraccion = (Nada, Tachado, Bingo);
    TipoResultadosExtracciones = array[1..3] of TipoResultadoExtraccion;

    TipoListaExtracciones = record
        extracciones: array[1..maxExtracciones] of TipoExtraccion;
        cantidadExtracciones: integer;
    end;
    TipoPunteroCadena = ^string;

function esBlanco(caracter: char): boolean;
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

function leerCadena(var entrada: text): string;
var 
    cadenaTemporal: string = '';
    caracter: char;
    hayCadena: boolean = false;
begin
    vaciarCadena(cadenaTemporal);
    while not eof(entrada) and not hayCadena do begin
        if eoln(entrada) then 
            readln(entrada)
        else begin
            read(entrada, caracter);
            hayCadena := not esBlanco(caracter);
        end;
    end;
    while hayCadena do begin
        agregarCaracter(cadenaTemporal, caracter);
        if eof(entrada) or eoln(entrada) then 
            hayCadena := false
        else begin
            read(entrada, caracter);
            hayCadena := not esBlanco(caracter);
        end;
    end;
    result := cadenaTemporal;
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

function esNumerico(cadena: string): boolean;
var 
    i: integer;
    caracter: char;
    esNumero: boolean = true;
begin
    for i := 1 to length(cadena) do begin
        caracter := cadena[i];
        esNumero := (caracter >= '0') and (caracter <= '9');
        if not esNumero then 
            break;
    end;
    result := esNumero;
end;

function comprobarNumero(cadena: string; var numero: TipoNumero): boolean;
var
    posicion: integer;
begin
    val(cadena, numero, posicion);
    result := (posicion = 0);
end;

procedure leerLinea(var entrada: text; var linea: TipoLinea; var esFin: boolean);
var 
    cadenaTemporal: string;
    colorTemporal: TipoColor;
    numeroTemporal: TipoNumero;
    esNumero: boolean = false;
    i: integer;
begin
    cadenaTemporal := leerCadena(entrada);
    if comprobarEsFin(cadenaTemporal) then begin
        esFin := true;
    end else if comprobarColor(cadenaTemporal, colorTemporal) then begin
        linea.color := colorTemporal;
        linea.cantidadNumeros := 5;
        for i := 1 to linea.cantidadNumeros do begin
            cadenaTemporal := leerCadena(entrada);
            esNumero := esNumerico(cadenaTemporal) and comprobarNumero(cadenaTemporal, numeroTemporal);
            if esNumero then begin
                linea.numeros[i] := numeroTemporal;
            end else begin
                writeln('Error: número no válido.');
                halt();
            end;
        end;
    end else begin
        writeln('Error: color no válido.');
        halt();
    end;
end;

procedure leerCarton(var entrada: text; var carton: TipoCarton; var esFin: boolean);
var
    i: integer;
begin
    carton.cantidadLineas := 3;
    for i := 1 to carton.cantidadLineas do begin
        leerLinea(entrada, carton.lineas[i], esFin);
        if esFin then begin
            break;
        end;
    end;
end;

procedure leerJugador(var entrada: text; var jugador: TipoJugador);
var
    esFin: boolean = false;
    cartonTemporal: TipoCarton;
begin
    jugador.cantidadCartones := 0;
    while not esFin do begin
        leerCarton(entrada, cartonTemporal, esFin);
        if not esFin then begin
            jugador.cartones[jugador.cantidadCartones + 1] := cartonTemporal;
            jugador.cantidadCartones := jugador.cantidadCartones + 1;
        end;
    end;
end;

procedure leerFaseConfiguracion(var entrada: text; var juego: TipoJuego);
var 
    i: integer;
begin
    for i := 1 to 3 do begin
        leerJugador(entrada, juego.jugadores[i]);
    end;
end;

procedure ordenarNumeros(var fila: TipoLinea);
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
    linea: TipoLinea;
begin
    for i := 1 to 3 do begin
        ordenarNumeros(carton.lineas[i]);
        linea := carton.lineas[i];
        writeln();
        write(linea.color);
        for j := 1 to 5 do begin
            write(' ');
            if linea.numeros[j] = numeroTachado then begin
                write('XX')
            end else begin
                write(linea.numeros[j]);
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

function leerExtraccion(var entrada: text; var hayError: boolean): TipoExtraccion;
var
    cadenaTemporal: string;
    colorTemporal: TipoColor;
    numeroTemporal: TipoNumero;
begin
    cadenaTemporal := leerCadena(entrada);
    if comprobarColor(cadenaTemporal, colorTemporal) then begin
        result.color := colorTemporal;
        cadenaTemporal := leerCadena(entrada);
        if comprobarNumero(cadenaTemporal, numeroTemporal) then begin
            result.numero := numeroTemporal;
        end else begin
            hayError := true;
        end;
    end else begin
        hayError := true;
    end;
end;

function comprobarBingoJugador(jugador: TipoJugador): boolean;
var
    i, j, k: integer;
    cartonTemporal: TipoCarton;
    lineaTemporal: TipoLinea;
    numeroTemporal: TipoNumero;
    esBingoCarton: boolean;
begin
    result := false;
    for i := 1 to jugador.cantidadCartones do begin
        esBingoCarton := true;
        cartonTemporal := jugador.cartones[i];
        for j := 1 to cartonTemporal.cantidadLineas do begin
            lineaTemporal := cartonTemporal.lineas[j];
            for k := 1 to lineaTemporal.cantidadNumeros do begin
                numeroTemporal := lineaTemporal.numeros[k];
                if numeroTemporal <> numeroTachado then begin
                    esBingoCarton := false;
                end;
            end;
        end;
        if esBingoCarton then begin
            result := true;
            exit;
        end;
    end;
end;

function resultadoExtraccionJugador(extraccion: TipoExtraccion; var jugador: TipoJugador): TipoResultadoExtraccion;
var
    i, j, k: integer;
    cartonTemporal: TipoCarton;
    lineaTemporal: TipoLinea;
    numeroTemporal: TipoNumero;
begin
    result := Nada;
    for i := 1 to jugador.cantidadCartones do begin
        cartonTemporal := jugador.cartones[i];
        for j := 1 to cartonTemporal.cantidadLineas do begin
            lineaTemporal := cartonTemporal.lineas[j];
            if lineaTemporal.color = extraccion.color then begin
                for k := 1 to lineaTemporal.cantidadNumeros do begin
                    numeroTemporal := lineaTemporal.numeros[k];
                    if extraccion.numero = numeroTemporal then begin
                        jugador.cartones[i].lineas[j].numeros[k] := numeroTachado;
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

procedure mostrarResultados(resultados: TipoResultadosExtracciones);
var
    i: integer;
begin
    for i := 1 to 3 do begin
        writeln();
        write('Jugador ', i, ': ', resultados[i], '.');
    end;
end;

function resultadoExtraccionJugadores(extraccion: TipoExtraccion; var juego: TipoJuego): TipoResultadosExtracciones;
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
    end else if numeroGanadores > 1 then begin
        juego.estado := Empate;
    end;
end;

procedure terminarJuego(juego: TipoJuego; listaExtracciones: TipoListaExtracciones);
var 
    extraccionTemporal: TipoExtraccion;
    i: integer;
begin
    for i := 1 to listaExtracciones.cantidadExtracciones do begin
        extraccionTemporal := listaExtracciones.extracciones[i];
        writeln();
        write(extraccionTemporal.color, ' ', extraccionTemporal.numero);
    end;

    writeln();
    case juego.estado of
        Error:
            write('Error en el juego.');
        Ganador:
            write('Ganador: Jugador ', juego.numeroGanador);
        Empate:
            write('Empate entre jugadores.');
    end;
end;

procedure leerFaseExtracciones(var entrada: text; var juego: TipoJuego);
var
    extraccionTemporal: TipoExtraccion;
    resultadosTemporales: TipoResultadosExtracciones;
    listaExtracciones: TipoListaExtracciones;
    hayError: boolean = false;
begin
    listaExtracciones.cantidadExtracciones := 0;
    while not eof(entrada) and (juego.estado = Jugando) do begin
        escribirCartonesJugadores(juego);
        extraccionTemporal := leerExtraccion(entrada, hayError);
        if hayError then begin
            juego.estado := Error;
        end else begin
            listaExtracciones.extracciones[listaExtracciones.cantidadExtracciones + 1] := extraccionTemporal;
            listaExtracciones.cantidadExtracciones := listaExtracciones.cantidadExtracciones + 1;
            resultadosTemporales := resultadoExtraccionJugadores(extraccionTemporal, juego);
            mostrarResultados(resultadosTemporales);
        end;
    end;
    terminarJuego(juego, listaExtracciones);
end;

var 
    juego: TipoJuego;
    archivoEntrada: string = 'datos.txt';
    entrada: text;
begin
    assign(entrada, archivoEntrada);
    reset(entrada);

    juego.cantidadJugadores := 3;

    leerFaseConfiguracion(entrada, juego);

    leerFaseExtracciones(entrada, juego);

    close(entrada);
end.
