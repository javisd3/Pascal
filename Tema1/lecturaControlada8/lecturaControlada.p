program lecturaControlada;

const
    numFilas = 10;
    numColumnas = 10;
    MaxBarcos = 10;

type
  TipoEntrada = (Submarino, Dragaminas, Fragata, Portaaviones, FIN);
  TipoNombre = Submarino..Portaaviones;
  TipoOrientacion = (Horizontal, Vertical);
  TipoPal = string;
  
  TipoCasilla = record
    columna: integer;
    fila: integer;
  end;

  TipoBarco = record
    nombre: TipoNombre;
    proa: TipoCasilla;
    orientacion: TipoOrientacion;
    caracter: char;
    tocadas: array[1..MaxBarcos] of boolean;  
    longitud: integer;  
  end;

  TipoBarcos = array[1..MaxBarcos] of TipoBarco;

function esblanco(c: char): boolean;
begin
  esblanco := (c = ' ') or (c = '   ');  
end;

procedure addcar(var pal: TipoPal; c: char);
var
  n: integer;
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
  while not eof(fich) and not haypal do
  begin
    if eoln(fich) then
    begin
      readln(fich);
    end
    else
    begin
      read(fich, c);
      haypal := not esblanco(c);
      if haypal then
      begin
        addcar(pal, c);
      end;
    end;
  end;
  while haypal and not eof(fich) and not eoln(fich) do
  begin
    read(fich, c);
    haypal := not esblanco(c);
    if haypal then
    begin
      addcar(pal, c);
    end;
  end;
end;

function letraANumero(letra: char): integer;
begin
  if (letra >= 'A') and (letra <= 'Z') then
    letraANumero := ord(letra) - ord('A') + 1;
end;

procedure leerDatos(var barco: TipoBarco; var hayBarco: boolean);
var
  entrada: string; 
  proaChr: char;
  archivo: text;
begin
  hayBarco := false;

  Assign(archivo, 'datos.txt');
  Reset(archivo);

  if not EOF(archivo) then
  begin
    readln(archivo, entrada);

    if entrada <> 'FIN' then
    begin
      hayBarco := true;
      // Asignar el tipo de barco
      if entrada = 'Submarino' then
        barco.nombre := Submarino
      else if entrada = 'Dragaminas' then
        barco.nombre := Dragaminas
      else if entrada = 'Fragata' then
        barco.nombre := Fragata
      else if entrada = 'Portaaviones' then
        barco.nombre := Portaaviones;

      readln(archivo, entrada);  
      if entrada = 'Horizontal' then
        barco.orientacion := Horizontal
      else
        barco.orientacion := Vertical;

      readln(archivo, proaChr);  
      barco.proa.columna := letraANumero(proaChr);

      readln(archivo, barco.proa.fila); 
    end;
  end;

  Close(archivo);
end;

function longitudbarco(barco: TipoBarco): integer;
begin
  case barco.nombre of
    Submarino: longitudbarco := 1;
    Dragaminas: longitudbarco := 2;
    Fragata: longitudbarco := 3;
    Portaaviones: longitudbarco := 4;
  else
    longitudbarco := 0; 
  end;
end;

function InicialDelBarco(barco: TipoBarco): char;
begin
  case barco.nombre of
    Submarino: InicialDelBarco := 'S';
    Dragaminas: InicialDelBarco := 'D';
    Fragata: InicialDelBarco := 'F';
    Portaaviones: InicialDelBarco := 'P';
  else
    InicialDelBarco := 'X'; 
  end;
end;

function ubicacionBarco(barco: TipoBarco; casilla: TipoCasilla): boolean;
var
  procolumna: integer;
  proafila: integer;
  i: integer;
begin
  if barco.orientacion = Horizontal then
  begin
    procolumna := barco.proa.columna + longitudbarco(barco) - 1;
    ubicacionBarco :=   (casilla.fila = barco.proa.fila) and
                        (casilla.columna >= barco.proa.columna) and
                        (casilla.columna <= procolumna);
    // Marcar casillas tocadas
    if ubicacionBarco then
    begin
      for i := barco.proa.columna to procolumna do
        barco.tocadas[i] := true;
    end;
  end
  else
  begin
    proafila := barco.proa.fila + longitudbarco(barco) - 1;
    ubicacionBarco :=   (casilla.columna = barco.proa.columna) and
                        (casilla.fila >= barco.proa.fila) and
                        (casilla.fila <= proafila);
    // Marcar casillas tocadas
    if ubicacionBarco then
    begin
      for i := barco.proa.fila to proafila do
        barco.tocadas[i] := true;
    end;
  end;
end;

procedure dibujarTablero(Barcos: TipoBarcos; numBarcos: integer);
var
  fila: integer;
  columna: integer;
  casilla: TipoCasilla;
  i: integer;
  hayBarco: boolean;
begin
  for fila := 1 to numFilas do
  begin
    for columna := 1 to numColumnas do
    begin
      casilla.columna := columna;
      casilla.fila := fila;
      hayBarco := false;

      for i := 1 to numBarcos do
      begin
        if ubicacionBarco(Barcos[i], casilla) then
        begin
          hayBarco := true;
          write(InicialDelBarco(Barcos[i]), ' ');
        end;
      end;

      if not hayBarco then
        write('. ', ' ');  
    end;
    writeln;
  end;
end;

procedure disparar(var Barcos: TipoBarcos; numBarcos: integer);
var
  disparo: TipoCasilla;
  i: integer;
  tocado: boolean;
begin
  writeln('Introduce las coordenadas de tu disparo (fila y columna):');
  readln(disparo.fila, disparo.columna);
  
  tocado := false;
  for i := 1 to numBarcos do
  begin
    if ubicacionBarco(Barcos[i], disparo) then
    begin
      tocado := true;
      writeln('¡Tocado!');
      exit; 
    end;
  end;

  if not tocado then
    writeln('¡Agua!');
end;

var
  Barcos: TipoBarcos;
  numBarcos, i: integer;
  hayBarco: boolean;
begin
  numBarcos := 0;
  hayBarco := false;

  while not hayBarco do
  begin
    leerDatos(Barcos[numBarcos + 1], hayBarco);
    if hayBarco then
      numBarcos := numBarcos + 1;
  end;

  dibujarTablero(Barcos, numBarcos);
  
  while true do
  begin
    disparar(Barcos, numBarcos);
  end;
end.
