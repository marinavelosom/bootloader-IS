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

;Palavra imprmir, chama: PrintString palavra, linha, coluna
%macro PrintString 3 
    mov si, %1
    PosicaoYX %2,%3
    ;Imprime a instrucao: Digite uma leta
    LoopString%2:
        lodsb
        mov ah, 0Eh ;imprime o que leu, tá em al
        mov bh, 0
        int 10h
        inc cx
        cmp al, 0
        jne LoopString%2
%endmacro

%macro PrintVal 1
    mov al, %1
    mov ah, 0Eh ;imprime o que esta em al
    mov bh, 0
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

%macro ConstruirForca 3
    PosicaoYX %2, %3 ; 
    mov al, %1
    mov ah, 0Eh ;imprime o que leu, tá em al
    mov bh, 0
    int 10h
%endmacro

%macro MostrarBoneco 3
    PosicaoYX %2, %3 
    mov al, %1
    mov ah, 0Eh
    mov bh, 0
    int 10h
%endmacro

%macro CopiarString 3
    mov [auxBX], bx
    xor bx, bx
    CopiaP%3:       
        mov al, byte[%2+bx]
        mov byte[%1+bx], al
        ;PrintVal byte[%1+bx]
        inc bx
        cmp al, 0 ;6 é o tamanho da string, se mudar a string, precisa mudar aqui
        jne CopiaP%3
        sub bx, 2
        mov cx, bx
        mov [tamAtual], bx
        mov bx, [auxBX]
%endmacro

data:
    auxBX db 0
    fraseINICIO db "VAMOS JOGAR FORCA?",10,0
    fraseDica db "APRTE ENTER PARA COMECAR",10,0
    
    fraseInst db "DIGITE SEU PAPITE EM MAIUSCULO", 10,0
    
    instrucao db "DIGITE UMA LETRA MAISCULA:", 10, 0
    palavra db "CASACO", 10, 0
    espacoPalavra db '------', 0
    fraseGanhou db "PARABENS, VOCE GANHOU!", 10,0
    frasePerdeu db "QUE PENA, VOCE PERDEU",10,0
    letra resb 2
    posLetra resb 2
    erros resb 2
    flag resb 2
    numeroAleatorio resb 1 

    cabeca db "O", 10,0
    bracoDir db "/", 10,0
    bracoEsq db "\", 10,0
    pernaDir db "/", 10,0
    pernaEsq db "\", 10,0
    tronco db "U", 10,0
    
    forca_tonco db "|", 10,0
    forca_tonco_cima db "_", 10,0
                                    ;TAMANHO    
    tema1 db "TEMA: ESCOLA", 10, 0        ;6
    escola1 db "LANCHEIRA", 10, 0   ;9
    escola2 db "CANTINA", 10, 0     ;7
    escola3 db "FARDAMENTO", 10, 0  ;10
    escola4 db "AVALIACAO", 10, 0   ;9
    escola5 db "FICHARIO", 10, 0    ;8
    tema2 db "TEMA: INFORMATICA", 10, 0   
    info1 db "MONITOR", 10, 0       ;7
    info2 db "TECLADO", 10, 0       ;7
    info3 db "ROTEADOR", 10, 0      ;8
    info4 db "SISTEMAS", 10, 0      ;8
    info5 db "ALGORITMO", 10, 0     ;9
    tema3 db "TEMA: PROFISSAO", 10, 0
    prof1 db "MEDICO", 10, 0        ; 6
    prof2 db "ENGENHEIRO", 10, 0    ;10
    prof3 db "ADVOGADO", 10, 0      ;8
    prof4 db "COZINHEIRO", 10, 0    ;10
    prof5 db "PROFESSOR", 10, 0     ;9
    
    espacoAtual resb 10
    palavraAtual resb 10
    temaAtual resb 20
    tamAtual db 0 
    score resb 1

start: ;*********************************************************
    XOR ax, ax
    mov bx, ax
    mov dx, ax
    xor cx, cx
    mov [flag], cl
    mov [posLetra], ax
    mov [flag], ax

    mov ah, 0h ;seta video mode
    mov al, 0h
    int 10h

    mov ah, 0Bh ;Seta um cor para background
    mov bh, 00h
    mov bl, 09h ;cor
    int 10h    

    call GerarNumAleatorio
    call EscolherPalavra
    call ConstruirForcaF
    call MostraInstrucao
