; HOOK.ASM - restart hook: JMP $A810
; $0480-$0482

         org $0480


* restart hook: JMP START ----------------------------------
RESTART
         jmp  START                ; 0480
