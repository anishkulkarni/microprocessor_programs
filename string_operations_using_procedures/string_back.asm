.model small
.stack 100h
        INPSTR macro
                mov ah,0Ah
                int 21h
        endm

        DISP macro msg
                lea dx,msg
                mov ah,09h
                int 21h
        endm

        OUP macro
                mov ah,02h
                int 21h
         endm

.data
        str1 db 25 dup('$')
        str2 db 25 dup('$')
        str3 db 50 dup('$')
        get1 db 13,10,'String 1: $'
        get2 db 13,10,'String 2: $'
        equal db 13,10,'Both strings equal$'
        s1g db 13,10,'String 1 greate$r'
        s2g db 13,10,'String 2 greater$'
        temp dw ?
        capAlpha db 0
        smAlpha db 0
        dig db 0
        spaces db 0
        newlc db 0
        specChar db 0
        capAlphaHead db 13,10,'Count of capital alphabets: $'
        smAlphaHead db 13,10,'Count of small alphabets: $'
        digHead db 13,10,'Count of digits: $'
        spaceHead db 13,10,'Count of words: $'
        newlHead db 13,10,'Count of lines: $'
        specCharhead db 13,10,'Count of special characters: $'
.code
        mov ax,@data
        mov ds,ax
        mov es,ax

        public inpString
        inpString proc far
                DISP get1
                lea dx,str1
                INPSTR
                DISP get2
                lea dx,str2
                INPSTR
                ret
        inpString endp

        public cmpString
        cmpString proc far
                lea si,str1+1
                lea di,str2+1
                mov cl,[si]
                mov ch,00h
                mov bl,[di]
                mov bh,00h
                inc si
                inc di
                cmp cx,bx
                ja great1
                jb great2
                rep cmpsb
                ja great1
                jb great2
                DISP equal
                ret
                great1:DISP s1g
                      ret
                great2:DISP s2g
                       ret
        cmpString endp

        public catString
        catString proc far
                lea si,str1+1
                mov cl,[si]
                mov ch,00h
                lea di,str3+1
                mov al,[si]
                mov [di],al
                inc si
                inc di
                rep movsb
                lea si,str2+1
                mov bl,[si]
                mov cl,[si]
                mov ch,00h
                inc si
                rep movsb
                lea di,str3+1
                add [di],bl
                DISP str3+2
                ret
        catString endp

        public subString
        subString proc far
                mov dl,0000h
                lea si,str1+1
                lea di,str2+1
                mov cl,[di]
                mov bl,[si]
                mov bh,00h
                mov ch,00h
                inc si
                inc di
                cmp cl,bl
                jg subret
                sub bl,cl
                inc bl
                again:mov temp,si
                      mov dh,cl
                      repe cmpsb
                      jne noinc
                      inc dl
                      noinc:lea di,str2+2
                            mov si,temp
                            inc si
                            mov cl,dh
                            dec bl
                            jnz again
                subret:add dl,30h
                       oup
                ret
        subString endp
        
        public countString
        countString proc far
        	lea si,str1+1
        	mov cl,[si]
        	inc si
        	countLoop:mov al,'0'
        		  cmp [si],al
        		  jbe sac
        		  mov al,'9'
        		  cmp [si],al
        		  jg sac
        		  inc dig
        		  jmp iter
        		  sac:mov al,'a'
        		      cmp [si],al
        		      jbe cac
        		      mov al,'z'
        		      cmp [si],al
        		      jg cac
        		      inc smAlpha
        		      jmp iter
        		  cac:mov al,'A'
        		      cmp [si],al
        		      jbe spc
        		      mov al,'Z'
        		      cmp [si],al
        		      jg spc
        		      inc capAlpha
        		      jmp iter
        		  spc:mov al,' '
        		      cmp [si],al
        		      jne newl
        		      inc spaces
        		      jmp iter
        		  newl:mov al,13
        		       cmp [si],al
        		       jne spec
        		       inc newlc
        		       jmp iter
        		  spec:inc specChar
        		  iter:inc si
        		       dec cl
        		       jnz countLoop
        	inc newlc
        	inc spaces
        	add capAlpha,30h
        	add smAlpha,30h
        	add dig,30h
        	add newlc,30h
        	add spaces,30h
        	add specChar,30h
        	DISP capAlphaHead
        	mov dl,capAlpha
        	OUP
        	DISP smAlphaHead
        	mov dl,smAlpha
        	OUP
        	DISP newlHead
        	mov dl,newlc
        	OUP
        	DISP spaceHead
        	mov dl,spaces
        	OUP
        	DISP specCharHead
        	mov dl,specChar
        	OUP
        	DISP digHead
        	mov dl,dig
        	OUP
        	ret
        endp countString
end
