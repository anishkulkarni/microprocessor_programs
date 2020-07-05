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

.data
        menu db 13,10,'Menu',13,10,'1. Input',13,10,'2. Compare',13,10,'3. Concatenate',13,10,'4. Substring',13,10,'5. Count',13,10,'6. Exit',13,10,'Choice: $'
        choice db 0
        invalid db 13,10,'Invalid choice please try again$'
.code
        mov ax,@data
        mov ds,ax
        mov es,ax

        extrn inpString:far
        extrn cmpString:far
        extrn catString:far
        extrn subString:far
        extrn countString:far

        menuLoop:disp menu
                 inp
                 mov choice,al
                 cmp choice, 31h
                 je inpCall
                 cmp choice,32h
                 je cmpCall
                 cmp choice,33h
                 je catCall
                 cmp choice,34h
                 je subCall
                 cmp choice,35h
                 je countCall
                 cmp choice,36h
                 je exit
                 disp invalid
                 jmp menuLoop

        inpCall:call inpString
                jmp menuLoop

        cmpCall:call cmpString
                jmp menuLoop

        catCall:call catString
                jmp menuLoop

        subCall:call subString
                jmp menuLoop
                
        countCall:call countString
        	  jmp menuLoop

        exit:mov ah,4Ch
             int 21h
end
