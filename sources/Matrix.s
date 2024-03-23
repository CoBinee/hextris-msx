; Matrix.s : �}�g���N�X
;


; ���W���[���錾
;
    .module Matrix

; �Q�ƃt�@�C��
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include	"Matrix.inc"

; �O���ϐ��錾
;

; �}�N���̒�`
;


; CODE �̈�
;
    .area   _CODE

; �}�g���N�X������������
;
_MatrixInitialize::
    
    ; ���W�X�^�̕ۑ�
    
    ; �}�g���N�X�̃N���A
    ld      hl, #_matrix
    ld      de, #0x0405
    ld      c, #0x1e
10$:
    xor     a
    ld      (hl), a
    inc     hl
    ld      (hl), d
    inc     hl
    ld      b, #0x0b
11$:
    ld      (hl), a
    inc     hl
    djnz    11$
    ld      (hl), d
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      a, d
    ld      d, e
    ld      e, a
    dec     c
    jr      nz, 10$
    xor     a
    ld      (hl), a
    inc     hl
    ld      b, #0x0d
12$:
    ld      (hl), d
    inc     hl
    djnz    12$
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      b, #0x10
13$:
    ld      (hl), a
    inc     hl
    djnz    13$
    
    ; �F�̃N���A
    ld      hl, #matrixColor
    ld      de, #0x5040
    ld      c, #0x17
20$:
    xor     a
    ld      b, #0x08
21$:
    ld      (hl), d
    inc     hl
    djnz    21$
    ld      b, #0x60
22$:
    ld      (hl), a
    inc     hl
    djnz    22$
    ld      b, #0x08
23$:
    ld      (hl), d
    inc     hl
    djnz    23$
    ld      b, #0x10
24$:
    ld      (hl), a
    inc     hl
    djnz    24$
    ld      a, d
    ld      d, e
    ld      e, a
    dec     c
    jr      nz, 20$
    ld      a, #0x44
    ld      b, #0x08
25$:
    ld      (hl), d
    inc     hl
    djnz    25$
    ld      b, #0x60
26$:
    ld      (hl), a
    inc     hl
    djnz    26$
    ld      b, #0x08
27$:
    ld      (hl), d
    inc     hl
    djnz    27$
    
    ; �}�g���N�X�̐F�̐ݒ�
    call    MatrixSetColor
    
    ; �X�V�s�̏�����
    ld      hl, #(_matrixPatternLine + 0x0000)
    ld      de, #(_matrixPatternLine + 0x0001)
    ld      bc, #0x1f
    xor     a
    ld      (hl), a
    ldir
    
    ; �`��s�̏�����
    xor     a
    ld      (matrixRenderLine), a
    
    ; �J���[�e�[�u���̓]��
    ld      hl, #(matrixColor + 0x0000)
    ld      de, #(APP_COLOR_TABLE_0 + 0x0400)
    ld      bc, #0x0400
    call    LDIRVM
    ld      hl, #(matrixColor + 0x0400)
    ld      de, #(APP_COLOR_TABLE_1 + 0x0400)
    ld      bc, #0x0400
    call    LDIRVM
    ld      hl, #(matrixColor + 0x0800)
    ld      de, #(APP_COLOR_TABLE_2 + 0x0400)
    ld      bc, #0x0400
    call    LDIRVM
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �}�g���N�X���X�V����
;
_MatrixUpdate::
    
    ; ���W�X�^�̕ۑ�
    
    ; �X�V���ꂽ�ŉ��P�s��`�悳����
    ld      hl, #(_matrixPatternLine + 0x001e)
    ld      de, #matrixRenderLine
    ld      bc, #0x171e
0$:
    ld      a, (hl)
    or      a
    jr      nz, 1$
    dec     hl
    dec     c
    djnz    0$
;   xor     a
    ld      (de), a
    jr      9$
1$:
    xor     a
    ld      (hl), a
    ld      a, c
    ld      (de), a
9$:

    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �}�g���N�X��`�悷��
