; Matrix.inc : マトリクス
;


; マクロの定義
;

; パターン
MATRIX_PATTERN_MATCH    =   0x0f

; 外部関数宣言
;

    .globl  _MatrixInitialize
    .globl  _MatrixUpdate
    .globl  _MatrixRender
    .globl  _MatrixReset
    .globl  _MatrixPattern
    .globl  _MatrixEliminate
    .globl  _MatrixGravity
    .globl  _MatrixLock

; 外部変数宣言
;

    .globl  _matrix
    .globl  _matrixPatternLine
