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
        array db 10 dup(?)
        range db 'Enter Range: ',13,10,'$'
        getno db 'Enter number: ',13,10,'$'
        disno db 'Numbers are: ',13,10,'$'
        addr db 'Sum is: ',13,10,'$'
        newl db 13,10,'$'
        sizer db ?
        sumr db 0
.code
        mov ax,@data
        mov ds,ax

        lea si,array
        disp range
  
	inp
        sub al,30h
        
	mov cl,al
        mov sizer,al
        mov bh,0h

getloop:disp newl ; loop to get array elements
        disp getno
        inp
        mov [si],al
        inc si
        dec cl
        jnz getloop

        call sum_array


        lea si,array
        disp newl
        disp disno
        mov cl,sizer

disloop:mov dl,[si] ; loop to display array elements
        oup
        disp newl
        inc si
        dec cx
        jnz disloop

        mov al,bh
        mov ah,00h
        mov dh,00h

        disp addr

        call disp_2dig

        mov ah,4ch
        int 21h

	disp_2dig proc near
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
	
        sum_array proc near ; procedure to add array elements
                lea si,array
                mov cl,sizer
                mov ax,0000h
                add_loop:
			mov bl,[si]
                        sub bl,30h                                       
			add al,bl
                        daa
                        inc si
                        dec cl
                        jnz add_loop
                mov bh,al
                ret
        sum_array endp
end
