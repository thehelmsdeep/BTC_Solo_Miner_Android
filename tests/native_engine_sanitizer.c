#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

extern int b_m_selftest(void);
extern int b_m_engine_selftest(void);

int main(void) {
    int a = b_m_selftest();
    int b = b_m_engine_selftest();
    printf("b_m_selftest=%d b_m_engine_selftest=%d\n", a, b);
    if (a != 0 || b != 0) return 1;
    return 0;
}
