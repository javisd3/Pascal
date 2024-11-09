{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

{
Alumno: Javier San Martín Hurtado
1ºCurso 1ºCuatrimestre
Doble grado teleco y ade
}

program bucles;

type
    TFigura = (Cuadrado, Rectangulo, TrianguloIzqdo, TrianguloDrcho, Triangulo);

var
    nombreFigura: TFigura;
    caracter: char;
    altura, ancho, figuraID: integer;
    totalFiguras, totalLineas, lineasUsadas, menorAltura: integer;
    figuraConMenorAltura: TFigura;
    continuar: char;

procedure DibujarCuadrado(altura: integer; caracter: char; var lineas: integer);
var
    i, j: integer;
begin
    lineas := altura;  
    for i := 1 to altura do
    begin
        for j := 1 to altura do
            write(caracter);
        writeln;
    end;
end;

procedure DibujarRectangulo(alto, ancho: integer; caracter: char; var lineas: integer);
var
    i, j: integer;
begin
    lineas := alto;  
    for i := 1 to alto do
    begin
        for j := 1 to ancho do
            write(caracter);
        writeln;
    end;
end;

procedure DibujarTrianguloDrcho(altura: integer; caracter: char; var lineas: integer);
var
    i, j: integer;
begin
    lineas := altura;  
    for i := 1 to altura do
    begin
        for j := 1 to i do
            write(caracter);
        writeln;
    end;
end;

procedure DibujarTrianguloIzqdo(altura: integer; caracter: char; var lineas: integer);
var
    i, j: integer;
begin
    lineas := altura;  
    for i := 1 to altura do
    begin
        for j := 1 to altura - i do
            write(' ');
        for j := 1 to i do
            write(caracter);
        writeln;
    end;
end;

procedure DibujarTriangulo(altura: integer; caracter: char; var lineas: integer);
var
    i, j: integer;
begin
    lineas := altura;  
    for i := 0 to altura - 1 do
    begin
        for j := 1 to altura - i - 1 do
            write(' ');
        for j := 1 to 2 * i + 1 do
            write(caracter);
        writeln;
    end;
end;

begin
    totalFiguras := 0;
    totalLineas := 0;
    menorAltura := 50; 

    repeat
        writeln('Selecciona el tipo de figura ingresando un numero:');
        writeln('1: Cuadrado');
        writeln('2: Rectangulo');
        writeln('3: TrianguloIzqdo');
        writeln('4: TrianguloDrcho');
        writeln('5: Triangulo');
        
        readln(figuraID);
        readln(caracter);

        case figuraID of
            1: nombreFigura := Cuadrado;
            2: nombreFigura := Rectangulo;
            3: nombreFigura := TrianguloIzqdo;
            4: nombreFigura := TrianguloDrcho;
            5: nombreFigura := Triangulo;
        end;

        if nombreFigura = Rectangulo then
        begin
            writeln('Ingresa la altura del rectangulo:');
            readln(altura);
            writeln('Ingresa el ancho del rectangulo:');
            readln(ancho);
        end
        else
        begin
            writeln('Ingresa la altura de la figura:');
            readln(altura);
        end;

        lineasUsadas := 0;
        case nombreFigura of
            Cuadrado: DibujarCuadrado(altura, caracter, lineasUsadas);
            Rectangulo: DibujarRectangulo(altura, ancho, caracter, lineasUsadas);
            TrianguloIzqdo: DibujarTrianguloIzqdo(altura, caracter, lineasUsadas);
            TrianguloDrcho: DibujarTrianguloDrcho(altura, caracter, lineasUsadas);
            Triangulo: DibujarTriangulo(altura, caracter, lineasUsadas);
        end;

        totalFiguras := totalFiguras + 1;
        totalLineas := totalLineas + lineasUsadas;


        if altura < menorAltura then
        begin
            menorAltura := altura;
            figuraConMenorAltura := nombreFigura;
        end;

        writeln('Quieres ingresar otra figura? (S/N)');
        readln(continuar);
    until (continuar = 'N') or (continuar = 'n');

    writeln;
    writeln('Resultados:');
    writeln('Numero total de figuras leidas: ', totalFiguras);
    writeln('Numero total de lineas necesarias para dibujarlas: ', totalLineas);

    write('Figura con menor altura: ');
    case figuraConMenorAltura of
        Cuadrado: writeln('Cuadrado');
        Rectangulo: writeln('Rectangulo');
        TrianguloIzqdo: writeln('TrianguloIzqdo');
        TrianguloDrcho: writeln('TrianguloDrcho');
        Triangulo: writeln('Triangulo');
    end;
end.