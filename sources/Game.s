; Game.s : �Q�[��
;


; ���W���[���錾
;
    .module Game

; �Q�ƃt�@�C��
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include	"Game.inc"
    .include    "Matrix.inc"
    .include    "Tetrimino.inc"

; �O���ϐ��錾
;

; �}�N���̒�`
;


; CODE �̈�
;
    .area   _CODE

; �Q�[��������������
;
_GameInitialize::
    
    ; ���W�X�^�̕ۑ�
    
    ; �X�v���C�g�̃N���A
    call    _SystemClearSprite
    
    ; �p�^�[���̃N���A
    ld      hl, #gamePatternName
    ld      de, #_appPatternName
    ld      bc, #0x0300
    ldir
    
    ; �p�^�[���l�[���̓]��
    ld      hl, #_appPatternName
    ld      de, #APP_PATTERN_NAME_TABLE_0
    ld      bc, #0x0300
    call    LDIRVM
    
    ; �}�g���N�X�̏�����
    call    _MatrixInitialize
    
    ; �e�g���~�m�̏�����
    call    _TetriminoInitialize
    
    ; �X�R�A�̏�����
    call    GameResetScore
    
    ; �n�C�X�R�A�̏�����
    ld      hl, #(gameHiScore + 0x0000)
    ld      de, #(gameHiScore + 0x0001)
    ld      bc, #(GAME_NUMBER_SIZE - 1)
    xor     a
    ld      (hl), a
    ldir
    inc     a
    ld      (gameHiScore + GAME_NUMBER_SIZE - 5), a
    
    ; �`��̊J�n
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)
    
    ; �r�f�I���W�X�^�̓]��
    ld      hl, #_request
    set     #REQUEST_VIDEO_REGISTER, (hl)
    
    ; ��Ԃ̐ݒ�
    ld      a, #GAME_STATE_TITLE
    ld      (gameState), a
    ld      a, #APP_STATE_GAME_UPDATE
    ld      (_appState), a
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �Q�[�����X�V����
;
_GameUpdate::
    
    ; ���W�X�^�̕ۑ�
    push    hl
    push    bc
    push    de
    push    ix
    push    iy
    
    ; �X�v���C�g�̃N���A
    call    _SystemClearSprite
    
    ; ��ԕʂ̏���
    ld      a, (gameState)
    and     #0xf0
    cp      #GAME_STATE_TITLE
    jr      nz, 10$
    call    GameTitle
    jr      99$
10$:
    cp      #GAME_STATE_START
    jr      nz, 11$
    call    GameStart
    jr      99$
11$:
    cp      #GAME_STATE_GENERATE
    jr      nz, 12$
    call    GameGenerate
    jr      90$
12$:
    cp      #GAME_STATE_FALL
    jr      nz, 13$
    call    GameFall
    jr      90$
13$:
    cp      #GAME_STATE_PATTERN
    jr      nz, 14$
    call    GamePattern
    jr      90$
14$:
    cp      #GAME_STATE_ELIMINATE
    jr      nz, 15$
    call    GameEliminate
    jr      90$
15$:
    cp      #GAME_STATE_GRAVITY
    jr      nz, 16$
    call    GameGravity
    jr      90$
16$:
    cp      #GAME_STATE_COMPLETE
    jr      nz, 17$
    call    GameComplete
    jr      90$
17$:
    cp      #GAME_STATE_OVER
    jr      nz, 18$
    call    GameOver
    jr      99$
18$:
    jr      99$

    ; �a�f�l�̍Đ�
90$:
    call    GameBgmPlayer

    ; ��ԕʏ����̊���
99$:
    
    ; ���W�X�^�̕��A
    pop     iy
    pop     ix
    pop     de
    pop     bc
    pop     hl
    
    ; �I��
    ret

; �^�C�g����\������
;
GameTitle:
    
    ; ���W�X�^�̕ۑ�
    
    ; �������̊J�n
    ld      a, (gameState)
    and     #0x0f
    jr      nz, 09$
    
    ; �^�C�}�̐ݒ�
    xor     a
    ld      (gameTimer), a
    
    ; �������̊���
    ld      hl, #gameState
    inc     (hl)
