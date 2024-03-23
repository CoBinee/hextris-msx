; Game.inc : ゲーム
;


; マクロの定義
;

; 状態
GAME_STATE_NULL                 =   0x00
GAME_STATE_TITLE                =   0x10
GAME_STATE_START                =   0x20
GAME_STATE_GENERATE             =   0x30
GAME_STATE_FALL                 =   0x40
GAME_STATE_PATTERN              =   0x50
GAME_STATE_ELIMINATE            =   0x60
GAME_STATE_GRAVITY              =   0x70
GAME_STATE_COMPLETE             =   0x80
GAME_STATE_OVER                 =   0x90

; スプライト
GAME_SPRITE_TETRIMINO_NORMAL    =   0x00
GAME_SPRITE_TETRIMINO_GHOST     =   0x10
GAME_SPRITE_LOGO                =   0x40
GAME_SPRITE_PRESS               =   0x60
GAME_SPRITE_OVER                =   0x40

; 数値
GAME_NUMBER_SIZE                =   7

; レベル
GAME_LEVEL_MAX                  =   15

; 外部関数宣言
;

    .globl  _GameInitialize
    .globl  _GameUpdate

; 外部変数宣言
;

    .globl  _gameLevel
