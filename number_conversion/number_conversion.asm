.model small
.stack 100h
        disp macro msg
                lea dx,msg
                mov ah,09h
                int 21h
        endm ;macro display string

        inp macro
                mov ah,01h
                int 21h
        endm;macro to input character

        oup macro
                mov ah,02h
                int 21h
        endm ;macro to output character
.data
        menu db 13,10,'Menu',13,10,'1. BCD to HEX',13,10,'2. HEX to BCD',13,10,'3. Exit',13,10,'Choice: ','$'
        inv db 13,10,'Invalid input',13,10,'$'
        thanks db 13,10,'Thank You',13,10,'$'
        htb_head db 13,10,'Enter HEX number: ','$'
        bth_head db 13,10,'Enter BCD number: ','$'
        htb_res db 13,10,'BCD Result is: ','$'
        bth_res db 13,10,'HEX Result is: ','$'
        res dw ?
        choice db ?
        ten dw 000Ah
        ten_div db 0Ah
        bcd_arr db 5 dup(0)
        hex_val dw 0h
.code
	mov ax,@data
	mov ds,ax

	menuloop:disp menu
		 inp
                 mov choice,al
                 cmp choice,31h
                 je bth_call
                 cmp choice,32h
                 je htb_call
                 cmp choice,33h
                 je exit_call
                 disp inv
                 jmp menuloop;loop to display menu

        htb_call:call htb
                 jmp menuloop

        bth_call:call bth
                 jmp menuloop
	
        exit_call:disp thanks
                  mov ah,4ch
                  int 21h

        htb proc near ; near procedure to convert BCD to hex
                disp htb_head
                call get4dig
                mov cl,05h
                mov ax,hex_val
                mov dx,0000h
                mov bx,000Ah
                cloop:div bx
                      push dx
                      mov dx,0000H
                      dec cl
                      jnz cloop
                disp htb_res
                mov cl,05h
                dloop:pop bx
                      mov dx,bx
                      add dx,30h
                      oup
                      dec cl
                      jnz dloop ; loop to display 5 digit result
                ret
        htb endp

        bth proc near ;near procedure to convert hex to BCD
                disp bth_head
                lea si,bcd_arr
                mov cl,05h
                jmp getloop
                again:mov cl,05h
                      disp inv
                      disp bth_head           
                getloop:inp
                        sub al,30h
                        cmp al,09h
                        jg getloop
                        mov [si],al
                        inc si
                        dec cl
                        jnz getloop;input digits in array
                lea si,bcd_arr
                mov al,[si]
                cmp al,06h;most significant digit less than 6
                jg again
                mov res,0000h
                mov dx,0001h
                lea si,bcd_arr
                add si,04h
                mov cl,05h
                calloop:mov ax,[si]
                        mov ah,00h
                        mov bx,dx
                        mul dx;multiply with apt. powers of 10
                        mov dx,bx
                        add res,ax;add sum in res
                        mov ax,dx
                        mul ten
                        mov dx,ax
                        dec si
                        dec cl
                        jnz calloop;loop to convert BCD to hex
                disp bth_res
                mov bx,res
                call disp_4dig
                ret
        bth endp

	disp_4dig proc near
		mov cx,0404h
	     	l1:
			rol bx,cl
			mov dx,bx
			and dx,0fh
			cmp dl,09h
			jbe l2
			add dx,0007h
	     	l2:
			add dx,0030h
			mov ah,02h
			int 21h
			dec ch
			jnz l1
		ret
	disp_4dig endp;near procedure to display 4 digit number

        get4dig proc near
                mov dx,0000h
                mov cx,0404h
                jmp digloop
           val1:cmp al,10h
                jbe digloop
                cmp al,16h
                jg n1
                sub al,07h
                jmp val
                n1:cmp al,30h
                jbe digloop
                cmp al,36h
                jg digloop
                sub al,27h
                jmp val
                digloop:inp
                        sub al,30h
                        cmp al,09h
                        jg val1
                    val:add dl,al
                        rol dx,cl
                        dec ch
                        jnz digloop
                ror dx,cl
                mov hex_val,dx
                ret
        get4dig endp;near procedure to input 4 digit number

end
