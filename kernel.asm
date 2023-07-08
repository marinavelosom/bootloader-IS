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

;Palavra imprmir, chama: PrintString palavra, linha, coluna, ID (ID é para cada vez que chamar nao dar erro)
%macro PrintString 4
    xor ax, ax
    xor bx, bx
    xor cx, cx
    mov si, %1
    PosicaoYX %2,%3
    ;Imprime a instrucao: Digite uma leta
    LoopString%4: ;Percorre a string apontada por SI, e e mostra o o byte atual em al
        lodsb
        mov ah, 0xe ;imprime o que esta em al
        mov bh, 0
        mov bl, 0Ah
        int 10h
        inc cx
        cmp al, 0
        jne LoopString%4
%endmacro

;Printa o valor de um CHAR (Usado em testes)
%macro PrintVal 1 
    mov al, %1
    mov ah, 0Eh ;imprime o que esta em al
    mov bh, 0
    int 10h
%endmacro

;Soma +1 no registrador ou posição de memoria
%macro Somar1 1
    mov dx, %1 
    add dx, 1
    mov %1, dx
%endmacro

;Suntrai -1 no registrador ou posição de memoria
%macro Sub1 1
    mov dx, %1 ;soma a qtd de erros
    sub dx, 1
    mov %1, dx
%endmacro

;Para imprmir a forca, "ConstruirForca caracter, linha, coluna
%macro ConstruirForca 3
    PosicaoYX %2, %3 ; 
    mov al, %1
    mov ah, 0Eh ;imprime o que leu, tá em al
    mov bh, 0
    int 10h
%endmacro

;Para imprmir o boneco, "MostrarBoneco caracter, linha, coluna
%macro MostrarBoneco 3
    PosicaoYX %2, %3 
    mov al, %1
    mov ah, 0Eh
    mov bh, 0
    int 10h
%endmacro

;Serve para copiar a string %2 para string %1, "CopiarString strg1,strg2, ID
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

;Para imprmir uma string com cores nos caracters "PrintStringCor strng, linha, coluna
%macro PrintStringCor 4
    PosicaoYX %2, %3
    mov si, %1
    
    LoopPerdeu%4:
        lodsb
        mov ah, 0xe ;imprime o que esta em al
        mov bh, 0
        mov bl, 0Ah
        int 10h

        inc cx
        cmp al, 0
        jne LoopPerdeu%4
%endmacro

%macro DeixarMaiuscula 1
    mov al, %1;Letra
    cmp al, 'a'
    ja MaiorQue ;Se for maior que 'a' vai para MaiorQue
    jb MenorQue ;Se for menor que 'a' vai para MenorQue

    MaiorQue:
        sub al, 32
        mov %1, al

    MenorQue:
%endmacro

data:
    auxBX db 0 ;AUXILIAR PARA SALVAR BX EM UM MACRO E DEVOLVER NO FINAL
    ;Aqui é somente para imperssão do menu inicial
    forca1 db "000000 000000 0000000  000000  000000",10,0
    forca2 db " 00    00  00  00  00  00  00  00  00",10,0
    forca3 db " 0000  00  00  000000  00      000000",10,0
    forca4 db " 00    00  00  00 00   00  00  00  00",10,0
    forca5 db "0000   000000 000  000 000000 000  000",10,0

    ;Frases que utilizaresmos no menu inical e final
    fraseInicio db "OLA, VAMOS JOGAR FORCA?",10,0
    fraseDica db "APERTE ENTER PARA COMECAR",10,0
    fraseScore db "SEU SCORE Eh: ",10,0
    jogarNovamente db "QUER JOGAR NOVAMENTE? Y/N",10,0
    sairJogo db "FOI BOM JOGAR COM VOCE!",10,0
    
    ;Frases para menu final
    instrucao db "DIGITE UMA LETRA:", 10, 0
    fraseGanhou db "PARABENS, VOCE GANHOU!", 10,0
    frasePerdeu db "QUE PENA, VOCE PERDEU",10,0
    letra resb 2                        ;letra do papite
    posLetra resb 2                     ;posição da letra
    erros resb 2                        ;qtd erros    
    flag resb 2                         ;auxiliar para erros    
    numeroAleatorio resb 1              ;numero "aleatorio" que usaremos para sortar uma palavra e tema

    ;caracteres para construir boneco
    cabeca db "O", 10,0
    bracoDir db "/", 10,0
    bracoEsq db "\", 10,0
    pernaDir db "/", 10,0
    pernaEsq db "\", 10,0
    tronco db "U", 10,0
    ;Caracteres para construir a forca
    forca_tonco db "|", 10,0
    forca_tonco_cima db "_", 10,0
    ;Temnas e Palavras que seras sorteados
                                    ;TAMANHO    
    tema1 db "TEMA: ESCOLA", 10, 0        
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
    
    ;"Variaveis" que usaremos na jogada atual
    espacoAtual resb 10
    palavraAtual resb 10
    temaAtual resb 30
    tamAtual db 0 
    score db 0

