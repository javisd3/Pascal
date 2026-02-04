{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

{
Alumno: Javier San Martín Hurtado
1ºCurso 1ºCuatrimestre
Doble grado teleco y ade
}

program ejercicioCondicionales;

const 
  Test1: char = 'C';
  Test2: char = 'A';
  Test3: char = 'B';

  prueba1: real = 6.6;
  prueba2: real = 8.0;
  prueba3: real = 9.5;

//Calcular nota media
function CalcularNotaFinal(test: char): real;
begin
  if test = 'A' then
    CalcularNotaFinal := 0.0
  else if test = 'B' then
    CalcularNotaFinal := (5.0 + prueba2) / 2.0
  else if test = 'C' then
    CalcularNotaFinal := (10.0 + prueba3) / 2.0;
end;

//Declarar apto o no
function MostrarResultado(test: char): boolean;
begin
  if CalcularNotaFinal(test) >= 5.0 then
    MostrarResultado := True
  else
    MostrarResultado := False;
end;

//Funciones para ordenar los tres valores
function menor(a, b, c: real): real;
begin
  menor := a;
  if b < menor then menor := b;
  if c < menor then menor := c;
end;

function mayor(a, b, c: real): real;
begin
  mayor := a;
  if b > mayor then mayor := b;
  if c > mayor then mayor := c;
end;

function intermedio(a, b, c: real): real;
begin
  if (a > menor(a, b, c)) and (a < mayor(a, b, c)) then
    intermedio := a
  else if (b > menor(a, b, c)) and (b < mayor(a, b, c)) then
    intermedio := b
  else
    intermedio := c;
end;

begin
  //Test1
  if MostrarResultado(Test1) then
    writeln('Apto: ', CalcularNotaFinal(Test1):0:2)
  else
    writeln('No apto: ', CalcularNotaFinal(Test1):0:2);

  //Test2
  if MostrarResultado(Test2) then
    writeln('Apto: ', CalcularNotaFinal(Test2):0:2)
  else
    writeln('No apto: ', CalcularNotaFinal(Test2):0:2);

  //Test3
  if MostrarResultado(Test3) then
    writeln('Apto: ', CalcularNotaFinal(Test3):0:2)
  else
    writeln('No apto: ', CalcularNotaFinal(Test3):0:2);

  // Ordenar notas
  writeln('Notas ordenadas de menor a mayor:');
  writeln(menor(CalcularNotaFinal(Test1), CalcularNotaFinal(Test2), CalcularNotaFinal(Test3)):0:2);
  writeln(intermedio(CalcularNotaFinal(Test1), CalcularNotaFinal(Test2), CalcularNotaFinal(Test3)):0:2);
  writeln(mayor(CalcularNotaFinal(Test1), CalcularNotaFinal(Test2), CalcularNotaFinal(Test3)):0:2);
end.
