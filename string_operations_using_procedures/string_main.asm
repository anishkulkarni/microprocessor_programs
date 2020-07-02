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
        menu db 13,10,'Menu',13,10,'1. Input',13,10,'2. Compare',13,10,'3. Concatenate',13,10,'4. Check Substring',13,10,'5. Count Characters, Words, Digits',13,10,'6. Exit',13,10,'Choice: ','$'
        str_1 db 50 dup('$')
        str_2 db 25 dup('$')
        inv db 13,10,'Invalid input','$'
        thanks db 13,10,'Thank You','$'
        inp_head_1 db 13,10,'Enter first string: ','$'
        inp_head_2 db 13,10,'Enter second string: ','$'      
        choice db ?
        public str_1,str_2,inp_head_1,inp_head_2
.code
	mov ax,@data
	mov ds,ax ; data segment initialization
	
        mov es,ax ; extra segment initialization

        extrn inp_str:far
        extrn cmp_str:far
        extrn cat_str:far
        extrn sub_str:far

	menuloop:disp menu
		 inp
                 mov choice,al
                 cmp choice,31h
                 je inp_call
                 cmp choice,32h
                 je cmp_call
                 cmp choice,33h
                 je cat_call
                 cmp choice,34h
                 je sub_call
                 cmp choice,36h
                 je exit_call
                 disp inv
                 jmp menuloop ;loop to drive menu

        inp_call:call inp_str
                 jmp menuloop

        cmp_call:call cmp_str
                 jmp menuloop

        cat_call:call cat_str
                 jmp menuloop

        sub_call:call sub_str
                 jmp menuloop

        exit_call:disp thanks
                  mov ah,4ch
                  int 21h

end
