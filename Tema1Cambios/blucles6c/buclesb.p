{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

{
Alumno: Javier San Martín Hurtado
1ºCurso 1ºCuatrimestre
Doble grado teleco y ade
}

program bucles;
type
    TFigura = (Cuadrado, Rectangulo, TrianguloIzqdo, TrianguloDrcho, Triangulo);

    TfiguraR = record
        figura: TFigura;
        caracter: char;
        altura, ancho: integer;
    end;

var
    figura1, figura2, figura3, figura4, figura5: TfiguraR;
    nombreFigura: integer;
    parar: char;
    contador, totalFiguras, totalLineas: integer;
    figuraMenorAltura: TfiguraR;
    primeraFigura: boolean;
    totalcaracteres: integer;

procedure DibujarCuadrado(altura: integer; caracter: char);
var
    i, j: integer;
begin
    for i := 1 to altura do
    begin
        for j := 1 to altura do
            write(caracter);
        writeln;
    end;
end;

procedure DibujarRectangulo(alto, ancho: integer; caracter: char);
var
    i, j: integer;
begin
    for i := 1 to alto do
    begin
        for j := 1 to ancho do
            write(caracter);
        writeln;
    end;
end;

procedure DibujarTrianguloDrcho(altura: integer; caracter: char);
var
    i, j: integer;
begin
    for i := 1 to altura do
    begin
        for j := 1 to i do
            write(caracter);
        writeln;
    end;
end;

procedure DibujarTrianguloIzqdo(altura: integer; caracter: char);
var
    i, j: integer;
begin
    for i := 1 to altura do
    begin
        for j := 1 to altura - i do
            write(' ');
        for j := 1 to i do
            write(caracter);
        writeln;
    end;
end;

procedure DibujarTriangulo(altura: integer; caracter: char);
var
    i, j: integer;
begin
    for i := 0 to altura - 1 do
    begin
        for j := 1 to altura - i - 1 do
            write(' ');
        for j := 1 to 2 * i + 1 do
            write(caracter);
        writeln;
    end;
end;

procedure SolicitarDatos(var figura: TfiguraR);
begin
    writeln('Elige una figura:');
    writeln('0 - Cuadrado');
    writeln('1 - Rectangulo');
    writeln('2 - Triangulo izquierdo');
    writeln('3 - Triangulo derecho');
    writeln('4 - Triangulo');
    readln(nombreFigura);

    figura.figura := TFigura(nombreFigura);

    writeln('Ingresa el caracter para la figura:');
    readln(figura.caracter);

    writeln('Ingresa la altura de la figura:');
    readln(figura.altura);

    if figura.figura = Rectangulo then
    begin
        writeln('Ingresa el ancho del rectangulo:');
        readln(figura.ancho);
    end
    else
    begin
        figura.ancho := figura.altura;
    end;
end;

procedure MostrarInformacion(figura: TfiguraR);
begin
    case figura.figura of
        Cuadrado: write('Figura: Cuadrado');
        Rectangulo: write('Figura: Rectangulo');
        TrianguloIzqdo: write('Figura: Triangulo izquierdo');
        TrianguloDrcho: write('Figura: Triangulo derecho');
        Triangulo: write('Figura: Triangulo');
    end;
    write(' ',figura.caracter, ' ', figura.altura, ' ');
    if figura.figura = Rectangulo then
        write(figura.ancho);
    writeln();
end;

procedure DibujarFigura(figura: TfiguraR);
begin
    MostrarInformacion(figura);
    case figura.figura of
        Cuadrado: DibujarCuadrado(figura.altura, figura.caracter);
        Rectangulo: DibujarRectangulo(figura.altura, figura.ancho, figura.caracter);
        TrianguloIzqdo: DibujarTrianguloIzqdo(figura.altura, figura.caracter);
        TrianguloDrcho: DibujarTrianguloDrcho(figura.altura, figura.caracter);
        Triangulo: DibujarTriangulo(figura.altura, figura.caracter);
    end;
end;

procedure EvaluarEstadisticas(figura: TfiguraR);
begin
    totalFiguras := totalFiguras + 1;
    totalLineas := totalLineas + figura.altura;

    if primeraFigura or (figura.altura < figuraMenorAltura.altura) then
    begin
        figuraMenorAltura := figura;
        primeraFigura := false;
    end;
end;
procedure ContarCaracteres(figura: TfiguraR);
begin
    case figura.figura of
        Cuadrado: totalcaracteres := totalcaracteres + (figura.altura * figura.altura);
        Rectangulo: totalcaracteres := totalcaracteres + (figura.altura * figura.ancho);
        TrianguloIzqdo, TrianguloDrcho, Triangulo: totalcaracteres := totalcaracteres + ((figura.altura * (figura.altura + 1)) div 2);
    end;
end;
procedure MostrarNombreFiguraMenorAltura(figura: TfiguraR);
begin
    case figura.figura of
        Cuadrado: writeln('La figura de menor altura es: Cuadrado');
        Rectangulo: writeln('La figura de menor altura es: Rectángulo');
        TrianguloIzqdo: writeln('La figura de menor altura es: Triangulo izquierdo');
        TrianguloDrcho: writeln('La figura de menor altura es: Triangulo derecho');
        Triangulo: writeln('La figura de menor altura es: Triangulo');
    end;
end;

begin
    contador := 0;
    totalFiguras := 0;
    totalLineas := 0;
    primeraFigura := true;

    repeat
        contador := contador + 1;

        case contador of
            1: SolicitarDatos(figura1);
            2: SolicitarDatos(figura2);
            3: SolicitarDatos(figura3);
            4: SolicitarDatos(figura4);
            5: SolicitarDatos(figura5);
        end;

        writeln('¿Finalizar?');
        readln(parar);
    until (parar = 'F') or (contador = 5);

    writeln('Dibujando las figuras ingresadas:');
    writeln();

    if contador >= 1 then
    begin
        DibujarFigura(figura1);
        EvaluarEstadisticas(figura1);
        ContarCaracteres(figura1);
        writeln();
    end;
    if contador >= 2 then
    begin
        DibujarFigura(figura2);
        EvaluarEstadisticas(figura2);
        ContarCaracteres(figura2);
        writeln();
    end;
    if contador >= 3 then
    begin
        DibujarFigura(figura3);
        EvaluarEstadisticas(figura3);
        ContarCaracteres(figura3);
        writeln();
    end;
    if contador >= 4 then
    begin
        DibujarFigura(figura4);
        EvaluarEstadisticas(figura4);
        ContarCaracteres(figura4);
        writeln();
    end;
    if contador >= 5 then
    begin
        DibujarFigura(figura5);
        EvaluarEstadisticas(figura5);
        ContarCaracteres(figura5);
        writeln();
    end;

    writeln('Total de figuras dibujadas: ', totalFiguras);
    writeln('Total de lineas dibujadas: ', totalLineas);
    MostrarNombreFiguraMenorAltura(figuraMenorAltura);
    writeln('Total de caracteres:', totalcaracteres);
    
end.
