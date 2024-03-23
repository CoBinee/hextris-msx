; Tetrimino.inc : テトリミノ
;


; マクロの定義
;

; テトリミノ
;
TETRIMINO_TYPE              =   0x00
TETRIMINO_ROTATE            =   0x01
TETRIMINO_STATE             =   0x02
TETRIMINO_TIMER             =   0x03
TETRIMINO_POSITION_X        =   0x04
TETRIMINO_POSITION_Y        =   0x05
TETRIMINO_COLOR             =   0x06
TETRIMINO_PATTERN           =   0x07
TETRIMINO_INPUT_LEFT        =   0x08
TETRIMINO_INPUT_RIGHT       =   0x09
TETRIMINO_INPUT_DROP        =   0x0a
TETRIMINO_FALL              =   0x0b
TETRIMINO_LOCK              =   0x0c
TETRIMINO_DETECT            =   0x0d
TETRIMINO_DETECT_MOVE       =   0x0e
TETRIMINO_DETECT_ROTATE     =   0x0f
TETRIMINO_SIZE              =   0x10

; 種類
TETRIMINO_TYPE_NULL         =   0x00
TETRIMINO_TYPE_O            =   0x01
TETRIMINO_TYPE_I            =   0x02
TETRIMINO_TYPE_B            =   0x03
TETRIMINO_TYPE_D            =   0x04
TETRIMINO_TYPE_L            =   0x05
TETRIMINO_TYPE_J            =   0x06
TETRIMINO_TYPE_S            =   0x07
TETRIMINO_TYPE_Z            =   0x08
TETRIMINO_TYPE_U            =   0x09
TETRIMINO_TYPE_Y            =   0x0a
TETRIMINO_TYPE_SIZE         =   0x0b

; 回転
TETRIMINO_ROTATE_000        =   0x00
TETRIMINO_ROTATE_060        =   0x01
TETRIMINO_ROTATE_120        =   0x02
TETRIMINO_ROTATE_180        =   0x03
TETRIMINO_ROTATE_240        =   0x04
TETRIMINO_ROTATE_300        =   0x05
TETRIMINO_ROTATE_SIZE       =   0x06

; 状態
TETRIMINO_STATE_NULL        =   0x00

; パターン
TETRIMINO_PATTERN_NORMAL    =   0x08
TETRIMINO_PATTERN_GHOST     =   0x0c

; キー入力
TETRIMINO_INPUT_INTERVAL_0  =   0x08
TETRIMINO_INPUT_INTERVAL_1  =   0x03

; 落下
TETRIMINO_FALL_INTERVAL     =   0x01

; ロックダウン
TETRIMINO_LOCK_INTERVAL     =   0x1e

; 判定
TETRIMINO_DETECT_NULL       =   0b00000000
TETRIMINO_DETECT_SIZE       =   0x06
TETRIMINO_DETECT_O          =   0b00000001
TETRIMINO_DETECT_000        =   0b00000010
TETRIMINO_DETECT_060        =   0b00000100
TETRIMINO_DETECT_120        =   0b00001000
TETRIMINO_DETECT_240        =   0b00010000
TETRIMINO_DETECT_300        =   0b00100000
TETRIMINO_DETECT_090        =   0b01000000
TETRIMINO_DETECT_270        =   0b10000000

; 外部関数宣言
;

    .globl  _TetriminoInitialize
    .globl  _TetriminoUpdate
    .globl  _TetriminoRender
    .globl  _TetriminoReset
    .globl  _TetriminoGenerate
    .globl  _TetriminoFall

; 外部変数宣言
;

    .globl  _tetrimino
    .globl  _tetriminoGhost
