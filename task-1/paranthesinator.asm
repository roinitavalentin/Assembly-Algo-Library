[bits 32]

%include "../include/io.mac"

section .text
; int check_parantheses(char *str)
global check_parantheses
check_parantheses:
    push ebp
    mov ebp, esp

    ; Initializăm stiva
    xor ecx, ecx      ; ecx este contorul pentru parantezele deschise
    xor edx, edx      ; edx este contorul pentru parantezele închise

    ; Parcurgem șirul de paranteze
    mov esi, [ebp+8]  ; esi = adresa începutului șirului
    xor edi, edi      ; edi = indexul pentru parantezele din șir

loop_func:
    mov al, byte [esi + edi]  ; Încărcăm paranteza curentă în registrul al
    cmp al, 0                  ; Verificăm dacă am ajuns la sfârșitul șirului
    jz end_loop

    cmp al, '('                ; Verificăm dacă este o paranteză deschisă '('
    je .open
    cmp al, '{'                ; Verificăm dacă este o paranteză închisă ')'
    je .open
    cmp al, '['                ; Verificăm dacă este o paranteză deschisă '{'
    je .open
    cmp al, ')'                ; Verificăm dacă este o paranteză închisă '}'
    je .close
    cmp al, '}'                ; Verificăm dacă este o paranteză deschisă '['
    je .close
    cmp al, ']'                ; Verificăm dacă este o paranteză închisă ']'
    je .close

.open:
    inc ecx                    ; Creștem numărul de paranteze deschise
    jmp next_char

.close:
    inc edx                    ; Creștem numărul de paranteze închise
    cmp ecx, edx               ; Verificăm dacă există suficiente paranteze deschise
    jge pop_stack             ; Dacă da, continuăm verificarea
    mov eax, 1                 ; Altfel, returnăm 1 (eroare)
    jmp exit_func


pop_stack:
    dec eax                    ; Scădem un '(' de pe stivă
    jmp next_char

next_char:
    inc edi                    ; Trecem la următoarea paranteză din șir
    jmp loop_func

end_loop:
    cmp ecx, edx               ; Verificăm dacă toate parantezele deschise au fost închise
    je success                ; Dacă da, returnăm 0 (succes)
    mov eax, 1                 ; Altfel, returnăm 1 (eroare)
    jmp exit_func

success:
    xor eax, eax               ; Returnăm 0 în eax (succes)

exit_func:
    leave
    ret
