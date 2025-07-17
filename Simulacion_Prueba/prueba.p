import random

# Número de simulaciones
simulaciones = 1000

ganar_quedarse = 0
ganar_cambiar = 0

for _ in range(simulaciones):
    # Poner el auto detrás de una de las 3 puertas (puertas: 0, 1, 2)
    premio = random.randint(0,2)
    # El jugador elige una puerta al azar
    eleccion = random.randint(0,2)
    # El presentador abre una de las otras puertas (que no tiene el auto y no es la elegida)
    opciones_para_monty = [i for i in range(3) if i != eleccion and i != premio]
    puerta_abierta = random.choice(opciones_para_monty)
    # Opciones que quedan para cambiar
    puertas_disponibles = [i for i in range(3) if i != eleccion and i != puerta_abierta]
    # Quedarse
    if eleccion == premio:
        ganar_quedarse += 1
    # Cambiar (la otra puerta disponible es la elegida)
    if puertas_disponibles[0] == premio:
        ganar_cambiar += 1

print(f'Tasa de ganar si te quedas: {ganar_quedarse/simulaciones:.2%}')
print(f'Tasa de ganar si cambias: {ganar_cambiar/simulaciones:.2%}')
