program practica6;

type
  tipo_figura = record
    nombre: (Cuadrado, Rectangulo, TrianguloIzqdo, TrianguloDrcho, Triangulo, FIN);
    caracter: char;
    ancho: integer;
    alto: integer;
  end;

procedure DibujarCuadrado(dibujo: char; alto: integer);
var
  i, j: integer;
begin
  for i := 1 to alto do
  begin
    for j := 1 to alto do
    begin
      write(dibujo);
    end;
    writeln();
  end;
end;

procedure DibujarRectangulo(dibujo: char; alto, ancho: integer);
var
  i, j: integer;
begin
  for i := 1 to alto do
  begin
    for j := 1 to ancho do
    begin
      write(dibujo);
    end;
    writeln();
  end;
end;

procedure DibujarTrianguloIzqdo(dibujo: char; alto: integer);
var
  i, j: integer;
begin
  for i := 1 to alto do
  begin
    for j := 1 to i do
    begin
      write(dibujo);
    end;
    writeln();
  end;
end;

procedure DibujarTrianguloDrcho(dibujo: char; alto: integer);
var
  i, j: integer;
begin
  for i := 1 to alto do
  begin
    for j := 1 to alto - i do
    begin
      write(' ');
    end;
    for j := 1 to i do
    begin
      write(dibujo);
    end;
    writeln();
  end;
end;

procedure DibujarTriangulo(dibujo: char; alto: integer);
var
  i, j: integer;
begin
  for i := 1 to alto do
  begin
    for j := 1 to alto - i do
    begin
      write(' ');
    end;
    for j := 1 to 2 * i - 1 do
    begin
      write(dibujo);
    end;
    writeln();
  end;
end;

procedure EvaluarEstadisticas(figura: tipo_figura; var figuraMenorAltura: tipo_figura; var primeraFigura: boolean);
begin
    if primeraFigura or (figura.alto < figuraMenorAltura.alto) then
    begin
        figuraMenorAltura := figura;
        primeraFigura := false;
    end;
end;

var
  figura: tipo_figura;
  num_fig, num_lin: integer;
  figuraMenorAltura: tipo_figura;
  primeraFigura: boolean;
begin
  num_fig := 0;
  num_lin := 0;
  primeraFigura := true;

  figuraMenorAltura.nombre := FIN; 

  readln(figura.nombre);

  while figura.nombre <> FIN do
  begin
    num_fig := num_fig + 1;

    case figura.nombre of
      Cuadrado:
        begin
          readln(figura.caracter);
          readln(figura.alto);
          num_lin := num_lin + figura.alto;
          writeln(figura.nombre, ' "', figura.caracter, '" ', figura.alto);
          DibujarCuadrado(figura.caracter, figura.alto);
        end;
      Rectangulo:
        begin
          readln(figura.caracter);
          readln(figura.alto);
          readln(figura.ancho);
          num_lin := num_lin + figura.alto;
          writeln(figura.nombre, ' "', figura.caracter, '" ', figura.alto, ' ', figura.ancho);
          DibujarRectangulo(figura.caracter, figura.alto, figura.ancho);
        end;
      TrianguloIzqdo:
        begin
          readln(figura.caracter);
          readln(figura.alto);
          num_lin := num_lin + figura.alto;
          writeln(figura.nombre, ' "', figura.caracter, '" ', figura.alto);
          DibujarTrianguloIzqdo(figura.caracter, figura.alto);
        end;
      TrianguloDrcho:
        begin
          readln(figura.caracter);
          readln(figura.alto);
          num_lin := num_lin + figura.alto;
          writeln(figura.nombre, ' "', figura.caracter, '" ', figura.alto);
          DibujarTrianguloDrcho(figura.caracter, figura.alto);
        end;
      Triangulo:
        begin
          readln(figura.caracter);
          readln(figura.alto);
          num_lin := num_lin + figura.alto;
          writeln(figura.nombre, ' "', figura.caracter, '" ', figura.alto);
          DibujarTriangulo(figura.caracter, figura.alto);
        end;
    end;

    EvaluarEstadisticas(figura, figuraMenorAltura, primeraFigura);

    readln(figura.nombre);
  end;

  writeln('Total de figuras dibujadas: ', num_fig);
  writeln('Total de lineas dibujadas: ', num_lin);
  writeln('La figura de menor altura es: ', figuraMenorAltura.nombre);
end.
