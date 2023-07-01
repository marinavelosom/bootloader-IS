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
    letra resb 2
    posLetra resb 2
    erro resb 2
    acerto resb 2
start:
    XOR ax, ax
    mov bx, ax
    mov cx, ax
    mov dx, ax
    mov [erro], ax
    mov [posLetra], ax

    mov ah, 00h ;seta video mode
    mov al, 00h
    int 10h
MostraInstrucao:
    lea si, instrucao
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
;;******imprmirir qtd erros       
;        mov al, [erro] 
;        add al, '0'
;        mov ah, 0Eh ;imprime o que esta em al
;        mov bh, 0
;        int 10h
;;********************
    call imprimeEspaco
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
    jmp LerLetra
FimGanhou:

FimPerdeu:

ConstruirForca:
ConstruirBoneco:
fim:
        mov ah, 0Eh ;;imprime o que esta em al
        mov bh, 0
        mov al, cl
        int 10h
    jmp $