;
_MatrixRender::

    ; ���W�X�^�̕ۑ�
    
    ; �P�s�̕`��
    ld      a, (matrixRenderLine)
    push    af
    call    MatrixSetColorLine
    pop     af
    sub     #0x08
    jr      c, 9$
    ld      c, a
    and     #0x07
    ld      d, a
    ld      e, #0x00
    srl     d
    rr      e
    ld      a, c
    and     #0x18
    add     a, d
    ld      d, a
    ld      hl, #(APP_COLOR_TABLE_0 + 0x0400)
    add     hl, de
    ld      (_videoTransfer + VIDEO_TRANSFER_VRAM_0_DST), hl
    ld      d, c
    ld      e, #0x00
    srl     d
    rr      e
    ld      hl, #matrixColor
    add     hl, de
    ld      (_videoTransfer + VIDEO_TRANSFER_VRAM_0_SRC), hl
    ld      a, #0x80
    ld      (_videoTransfer + VIDEO_TRANSFER_VRAM_0_BYTES), a
    ld      hl, #(_request)
    set     #REQUEST_VRAM, (hl)
9$:
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �}�g���N�X�����Z�b�g����
;
_MatrixReset::

    ; ���W�X�^�̕ۑ�
    
    ; �}�g���N�X�̃N���A
    ld      hl, #(_matrix + 0x0002)
    ld      de, #0x0005
    xor     a
    ld      c, #0x1e
10$:
    ld      b, #0x0b
11$:
    ld      (hl), a
    inc     hl
    djnz    11$
    add     hl, de
    dec     c
    jr      nz, 10$
    
    ; �X�V�s�̐ݒ�
    ld      hl, #(_matrixPatternLine + 0x0008)
    ld      de, #(_matrixPatternLine + 0x0009)
    ld      bc, #0x0016
    ld      a, #MATRIX_PATTERN_MATCH
    ld      (hl), a
    ldir
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �}�g���N�X�̃p�^�[�����X�V����
;
_MatrixPattern::

    ; ���W�X�^�̕ۑ�
    
    ; �X�V�s�̃N���A����
    ld      hl, #(_matrix + 0x0002)
    ld      de, #_matrixPatternLine
    ld      b, #0x1e
0$:
    push    bc
    ld      a, (de)
    or      a
    jr      z, 1$
    push    hl
    xor     a
    ld      bc, #0x0b
    cpir
    pop     hl
    jr      z, 1$
    push    de
    ld      e, l
    ld      d, h
    inc     de
    ld      bc, #0x000a
    ld      a, #MATRIX_PATTERN_MATCH
    ld      (hl), a
    ldir
    pop     de
    ld      bc, #0x0006
    add     hl, bc
    jr      2$
1$:
    ld      bc, #0x0010
    add     hl, bc
2$:
    pop     bc
    inc     de
    djnz    0$
    
    ; �����Ȃ��s�͍X�V���Ȃ�
    ld      hl, #(_matrixPatternLine + 0x0000)
    ld      de, #(_matrixPatternLine + 0x0001)
    ld      bc, #0x08
    xor     a
    ld      (hl), a
    ldir
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �}�g���N�X�̂�������s������
;
_MatrixEliminate::

    ; ���W�X�^�̕ۑ�
    
    ; �X�V�s�̃N���A����
    ld      hl, #(_matrix + 0x0002)
    ld      de, #_matrixPatternLine
    ld      bc, #0x1e00
10$:
    push    de
    ld      a, (hl)
    cp      #MATRIX_PATTERN_MATCH
    jr      nz, 11$
    inc     c
    ld      (de), a
    inc     de
    ld      (de), a
    push    bc
    ld      e, l
    ld      d, h
    inc     de
    ld      bc, #0x000a
    xor     a
    ld      (hl), a
    ldir
    pop     bc
    ld      de, #0x06
    add     hl, de
    jr      12$
11$:
    ld      de, #0x0010
    add     hl, de
12$:
    pop     de
    inc     de
    djnz    10$
    
    ; ���������C�����̕ۑ�
    ld      a, c
    push    af
    
    ; �����Ȃ��s�͍X�V���Ȃ�
    ld      hl, #(_matrixPatternLine + 0x0000)
    ld      de, #(_matrixPatternLine + 0x0001)
    ld      bc, #0x08
    xor     a
    ld      (hl), a
    ldir
    
    ; ���������C�����̕��A
    pop     af
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �}�g���N�X�̍s���߂�
;
_MatrixGravity::

    ; ���W�X�^�̕ۑ�
    
    ; ��s�̎擾
    ld      hl, #(_matrix + 0x0002)
    ld      de, #_matrixPatternLine
    ld      b, #0x1e
10$:
    push    bc
    xor     a
    ld      b, #0x0b
11$:
    or      (hl)
    inc     hl
    djnz    11$
    ld      (de), a
    ld      bc, #0x0005
    add     hl, bc
    pop     bc
    inc     de
    djnz    10$
    
    ; ��s���߂�
    ld      hl, #(_matrix + 0x01d2)
    ld      de, #(_matrixPatternLine + 0x1d)
    ld      b, #0x1e
20$:
    push    bc
    push    de
    push    hl
    ld      a, (de)
    or      a
    jr      nz, 29$
    ld      c, #0x00
21$:
    dec     b
    jr      z, 29$
    inc     c
    dec     de
    ld      a, (de)
    or      a
    jr      z, 21$
    xor     a
    ld      (de), a
    ld      a, c
    ld      b, #0x00
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    ld      c, a
    ld      e, l
    ld      d, h
    or      a
    sbc     hl, bc
    ld      bc, #0x000b
    ldir
    ld      bc, #0xfff5
    add     hl, bc
    ld      e, l
    ld      d, h
    inc     de
    ld      bc, #0x000a
    xor     a
    ld      (hl), a
    ldir
29$:
    pop     hl
    ld      bc, #0xfff0
    add     hl, bc
    pop     de
    pop     bc
    dec     de
    djnz    20$
    
    ; �����Ȃ��s�͍X�V���Ȃ�
    ld      hl, #(_matrixPatternLine + 0x0000)
    ld      de, #(_matrixPatternLine + 0x0001)
    ld      bc, #0x08
    xor     a
    ld      (hl), a
    ldir
    
    ; ������s���X�V����
    ld      bc, #0x17
    ld      a, #MATRIX_PATTERN_MATCH
    ld      (hl), a
    ldir
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �}�g���N�X�����b�N����
;
_MatrixLock:

    ; ���W�X�^�̕ۑ�
    
    ; �u���b�N�̐F��ς���
    ld      hl, #(_matrix + 0x0002)
    ld      c, #0x1e
10$:
    ld      e, #0x0e
    ld      b, #0x0b
11$:
    ld      a, (hl)
    or      a
    jr      z, 12$
    ld      (hl), e
12$:
    inc     hl
    djnz    11$
    ld      de, #0x0005
    add     hl, de
    dec     c
    jr      nz, 10$
    
    ; �����Ȃ��s�͍X�V���Ȃ�
    ld      hl, #(_matrixPatternLine + 0x0000)
    ld      de, #(_matrixPatternLine + 0x0001)
    ld      bc, #0x08
    xor     a
    ld      (hl), a
    ldir
    
    ; ������s���X�V����
    ld      bc, #0x17
    ld      a, #MATRIX_PATTERN_MATCH
    ld      (hl), a
    ldir
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �}�g���N�X�̐F��ݒ肷��
;
MatrixSetColor:

    ; ���W�X�^�̕ۑ�
    
    ; ��ʏ�̑S���C���̑���
    ld      a, #0x08
0$:
    push    af
    call    MatrixSetColorLine
    pop     af
    inc     a
    cp      #0x1f
    jr      c, 0$
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �P���C�����̃}�g���N�X�̐F��ݒ肷��
;
MatrixSetColorLine:

    ; ���W�X�^�̕ۑ�
    
    ; �V��̃N���b�s���O
    sub     #0x08
    jr      c, 99$
    
    ; �F�̐ݒ�
    ld      d, #0x00
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    ld      e, a
    ld      ix, #(_matrix + 0x0072)
    add     ix, de
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    ld      e, a
    ld      hl, #(matrixColor + 0x0008)
    add     hl, de
    ld      b, #0x06
10$:
    ld      a, 0xff(ix)
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    add     a, 0x00(ix)
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    and     #0xf0
    add     a, 0x10(ix)
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    inc     ix
    ld      a, 0x00(ix)
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    add     a, 0xff(ix)
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    and     #0xf0
    add     a, 0x0f(ix)
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    inc     ix
    djnz    10$
    
    ; �ݒ�̊���
99$:
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret
    
; �萔�̒�`
;


; DATA �̈�
;
    .area   _DATA

; �ϐ��̒�`
;

; �}�g���N�X
;
_matrix::

    .ds     0x0200

; �F
;
matrixColor:

    .ds     0x0c00

; �X�V�s
;
_matrixPatternLine::

    .ds     0x20
    
; �`��s
;
matrixRenderLine:

    .ds     1
    