{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

{
Alumno: Javier San Martín Hurtado
1ºCurso 1ºCuatrimestre
Doble grado teleco y ade
}

program PartidaCartas;

type
  TRango = (Invitado, Aspirante, Maestro);
  TPalo = (Oros, Copas, Espadas, Bastos);
  TCarta = record
    numero: 1..12;  
    palo: TPalo;      
  end;
  TJugador = record
    nifNumero: 1..1000;
    nifLetra: 'A'..'Z';
    rango: TRango;
    carta1, carta2, carta3: TCarta; 
    puntos: integer;  
  end;

function CalcularPuntuacionCarta(carta: TCarta): integer;
begin
  case carta.numero of
    1, 10, 11, 12: CalcularPuntuacionCarta := 10; 
  else
    CalcularPuntuacionCarta := carta.numero; 
  end;
end;

function CalcularPuntuacionJugador(jugador: TJugador): integer;
begin
  CalcularPuntuacionJugador := CalcularPuntuacionCarta(jugador.carta1) +
                               CalcularPuntuacionCarta(jugador.carta2) +
                               CalcularPuntuacionCarta(jugador.carta3);
end;

procedure LeerCarta(var carta: TCarta);
begin
  readln(carta.numero);
end;

procedure LeerJugador(var jugador: TJugador);
begin
  write('Numero del NIF: ');
  readln(jugador.nifNumero);
  write('Letra del NIF: ');
  readln(jugador.nifLetra);
  
  write('Rango (Invitado, Aspirante, Maestro): ');
  readln(jugador.rango);
  
  
  writeln('Ingrese las cartas del jugador:');
  LeerCarta(jugador.carta1);
  LeerCarta(jugador.carta2);
  LeerCarta(jugador.carta3);
  
  jugador.puntos := CalcularPuntuacionJugador(jugador);
end;

procedure MostrarResultado(jugador: TJugador; nombre: integer);
begin
  write('Jugador ', nombre, ': ');
  case jugador.rango of
    Invitado: write('Invitado, ');
    Aspirante: write('Aspirante, ');
    Maestro: write('Maestro, ');
  end;

  writeln('NIF ', jugador.nifNumero, '-', jugador.nifLetra, ', ', jugador.puntos, ' puntos');
end;

procedure DeterminarGanador(jugador1, jugador2: TJugador);
var
  ganador: integer;
begin
  if (jugador1.puntos <= 20) and ((jugador1.puntos > jugador2.puntos) or (jugador2.puntos > 20)) then
    ganador := 1
  else if (jugador2.puntos <= 20) and ((jugador2.puntos > jugador1.puntos) or (jugador1.puntos > 20)) then
    ganador := 2
  else
    ganador := 0; 

  MostrarResultado(jugador1, 1);
  MostrarResultado(jugador2, 2);
  
  if ganador = 1 then
    writeln('Ganador: Jugador 1')
  else if ganador = 2 then
    writeln('Ganador: Jugador 2')
  else
    writeln('Ganador: Ninguno, ambos pierden');
end;

var
  jugador1, jugador2: TJugador;
begin
  writeln('Ingrese los datos del jugador 1:');
  LeerJugador(jugador1);
  writeln('Ingrese los datos del jugador 2:');
  LeerJugador(jugador2);

  DeterminarGanador(jugador1, jugador2);
end.