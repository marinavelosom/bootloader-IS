org 0x7e00
jmp 0x0000:start

cabecaBoneco1 db 16, 16, 0, 0, 0, 0, 0, 15, 7, 8, 8, 8, 8, 8, 8, 8, 8, 15, 0, 0, 0, 15, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 15, 0, 0, 15, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 15, 0, 0, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 15, 0, 0, 7, 8, 8, 7, 8, 7, 7, 7, 8, 7, 7, 8, 7, 0, 0, 0, 7, 8, 8, 7, 7, 7, 7, 7, 7, 7, 7, 8, 7, 0, 0, 0, 7, 8, 8, 7, 7, 15, 7, 7, 7, 7, 7, 8, 15, 0, 0, 0, 15, 8, 8, 8, 8, 7, 7, 7, 8, 7, 7, 7, 15, 15, 15, 7, 7, 8, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 15, 15, 15, 7, 7, 7, 7, 7, 7, 8, 8, 8, 7, 7, 15, 0, 0, 0, 0, 0, 15, 7, 7, 7, 7, 8, 8, 8, 7, 7, 15, 0, 0, 0, 0, 0, 15, 7, 7, 7, 7, 7, 7, 7, 7, 7, 15, 0, 0, 0, 0, 0, 15, 15, 7, 7, 7, 7, 7, 7, 7, 15, 15, 0, 0, 0, 0, 0, 0, 15, 15, 7, 7, 7, 7, 15, 15, 15, 0, 0, 0

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
    instrucao db "DIGITE UMA LETRA MAISCULA:", 10, 0
    palavra db "CASACO", 10, 0
    espacoPalavra db '------', 0
    fraseGanhou db "PARABENS, VOCE GANHOU!", 10,0
    letra resb 2
    posLetra resb 2
    erro resb 2
    acerto resb 2

    cabeca db "O", 10,0
    bracoDir db "/", 10,0
    bracoEsq db "\", 10,0
    pernaDir db "/", 10,0
    pernaEsq db "\", 10,0
    tronco db "U", 10,0

start:
    XOR ax, ax
    mov bx, ax
    mov cx, ax
    mov dx, ax
    mov [erro], ax
    mov [posLetra], ax

    mov ah, 0h ;seta video mode
    mov al, 0h
    int 10h
  
    PosicaoYX 3,4 ; 
    mov al, [cabeca]
    mov ah, 0Eh ;imprime o que leu, tá em al
    mov bh, 0
    int 10h
    PosicaoYX 4,4
    mov al, [tronco]
    mov ah, 0Eh ;imprime o que leu, tá em al
    mov bh, 0
    int 10h
    PosicaoYX 4,3
    mov al, [bracoDir]
    mov ah, 0Eh ;imprime o que leu, tá em al
    mov bh, 0
    int 10h
    PosicaoYX 4,5
    mov al, [bracoEsq]
    mov ah, 0Eh ;imprime o que leu, tá em al
    mov bh, 0
    int 10h
    PosicaoYX 5,3
    mov al, [pernaDir]
    mov ah, 0Eh ;imprime o que leu, tá em al
    mov bh, 0
    int 10h
    PosicaoYX 5,5
    mov al, [pernaEsq]
    mov ah, 0Eh ;imprime o que leu, tá em al
    mov bh, 0
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
        mov al, byte[palavra+bx]
        cmp al, byte[espacoPalavra+bx]
        jne LerLetra

        inc bx
        cmp bl, 6 ;6 é o tamanho da string, se mudar a string, precisa mudar aqui
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
    xor dx, dx
    jmp Compara
    ;jmp LerLetra
FimGanhou:
    mov ah, 0 ; Função de limpar a tela
    mov al, 0 ; Preenche a tela com o caractere de fundo
    int 10h   ; Chamada de interrupção para limpar a tela
    
    PosicaoYX 10, 7
    mov si, fraseGanhou
    
    LoopGanhou:
        lodsb
        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 0
        int 10h
        inc cx
        cmp al, 0
        jne LoopGanhou
    
    ;jmp Fim
    
FimPerdeu:

ConstruirForca:
ConstruirBoneco:
Fim:  
    jmp $
