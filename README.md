# Juego Game Boy Clásico (Assembly)

Un juego básico para Game Boy desarrollado en ensamblador puro.

## Requisitos

- RGBDS (Rednex Game Boy Development System)
- Make
- Emulador de Game Boy (BGB, Visual Boy Advance, etc.)

## Instalación de RGBDS

1. Descarga RGBDS desde: https://github.com/gbdev/rgbds/releases
2. Extrae el archivo y añade la carpeta al PATH del sistema

## Compilación

```bash
make
```

Esto generará el archivo `game.gb` que puedes ejecutar en cualquier emulador de Game Boy.

## Controles

- Flechas direccionales: Mover el jugador
- El objetivo es mover el sprite por la pantalla

## Estructura del Proyecto

- `main.asm`: Código principal del juego en ensamblador
- `Makefile`: Script de compilación
- `game.gb`: ROM compilada (se genera después de make)

## Características del Assembly

- Control directo de registros del Game Boy
- Lectura manual del joypad
- Manejo de sprites en OAM
- Sincronización con VBlank
- Header de cartucho válido

## Próximos Pasos

Puedes expandir este juego añadiendo:
- Más sprites y tiles
- Background graphics
- Sistema de colisiones
- Enemigos
- Sonido
- Múltiples niveles