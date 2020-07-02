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

        inp_msg macro
                mov ah,0Ah
                int 21h
        endm ;macro to input string

.data

	hi db 13,10,'Hello',13,10,'$'
        e_msg db 13,10,'Given strings are equal','$'
        ne_msg db 13,10,'Given strings are not equal: ','$'
        s1_msg db 'String 1 greater','$'
        s2_msg db 'String 2 greater','$'
        cat_head db 13,10,'String after concatenation is: ','$'
        sub_res db 13,10,'String 2 is a substring of String 1','$'
        not_sub_res db 13,10,'String 2 is not a substring of String 1','$'
        extrn str_1:byte
        extrn str_2:byte
        extrn inp_head_1:byte
        extrn inp_head_2:byte      

.code

	mov ax,@data
        mov ds,ax

        mov es,ax
	
        public inp_str
        inp_str proc far
                disp inp_head_1
                lea dx,str_1
                inp_msg
                disp inp_head_2
                lea dx,str_2
                inp_msg
		ret
	inp_str endp

        public cmp_str
        cmp_str proc far
                lea si,str_1+1
                lea di,str_2+1
                mov cx,[si]
		mov ch,00h
                mov bx,[di]
		mov bh,00h
                cmp bl,cl
                ja s2_greater
                jb s1_greater
                inc si
                inc di
		cld
                repe cmpsb
                jb s1_greater
                ja s2_greater
                disp e_msg
                ret
                s1_greater:disp ne_msg
                           disp s1_msg
                           ret
                s2_greater:disp ne_msg
                           disp s2_msg
                           ret
        cmp_str endp

        public cat_str
        cat_str proc far
                lea di,str_1+1
                lea si,str_2+1
                mov bl,[di]
                mov bh,00h
                mov cx,[si]
                mov ch,00h
                add di,bx
                inc si
                inc di
                rep movsb
                disp cat_head
                lea dx,str_1+2
                mov ah,09h
                int 21h
                ret
        cat_str endp

        public sub_str
        sub_str proc far
                lea di,str_1+1
                lea si,str_2+1
                mov bl,[di]
                mov bh,00h
                mov dl,[si]
                mov dh,00h
                cmp dl,bl
                jg not_sub
                sub bl,dl
                mov cl,dl
                mov ch,00h
                inc si
                inc di
                inc bl
                outloop:rep cmpsb
                        cmp cx,0000h
                        je is_sub
                        inc di
                        mov cl,dl
                        dec bl
                        jnz outloop
                not_sub:disp not_sub_res
                       ret
                is_sub:disp sub_res
                        ret
                ret
        sub_str endp 
end
