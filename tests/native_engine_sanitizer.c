#include <stdint.h>
#include <stdio.h>
#include <string.h>

extern int b_m_selftest(void);
extern int b_m_engine_selftest(void);
extern int b_m_mine_parallel(const uint8_t prefix[76], const uint8_t target[32],
                             uint32_t start, uint32_t thread_count,
                             uint64_t max_hashes, uint32_t *found, uint64_t *hashes);
typedef struct BM_ENGINE BM_ENGINE;
extern BM_ENGINE *b_m_engine_create(uint32_t thread_count);
extern int b_m_engine_set_job(BM_ENGINE *, const uint8_t prefix[76], const uint8_t target[32]);
extern int b_m_engine_poll(BM_ENGINE *, uint32_t *found, uint64_t *hashes);
extern void b_m_engine_stop_job(BM_ENGINE *);
extern void b_m_engine_destroy(BM_ENGINE *);

static void vector(uint8_t prefix[76], uint8_t target[32], uint32_t nonce) {
    for (int i = 0; i < 76; ++i) prefix[i] = (uint8_t)(i * 37 + 11);
    /* A zero target is intentionally not used: self-tests already cover
       exact SHA256d. For sanitizer stress, a maximal target guarantees a hit
       without requiring a known digest. */
    memset(target, 0xff, 32);
    (void)nonce;
}

int main(void) {
    if (b_m_selftest() != 0 || b_m_engine_selftest() != 0) return 1;

    uint8_t prefix[76], target[32];
    vector(prefix, target, 0);

    /* Exercise the multi-thread parallel API repeatedly. */
    for (int i = 0; i < 200; ++i) {
        uint32_t found = 0;
        uint64_t hashes = 0;
        if (!b_m_mine_parallel(prefix, target, (uint32_t)i,
                               8, 4096, &found, &hashes)) {
            fprintf(stderr, "parallel stress failed at %d\n", i);
            return 2;
        }
        if (hashes == 0) return 3;
    }

    /* Repeated persistent-job replacement exercises lifecycle and locking. */
    BM_ENGINE *e = b_m_engine_create(8);
    if (!e) return 4;
    for (int i = 0; i < 200; ++i) {
        if (!b_m_engine_set_job(e, prefix, target)) {
            b_m_engine_destroy(e);
            return 5;
        }
        uint32_t found = 0;
        uint64_t hashes = 0;
        for (int p = 0; p < 100; ++p) {
            (void)b_m_engine_poll(e, &found, &hashes);
            if (found || hashes) break;
        }
        b_m_engine_stop_job(e);
    }
    b_m_engine_destroy(e);

    puts("NATIVE ENGINE SANITIZER HARNESS: PASS");
    return 0;
}
