{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}


program bingoPractica;

const 
    MaxCartones = 25;
    numTachado: integer = 100;
    Esp: char = ' ';
    Tab: char = '	';
    maxExtracciones = 100;
type
    TipoNum = 1..100;
    TipoColor=(rojo, azul, amarillo, verde, FIN);
    TipoLinea = record
        color: TipoColor;
        numeros: array[1..5] of TipoNum;
        nnumeros: integer;
    end;
    TipoCarton = record
        lineas: array[1..3] of TipoLinea;
        nlineas: integer;
    end;
    TipoJugador = record
        cartones: array[1..MaxCartones] of TipoCarton;
        ncartones: integer;
    end;
    TipoEstado = (Jugando, Error, Ganador, Empate);
    TipoJuego = record 
        jugadores: array[1..3] of TipoJugador;
        njugadores: integer;
        estado: TipoEstado;
        nganador: integer;
    end;
    TipoBola= record
        numero: TipoNum;
        color: TipoColor;
    end;
    TipoResultExtrac= (Nada, Tachado, Bingo);
    TipoResultadosExtrac= array[1..3] of TipoResultExtrac;

    TipoListaExtracciones= record
        extracciones: array[1..maxExtracciones] of TipoBola;
        nextracciones: integer;
    end;


function esBlanco(car:char):boolean;
begin
    result:= (car = Esp ) or (car = Tab);
end;

procedure borrar(var pal:string);
begin
    pal:=''; 
end;

procedure addCar(var pal:string; c:char);
begin
    pal:=pal+c;
end;

function leerPalabra(var fich:text):string;
var 
    tmpPal:string='';
    c:char;
    hayPal:boolean=false;
begin
    borrar(tmpPal);
    while not eof(fich) and  not hayPal do begin
        if( eoln(fich) ) then 
            readln(fich)
        else begin
            read(fich,c);
            hayPal:= not esBlanco(c);
        end;
    end;
    while hayPal do begin
        addCar(tmpPal,c);
        if( eof(fich) or eoln(fich) ) then begin
            hayPal:= false;
        end else
        begin
            read(fich,c);
            hayPal:= not esBlanco(c);
        end;
    end;
    result:= tmpPal;
end;


function EsFin(palabra:string):boolean;
var
    color: TipoColor;
    pos: integer;
begin
    val(palabra,color,pos);
    result:= (pos = 0) and (color = FIN);
end;

function EsColor(palabra:string;var color:TipoColor):boolean;
var 
    pos: integer;
begin
    val(palabra,color,pos);
    result:= (pos = 0);
end;

function esTodoNumeros(palabra:string):boolean;
var 
    i: integer;
    c: char;
    esNum: boolean = true;
begin
    for i := 1 to length(palabra) do begin
        c:=palabra[i];
        esNum:=(c>='0') and (c<='9');
        if(not esNum) then 
            break;
    end;
    result:= esNum;        
end;

function EsNumero(palabra:string;var numero:TipoNum):boolean;
var
    pos: integer;
begin
    val(palabra,numero,pos);
    result:= (pos = 0) ;
end;

procedure leerLinea(var fich: text; var linea: TipoLinea; var hayFin: boolean);
var 
    tmpPal: string;
    tmpCol: TipoColor;
    tmpNum: TipoNum;
    esNum: boolean = false;
    i: integer;
begin
    tmpPal:=leerPalabra(fich);
    if(EsFin(tmpPal)) then begin
        hayFin:= true;
    end else if(EsColor(tmpPal,tmpCol)) then
    begin
        linea.color:=tmpCol;
        linea.nnumeros:= 5;
        for i := 1 to linea.nnumeros do begin
            tmpPal:=leerPalabra(fich);
            esNum:=esTodoNumeros(tmpPal) and EsNumero(tmpPal,tmpNum);
            if(esNum) then begin
                linea.numeros[i]:=tmpNum;
            end else
            begin
                writeln('Error: número inválido');
                hayFin := true;
                halt;
            end;
        end;
    end else
    begin
        writeln('Error: color inválido');
        hayFin := true;
        halt;
    end;