MostraInstrucao:
    PrintString instrucao, 10, 3
    PrintString temaAtual, 9, 3
    call imprimeEspaco
Compara:       
        mov al, byte[palavraAtual+bx]
        cmp al, byte[espacoAtual+bx]
        jne LerLetra

        inc bx
        cmp bl, [tamAtual] ;6 é o tamanho da string, se mudar a string, precisa mudar aqui
        jne Compara
        jmp FimGanhou

LerLetra:
    xor cx, cx
    mov [flag], cl

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
       
    mov si, palavraAtual

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

    jmp imprimeEspaco


LetraExiste: ;Aqui insere a [letra] na string de espaços, na posição [posLetra] (indice onde foi encontrada)
    mov dl, [letra]
    mov bl, [posLetra]
    add bl, '0'
    sub bl, 1
    sub bl, '0'
    mov byte[espacoAtual+bx], dl ;coloca a letra na posição 
    Somar1 [flag]
    jmp LoopPalavra
    
imprimeEspaco:
    mov dl, [flag]
    cmp dl, 0
    jne LetraNaoExiste
    
    mov dx, [erros] ;soma a qtd de erros
    add dx, 1
    mov [erros], dx

    call VerificaErros

    PosicaoYX 2, 1
    mov al, [erros]
    jmp LetraNaoExiste

    LetraNaoExiste:
        mov si, espacoAtual
        
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
        xor bx, bx
        call VerificaErros
        jmp Compara
    ;jmp LerLetra
VerificaErros:
    mov al, [erros]
    cmp al, 2
    jne segundoErro
    MostrarBoneco [cabeca], 3, 6

    segundoErro:
        cmp al, 3
        jne terceiroErro
        MostrarBoneco [tronco], 4, 6

    terceiroErro:
        cmp al, 4
        jne quartoErro
        MostrarBoneco [bracoDir], 4, 5
    
    quartoErro:
        cmp al, 5
        jne quintoErro
        MostrarBoneco [bracoEsq], 4, 7
    
    quintoErro:
        cmp al, 6
        jne sextoErro
        MostrarBoneco [pernaDir], 5, 5
    
    sextoErro:
        cmp al, 7
        jne setimoErro
        MostrarBoneco [pernaEsq], 5, 7
    
    setimoErro:
        cmp al, 8
        je FimPerdeu
    
    ret

FimGanhou:
    mov ah, 0h ;seta video mode
    mov al, 0h
    int 10h
    
    mov ah, 0Bh ;Seta um cor para background
    mov bh, 00h
    mov bl, 08h ;cor
    int 10h

    PosicaoYX 10, 7
    mov si, fraseGanhou
    
    LoopGanhou:
        lodsb
        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 00h
        int 10h

        inc cx
        cmp al, 0
        jne LoopGanhou
    jmp Fim
    
FimPerdeu:
    mov ah, 0h ;seta video mode
    mov al, 12h
    int 10h
    
    mov ah, 0xb ;Seta um cor para background
    mov bh, 00h
    mov bl, 04h ;cor
    int 10h
    
    PosicaoYX 14, 27
    mov si, frasePerdeu
    
    LoopPerdeu:
        lodsb
        mov ah, 0xe ;imprime o que esta em al
        mov bh, 0
        mov bl, 0Fh
        int 10h

        inc cx
        cmp al, 0
        jne LoopPerdeu
    
    jmp Fim

ConstruirForcaF:
    ConstruirForca [forca_tonco_cima], 1, 6
    ConstruirForca [forca_tonco_cima], 1, 5
    ConstruirForca [forca_tonco_cima], 1, 4
    ConstruirForca [forca_tonco_cima], 1, 3
    ConstruirForca [forca_tonco], 2, 6
    ConstruirForca [forca_tonco], 2, 3
    ConstruirForca [forca_tonco], 3, 3
    ConstruirForca [forca_tonco], 4, 3
    ConstruirForca [forca_tonco], 5, 3
    ConstruirForca [forca_tonco], 6, 3
    ret