09$:

    ; �L�[���͑҂�
    ld      a, (gameState)
    and     #0x0f
    dec     a
    jr      nz, 19$
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 10$
    ld      hl, #gameSoundStart_0
    ld      (_soundRequest + 0x0000), hl
    ld      hl, #gameState
    inc     (hl)
10$:

    ; PRESS SPACE BAR �̕`��
    ld      a, (gameTimer)
    rra
    rra
    and     #0x30
    ld      e, a
    ld      d, #0x00
    ld      hl, #gameSpritePress
    add     hl, de
    ld      de, #(_sprite + GAME_SPRITE_PRESS)
    ld      bc, #0x000c
    ldir
    
    ; �L�[���͑҂��̊���
    jr      90$
19$:

    ; �T�E���h�̍Đ��҂�
    dec     a
    jr      nz, 29$
    ld      hl, (_soundPlay + 0x0000)
    ld      a, h
    or      l
    jr      nz, 90$
    
    ; �T�E���h�̍Đ��҂��̊���
    ld      a, #GAME_STATE_START
    ld      (gameState), a
    jr      90$
29$:

    ; �^�C�g���̊���
90$:
    
    ; �����̍X�V
    call    _SystemGetRandom
    
    ; �^�C�}�̍X�V
    ld      hl, #gameTimer
    inc     (hl)
    
    ; ���S�̕`��
    ld      hl, #gameSpriteLogo
    ld      de, #(_sprite + GAME_SPRITE_LOGO)
    ld      bc, #0x001c
    ldir
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �Q�[�����X�^�[�g����
;
GameStart:
    
    ; ���W�X�^�̕ۑ�
    
    ; �X�R�A�̃��Z�b�g
    ld      a, (gameState)
    and     #0x0f
    jr      nz, 09$
    call    GameResetScore
    call    GameDrawScore
    
    ; �X�R�A�̃��Z�b�g�̊���
    ld      hl, #gameState
    inc     (hl)
    jr      99$
09$:
    
    ; �e�g���~�m�̃��Z�b�g
    dec     a
    jr      nz, 19$
    call    _TetriminoReset
    
    ; �e�g���~�m�̃��Z�b�g�̊���
    ld      hl, #gameState
    inc     (hl)
    jr      99$
19$:
    
    ; �}�g���N�X�̃��Z�b�g
    dec     a
    jr      nz, 29$
    call    _MatrixReset
    
    ; �}�g���N�X�̃��Z�b�g�̊���
    ld      hl, #gameState
    inc     (hl)
    jr      99$
29$:
    
    ; �}�g���N�X�̍X�V
;   dec     a
;   jr      nz, 39$
    call    _MatrixUpdate
    call    _MatrixRender
    
    ; �}�g���N�X�̍X�V�̊���
    ld      hl, #_matrixPatternLine
    ld      a, #MATRIX_PATTERN_MATCH
    ld      bc, #0x1f
    cpir
    jr      z, 99$
