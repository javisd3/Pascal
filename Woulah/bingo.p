{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}


program playbingo;

const 
    MaxCart=100;
    tab:string='	';
    numTachad:integer=101;
    gap:string=' ';
    maxExtracc=401;
type
    TipoNum = 1..101;
    TipoColor=(Rojo,Azul,Amarillo,Verde,FIN);
    TipoLinea = record
        color:TipoColor;
        nums:array[1..5] of TipoNum;
        nnumeros:integer;
    end;
    TipoCarton = record
        lineas: array[1..3] of TipoLinea;
        nlineas: integer;
    end;
    TipoPlayer = record
        cartones : array[1..MaxCart] of TipoCarton;
        ncartones : integer;
    end;
    TipoEstado = (Jugando, Error, Ganador, Empate);
    TipoGame = record 
        jugadores: array[1..3] of TipoPlayer;
        njugadores:integer;
        estado:TipoEstado;
        nganador:integer;
    end;
    TipoExtrac=record
        numero:TipoNum;
        color:TipoColor;
    end;
    TipoResultExtrac=(Nada, Tachado, Bingo);
    TipoResultadosExtrac=array[1..3] of TipoResultExtrac;

    TipoListaExtracciones=record
        extracciones:array[1..maxExtracc] of TipoExtrac;
        nextracciones:integer;
    end;
    TipoPunteroString=^string;


function esBlanco(car:char):boolean;
begin
    result:= (car = gap ) or (car = tab);
end;

procedure vaciarPal(var pal:string);
begin
    pal:=''; 
end;
procedure addCar(var pal:string; c:char);
begin
    pal:=pal+c;
end;


function leerPal(var entrada:text):string;
var 
    tmpPal:string='';
    c:char;
    hayPal:boolean=false;
begin
    while not eof(entrada) and  not hayPal do begin
        if( eoln(entrada) ) then 
            readln(entrada)
        else begin
            read(entrada,c);
            hayPal:=not esBlanco(c);
        end;
    end;
    while hayPal do begin
        addCar(tmpPal,c);
        if( eof(entrada) or eoln(entrada) ) then begin
            hayPal:=false;
        end else
        begin
            read(entrada,c);
            hayPal:=not esBlanco(c);
        end;
    end;
    result:=tmpPal;
end;


function comprobarEsFin(palabra:string):boolean;
var
    color:TipoColor;
    pos:integer;
begin
    val(palabra,color,pos);
    result:= (pos = 0) and (color = FIN);
end;
function checkcolor(palabra:string;var color:TipoColor):boolean;
var 
    pos:integer;
begin
    val(palabra,color,pos);
    result:= (pos = 0);
end;
function esTodoNumeros(palabra:string):boolean;
var 
    i:integer;
    c:char;
    esNum:boolean=true;
begin
    for i := 1 to length(palabra) do begin
        c:=palabra[i];
        esNum:=(c>='0') and (c<='9');
        if(not esNum) then 
            break;
    end;
    result:=esNum;
        
end;

function checknum(palabra:string;var numero:TipoNum):boolean;
var
    pos:integer;
begin
    val(palabra,numero,pos);
    result:= (pos = 0) ;
end;

procedure leerLinea(var entrada:text; var linea:TipoLinea; var hayFin:boolean);
var 
    tmpPal:string;
    tmpCol:TipoColor;
    tmpNum:TipoNum;
    esNum:boolean=false;
    i:integer;
begin
    tmpPal:=leerPal(entrada);
    if(comprobarEsFin(tmpPal)) then begin
        hayFin:=true;
    end else if(checkcolor(tmpPal,tmpCol)) then
    begin
      
        linea.color:=tmpCol;

        linea.nnumeros:=5;
        for i := 1 to linea.nnumeros do begin
            tmpPal:=leerPal(entrada);

            esNum:=esTodoNumeros(tmpPal) and checknum(tmpPal,tmpNum);

            if(esNum) then begin
                linea.nums[i]:=tmpNum;
            end else
            begin
                writeln('número ');
                halt();
            end;
        end;
            

    end else
    begin
        writeln('color');
        halt();
    end;
end;

procedure readCarton(var entrada:text; var carton:TipoCarton; var hayFin:boolean);
var
    i:integer;
begin
    carton.nlineas:=3;
    for i := 1 to carton.nlineas do begin
        leerLinea(entrada,carton.lineas[i],hayFin);
        if(hayFin) then begin
            break;
        end;
    end;
        
end;

procedure readPlayer(var entrada:text; var jugador:TipoPlayer);
var
    hayFin:boolean=false;
    tmpCarton:TipoCarton;
begin
    jugador.ncartones:=0;
    while not hayFin do begin
        readCarton(entrada,tmpCarton,hayFin);
        if(not hayFin) then begin
            jugador.cartones[jugador.ncartones+1]:=tmpCarton;
            jugador.ncartones:=jugador.ncartones+1;
        end;
    end;
end;

procedure leerFaseConfig(var entrada:text; var juego:TipoGame);
var 
    i:integer;
begin
    for i := 1 to 3 do begin
        readPlayer(entrada, juego.jugadores[i]);
    end;

        
end;

procedure writeCarton(carton:TipoCarton);
var
    i,j:integer;
    linea:TipoLinea;
begin
    for i := 1 to 3 do begin
        linea:=carton.lineas[i];
        writeln();
        write(linea.color);
        for j := 1 to 5 do begin
            write(' ');
            if(linea.nums[j] = numTachad) then begin
                write('XX')
            end else
            begin
                write(linea.nums[j]);
            end;
        end;
         
    end;
        