GerarNumAleatorio:
    ;Configura a semente do gerador de números aleatórios
    mov cx, 0   ;o menor numero 0
    xor dx, dx  ;limpa reg dx
    rdtsc       ;Lê o contador de tempo em edx:eax, parte alta em bx, e alta em ax, ps: num de 64 bits. ;A instrução rdtsc é usada para ler o contador de tempo de alta resolução (Time Stamp Counter - TSC)
    mov cx, ax  ;Define o valor de semente como o tempo atual
                
    ; Gera um número aleatório de 0 a 15
    mov ax, cx  ; Carrega a semente em eax
    xor dx, dx 
    mov bx, 16  ; Valor máximo (16 para 0 a 15)
    div bx      ; Divide eax pela base (16)
    mov ax, dx  ; O resto da divisão está em edx (o numero que queremos entre 0 a 15)
    mov [numeroAleatorio], al ;salva na posiçao de memoria que reservamos
    mov ax, dx 
    ret
PreencherEspaco:
    xor bx, bx
    mov al, '-'
    loopEspaco: ;Enquando bx < cx (num de caracteres da palavraAtual), é inserido "-" espaco
        mov byte[espacoAtual+bx], al
        ;PrintVal byte[espacoAtual+bx]
        inc bx
        cmp bx, [tamAtual]
        jne loopEspaco
    ret
EscolherPalavra:
    mov bl, [numeroAleatorio]
    add bl, '0'
    PrintVal bl
    cmp bl, 52 ;04 em ascii
    jg Tema2 ;ENTRA AQUI SE O NUMERO<5, se for maior>4 ele pula para tema2
        ;CopiarString [temaAtual], [tema1], 0 ;salva o tema
        ;compara de 0 a 4 para saber qual a palavra na jogada atual, o tem2 tema3 é a mesma coisa, mas de 5 a 9, e 10 a 14 respectivamente
        ;PrintVal bl
            CopiarString temaAtual, tema1,0
            cmp bl, 48;0
            jne palavra2
            CopiarString palavraAtual, escola1,1
            call PreencherEspaco
            ret
        palavra2:                                       ;Else If(num == 1) palavraAtual = palavra2
            cmp bl, 49;1
            jne palavra3
            CopiarString palavraAtual, escola2,2
            call PreencherEspaco
            ret
        palavra3:
            cmp bl, 50;2
            jne palavra4
            CopiarString palavraAtual, escola3,3
            call PreencherEspaco
            ret
        
        palavra4:
            cmp bl, 52 ;3
            jne palavra5
            CopiarString palavraAtual, escola4,4
            call PreencherEspaco
            ret
        palavra5: ;ENTRA AQUI SE FOR ==4
            CopiarString palavraAtual, escola5,5
            call PreencherEspaco
            ret
    Tema2: 
        ;PrintVal bl
        cmp bl, 57 ;9
        jg Tema2 ;ENTRA AQUI SE O 4<NUMERO<9 Se for maior que 9 ele pula para tema3
        CopiarString temaAtual, tema2, 6
        cmp bl, 53 ;5
        jne palavra7 
            CopiarString palavraAtual, info1,7
            call PreencherEspaco
            ret
        palavra7:
            cmp bl, 54 ;6
            jne palavra8
            CopiarString palavraAtual, info2,8
            call PreencherEspaco
            ret
        palavra8:
            cmp bl, 55 ;7
            jne palavra9
            CopiarString palavraAtual, info3,9
            call PreencherEspaco
            ret
        
        palavra9:
            cmp bl, 56 ;8
            jne palavra10
            CopiarString palavraAtual, info4,10
            call PreencherEspaco
            ret

        palavra10: ;ENTRA AQUI SE FOR ==9 ;57 em ascii
            CopiarString palavraAtual, info5,11
            call PreencherEspaco
            ret

    Tema3: ;ENTRA AQUI SE O 9<NUMERO
        ;PrintVal bl
        CopiarString temaAtual, tema3,12 
        cmp bl, 58 ;: em ascii
        jne palavra11
        CopiarString palavraAtual, prof1,13
        call PreencherEspaco
        ret
        palavra11:
            cmp bl, 59
            jne palavra12
            CopiarString palavraAtual, prof2,14
            call PreencherEspaco
            ret

        palavra12:
           cmp bl, 60
            jne palavra13
            CopiarString palavraAtual, prof3,15
            call PreencherEspaco
            ret
        
        palavra13:
            cmp bl, 61
            jne palavra14
            CopiarString palavraAtual, prof4,16
            call PreencherEspaco
            ret

        palavra14: ;ENTRA AQUI SE FOR ==14 (> em ASCII)
            CopiarString palavraAtual, prof5,17
            call PreencherEspaco
            ret
    ret
Fim:  
    jmp $