end;

procedure leerCarton(var fich: text; var carton: TipoCarton; var hayFin: boolean);
var
    i: integer;
begin
    carton.nlineas:=3;
    for i := 1 to carton.nlineas do begin
        leerLinea(fich,carton.lineas[i],hayFin);
        if(hayFin) then begin
            break;
        end;
    end;
        
end;

procedure leerJugador(var fich:text; var jugador:TipoJugador);
var
    hayFin: boolean=false;
    tmpCarton: TipoCarton;
begin
    jugador.ncartones:=0;
    while not hayFin do begin
        leerCarton(fich,tmpCarton,hayFin);
        if(not hayFin) then begin
            jugador.cartones[jugador.ncartones + 1]:=tmpCarton;
            jugador.ncartones:=jugador.ncartones + 1;
        end;
    end;
end;

procedure leerFaseConfig(var fich:text; var juego:TipoJuego);
var 
    i: integer;
begin
    for i := 1 to 3 do begin
        leerJugador(fich, juego.jugadores[i]);
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

procedure escribirCarton(carton:TipoCarton);
var
    i,j: integer;
    linea: TipoLinea;
begin
    for i := 1 to 3 do begin
        ordenarNumeros(carton.lineas[i]);
        linea:= carton.lineas[i];
        writeln();
        write(linea.color);
        for j := 1 to 5 do begin
            write(' ');
            if(linea.numeros[j] = numTachado) then begin
                write('XX')
            end else
            begin
                write(linea.numeros[j]);
            end;
        end;
         
    end;
        
end;

procedure EscribirCartonesJugador(jugador:TipoJugador;njug:integer);
var 
    i: integer;
begin
    for i := 1 to jugador.ncartones do begin
        writeln();
        write('Jugador ',njug,' Carton ',i);
        escribirCarton(jugador.cartones[i]);
    end;
        
end;

procedure EscribirCartonesJugadores(juego:TipoJuego);
var 
    i: integer;
begin
    for i := 1 to juego.njugadores do begin
        writeln();
        EscribirCartonesJugador(juego.jugadores[i],i);
    end;
        
end;

function leerExtracciones(var fich:text; var hayError:boolean):TipoBola;
var
    tmpPal: string;
    tmpCol: TipoColor;
    tmpNum: TipoNum;
begin
    tmpPal:=leerPalabra(fich);
    if(EsColor(tmpPal,tmpCol)) then begin
        result.color:=tmpCol;
        tmpPal:=leerPalabra(fich);
        if(EsNumero(tmpPal,tmpNum)) then begin
            result.numero:=tmpNum;
        end else
        begin
            hayError:= true;
        end;
    end else begin
        hayError:= true;
    end;
end;

function comprobarBingoJugador(jugador: TipoJugador):boolean;
var
    i,j,k: integer;
    tmpCarton: TipoCarton;
    tmpLin: TipoLinea;
    tmpNum: TipoNum;
    esBingoCarton: boolean;
begin
    for i := 1 to jugador.ncartones do begin
        esBingoCarton:=true;
        tmpCarton:= jugador.cartones[i];
        for j := 1 to tmpCarton.nlineas do begin
            tmpLin:= tmpCarton.lineas[j];
            for k := 1 to tmpLin.nnumeros do begin
                tmpNum:=tmpLin.numeros[k];
                if(tmpNum <> numTachado) then begin
                    esBingoCarton:= false;
                end;
            end;
        end;
        if(esBingoCarton) then begin
            result:= true;
            break;
        end;
            
    end;
        
end;