;Menu inicial    
menuInicio:
    mov ah, 0h ;seta video mode
    mov al, 12h
    int 10h
    
    mov ah, 0xb ;Seta um cor para background
    mov bh, 00h
    mov bl, 00h ;cor do bg
    int 10h
    ;Mostrando a palavra FORCA grande
    PrintStringCor forca1, 5,20, 5
    PrintStringCor forca2, 6,20, 6
    PrintStringCor forca3, 7,20, 7
    PrintStringCor forca4, 8,20, 8
    PrintStringCor forca5, 9,20, 9
    ;Frases do inicio
    PrintStringCor fraseInicio, 14, 26, 3
    PrintStringCor fraseDica, 15,25, 4
    loopInicio: ;Esse loop só começa o jogo quando é apertado ENTER (13)
        PosicaoYX 16, 37 ;Posição na tela
        mov ah, 0h ;ler do teclado
        int 16h
        mov ah, 0xe ;imprime o que esta em al
        mov bh, 0
        mov bl, 0Fh
        int 10h
        cmp al, 13
        je start1
        jmp loopInicio
    jmp start1
start: 
    jmp menuInicio ;menu inicial antes de tudo
    start1: ;start secundario que netrará nas proximas jogadas
    ;Limpando registadores
    XOR ax, ax
    mov bx, ax
    mov dx, ax
    xor cx, cx
    mov [flag], cl
    mov [posLetra], ax
    mov [flag], ax
    mov [erros], ax

    mov ah, 0h ;seta video mode
    mov al, 0h
    int 10h

    mov ah, 0Bh ;Seta um cor para background
    mov bh, 00h
    mov bl, 09h ;cor do fundo
    int 10h    
    
    call GerarNumAleatorio
    call EscolherPalavra
    call ConstruirForcaF
    call MostraInstrucao
MostraInstrucao: ;Aqui printa a Instrução para digitar em MAIUSCULO
    PrintString instrucao, 10, 3,10
    call imprimeEspaco
Compara:  ;Aqui serve para comparar a palavra secreta com a palavra que montou na forca     
        mov al, byte[palavraAtual+bx]
        cmp al, byte[espacoAtual+bx]
        jne LerLetra ;Se ecnontrar algum diferente já volta para ler a proxima letra

        inc bx
        cmp bl, [tamAtual] ;tamanho da string
        jne Compara 
        jmp FimGanhou 

;Ler uma letra do teclado e já salva em [Letra]
LerLetra:
    xor cx, cx
    mov [flag], cl

    PosicaoYX 11, 3
    mov ah, 0h ;ler teclado
    int 16h
    mov [letra], al
    DeixarMaiuscula [letra]

    mov ah, 0Eh ;;imprime o que esta em al
    mov bh, 0
    int 10h
    jmp VerificaSeLetraExiste
    jmp LerLetra

;Aqui faz uma verificação se a letra digitada existe 
VerificaSeLetraExiste:
    mov si, palavraAtual

    PosicaoYX 12, 3
    LoopPalavra:
        lodsb
        cmp al, 0
        je imprimeEspaco
        ;mov ah, 0Eh ;********* TIRAR COMENTÀRIO PARA VER A PALAVRA DA JOGADA ATUAL
        ;mov bh, 0
        ;int 10h
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
    
;Aqui imprme os espaços, e a nova palavra, cad letra que tiver vai ser trocar pelo "-"     
imprimeEspaco:
    mov dl, [flag] ;auxiliar para saber se entrou em LetraExiste 
    cmp dl, 0
    jne LetraNaoExiste
    
    mov dx, [erros] ;soma erro, se chegar em 7 o boneco já está montado e perde a jogada
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
;Aqui verifica a quantidade de errosm se for 1 coloca a cabeça do boneci, se for 2 o tronco e assim por diante  
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

;Fim de Jogo se a palavra foi desvendada
FimGanhou:
    mov dx, [score] 
    add dl, 48
    add dx, 1
    mov [score], dx

    mov ah, 0h ;seta video mode
    mov al, 0h
    int 10h
    
    mov ah, 0Bh ;Seta um cor para background
    mov bh, 00h
    mov bl, 08h ;cor
    int 10h

    PrintString fraseGanhou, 9,9,15
    PrintString jogarNovamente, 12,7,17
   ;Aguarda Y para jogar novamente ou N para finalizar o jogo
    loopFim: 
        PosicaoYX 13, 19
        mov ah, 0h ;ler teclado
        int 16h
        mov ah, 0Eh ;;imprime o que esta em al
        mov bh, 0
        int 10h
        cmp al, 'Y'
        je start1
        cmp al, 'y'
        je start1
        cmp al, 'N'
        je Fim
        cmp al, 'n'
        je Fim
        jmp loopFim
    jmp start1