end;

procedure EscribirCartonesJugador(jugador:TipoPlayer;njug:integer);
var 
    i:integer;
begin
    for i := 1 to jugador.ncartones do begin
        writeln();
        write('Jugador ',njug,' Carton ',i);
        writeCarton(jugador.cartones[i]);
    end;
        
end;

procedure EscribirCartonesJugadores(juego:TipoGame);
var 
    i:integer;
begin
    for i := 1 to juego.njugadores do begin
        writeln();
        EscribirCartonesJugador(juego.jugadores[i],i);
    end;
        
end;

function leerExtrac(var entrada:text; var hayError:boolean):TipoExtrac;
var
    tmpPal:string;
    tmpCol:TipoColor;
    tmpNum:TipoNum;
begin
    tmpPal:=leerPal(entrada);
    if(checkcolor(tmpPal,tmpCol)) then begin
        result.color:=tmpCol;
        tmpPal:=leerPal(entrada);
        if(checknum(tmpPal,tmpNum)) then begin
            result.numero:=tmpNum;
        end else
        begin
            hayError:=true;
        end;
    end else begin
        hayError:=true;
    end;
end;

function comprobarBingoJugador(jugador:TipoPlayer):boolean;
var
    i,j,k:integer;
    tmpCarton:TipoCarton;
    tmpLin:TipoLinea;
    tmpNum:TipoNum;
    esBingoCarton:boolean;
begin
    for i := 1 to jugador.ncartones do begin
        esBingoCarton:=true;
        tmpCarton:=jugador.cartones[i];
        for j := 1 to tmpCarton.nlineas do begin
            tmpLin:=tmpCarton.lineas[j];
            for k := 1 to tmpLin.nnumeros do begin
                tmpNum:=tmpLin.nums[k];
                if(tmpNum <> numTachad) then begin
                    esBingoCarton:=false;
                end;
            end;
        end;
        if(esBingoCarton) then begin
            result:=true;
            break;
        end;
            
    end;
        
end;

function resultExtracJugador(extrac:TipoExtrac; var jugador:TipoPlayer):TipoResultExtrac;
var
    i,j,k:integer;
    tmpCarton:TipoCarton;
    tmpLin:TipoLinea;
    tmpNum:TipoNum;
begin
    result:=Nada;
    for i := 1 to jugador.ncartones do begin
        tmpCarton:=jugador.cartones[i];
        for j := 1 to tmpCarton.nlineas do begin
            tmpLin:=tmpCarton.lineas[j];
            if(tmpLin.color = extrac.color) then begin
                for k := 1 to tmpLin.nnumeros do begin
                    tmpNum:=tmpLin.nums[k];
                    if(extrac.numero = tmpNum) then begin
                        jugador.cartones[i].lineas[j].nums[k]:=numTachad;
                        result:=Tachado;
                    end;
                end;
                    
            end;
        end;
                
    end;

    if( comprobarBingoJugador(jugador) ) then begin
        result:=Bingo;
    end;
        
end;



procedure showResult(resultados:TipoResultadosExtrac);
var
    i:integer;
begin
    for i := 1 to 3 do begin
        writeln();
        write('Jugador ',i,': ',resultados[i],'.');
    end;
        
end;

function resultExtracJugadores(extrac:TipoExtrac;var juego:TipoGame):TipoResultadosExtrac;
var
    i:integer;
    nganadores:integer=0;
begin
    for i := 1 to juego.njugadores do begin
        result[i]:=resultExtracJugador(extrac,juego.jugadores[i]);
        if(result[i] = Bingo) then begin
            nganadores:=nganadores+1;
            juego.nganador:=i;
        end;
    end;

    if( nganadores = 1 ) then begin
        juego.estado:=Ganador;
    end else if(nganadores > 1) then begin
        juego.estado:=Ganador;
    end;
        
end;

procedure terminarJuego(juego:TipoGame; listaExtrac:TipoListaExtracciones);
var 
    tmpExtrac:TipoExtrac;
    i:integer;
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
            write('Ganador: Jugador',juego.nganador);
        Empate:
            write('Gana');
    end;
end;

procedure leerFaseExtrac(var entrada:text; juego:TipoGame);
var
    tmpExtrac:TipoExtrac;
    tmpResults:TipoResultadosExtrac;
    listaExtrac:TipoListaExtracciones;
    hayError:boolean=false;
begin
    listaExtrac.nextracciones:=0;
    while not eof(entrada) and (juego.estado=Jugando) do begin
        EscribirCartonesJugadores(juego);
        tmpExtrac:=leerExtrac(entrada,hayError);
        if(hayError) then begin
            juego.estado:=Error;
        end else
        begin
            listaExtrac.extracciones[listaExtrac.nextracciones+1]:=tmpExtrac;
            listaExtrac.nextracciones:=listaExtrac.nextracciones+1;

            tmpResults:=resultExtracJugadores(tmpExtrac,juego);
            showResult(tmpResults);
        end;

    end;
    terminarJuego(juego,listaExtrac);
end;

var 
    juego:TipoGame;
    nombreArchivo:string='datos.txt';
    entrada:text;
begin

    assign(entrada,nombreArchivo);
    reset(entrada);

    juego.njugadores:=3;

    leerFaseConfig(entrada,juego);

    leerFaseExtrac(entrada,juego);

    close(entrada);

end.
