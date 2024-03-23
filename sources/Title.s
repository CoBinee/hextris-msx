; Title.s : �^�C�g��
;


; ���W���[���錾
;
    .module Title

; �Q�ƃt�@�C��
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include	"Title.inc"

; �O���ϐ��錾
;

; �}�N���̒�`
;


; CODE �̈�
;
    .area   _CODE

; �^�C�g��������������
;
_TitleInitialize::
    
    ; ���W�X�^�̕ۑ�
    
    ; �X�v���C�g�̃N���A
    call    _SystemClearSprite
    
    ; �p�^�[���̃N���A
    ld      hl, #(_appPatternName + 0x0000)
    ld      de, #(_appPatternName + 0x0001)
    ld      bc, #0x02ff
    xor     a
    ld      (hl), a
    ldir
    
    ; �p�^�[���l�[���̓]��
    call    _AppTransferPatternName
    
    ; �`��̊J�n
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)
    
    ; �r�f�I���W�X�^�̓]��
    ld      hl, #_request
    set     #REQUEST_VIDEO_REGISTER, (hl)
    
    ; ��Ԃ̐ݒ�
    xor     a
    ld      (titleState), a
    ld      a, #APP_STATE_TITLE_UPDATE
    ld      (_appState), a
    
    ; ���W�X�^�̕��A
    
    ; �I��
    ret

; �^�C�g�����X�V����
;
_TitleUpdate::
    
    ; ���W�X�^�̕ۑ�
    push    hl
    push    bc
    push    de
    push    ix
    push    iy
    
    ; �������̊J�n
    ld      a, (titleState)
    or      a
    jr      nz, 09$
    
    ; �������̊���
    ld      hl, #titleState
    inc     (hl)
09$:
    
    ; �Q�[���̊J�n
;   ld      a, #APP_STATE_GAME_INITIALIZE
;   ld      (_appState), a
;   jr      90$
    
    ; �X�V�̊���
99$:

    ; ���W�X�^�̕��A
    pop     iy
    pop     ix
    pop     de
    pop     bc
    pop     hl
    
    ; �I��
    ret

; �萔�̒�`
;


; DATA �̈�
;
    .area   _DATA

; �ϐ��̒�`
;

; ���
;
titleState:

    .ds     1

