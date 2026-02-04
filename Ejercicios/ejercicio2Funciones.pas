{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

{
Alumno: Javier San Martín Hurtado
1ºCurso 1ºCuatrimestre
Doble grado teleco y ade
}

program ejerciciosExpresiones;
uses Math;

const
	LetraMayuscula: char = 'Z';
function ConvMin(letra: char): char;
begin
    ConvMin := chr(ord(letra) + 32);
end;

const
	LetraMinuscula: char = 'b';
function ConvMay(letra: char): char;
begin
    ConvMay := chr(ord(letra) - 32);
end;

const
    Unidades: char = '3';
	Decenas: char = '5';
function NumCom(decena, unidad: char): string;
begin
    NumCom := decena + unidad;
end;

const
    PosiblePar: integer = 7;
function EsPar(numero: integer): boolean;
begin
    EsPar := (numero mod 2 = 0);
end;

const
    Letra1: char = 'd';
    Letra2: char = 'b';
function EstanOrdenadas(letra1, letra2: char): boolean;
begin
    EstanOrdenadas := ord(letra1) <= ord(letra2);
end;

const
    Base: real = 4;
    Altura: real = 2;
function AreaRectangulo(base, altura: real): real;
begin
    AreaRectangulo := base * altura;
end;

const
    Radio: real = 3;
    Pi: real = 3.1415;
function VolumenEsfera(radio: real; pi: real): real;
begin
    VolumenEsfera := (4 / 3) * pi * (radio * radio * radio);
end;

function CompararAreas(base, altura, radio, pi: real): boolean;
begin
    CompararAreas := (base * altura) = (pi * (radio * radio));
end;

const
    A: real = 3;
    B: real = 2;
    C: real = 4;
function SolucionReal(a, b: real): real;
begin
    SolucionReal := -b / (2 * a);
end;

function SolucionImaginaria(a, b, c: real): real;
begin
    SolucionImaginaria := sqrt(abs(b * b - 4 * a * c)) / (2 * a);
end;

begin 
	writeln('1) La letra minuscula de ', LetraMayuscula, ' es: ', ConvMin(LetraMayuscula));
	writeln('2) La letra mayuscula de ', LetraMinuscula, ' es: ', ConvMay(LetraMinuscula));
	writeln('3) El valor del numero que tiene ', Decenas, ' decenas y ', Unidades, ' unidades es: ', NumCom(Decenas, Unidades));
	writeln('4) ¿El numero ', PosiblePar, ' es par? ', EsPar(PosiblePar));
	writeln('5) ¿Estan las letras ', Letra1, ' y ', Letra2, ' ordenadas? ', EstanOrdenadas(Letra1, Letra2));
	writeln('6) El area de un rectangulo de base ', Base:0:2, ' y altura ', Altura:0:2, ' es: ', AreaRectangulo(Base, Altura):0:2);
	writeln('7) El volumen de una esfera de radio ', Radio:0:2, ' es: ', VolumenEsfera(Radio, Pi):0:2);
	writeln('8) Dado un rectangulo de base ', Base:0:2, ' con altura ', Altura:0:2, ' y un circulo de radio ', Radio:0:2, ', comprobamos si tienen el mismo area: ', CompararAreas(Base, Altura, Radio, Pi));
	writeln('9) Dado un polinomio de: ', A:0:1, 'x^2 + ', B:0:1, 'x + ', C:0:1);
	writeln('La solución real es: ', SolucionReal(A, B):0:2, ' y la solución imaginaria es: +-', SolucionImaginaria(A, B, C):0:2);
end.