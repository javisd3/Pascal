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
	LetraMinuscula: char = 'b';
	Unidades: char = '3';
	Decenas: char = '5';
	PosiblePar: integer = 7;
	Letra1: char = 'd';
	Letra2: char = 'b';
	Base: real = 4;
	Altura: real = 2;
	Radio: real = 3;
	Pi: real = 3.1415;
	A: real = 3;
	B: real = 2;
	C: real = 4;
begin 
	writeln('1)La letra minuscula de ' , LetraMayuscula , ' es: ', chr(ord(LetraMayuscula)+32));
	writeln('2)La letra mayuscula de ' , LetraMinuscula , ' es: ', chr(ord(LetraMinuscula)-32));
	writeln('3)El valor del numero que tiene ', Decenas, ' decenas y tiene ', Unidades, ' unidades es ', Decenas,Unidades);
	writeln('4)¿El numero ', PosiblePar, ' es par? ' , (PosiblePar mod 2 = 0));
	writeln('5)¿Esta la letra ', Letra1, ' y la letra ', Letra2, ' ordenadas? ', ord(Letra1)<= ord(Letra2));
	writeln('6)El area de un rectangulo de base ', Base:0:2, ' y altura ', Altura:0:2, ' es ',  Base*Altura:0:2); 
	writeln('7)El volumen de una esfera de radio ', Radio:0:2, ' es ', ((4/3)*Pi*(Radio*Radio*Radio)):0:2);
	writeln('8)Dado un rectangulo de base ', Base:0:2, ' con altura ', Altura:0:2, ' y un circulo de radio ' , Radio:0:2, ', comprobamos si tienen el mismo area. ', (base * altura)=(Pi*(radio*radio)));
	writeln('9) Dado un polinomio de: ', A:0:1, 'x^2 + ', B:0:1, 'x + ', C:0:1);
	writeln('La solución real es: ', (-B / (2 * A)):0:2, ' y la solución imaginaria es: +-', (sqrt(abs(B * B - 4 * A * C)) / (2 * A)):0:2);

end.	