;Se o boneco já foi construido por completo   
FimPerdeu:
    mov ah, 0h ;seta video mode
    mov al, 12h
    int 10h
    
    mov ah, 0xb ;Seta um cor para background
    mov bh, 00h
    mov bl, 00h ;cor
    int 10h
    
    PrintStringCor frasePerdeu, 14, 28, 1
    PrintStringCor jogarNovamente, 15,26, 2
    ;Aguarda Y para jogar novamente ou N para finalizar o jogo
    loopFimPerdeu:
        PosicaoYX 16, 37
        mov ah, 0h
        int 16h
        mov ah, 0xe ;imprime o que esta em al
        mov bh, 0
        mov bl, 0Eh
        int 10h
        cmp al, 'Y'
        je start1

        cmp al, 'y'
        je start1

        cmp al, 'N'
        je Fim

        cmp al, 'n'
        je Fim
        jmp loopFimPerdeu
    jmp start1
;É chamada logo no inicio para mostra a forca
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

;Aqui gera um numero aleatorio entre 0 e 15 que será usado para escolher uma palavra
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
;Aqui quando a palavra foi escolhida, ele faz um loop até percorrer toda a palavraAtual e preenche os espaço, ex: CASA, vai de 0 a3, e cria o espaço "----"
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
;Aqui é para escolher uma palavra e tema para a jogada atual
;Se num <5 tem1, se 4<num<9 ->tema2, se maior que 9 tema3, e consequentemente escolhe a palavra
;Se num==0 palavra1, se num==1 palavra 2 e assim por diante
EscolherPalavra:
    mov bl, [numeroAleatorio]
    add bl, 48
    ;PrintVal bl
    cmp bl, 53 ;04 em ascii
    jge Tema2 ;ENTRA AQUI SE O NUMERO<5
        ;PrintVal bl
        CopiarString temaAtual, tema1, 0
        PrintString temaAtual, 8, 3,1
        cmp bl, 48 ;0
        jne palavra2
            ;PrintVal bl
            CopiarString temaAtual, tema1, 19 
            CopiarString palavraAtual, escola1,1
            call PreencherEspaco
        ret

        palavra2:                                       ;Else If(num == 1) palavraAtual = palavra2
            PrintVal bl
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
            jmp fimSorteio 
        
        palavra4:
            cmp bl, 51 ;3
            jne palavra5
            CopiarString palavraAtual, escola4,4
            call PreencherEspaco
            jmp fimSorteio 

        palavra5: ;ENTRA AQUI SE FOR ==4
            CopiarString palavraAtual, escola5,5
            call PreencherEspaco
            jmp fimSorteio 
    Tema2: 
        ;PrintVal bl
        cmp bl, 58 ;9
        jge Tema3 ;ENTRA AQUI SE O 4<NUMERO<9 Se for maior que 9 ele pula para tema3
        CopiarString temaAtual, tema2, 6
        PrintString temaAtual, 8, 3,6
        cmp bl, 53 ;5
        jne palavra7 
            CopiarString palavraAtual, info1,7
            call PreencherEspaco
            jmp fimSorteio 
        palavra7:
            cmp bl, 54 ;6
            jne palavra8
            CopiarString palavraAtual, info2,8
            call PreencherEspaco
            jmp fimSorteio 
        palavra8:
            cmp bl, 55 ;7
            jne palavra9
            CopiarString palavraAtual, info3,9
            call PreencherEspaco
            jmp fimSorteio 
        
        palavra9:
            cmp bl, 56 ;8
            jne palavra10
            CopiarString palavraAtual, info4,10
            call PreencherEspaco
            jmp fimSorteio 

        palavra10: ;ENTRA AQUI SE FOR ==9 ;57 em ascii
            CopiarString palavraAtual, info5,11
            call PreencherEspaco
            jmp fimSorteio 

    Tema3: ;ENTRA AQUI SE O 9<NUMERO
        ;PrintVal bl
        CopiarString temaAtual, tema3, 12 
        PrintString temaAtual, 8, 3,12
        cmp bl, 58 ;: em ascii
        jne palavra11
        CopiarString palavraAtual, prof1,13
        call PreencherEspaco
        jmp fimSorteio 
        palavra11:
            cmp bl, 59
            jne palavra12
            CopiarString palavraAtual, prof2,14
            call PreencherEspaco
            jmp fimSorteio 

        palavra12:
           cmp bl, 60
            jne palavra13
            CopiarString palavraAtual, prof3,15
            call PreencherEspaco
            jmp fimSorteio 
        
        palavra13:
            cmp bl, 61
            jne palavra14
            CopiarString palavraAtual, prof4,16
            call PreencherEspaco
            jmp fimSorteio 

        palavra14: ;ENTRA AQUI SE FOR ==14 (> em ASCII)
            CopiarString temaAtual, tema2, 18
            CopiarString palavraAtual, prof5,17
            call PreencherEspaco
            jmp fimSorteio
    fimSorteio:        
        ret
;Fim limpa a tela e mostra a mesnagem        
Fim: 
    mov ah, 0h ;seta video mode
    mov al, 12h
    int 10h

    mov ah, 0xb ;Seta um cor para background
    mov bh, 00h
    mov bl, 04h ;cor
    int 10h
    
    mov ah, 0Bh ;Seta um cor para background
    mov bh, 00h
    mov bl, 00h ;cor
    int 10h
    PrintString sairJogo, 12,27,21
    jmp $
