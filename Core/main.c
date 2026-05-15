#include <stdint.h>

// Définitions minimales pour faire clignoter la LED sur PA5 (Nucleo-L476RG)
#define RCC_BASE      0x40021000
#define RCC_AHB2ENR   (*(volatile uint32_t *)(RCC_BASE + 0x4C))

#define GPIOA_BASE    0x48000000
#define GPIOA_MODER   (*(volatile uint32_t *)(GPIOA_BASE + 0x00))
#define GPIOA_ODR     (*(volatile uint32_t *)(GPIOA_BASE + 0x14))

void delay(volatile uint32_t count) {
    while (count--) { __asm__("nop"); }
}

int main(void) {
    // 1. Activer l'horloge du GPIOA
    RCC_AHB2ENR |= (1 << 0);
    
    // 2. Configurer PA5 en mode sortie (01)
    GPIOA_MODER &= ~(3 << 10);
    GPIOA_MODER |=  (1 << 10);

    while (1) {
        GPIOA_ODR ^= (1 << 5); // Inverser l'état de la LED
        delay(400000);         // Attendre un peu
    }
}
