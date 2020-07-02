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
        array db 8 dup(11h,12h,13h,14h,21h,22h,23h,24h)
	res db 'Addition of initialized elements is: ',13,10,'$'
.code
        mov ax,@data
        mov ds,ax

	call sum_array
	disp res
	call disp_2dig	

	mov ah,4ch
	int 21h	

	disp_2dig proc near 	; procedure to display 2 digit number
		mov bl,bh
		mov cx,0204h
	     	l1:
			rol bl,cl
			mov dl,bl
			and dl,0fh
			cmp dl,09h
			jbe l2
			add dl,07h
	     	l2:
			add dl,30h
			mov ah,02h
			int 21h
			dec ch
			jnz l1
		ret
	disp_2dig endp
	
        sum_array proc near
                lea si,array
                mov cl,08h
                mov ax,0000h
                add_loop:               ;loop for addition of array elements                      
			add al,[si]
                        inc si
                        dec cl
                        jnz add_loop
                mov bh,al
                ret
        sum_array endp
end
