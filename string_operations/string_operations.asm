.model small
.stack 100h
        disp macro msg
                lea dx,msg
                mov ah,09h
                int 21h
        endm ;macro to display string

        inp macro
                mov ah,01h
                int 21h
        endm ;macro to input character

        oup macro
                mov ah,02h
                int 21h
        endm ;macro to output character

.data
        menu db 13,10,'Menu',13,10,'1. Input',13,10,'2. Display',13,10,'3. Length',13,10,'4. Reverse',13,10,'5. Palindrome',13,10,'6. Exit',13,10,'Choice: ','$'
	act_str db 25 dup('$')
        inv db 13,10,'Invalid input',13,10,'$'
        thanks db 13,10,'Thank You',13,10,'$'
        inp_head db 13,10,'Enter string: ','$'
        dis_head db 13,10,'String is: ','$'
        len_head db 13,10,'Length is: ','$'
        rev_head db 13,10,'Reverse String is: ','$'
        palres db 13,10,'The given string is palindrome','$'
        notpalres db 13,10,'The given string is not palindrome','$'
        choice db ?
        size_str dw ?
.code
	mov ax,@data
	mov ds,ax ; data segment initialization
	
        mov es,ax ; extra segment initialization

	menuloop:disp menu
		 inp
                 mov choice,al
                 cmp choice,31h
                 je inp_call
                 cmp choice,32h
                 je dis_call
                 cmp choice,33h
                 je len_call
                 cmp choice,34h
                 je rev_call
                 cmp choice,35h
                 je pal_call
                 cmp choice,36h
                 je exit_call
                 disp inv
                 jmp menuloop ;loop to drive menu

        inp_call:call inp_str
                 jmp menuloop

        dis_call:call dis_str
                 jmp menuloop

        len_call:call dis_len
                 jmp menuloop

        rev_call:call dis_rev
                 jmp menuloop

        pal_call:call dis_pal
                 jmp menuloop

        exit_call:disp thanks
                  mov ah,4ch
                  int 21h
	
	inp_str proc near
		disp inp_head
                lea dx,act_str
                mov ah,0ah
                int 21h
		ret
	inp_str endp ; procedure to input string

	dis_str proc near
		disp dis_head
                lea si,act_str+2
                disloop:mov dl,[si]
                cmp dl,'$'
                je done
                oup
                inc si
                jmp disloop
                done:ret
	dis_str endp

        dis_len proc near ; procedure to display length of string
                disp len_head
                lea si,act_str+1
                mov al,[si]
                daa
                call disp_2dig
                ret
        dis_len endp

        dis_rev proc near ; procedure to display string reverse
                disp rev_head
                lea si,act_str+1
                mov ch,[si]
                mov cl,[si]
                incloop:inc si
                        dec ch
                        jnz incloop
                revloop:mov dl,[si]
                        oup
                        dec si
                        dec cl
                        jnz revloop
                ret
        dis_rev endp

        dis_pal proc near ; procedure to check if string is palindrome
               lea si,act_str+1
               mov ax,[si]
               mov ah,00h
               mov bx,0002h
               div bx
               mov cx,ax
               mov size_str,cx
               mov bx,dx
               inc si
               pushloop:mov dx,[si]
                        mov dh,00h
                        push dx
                        inc si
                        dec cx
                        jnz pushloop
               mov cx,size_str
               cmp bx,0001h
               jne poploop
               inc si
               poploop:pop dx
                       mov bx,[si]
                       mov bh,00h
                       cmp bx,dx
                       jne notpalin
                       inc si
                       dec cx
                       jnz poploop
                       jmp pal
                notpalin:dec cx
                         jnz emploop
                         emploop:pop dx
                                 dec cx
                                 jnz emploop
                         disp notpalres
                         jmp palret
                pal:disp palres
                    jmp palret
                palret:ret
        dis_pal endp

	disp_2dig proc near ; procedure to display 2 digit number
			mov bl,al
			mov cx,0204h
		     l1:rol bl,cl
			mov dl,bl
			and dl,0fh
			cmp dl,09h
			jbe l2
			add dl,07h
		     l2:add dl,30h
			mov ah,02h
			int 21h
			dec ch
			jnz l1
			ret
	disp_2dig endp

end
