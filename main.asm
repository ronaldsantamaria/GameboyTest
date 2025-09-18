SECTION "Header", ROM0[$100]
    nop
    jp Start

SECTION "NintendoLogo", ROM0[$104]
    ; Logo de Nintendo (obligatorio)
    DB $CE, $ED, $66, $66, $CC, $0D, $00, $0B, $03, $73, $00, $83, $00, $0C, $00, $0D
    DB $00, $08, $11, $1F, $88, $89, $00, $0E, $DC, $CC, $6E, $E6, $DD, $DD, $D9, $99
    DB $BB, $BB, $67, $63, $6E, $0E, $EC, $CC, $DD, $DC, $99, $9F, $BB, $B9, $33, $3E

SECTION "CartridgeHeader", ROM0[$134]
    DB "GAMEBOY GAME", 0, 0, 0, 0

SECTION "Start", ROM0[$150]
Start:
    ; Deshabilitar interrupciones
    di
    
    ; Configurar stack pointer
    ld sp, $FFFE
    
    ; Esperar VBlank
    call WaitVBlank
    
    ; Apagar LCD
    ld a, 0
    ld [$FF40], a
    
    ; Cargar sprite data de Dave
    ld hl, DaveSprites
    ld de, $8000
    ld bc, 64          ; 4 tiles de 16 bytes cada uno
    call CopyData
    
    ; Configurar sprite en OAM
    ld a, 80        ; Y position
    ld [$FE00], a
    ld a, 80        ; X position  
    ld [$FE01], a
    ld a, 0         ; Tile number
    ld [$FE02], a
    ld a, 0         ; Attributes
    ld [$FE03], a
    
    ; Encender LCD con sprites
    ld a, %10010010
    ld [$FF40], a
    
    ; Variables del jugador Dave
    ld a, 80
    ld [PlayerX], a
    ld [PlayerY], a
    ld a, 0             ; Dave mirando hacia abajo
    ld [PlayerDirection], a
    
    ; Habilitar interrupciones
    ei

GameLoop:
    ; Leer joypad
    call ReadJoypad
    
    ; Procesar input
    ld a, [JoypadState]
    
    ; Verificar UP
    bit 2, a
    jr nz, CheckDown
    ld a, [PlayerY]
    cp 16
    jr c, CheckDown
    dec a
    dec a
    ld [PlayerY], a
    ld a, 1             ; Dirección: arriba
    ld [PlayerDirection], a
    
CheckDown:
    ld a, [JoypadState]
    bit 3, a
    jr nz, CheckLeft
    ld a, [PlayerY]
    cp 144
    jr nc, CheckLeft
    inc a
    inc a
    ld [PlayerY], a
    ld a, 0             ; Dirección: abajo
    ld [PlayerDirection], a
    
CheckLeft:
    ld a, [JoypadState]
    bit 1, a
    jr nz, CheckRight
    ld a, [PlayerX]
    cp 8
    jr c, CheckRight
    dec a
    dec a
    ld [PlayerX], a
    ld a, 2             ; Dirección: izquierda
    ld [PlayerDirection], a
    
CheckRight:
    ld a, [JoypadState]
    bit 0, a
    jr nz, UpdateSprite
    ld a, [PlayerX]
    cp 160
    jr nc, UpdateSprite
    inc a
    inc a
    ld [PlayerX], a
    ld a, 3             ; Dirección: derecha
    ld [PlayerDirection], a
    
UpdateSprite:
    ; Actualizar posición y tile de Dave
    ld a, [PlayerY]
    ld [$FE00], a
    ld a, [PlayerX]
    ld [$FE01], a
    ld a, [PlayerDirection]  ; Cambiar sprite según dirección
    ld [$FE02], a
    
    ; Esperar VBlank
    call WaitVBlank
    
    jr GameLoop

WaitVBlank:
    ld a, [$FF44]
    cp 144
    jr nz, WaitVBlank
    ret

ReadJoypad:
    ; Leer direcciones
    ld a, $20
    ld [$FF00], a
    ld a, [$FF00]
    ld a, [$FF00]
    cpl
    and $0F
    swap a
    ld b, a
    
    ; Leer botones
    ld a, $10
    ld [$FF00], a
    ld a, [$FF00]
    ld a, [$FF00]
    ld a, [$FF00]
    ld a, [$FF00]
    ld a, [$FF00]
    ld a, [$FF00]
    cpl
    and $0F
    or b
    ld [JoypadState], a
    
    ; Resetear joypad
    ld a, $30
    ld [$FF00], a
    ret

CopyData:
    ld a, [hl+]
    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, CopyData
    ret

SECTION "SpriteData", ROM0
DaveSprites:
    ; Dave mirando hacia abajo (tile 0) - Cara frontal
    DB $18, $18, $24, $3C, $66, $7E, $5A, $66
    DB $42, $7E, $42, $7E, $24, $3C, $18, $18
    
    ; Dave mirando hacia arriba (tile 1) - Cabello visible
    DB $18, $18, $3C, $24, $7E, $42, $66, $5A
    DB $7E, $42, $3C, $24, $18, $18, $00, $00
    
    ; Dave mirando izquierda (tile 2) - Perfil izquierdo
    DB $0C, $0C, $1E, $12, $3F, $21, $33, $2D
    DB $3F, $21, $1E, $12, $0C, $0C, $00, $00
    
    ; Dave mirando derecha (tile 3) - Perfil derecho
    DB $30, $30, $78, $48, $FC, $84, $CC, $B4
    DB $FC, $84, $78, $48, $30, $30, $00, $00

SECTION "Variables", WRAM0
PlayerX: DS 1
PlayerY: DS 1
JoypadState: DS 1
PlayerDirection: DS 1    ; 0=abajo, 1=arriba, 2=izq, 3=der