39$:
    
    ; �a�f�l�̏�����
    xor     a
    ld      (gameBgm), a
    
    ; �Q�[���X�^�[�g�̊���
    ld      a, #GAME_STATE_GENERATE
    ld      (gameState), a
99$:

    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �e�g���~�m�𐶐�����
;
GameGenerate:
    
    ; ���W�X�^�̕ۑ�
    
    ; �e�g���~�m�̐���
    call    _TetriminoGenerate
    
    ; �t���O�̕ۑ�
    push    af
    
    ; �e�g���~�m�̕`��
    call    _TetriminoRender
    
    ; �t���O�̕��A
    pop     af
    
    ; �����̊���
    ld      a, #GAME_STATE_FALL
    jr      z, 90$
    ld      a, #GAME_STATE_OVER
90$:
    ld      (gameState), a
99$:
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �e�g���~�m����������
;
GameFall:
    
    ; ���W�X�^�̕ۑ�
    
    ; �e�g���~�m�̗���
    call    _TetriminoFall
    
    ; �X�R�A�̉��Z
10$:
    cp      #0x0a
    jr      c, 11$
    ld      hl, #(gameScore + GAME_NUMBER_SIZE - 1)
    ld      a, #0x0a
    call    GameAddValue
    ld      a, c
    sub     #0x0a
    ld      c, a
    jr      10$
11$:
    ld      hl, #(gameScore + GAME_NUMBER_SIZE - 1)
    call    GameAddValue
    
    ; �n�C�X�R�A�̍X�V
    ld      hl, #gameHiScore
    ld      de, #gameScore
    ld      b, #GAME_NUMBER_SIZE
20$:
    ld      a, (de)
    cp      (hl)
    jr      c, 29$
    jr      nz, 21$
    inc     hl
    inc     de
    djnz    20$
    jr      29$
21$:
    ld      hl, #gameScore
    ld      de, #gameHiScore
    ld      bc, #GAME_NUMBER_SIZE
    ldir
29$:
    
    ; �X�R�A�̕`��
    call    GameDrawScore
    
    ; �e�g���~�m�̕`��
    call    _TetriminoRender
    
    ; �����̊���
    ld      a, (_tetrimino + TETRIMINO_TYPE)
    or      a
    jr      nz, 99$
    ld      hl, #gameSoundLock_3
    ld      (_soundRequest + 0x0006), hl
    ld      a, #GAME_STATE_PATTERN
    ld      (gameState), a
99$:
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �p�^�[�����X�V����
;
GamePattern::
    
    ; ���W�X�^�̕ۑ�
    
    ; �������̊J�n
    ld      a, (gameState)
    and     #0x0f
    jr      nz, 09$
    
    ; �p�^�[���̍X�V
    call    _MatrixPattern
    
    ; �������̊���
    ld      hl, #gameState
    inc     (hl)
09$:
    
    ; �}�g���N�X�̍X�V
    call    _MatrixUpdate
    
    ; �}�g���N�X�̕`��
    call    _MatrixRender
    
    ; �p�^�[���X�V�̊���
    ld      hl, #_matrixPatternLine
    ld      a, #MATRIX_PATTERN_MATCH
    ld      bc, #0x1f
    cpir
    jr      z, 99$
    ld      a, #GAME_STATE_ELIMINATE
    ld      (gameState), a
99$:
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; ��������s������
;
GameEliminate:
    
    ; ���W�X�^�̕ۑ�
    
    ; �������̊J�n
    ld      a, (gameState)
    and     #0x0f
    jr      nz, 09$
    
    ; ��������s������
    call    _MatrixEliminate
    ld      (gameLineEliminate), a
    
    ; �������̊���
    ld      hl, #gameState
    inc     (hl)
09$:
    
    ; �}�g���N�X�̍X�V
    call    _MatrixUpdate
    
    ; �}�g���N�X�̕`��
    call    _MatrixRender
    
    ; �p�^�[���X�V�̊���
    ld      hl, #_matrixPatternLine
    ld      a, #MATRIX_PATTERN_MATCH
    ld      bc, #0x1f
    cpir
    jr      z, 99$
    ld      a, #GAME_STATE_GRAVITY
    ld      (gameState), a
99$:
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �s���߂�
;
GameGravity:
    
    ; ���W�X�^�̕ۑ�
    
    ; �������̊J�n
    ld      a, (gameState)
    and     #0x0f
    jr      nz, 09$
    
    ; �s���߂�
    call    _MatrixGravity
    
    ; �r�d�̍Đ�
    ld      a, (gameLineEliminate)
    or      a
    jr      z, 00$
    ld      hl, #gameSoundGravity_3
    ld      (_soundRequest + 0x0006), hl
00$:
    
    ; �������̊���
    ld      hl, #gameState
    inc     (hl)
09$:
    
    ; �}�g���N�X�̍X�V
    call    _MatrixUpdate
    
    ; �}�g���N�X�̕`��
    call    _MatrixRender
    
    ; �p�^�[���X�V�̊���
    ld      hl, #_matrixPatternLine
    ld      a, #MATRIX_PATTERN_MATCH
    ld      bc, #0x1f
    cpir
    jr      z, 99$
    ld      a, #GAME_STATE_COMPLETE
    ld      (gameState), a
99$:
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �P��̃Q�[�����[�v����������
;
GameComplete:
    
    ; ���W�X�^�̕ۑ�
    
    ; �X�R�A�̌v�Z
    ld      a, (gameLineEliminate)
    or      a
    jr      z, 90$
    
    ; ���C�����̉��Z
    ld      hl, #(gameLine + GAME_NUMBER_SIZE - 1)
    ld      a, (gameLineEliminate)
    call    GameAddValue
    
    ; �X�R�A�̉��Z
    ld      a, (gameLineEliminate)
    dec     a
    ld      h, a
    ld      l, #0x00
    srl     h
    rr      l
    ld      a, (_gameLevel)
    ld      d, #0x00
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    ld      e, a
    add     hl, de
    ld      de, #(gameScoreEliminate + GAME_NUMBER_SIZE - 1)
    add     hl, de
    ld      de, #(gameScore + GAME_NUMBER_SIZE - 1)
    ex      de, hl
    call    GameAddNumber
    
    ; �n�C�X�R�A�̍X�V
    ld      hl, #gameHiScore
    ld      de, #gameScore
    ld      b, #GAME_NUMBER_SIZE
10$:
    ld      a, (de)
    cp      (hl)
    jr      c, 19$
    jr      nz, 11$
    inc     hl
    inc     de
    djnz    10$
    jr      19$
11$:
    ld      hl, #gameScore
    ld      de, #gameHiScore
    ld      bc, #GAME_NUMBER_SIZE
    ldir
19$:
    
    ; ���x���A�b�v
    ld      hl, #gameLineLevelUp
    ld      a, (gameLineEliminate)
    add     a, (hl)
    ld      (hl), a
    cp      #0x0a
    jr      c, 29$
    xor     a
    ld      (hl), a
    ld      hl, #_gameLevel
    ld      a, (hl)
    cp      #GAME_LEVEL_MAX
    jr      nc, 29$
    inc     (hl)
29$:
    
    ; �X�R�A�̕\��
    call    GameDrawScore
    
    ; �Q�[�����[�v�̊���
90$:
    ld      a, #GAME_STATE_GENERATE
    ld      (gameState), a

    ; ���W�X�^�̕��A
    
    ; �I��
    ret
    
; �Q�[���I�[�o�[�ɂȂ�
;
GameOver:
    
    ; ���W�X�^�̕ۑ�
    
    ; �}�g���N�X�̃��b�N
    ld      a, (gameState)
    and     #0x0f
    jr      nz, 09$
    call    _MatrixLock
    
    ; �a�f�l�̒�~
    ld      hl, #gameSoundNull
    ld      (_soundRequest + 0x0000), hl
    ld      (_soundRequest + 0x0002), hl
    ld      (_soundRequest + 0x0004), hl
    
    ; �}�g���N�X�̃��b�N�̊���
    ld      hl, #gameState
    inc     (hl)
    jr      90$
09$:
    
    ; �}�g���N�X�̍X�V
    dec     a
    jr      nz, 19$
    call    _MatrixUpdate
    call    _MatrixRender
    
    ; �}�g���N�X�̍X�V�̊���
    ld      hl, #_matrixPatternLine
    ld      a, #MATRIX_PATTERN_MATCH
    ld      bc, #0x1f
    cpir
    jr      z, 90$
    ld      hl, #gameState
    inc     (hl)
    jr      90$
19$:
    
    ; �W���O���̍Đ�
    dec     a
    jr      nz, 29$
    ld      hl, #gameSoundOver_0
    ld      (_soundRequest + 0x0000), hl
    
    ; �W���O���̍Đ��̊���
    ld      hl, #gameState
    inc     (hl)
    jr      90$
29$:
    
    ; �W���O���̊Ď�
    dec     a
    jr      nz, 39$
    
    ; �Q�[���I�[�o�[�̕`��
    ld      hl, #gameSpriteOver
    ld      de, #(_sprite + GAME_SPRITE_OVER)
    ld      bc, #0x0010
    ldir
    
    ; �T�E���h�Đ��̃`�F�b�N
    ld      hl, (_soundPlay + 0x0000)
    ld      a, h
    or      l
    jr      nz, 90$
    
    ; �W���O���̊Ď��̊���
    ld      hl, #gameState
    inc     (hl)
    jr      90$
39$:
    
    ; �}�g���N�X�̃N���A
    dec     a
    jr      nz, 49$
    call    _MatrixReset
    
    ; �}�g���N�X�̃N���A�̊���
    ld      hl, #gameState
    inc     (hl)
    jr      90$
49$:
    
    ; �}�g���N�X�̍X�V
    dec     a
    jr      nz, 59$
    call    _MatrixUpdate
    call    _MatrixRender
    
    ; �}�g���N�X�̍X�V�̊���
    ld      hl, #_matrixPatternLine
    ld      a, #MATRIX_PATTERN_MATCH
    ld      bc, #0x1f
    cpir
    jr      z, 90$
    ld      hl, #gameState
    inc     (hl)
    jr      90$
59$:
    
    ; �e�g���~�m�̃N���A
    dec     a
    jr      nz, 69$
    call    _TetriminoReset
    
    ; �e�g���~�m�̃N���A�̊���
    ld      a, #GAME_STATE_TITLE
    ld      (gameState), a
69$:
    
    ; �Q�[���I�[�o�[�̊���
90$:

    ; �e�g���~�m�̕`��
    call    _TetriminoRender
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �X�R�A�����Z�b�g����
;
GameResetScore:

    ; ���W�X�^�̕ۑ�
    
    ; �X�R�A�̏�����
    ld      hl, #(gameScore + 0x0000)
    ld      de, #(gameScore + 0x0001)
    ld      bc, #(GAME_NUMBER_SIZE - 1)
    xor     a
    ld      (hl), a
    ldir
    ld      hl, #(gameLine + 0x0000)
    ld      de, #(gameLine + 0x0001)
    ld      bc, #(GAME_NUMBER_SIZE - 1)
    xor     a
    ld      (hl), a
    ldir
    xor     a
    ld      (gameLineLevelUp), a
    ld      (gameLineEliminate), a
    ld      (gameLineDrop), a
    ld      a, #0x01
    ld      (_gameLevel), a
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret
    
; �X�R�A��\������
;
GameDrawScore:

    ; ���W�X�^�̕ۑ�
    
    ; �X�R�A�̕\��
    ld      hl, #gameScore
    ld      de, #(_appPatternName + 0x0041)
    call    GameDrawNumber
    
    ; �n�C�X�R�A�̕\��
    ld      hl, #gameHiScore
    ld      de, #(_appPatternName + 0x00c1)
    call    GameDrawNumber
    
    ; ���C�����̕\��
    ld      hl, #gameLine
    ld      de, #(_appPatternName + 0x0261)
    call    GameDrawNumber
    
    ; ���x���̕\��
    ld      hl, #(_appPatternName + 0x02e6)
    ld      a, (_gameLevel)
    sub     #0x0a
    jr      nc, 10$
    ld      c, #0x00
    add     a, #0x0a
    jr      11$
10$:
    ld      c, #0x11
11$:
    ld      (hl), c
    inc     hl
    add     a, #0x10
    ld      (hl), a
    
    ; �p�^�[���l�[���̓]��
    ld      hl, #(_appPatternName + 0x0040)
    ld      (_videoTransfer + VIDEO_TRANSFER_VRAM_2_SRC), hl
    ld      hl, #(APP_PATTERN_NAME_TABLE_0 + 0x0040)
    ld      (_videoTransfer + VIDEO_TRANSFER_VRAM_2_DST), hl
    ld      a, #0xa0
    ld      (_videoTransfer + VIDEO_TRANSFER_VRAM_2_BYTES), a
    ld      hl, #(_appPatternName + 0x0260)
    ld      (_videoTransfer + VIDEO_TRANSFER_VRAM_3_SRC), hl
    ld      hl, #(APP_PATTERN_NAME_TABLE_2 + 0x0060)
    ld      (_videoTransfer + VIDEO_TRANSFER_VRAM_3_DST), hl
    ld      a, #0xa0
    ld      (_videoTransfer + VIDEO_TRANSFER_VRAM_3_BYTES), a
    ld      hl, #(_request)
    set     #REQUEST_VRAM, (hl)
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; ���l�����Z����^(HL) = (HL) + (DE)
;
GameAddNumber:

    ; ���W�X�^�̕ۑ�
    
    ; (HL) = (HL) + (DE)
    ld      bc, #((GAME_NUMBER_SIZE << 8) + 0x00)
10$:
    ld      a, (de)
    add     a, c
    add     a, (hl)
    ld      (hl), a
    ld      c, #0x00
    sub     #0x0a
    jr      c, 11$
    ld      (hl), a
    inc     c
11$:
    dec     hl
    dec     de
    djnz    10$
    dec     c
    jr      nz, 19$
    ld      bc, #((GAME_NUMBER_SIZE << 8) + 0x09)
12$:
    inc     hl
    ld      (hl), c
    djnz    12$
19$:
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; ���l�����Z����^(HL) = (HL) + A
;
GameAddValue:

    ; ���W�X�^�̕ۑ�
    
    ; (HL) = (HL) + A
    ld      b, #GAME_NUMBER_SIZE
10$:
    add     a, (hl)
    ld      (hl), a
    sub     #0x0a
    jr      c, 19$
    ld      (hl), a
    ld      a, #0x01
    dec     hl
    dec     de
    djnz    10$
    ld      a, #0x09
    ld      b, #GAME_NUMBER_SIZE
11$:
    inc     hl
    ld      (hl), a
    djnz    11$
19$:
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; ���l��\������
;
GameDrawNumber:
    
    ; ���W�X�^�̕ۑ�
    
    ; �󔒂̕`��
    ld      c, #0x00
    ld      b, #(GAME_NUMBER_SIZE - 1)
10$:
    ld      a, (hl)
    or      a
    jr      nz, 19$
    ld      a, c
    ld      (de), a
    inc     hl
    inc     de
    djnz    10$
19$:

    ; ���l�̕`��
    ld      c, #0x10
    inc     b
20$:
    ld      a, (hl)
    add     a, c
    ld      (de), a
    inc     hl
    inc     de
    djnz    20$

    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �a�f�l�v���C��
;
GameBgmPlayer:
    
    ; ���W�X�^�̕ۑ�
    
    ; �T�E���h�̍Đ���
    ld      hl, (_soundPlay + 0x0000)
    ld      a, h
    or      l
    jr      nz, 99$
    
    ; �}�g���N�X�̏�Ԃ̎擾
    ld      hl, #(_matrix + 0x0082)
    xor     a
    ld      de, #0x0601
10$:
    ld      b, #0x0b
11$:
    or      (hl)
    jr      nz, 19$
    inc     hl
    djnz    11$
    push    de
    ld      de, #0x0005
    add     hl, de
    pop     de
    dec     d
    jr      nz, 10$
    dec     e
19$:

    ; �a�f�l�̍Đ�
    ld      a, (gameBgm)
    add     a, a
    add     a, e
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      ix, #gameBgmList
    add     ix, de
    ld      l, 0x00(ix)
    ld      h, 0x01(ix)
    ld      (_soundRequest + 0x0000), hl
    ld      l, 0x02(ix)
    ld      h, 0x03(ix)
    ld      (_soundRequest + 0x0002), hl
    ld      l, 0x04(ix)
    ld      h, 0x05(ix)
    ld      (_soundRequest + 0x0004), hl
    
    ; �a�f�l�̍X�V
    ld      a, (gameBgm)
    inc     a
    and     #0x03
    ld      (gameBgm), a
    
    ; �a�f�l�v���C���̊���
99$:
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �萔�̒�`
;

; �p�^�[���l�[��
;
gamePatternName:

    .db     0x00, 0x11, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86
    .db     0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x00, 0x50, 0x2e, 0x25, 0x38, 0x34, 0x54, 0x00, 0x00
    .db     0x00, 0x45, 0x46, 0x45, 0x46, 0x45, 0x46, 0x45, 0x00, 0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96
    .db     0x97, 0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x44, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6
    .db     0xa7, 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0x00, 0x50, 0x60, 0x61, 0x62, 0x63, 0x54, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6
    .db     0xb7, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0x00, 0x40, 0x64, 0x65, 0x66, 0x67, 0x44, 0x00, 0x00
    .db     0x00, 0x28, 0x29, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6
    .db     0xc7, 0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0x00, 0x50, 0x68, 0x69, 0x6a, 0x6b, 0x54, 0x00, 0x00
    .db     0x00, 0x45, 0x46, 0x45, 0x46, 0x45, 0x46, 0x45, 0x00, 0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6
    .db     0xd7, 0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0x00, 0x40, 0x6c, 0x6d, 0x6e, 0x6f, 0x44, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x11, 0x10, 0x10, 0x10, 0x10, 0x00, 0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6
    .db     0xe7, 0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0x00, 0x51, 0x52, 0x53, 0x52, 0x53, 0x54, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6
    .db     0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86
    .db     0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x00, 0x00, 0x60, 0x61, 0x62, 0x63, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96
    .db     0x97, 0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x00, 0x00, 0x64, 0x65, 0x66, 0x67, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6
    .db     0xa7, 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0x00, 0x00, 0x68, 0x69, 0x6a, 0x6b, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6
    .db     0xb7, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0x00, 0x00, 0x6c, 0x6d, 0x6e, 0x6f, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6
    .db     0xc7, 0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0x00, 0x00, 0x70, 0x71, 0x72, 0x73, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6
    .db     0xd7, 0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0x00, 0x00, 0x74, 0x75, 0x76, 0x77, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6
    .db     0xe7, 0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0x00, 0x00, 0x78, 0x79, 0x7a, 0x7b, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6
    .db     0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0x00, 0x00, 0x7c, 0x7d, 0x7e, 0x7f, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86
    .db     0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x00, 0x00, 0x60, 0x61, 0x62, 0x63, 0x00, 0x00, 0x00
    .db     0x00, 0x2c, 0x29, 0x2e, 0x25, 0x00, 0x00, 0x00, 0x00, 0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96
    .db     0x97, 0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x00, 0x00, 0x64, 0x65, 0x66, 0x67, 0x00, 0x00, 0x00
    .db     0x00, 0x55, 0x56, 0x55, 0x56, 0x55, 0x56, 0x55, 0x00, 0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6
    .db     0xa7, 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0x00, 0x00, 0x68, 0x69, 0x6a, 0x6b, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6
    .db     0xb7, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0x00, 0x00, 0x6c, 0x6d, 0x6e, 0x6f, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6
    .db     0xc7, 0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x2c, 0x25, 0x36, 0x25, 0x2c, 0x00, 0x00, 0x00, 0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6
    .db     0xd7, 0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x55, 0x56, 0x55, 0x56, 0x55, 0x56, 0x55, 0x00, 0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6
    .db     0xe7, 0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11, 0x00, 0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6
    .db     0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; �X�R�A
;
gameScoreEliminate:
    
    ; 1 LINE
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x01, 0x03, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x01, 0x04, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x01, 0x05, 0x00, 0x00, 0xff

    ; 2 LINES
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x01, 0x05, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x01, 0x08, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x02, 0x01, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x02, 0x04, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x02, 0x07, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x03, 0x03, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x03, 0x06, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x04, 0x02, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x04, 0x05, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x04, 0x08, 0x00, 0x00, 0xff

    ; 3 LINES
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x01, 0x05, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x02, 0x05, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x03, 0x05, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x04, 0x05, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x05, 0x05, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x06, 0x05, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x07, 0x05, 0x00, 0x00, 0xff

    ; 4 LINES
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x01, 0x06, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x02, 0x04, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x03, 0x02, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x04, 0x08, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x05, 0x06, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x06, 0x04, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x07, 0x02, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x08, 0x08, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x00, 0x09, 0x06, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x01, 0x00, 0x04, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x01, 0x01, 0x02, 0x00, 0x00, 0xff
    .db     0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x00, 0xff

; �X�v���C�g
;
gameSpriteLogo:

    .db     0x28, 0x54, 0x20, 0x0a
    .db     0x28, 0x60, 0x24, 0x07
    .db     0x28, 0x6c, 0x28, 0x0d
    .db     0x30, 0x78, 0x2c, 0x08
    .db     0x38, 0x84, 0x30, 0x04
    .db     0x38, 0x90, 0x34, 0x02
    .db     0x38, 0x9c, 0x38, 0x06
    
gameSpritePress:

    .db     0x80, 0x6a, 0x40, 0x0f
    .db     0x80, 0x7a, 0x44, 0x0f
    .db     0x80, 0x8a, 0x48, 0x0f
    .db     0x00, 0x00, 0x00, 0x00
    .db     0x88, 0x6a, 0x4c, 0x0f
    .db     0x88, 0x7a, 0x50, 0x0f
    .db     0x88, 0x8a, 0x54, 0x0f
    .db     0x00, 0x00, 0x00, 0x00
    .db     0x90, 0x72, 0x58, 0x0f
    .db     0x90, 0x82, 0x5c, 0x0f
    .db     0x90, 0x92, 0x00, 0x0f
    .db     0x00, 0x00, 0x00, 0x00
    .db     0x80, 0x6a, 0x00, 0x0f
    .db     0x80, 0x7a, 0x00, 0x0f
    .db     0x80, 0x8a, 0x00, 0x0f
    .db     0x00, 0x00, 0x00, 0x00

gameSpriteOver:

    .db     0x50, 0x5a, 0x60, 0x04
    .db     0x50, 0x6a, 0x64, 0x04
    .db     0x50, 0x82, 0x68, 0x04
    .db     0x50, 0x92, 0x6c, 0x04

; �T�E���h
;
gameSoundNull:

    .ascii  "T1V0R1"
    .db     0x00

gameSoundStart_0:
    .ascii  "T3V15-L3O4A5A4A1AGFED5R5"
    .db     0x00
    
gameSoundOver_0:

    .ascii  "T3V15L7O4DCRR"
    .db     0x00
    
gameSoundLock_3:

    .ascii  "T1V15L1O3B"
    .db     0x00
    
gameSoundGravity_3:

    .ascii  "T1V15-L7O2C"
    .db     0x00

; �a�f�l
;
gameBgmList:
    
    .dw     gameBgmNormal_0_0, gameBgmNormal_1_0, gameBgmNormal_2_0, 0x0000, gameBgmEmergency_0_0, gameBgmEmergency_1_0, gameBgmEmergency_2_0, 0x0000
    .dw     gameBgmNormal_0_1, gameBgmNormal_1_1, gameBgmNormal_2_1, 0x0000, gameBgmEmergency_0_1, gameBgmEmergency_1_1, gameBgmEmergency_2_1, 0x0000
    .dw     gameBgmNormal_0_2, gameBgmNormal_1_2, gameBgmNormal_2_2, 0x0000, gameBgmEmergency_0_2, gameBgmEmergency_1_2, gameBgmEmergency_2_2, 0x0000
    .dw     gameBgmNormal_0_3, gameBgmNormal_1_3, gameBgmNormal_2_3, 0x0000, gameBgmEmergency_0_3, gameBgmEmergency_1_3, gameBgmEmergency_2_3, 0x0000

gameBgmNormal_0_0:

    .ascii  "T3V15-L3"
    .ascii  "O5E5O4BO5CDE1D1CO4BA5AO5CE5DC"
    .db     0x00
    
gameBgmNormal_0_1:

    .ascii  "T3V15-L3"
    .ascii  "O4B5BO5CD5E5C5O4A5A5R5"
    .db     0x00
    
gameBgmNormal_0_2:

    .ascii  "T3V15-L3"
    .ascii  "O5RDRFA5GFE5RCE5O5DC"
    .db     0x00
    
gameBgmNormal_0_3:

    .ascii  "T3V15-L3"
    .ascii  "O4B5BO5CD5E5C5O4A5A7"
    .db     0x00

gameBgmNormal_1_0:

    .ascii  "T3V15-L3"
    .ascii  "O2EO3EO2EO3EO2EO3EO2EO3EO2AO3AO2AO3AO2AO3AO2AO3A"
    .db     0x00

gameBgmNormal_1_1:

    .ascii  "T3V15-L3"
    .ascii  "O2G+O3G+O2G+O3G+O2EO3EO2AO3AO2AO3AO2AO3AO2BO3C"
    .db     0x00

gameBgmNormal_1_2:

    .ascii  "T3V15-L3"
    .ascii  "O3DO2DRDRDAFCO3CRCO2CGGR"
    .db     0x00
    
gameBgmNormal_1_3:

    .ascii  "T3V15-L3"
    .ascii  "O2BO3BRBRERG+O2AO3EO2AO3EO2A7"
    .db     0x00

gameBgmNormal_2_0:

    .ascii  "T3V15-L3"
    .ascii  "O4B5O4G+ABRRRE5RRR5BR"
    .db     0x00

gameBgmNormal_2_1:

    .ascii  "T3V15-L3"
    .ascii  "O4G+5RRRB5O5C5O4A5E5E5R5"
    .db     0x00

gameBgmNormal_2_2:

    .ascii  "T3V15-L3"
    .ascii  "O4RFRAO5CC1C1O4BAG5RRGA1G1RR"
    .db     0x00

gameBgmNormal_2_3:

    .ascii  "T3V15-L3"
    .ascii  "O4E5RABG+O5CO4AA5E5E7"
    .db     0x00

gameBgmEmergency_0_0:

    .ascii  "T2V15-L3"
    .ascii  "O5E5O4BO5CDE1D1CO4BA5AO5CE5DC"
    .db     0x00
    
gameBgmEmergency_0_1:

    .ascii  "T2V15-L3"
    .ascii  "O4B5BO5CD5E5C5O4A5A5R5"
    .db     0x00
    
gameBgmEmergency_0_2:

    .ascii  "T2V15-L3"
    .ascii  "O5RDRFA5GFE5RCE5O5DC"
    .db     0x00
    
gameBgmEmergency_0_3:

    .ascii  "T2V15-L3"
    .ascii  "O4B5BO5CD5E5C5O4A5A7"
    .db     0x00

gameBgmEmergency_1_0:

    .ascii  "T2V15-L3"
    .ascii  "O2EO3EO2EO3EO2EO3EO2EO3EO2AO3AO2AO3AO2AO3AO2AO3A"
    .db     0x00

gameBgmEmergency_1_1:

    .ascii  "T2V15-L3"
    .ascii  "O2G+O3G+O2G+O3G+O2EO3EO2AO3AO2AO3AO2AO3AO2BO3C"
    .db     0x00

gameBgmEmergency_1_2:

    .ascii  "T2V15-L3"
    .ascii  "O3DO2DRDRDAFCO3CRCO2CGGR"
    .db     0x00
    
gameBgmEmergency_1_3:

    .ascii  "T2V15-L3"
    .ascii  "O2BO3BRBRERG+O2AO3EO2AO3EO2A7"
    .db     0x00

gameBgmEmergency_2_0:

    .ascii  "T2V15-L3"
    .ascii  "O4B5O4G+ABRRRE5RRR5BR"
    .db     0x00

gameBgmEmergency_2_1:

    .ascii  "T2V15-L3"
    .ascii  "O4G+5RRRB5O5C5O4A5E5E5R5"
    .db     0x00

gameBgmEmergency_2_2:

    .ascii  "T2V15-L3"
    .ascii  "O4RFRAO5CC1C1O4BAG5RRGA1G1RR"
    .db     0x00

gameBgmEmergency_2_3:

    .ascii  "T2V15-L3"
    .ascii  "O4E5RABG+O5CO4AA5E5E7"
    .db     0x00


; DATA �̈�
;
    .area   _DATA

; �ϐ��̒�`
;

; ���
;
gameState:
    
    .ds     1

; �^�C�}
;
gameTimer:

    .ds     1

; �X�R�A
;
gameScore:

    .ds     GAME_NUMBER_SIZE

gameHiScore:

    .ds     GAME_NUMBER_SIZE

gameLine:

    .ds     GAME_NUMBER_SIZE

gameLineLevelUp:

    .ds     1

gameLineEliminate:

    .ds     1
    
gameLineDrop:
    
    .ds     1

_gameLevel::

    .ds     1

; �a�f�l
;
gameBgm:

    .ds     1
