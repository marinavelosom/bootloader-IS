org 0x7e00
jmp 0x0000:start

data:
    instrucao db "DIGITE UMA LETRA:", 10, 0
    palavra db "CASACO", 10, 0
    espacoPalavra db '------', 0
    letra resb 2
    posLetra resb 2
    erro resb 2
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
    
    call LerLetra
    call ImprimePalavra
LerLetra:
    mov ah, 02h ;escohe em ah = coluna, dl-linha do cursor
    mov bh, 0
    mov dh, 10
    mov dl, 3
    int 10h

    mov si, instrucao
    LoopIntru:
        lodsb
        mov ah, 0Eh ;imprime o que leu, tá em al
        mov bh, 0
        int 10h
        inc cx
        cmp al, 0
        jne LoopIntru

    mov ah, 02h ;escohe em bh = coluna, dl-linha do cursor
    mov bh, 0
    mov dh, 11
    mov dl, 3
    int 10h
    
    mov ah, 0h ;ler teclado
    int 16h
    mov [letra], al

    mov ah, 0Eh ;;imprime o que esta em al
    mov bh, 0
    int 10h
    jmp ImprimePalavra

ImprimePalavra:
    mov si, palavra
    xor cx, cx
    
    mov ah, 02h ;escohe em bh = coluna, dl-linha do cursor
    mov bh, 0
    mov dh, 12
    mov dl, 3
    int 10h

    LoopPalavra:
        lodsb
        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 0
        int 10h

        inc cx
        mov [posLetra], cx
        cmp al, [letra]
        je LetraExiste 

        cmp al, 0
        jne LoopPalavra
        
        call imprimeEspaco
        mov dx, [erro] ;soma a qtd de erros
        add dx, 1
        mov [erro], dx
;******imprmirir qtd erros       
        mov al, [erro] 
        add al, '0'
        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 0
        int 10h
;********************
        jmp LerLetra
imprimeEspaco:
    mov si, espacoPalavra
    mov ah, 02h
    mov bh, 0
    mov dh, 14
    mov dl, 3
    int 10h
    ;mov byte[espacoPalavra+2], 'K'
    LoopEspaco:
        lodsb
        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 0
        int 10h
        inc cx
        cmp al, 0
        jne LoopEspaco
    ret
LetraExiste: ;Aqui insere a [letra] na string de espaços, na posição [posLetra] (indice onde foi encontrada)
    mov si, espacoPalavra ;para usar em lodsb (lodsb imprmie a strng apontada por si)

    mov ah, 02h ;escolhendo a posição na tela onde vai impmimir a string que stá preenchendo
    mov bh, 0
    mov dh, 14
    mov dl, 3
    int 10h

    mov dl, [letra]
    mov bl, [posLetra]
    add bl, '0'
 
 ;;****** teste ** ver posição   
 ;   mov al, bl 
 ;   mov ah, 0Eh ;imprime o que esta em al
 ;   mov bh, 0
 ;   int 10h
 ;;****** fim teste ************
    sub bl, 1
    sub bl, '0'
    mov byte[espacoPalavra+bx], dl ;coloca a letra na posição 

    LoopExiste: ;Imprimindo a nova palavra já com a letra inserida
        lodsb
        mov ah, 0Eh ;imprime o que esta em al
        mov bh, 0
        int 10h
        inc cx
        cmp al, 0
        jne LoopExiste
        
    jmp LoopPalavra 

   

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
