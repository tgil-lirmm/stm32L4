.syntax unified
.cpu cortex-m4
.thumb

.global g_pfnVectors
.global Reset_Handler

/* Table des vecteurs d'interruption minimale */
.section .isr_vector,"a",%progbits
.type g_pfnVectors, %object
g_pfnVectors:
    .word _estack
    .word Reset_Handler

.section .text.Reset_Handler
.weak Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
    /* Initialisation de la pile et saut vers le main */
    ldr r0, =_estack
    mov sp, r0
    bl main
    b .
