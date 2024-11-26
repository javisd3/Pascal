//leer, calcular media, ordenar y escribir
program cartones;

const
  MaxCartones = 10;
  Esp: char = ' ';
  Tab: string = '   ';

type
  TipoPal = string;
  TipoColor = (Rojo, Verde, Azul, Amarillo);
  TipoNumero = 1..100;  
  TipoFila = record
    Color: TipoColor;
    Numeros: array[1..5] of TipoNumero;
  end;

  TipoCarton = record
    Filas: array[1..3] of TipoFila;
    Media: Real;
  end;

var
  ListaCartones: array[1..MaxCartones] of TipoCarton;  
  numCartones: Integer;
  fich: TextFile;
  carton: TipoCarton;
  ok: Boolean;
  i, j: Integer;

function esblanco(c: char): boolean;
begin
  esblanco := (c = Esp) or (c = Tab);  
end;

procedure addcar(var pal: TipoPal; c: char);
var
  n: Integer;
begin
  n := length(pal);
  n := n + 1;
  setlength(pal, n);
  pal[n] := c;
end;

procedure leerpal(var fich: text; var pal: TipoPal);
var
  c: char;
  haypal: boolean;
begin
  haypal := False;
  pal := '';
  while not eof(fich) and not haypal do begin
    if eoln(fich) then begin
      readln(fich);
    end
    else begin
      read(fich, c);
      haypal := not esblanco(c);
      if haypal then begin
        addcar(pal, c);
      end;
    end;
  end;
  while haypal and not eof(fich) and not eoln(fich) do begin
    read(fich, c);
    haypal := not esblanco(c);
    if haypal then begin
      addcar(pal, c);
    end;
  end;
end;

procedure leercolor(var fich: text; var color: TipoColor; var ok: boolean);
var
  pal: TipoPal;
  pos: Integer;
begin
  leerpal(fich, pal);
  val(pal, color, pos);
  ok := pos = 0;
end;

procedure leernumero(var fich: text; var numero: TipoNumero; var ok: boolean);
var
  pal: TipoPal;
  pos: Integer;
begin
  leerpal(fich, pal);
  val(pal, numero, pos);
  ok := pos = 0;
end;

procedure leerfila(var fich: text; var fila: TipoFila; var ok: boolean);
var
  i: Integer;
begin
  leercolor(fich, fila.Color, ok);  
  if ok then begin
    for i := 1 to 5 do begin  
      leernumero(fich, fila.Numeros[i], ok);
      if not ok then
        break; 
    end;
  end;
end;

procedure leerCarton(var fich: text; var carton: TipoCarton; var ok: boolean);
var
  i: Integer;
begin
  for i := 1 to 3 do begin
    leerfila(fich, carton.Filas[i], ok);
    if not ok then
      break;
  end;

  if ok then begin
    carton.Media := 0;
    for i := 1 to 3 do begin
      for j := 1 to 5 do begin
        carton.Media := carton.Media + carton.Filas[i].Numeros[j];
      end;
    end;
    carton.Media := carton.Media / 15;  
  end;
end;

procedure ordenarCartones(var ListaCartones: array of TipoCarton; totalCartones: Integer);
var
  i, j: Integer;
  temp: TipoCarton;
begin
  for i := 0 to totalCartones - 2 do
    for j := i + 1 to totalCartones - 1 do
      if ListaCartones[i].Media < ListaCartones[j].Media then begin
        // Intercambio de cartones
        temp := ListaCartones[i];
        ListaCartones[i] := ListaCartones[j];
        ListaCartones[j] := temp;
      end;
end;

begin
  assign(fich, 'datos.txt');
  reset(fich);
  numCartones := 0;

  // Leer cartones
  while not eof(fich) and (numCartones < MaxCartones) do
  begin
    leerCarton(fich, ListaCartones[numCartones + 1], ok);
    if ok then
      numCartones := numCartones + 1;
  end;
  close(fich);

  // Ordenar los cartones por media
  ordenarCartones(ListaCartones, numCartones);

  // Mostrar cartones ordenados
  for i := 1 to numCartones do
  begin
    writeln('Cartón ', i, ': Media = ', ListaCartones[i].Media:0:2);
  end;
end.