function resultExtracJugador(extrac:TipoBola; var jugador:TipoJugador):TipoResultExtrac;
var
    i,j,k: integer;
    tmpCarton: TipoCarton;
    tmpLin: TipoLinea;
    tmpNum: TipoNum;
begin
    result:=Nada;
    for i := 1 to jugador.ncartones do begin
        tmpCarton:=jugador.cartones[i];
        for j := 1 to tmpCarton.nlineas do begin
            tmpLin:=tmpCarton.lineas[j];
            if(tmpLin.color = extrac.color) then begin
                for k := 1 to tmpLin.nnumeros do begin
                    tmpNum:=tmpLin.numeros[k];
                    if(extrac.numero = tmpNum) then begin
                        jugador.cartones[i].lineas[j].numeros[k]:=numTachado;
                        result:=Tachado;
                    end;
                end;
                    
            end;
        end;
                
    end;

    if( comprobarBingoJugador(jugador) ) then begin
        result:= Bingo;
    end;
        
end;

procedure mostrarResultado(resultados:TipoResultadosExtrac);
var
    i: integer;
begin
    for i := 1 to 3 do begin
        writeln();
        write('Jugador ',i,': ',resultados[i],'.');
    end;
        
end;

function resultExtracJugadores(extrac:TipoBola;var juego:TipoJuego):TipoResultadosExtrac;
var
    i: integer;
    nganadores: integer = 0;
begin
    for i := 1 to juego.njugadores do begin
        result[i]:=resultExtracJugador(extrac,juego.jugadores[i]);
        if(result[i] = Bingo) then begin
            nganadores:=nganadores + 1;
            juego.nganador:= i;
        end;
    end;

    if( nganadores = 1 ) then begin
        juego.estado:= Ganador;
    end
    else if(nganadores > 1) then begin
        juego.estado:= Empate;
    end;
end;

procedure terminarJuego(juego:TipoJuego; listaExtrac:TipoListaExtracciones);
var 
    tmpExtrac: TipoBola;
    i: integer;
begin
    
    for i := 1 to listaExtrac.nextracciones do begin
        tmpExtrac:=listaExtrac.extracciones[i];
        writeln();
        write(tmpExtrac.color,' ',tmpExtrac.numero);
    end;
        
    writeln();
    case juego.estado of
        Error:
            write('Error');
        Ganador:
            write('Ganador: Jugador ',juego.nganador);
        Empate:
            write('Empate');
    end;
end;

procedure noHayBingo(juego:TipoJuego; listaExtrac:TipoListaExtracciones; nganadores: integer);
begin
    if not (juego.estado = Error) and ( nganadores = 0 ) then begin
        write('Empate');
    end;
end;

procedure leerFaseExtrac(var fich:text; juego:TipoJuego);
var
    tmpExtrac: TipoBola;
    tmpResults: TipoResultadosExtrac;
    listaExtrac: TipoListaExtracciones;
    hayError: boolean = false;
    nganadores: integer = 0;
begin
    listaExtrac.nextracciones:=0;
    while not eof(fich) and (juego.estado=Jugando) do begin
        EscribirCartonesJugadores(juego);
        tmpExtrac:= leerExtracciones(fich,hayError);
        if(hayError) then begin
            juego.estado:=Error;
        end else
        begin
            listaExtrac.extracciones[listaExtrac.nextracciones + 1]:= tmpExtrac;
            listaExtrac.nextracciones:=listaExtrac.nextracciones + 1;

            tmpResults:=resultExtracJugadores(tmpExtrac,juego);
            mostrarResultado(tmpResults);
        end;

    end;
    terminarJuego(juego,listaExtrac);
    noHayBingo(juego,listaExtrac,nganadores);
end;

var 
    juego:TipoJuego;
    fich: TextFile;
begin

    assign(fich, 'datos.txt');
    reset(fich);

    juego.njugadores:= 3;

    leerFaseConfig(fich,juego);

    leerFaseExtrac(fich,juego);

    close(fich);

end.
