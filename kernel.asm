org 0x7e00
jmp 0x0000:start

;Aqui equivale a PosicaoYX(Linha, Coluna) referente a posição do cursor
;Parar definir posição faço 'PosicaoYX Y, X'
%macro PosicaoYX 2
    mov ah, 02h ;escohe em bh = coluna, dl-linha do cursor
    mov bh, 0
    mov dh, %1
    mov dl, %2
    int 10h
%endmacro

%macro Somar1 1
    mov dx, %1 ;soma a qtd de erros
    add dx, 1
    mov %1, dx
%endmacro

%macro Sub1 1
    mov dx, %1 ;soma a qtd de erros
    sub dx, 1
    mov %1, dx
%endmacro
data:
    instrucao db "DIGITE UMA LETRA:", 10, 0
    palavra db "CASACO", 10, 0
    espacoPalavra db '------', 0
    fraseGanhou db "PARABENS, VOCE GANHOU", 10,0
    frasePerdeu db "VOCE PERDEU", 10,0
    letra resb 2
    posLetra resb 2
    erro resb 2
    acerto resb 2
    i resb 1
    boneco db '  O', 10, ' /|\', 10, '/ \', 0
    posicao_bonecoX resb 2
    posicao_bonecoY resb 2

start:
    XOR ax, ax
    mov bx, ax
    mov cx, ax
    mov dx, ax
    mov [erro], ax
    mov [posLetra], ax
    mov [i], ax

    mov ah, 00h ;seta video mode
    mov al, 00h
    int 10h

MostraInstrucao:
    mov si, instrucao
    PosicaoYX 10,3
    ;Imprime a instrucao: Digite uma leta
    LoopIntru:
        lodsb
        mov ah, 0Eh ;imprime o que leu, tá em al
        mov bh, 0
        int 10h
        inc cx
        cmp al, 0
        jne LoopIntru
    call imprimeEspaco

Compara:
        mov dl, byte[espacoPalavra+bx]
        mov al, byte[palavra+bx]
        cmp al, dl
        jne LerLetra
;**** Imprmindo só para testar
        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 0
        int 10h

        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 0
        mov al, dl
        int 10h

        add bl, '0'
        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 0
        mov al, bl
        int 10h

        ;isso fica
        sub bl, '0'
        inc bx
        add bl, '0'
        ;----
        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 0
        mov al, bl
        int 10h
;************************* FIM TESTE
        cmp al, 0
        jne Compara
        jmp FimGanhou

LerLetra:
    PosicaoYX 11, 3
    mov ah, 0h ;ler teclado
    int 16h
    mov [letra], al
    mov ah, 0Eh ;;imprime o que esta em al
    mov bh, 0
    int 10h
    jmp ImprimePalavra
    jmp LerLetra

ImprimePalavra:
    mov si, palavra
    xor cx, cx

    PosicaoYX 12, 3
    LoopPalavra:
        lodsb
        cmp al, 0
        je imprimeEspaco
        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 0
        int 10h
        inc cx
        mov [posLetra], cx

        cmp al, [letra]
        jne LoopPalavra
        jmp LetraExiste

    Somar1 [erro]
    ;cmp [erro], 5
    ;jmp FimPerdeu
    ;jne ConstruirBoneco

;;******imprmirir qtd erros
;        mov al, [erro]
;        add al, '0'
;        mov ah, 0Eh ;imprime o que esta em al
;        mov bh, 0
;        int 10h
;;********************

    jmp imprimeEspaco
LetraExiste: ;Aqui insere a [letra] na string de espaços, na posição [posLetra] (indice onde foi encontrada)
    mov dl, [letra]
    mov bl, [posLetra]
    add bl, '0'
    sub bl, 1
    sub bl, '0'
    mov byte[espacoPalavra+bx], dl ;coloca a letra na posição
    Somar1 [acerto]
    jmp LoopPalavra
imprimeEspaco:
    mov si, espacoPalavra

    PosicaoYX 14, 3

    LoopEspaco:
        lodsb
        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 0
        int 10h
        inc cx
        cmp al, 0
        jne LoopEspaco
    jmp Compara
    ;jmp LerLetra
FimGanhou:
    PosicaoYX 15, 3
    ;Limpa a tela
    mov ah, 0 ; Função de limpar a tela
    mov al, 3 ; Preenche a tela com o caractere de fundo
    int 10h   ; Chamada de interrupção para limpar a tela

    mov si, fraseGanhou

    LoopGanhou:
        lodsb
        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 0
        int 10h
        inc cx
        cmp al, 0
        jne LoopGanhou

    jmp Fim

FimPerdeu:
    PosicaoYX 10, 7

    mov ah, 0 ; Função de limpar a tela
    mov al, 3 ; Preenche a tela com o caractere de fundo
    int 10h   ; Chamada de interrupção para limpar a tela

    mov si, frasePerdeu

    LoopPerdeu:
        lodsb
        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 0
        int 10h
        inc cx
        cmp al, 0
        jne LoopPerdeu

    jmp Fim

ConstruirForca:

ConstruirBoneco:
    mov si, boneco 
    
    LoopBoneco:
        lodsb
        cmp al, 0
        jne LoopBoneco
        inc cx ;Incrementar o contador de linha e coluna
        mov [posicao_bonecoX], cx
        mov [posicao_bonecoY], cx
        PosicaoYX [posicao_bonecoY], [posicao_bonecoX]
        mov ah, 0Eh
        mov bh, 0
        int 10h

Fim:
    jmp $
