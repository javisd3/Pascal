{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

{
Alumno: Javier San Martín Hurtado
1ºCurso 1ºCuatrimestre
Doble grado teleco y ade
}

program Procedimientos;

var
  test1, test2, test3: char;
  prueba1, prueba2, prueba3: real;

procedure LeerEstudiante(var test: char; var prueba: real);
begin
  readln(test);
  readln(prueba);
end;

function CalcularNotaFinal(test: char; prueba: real): real;
begin
  case test of
    'B': CalcularNotaFinal := (5.0 + prueba) / 2.0;
    'C': CalcularNotaFinal := (10.0 + prueba) / 2.0;
  otherwise
    CalcularNotaFinal := 0.0;  
  end;
end;

procedure MostrarResultado(test: char; prueba: real);
var
  notaFinal: real;
begin
  notaFinal := CalcularNotaFinal(test, prueba);
  if notaFinal >= 5.0 then
    writeln('Apto, ', notaFinal:0:1)
  else
    writeln('No apto, ', notaFinal:0:1);
end;

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
  writeln('Escribe las notas del test y de la prueba de los 3 alumnos:');
  
  // Lee datos
  LeerEstudiante(test1, prueba1);
  LeerEstudiante(test2, prueba2);
  LeerEstudiante(test3, prueba3);

  // Muestra apto o no junto a la nota
  MostrarResultado(test1, prueba1);
  MostrarResultado(test2, prueba2);
  MostrarResultado(test3, prueba3);

  // Ordena de menos a mayor
  writeln('Orden de notas:');
  writeln(menor(CalcularNotaFinal(test1, prueba1), CalcularNotaFinal(test2, prueba2), CalcularNotaFinal(test3, prueba3)):0:1);
  writeln(intermedio(CalcularNotaFinal(test1, prueba1), CalcularNotaFinal(test2, prueba2), CalcularNotaFinal(test3, prueba3)):0:1);
  writeln(mayor(CalcularNotaFinal(test1, prueba1), CalcularNotaFinal(test2, prueba2), CalcularNotaFinal(test3, prueba3)):0:1); 
end.
