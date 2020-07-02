.model small
.stack 100h
        disp macro msg
                lea dx,msg
                mov ah,09h
                int 21h
        endm

        inp macro
                mov ah,01h
                int 21h
        endm

        oup macro
                mov ah,02h
                int 21h
        endm
.data
        array dw 4 dup(5555h,2222h,3333h,4444h)
.code
        mov ax,@data
        mov ds,ax

	call sum_array
	call disp_4dig	

	mov ah,4ch
	int 21h	

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
	disp_4dig endp
	
        sum_array proc near
                lea si,array
                mov cl,04h
                mov ax,0000h
                add_loop:
			mov dx,[si]                                  
			add ax,dx
                        inc si
			inc si
                        dec cl
                        jnz add_loop
                mov bx,ax
                ret
        sum_array endp
end
