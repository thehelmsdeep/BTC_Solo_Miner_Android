#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#ifndef _WIN32
#include <time.h>
#endif
#ifdef _WIN32
#include <windows.h>
#include <process.h>
#else
#include <pthread.h>
#endif

typedef struct { uint32_t h[8]; uint64_t bits; uint8_t buf[64]; size_t len; } SHA256_CTX;

static const uint32_t K[64] = {
0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2};

static inline uint32_t R(uint32_t x,int n){return (x>>n)|(x<<(32-n));}
static inline uint32_t BSWAP32(uint32_t x){
#if defined(_MSC_VER)
 return _byteswap_ulong(x);
#elif defined(__GNUC__) || defined(__clang__)
 return __builtin_bswap32(x);
#else
 return ((x&0x000000ffU)<<24)|((x&0x0000ff00U)<<8)|
        ((x&0x00ff0000U)>>8)|((x&0xff000000U)>>24);
#endif
}

/* SHA-256 compression for already-decoded big-endian message words. */
static inline void transform_words(SHA256_CTX * restrict c,const uint32_t in[16]){
 uint32_t w[16],a,b,cc,d,e,f,g,h; int i;
 memcpy(w,in,64);
 a=c->h[0]; b=c->h[1]; cc=c->h[2]; d=c->h[3];
 e=c->h[4]; f=c->h[5]; g=c->h[6]; h=c->h[7];
 for(i=0;i<64;i++){
  uint32_t wi;
  if(i>=16){
   uint32_t x=w[(i-15)&15], y=w[(i-2)&15];
   uint32_t s0=R(x,7)^R(x,18)^(x>>3);
   uint32_t s1=R(y,17)^R(y,19)^(y>>10);
   wi=w[i&15]+s0+w[(i-7)&15]+s1;
   w[i&15]=wi;
  } else wi=w[i];
  uint32_t S1=R(e,6)^R(e,11)^R(e,25);
  uint32_t ch=(e&f)^((~e)&g);
  uint32_t t1=h+S1+ch+K[i]+wi;
  uint32_t S0=R(a,2)^R(a,13)^R(a,22);
  uint32_t maj=(a&b)^(a&cc);
  uint32_t t2=S0+maj;
  h=g; g=f; f=e; e=d+t1;
  d=cc; cc=b; b=a; a=t1+t2;
 }
 c->h[0]+=a; c->h[1]+=b; c->h[2]+=cc; c->h[3]+=d;
 c->h[4]+=e; c->h[5]+=f; c->h[6]+=g; c->h[7]+=h;
}
static inline void transform(SHA256_CTX * restrict c,const uint8_t * restrict p){
 uint32_t w[16]; int i;
 for(i=0;i<16;i++)
  w[i]=((uint32_t)p[i*4]<<24)|((uint32_t)p[i*4+1]<<16)|
       ((uint32_t)p[i*4+2]<<8)|p[i*4+3];
 transform_words(c,w);
}
static void init(SHA256_CTX*c){static const uint32_t h[8]={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19};memcpy(c->h,h,32);c->bits=0;c->len=0;}
static void update(SHA256_CTX*c,const uint8_t*p,size_t n){while(n){size_t k=64-c->len;if(k>n)k=n;memcpy(c->buf+c->len,p,k);c->len+=k;c->bits+=k*8;p+=k;n-=k;if(c->len==64){transform(c,c->buf);c->len=0;}}}
static void final(SHA256_CTX*c,uint8_t out[32]){size_t i=c->len;c->buf[i++]=0x80;if(i>56){while(i<64)c->buf[i++]=0;transform(c,c->buf);i=0;}while(i<56)c->buf[i++]=0;uint64_t b=c->bits;for(int j=0;j<8;j++)c->buf[63-j]=(uint8_t)(b>>(j*8));transform(c,c->buf);for(i=0;i<8;i++){out[i*4]=(uint8_t)(c->h[i]>>24);out[i*4+1]=(uint8_t)(c->h[i]>>16);out[i*4+2]=(uint8_t)(c->h[i]>>8);out[i*4+3]=(uint8_t)c->h[i];}}

static inline int le_target_words(const uint32_t h[8],const uint8_t t[32]){
 /* SHA-256 state words are big-endian digest words. Bitcoin compares the
  * digest as a little-endian integer, so compare words from 7 down to 0
  * after byte-swapping. This avoids materializing the 32-byte digest. */
 for(int i=7;i>=0;i--){
  uint32_t tv=(uint32_t)t[i*4]|((uint32_t)t[i*4+1]<<8)|
              ((uint32_t)t[i*4+2]<<16)|((uint32_t)t[i*4+3]<<24);
  uint32_t hv=BSWAP32(h[i]);
  if(hv<tv)return 1;
  if(hv>tv)return 0;
 }
 return 1;
}
static int le_target(const uint8_t h[32],const uint8_t t[32]){
 for(int i=31;i>=0;i--){if(h[i]<t[i])return 1;if(h[i]>t[i])return 0;}return 1;
}

/* Scans nonce values start, start+step, ... . Returns 1 on a target hit, 0 otherwise.
   The header prefix must be exactly the first 76 bytes of an 80-byte Bitcoin header. */
int b_m_mine(const uint8_t prefix[76], const uint8_t target[32],
            uint32_t start, uint32_t step, uint64_t max_hashes, uint32_t *found, uint64_t *hashes){
 uint8_t header[80],d1[32],d2[32]; memcpy(header,prefix,76);
 SHA256_CTX base; init(&base); update(&base,header,64);
 uint64_t n=0;
 for(uint64_t x=start;x<=0xffffffffULL;x+=step){
  header[76]=(uint8_t)x;header[77]=(uint8_t)(x>>8);header[78]=(uint8_t)(x>>16);header[79]=(uint8_t)(x>>24);
  SHA256_CTX a=base;update(&a,header+64,16);final(&a,d1);
  SHA256_CTX b;init(&b);update(&b,d1,32);final(&b,d2);n++;
  if(le_target(d2,target)){*found=(uint32_t)x;*hashes=n;return 1;}
  if(max_hashes && n >= max_hashes) break;
  if(x > 0xffffffffULL-step) break;
 }
 *hashes=n;return 0;
}

#ifdef _WIN32
#include <process.h>
#endif

static inline int hash_nonce_fast(const SHA256_CTX *base,
                                      uint32_t tail0,uint32_t tail1,uint32_t tail2,
                                      const uint8_t target[32],uint32_t nonce){
 uint32_t w[16];
 SHA256_CTX a=*base;
 w[0]=tail0; w[1]=tail1; w[2]=tail2; w[3]=BSWAP32(nonce);
 w[4]=0x80000000U;
 w[5]=0; w[6]=0; w[7]=0; w[8]=0; w[9]=0; w[10]=0; w[11]=0;
 w[12]=0; w[13]=0; w[14]=0; w[15]=0x00000280U;
 transform_words(&a,w);

 w[0]=a.h[0]; w[1]=a.h[1]; w[2]=a.h[2]; w[3]=a.h[3];
 w[4]=a.h[4]; w[5]=a.h[5]; w[6]=a.h[6]; w[7]=a.h[7];
 w[8]=0x80000000U;
 w[9]=0; w[10]=0; w[11]=0; w[12]=0; w[13]=0; w[14]=0; w[15]=0x00000100U;
 SHA256_CTX b;
 static const uint32_t IV[8]={
  0x6a09e667U,0xbb67ae85U,0x3c6ef372U,0xa54ff53aU,
  0x510e527fU,0x9b05688cU,0x1f83d9abU,0x5be0cd19U
 };
 memcpy(b.h,IV,32);
 transform_words(&b,w);
 return le_target_words(b.h,target);
}
#if defined(__SSE2__) || defined(_M_X64) || defined(_M_IX86_FP)
#include <emmintrin.h>

static inline __m128i v_rotr(__m128i x, int n) {
    return _mm_or_si128(_mm_srli_epi32(x,n), _mm_slli_epi32(x,32-n));
}
static inline __m128i v_ch(__m128i x,__m128i y,__m128i z) {
    return _mm_xor_si128(_mm_and_si128(x,y),_mm_andnot_si128(x,z));
}
static inline __m128i v_maj(__m128i x,__m128i y,__m128i z) {
    return _mm_xor_si128(_mm_xor_si128(_mm_and_si128(x,y),_mm_and_si128(x,z)),_mm_and_si128(y,z));
}
static inline __m128i v_s0(__m128i x) {
    return _mm_xor_si128(_mm_xor_si128(v_rotr(x,2),v_rotr(x,13)),v_rotr(x,22));
}
static inline __m128i v_s1(__m128i x) {
    return _mm_xor_si128(_mm_xor_si128(v_rotr(x,6),v_rotr(x,11)),v_rotr(x,25));
}
static inline __m128i v_l0(__m128i x) {
    return _mm_xor_si128(_mm_xor_si128(v_rotr(x,7),v_rotr(x,18)),_mm_srli_epi32(x,3));
}
static inline __m128i v_l1(__m128i x) {
    return _mm_xor_si128(_mm_xor_si128(v_rotr(x,17),v_rotr(x,19)),_mm_srli_epi32(x,10));
}

static inline void sha256_compress4(__m128i h[8],const __m128i in[16]) {
    __m128i w[16];
    for(int i=0;i<16;i++) w[i]=in[i];
    __m128i a=h[0],b=h[1],c=h[2],d=h[3],e=h[4],f=h[5],g=h[6],hh=h[7];
    for(int i=0;i<64;i++){
        __m128i wi;
        if(i>=16){
            __m128i x=w[(i-15)&15],y=w[(i-2)&15];
            wi=_mm_add_epi32(_mm_add_epi32(w[i&15],v_l0(x)),
                             _mm_add_epi32(w[(i-7)&15],v_l1(y)));
            w[i&15]=wi;
        } else wi=w[i];
        __m128i t1=_mm_add_epi32(
            _mm_add_epi32(_mm_add_epi32(hh,v_s1(e)),v_ch(e,f,g)),
            _mm_add_epi32(_mm_set1_epi32((int)K[i]),wi));
        __m128i t2=_mm_add_epi32(v_s0(a),v_maj(a,b,c));
        hh=g;g=f;f=e;e=_mm_add_epi32(d,t1);
        d=c;c=b;b=a;a=_mm_add_epi32(t1,t2);
    }
    h[0]=_mm_add_epi32(h[0],a);h[1]=_mm_add_epi32(h[1],b);
    h[2]=_mm_add_epi32(h[2],c);h[3]=_mm_add_epi32(h[3],d);
    h[4]=_mm_add_epi32(h[4],e);h[5]=_mm_add_epi32(h[5],f);
    h[6]=_mm_add_epi32(h[6],g);h[7]=_mm_add_epi32(h[7],hh);
}

static inline int le_target_lane(const uint32_t hv[8][4],int lane,const uint32_t target_words[8]){
    /* Compare directly from the most-significant Bitcoin word. The digest
     * words are already in registers after the SIMD compression; only the
     * selected lane needs byte swapping. */
    for(int i=7;i>=0;i--){
        uint32_t hvv=BSWAP32(hv[i][lane]);
        uint32_t tv=target_words[i];
        if(hvv!=tv) return hvv<tv;
    }
    return 1;
}

/* Precompute the fixed second-block padding and first-block constants outside
 * the 4-lane hot loop. */
static inline void sha256_4_hashes(const SHA256_CTX *base,
                                   uint32_t t0,uint32_t t1,uint32_t t2,
                                   const uint32_t nonce[4],
                                   const uint32_t target_words[8],uint8_t hit_mask[4]){
    __m128i h[8],w[16];
    for(int i=0;i<8;i++) h[i]=_mm_set1_epi32((int)base->h[i]);
    w[0]=_mm_set1_epi32((int)t0);w[1]=_mm_set1_epi32((int)t1);w[2]=_mm_set1_epi32((int)t2);
    uint32_t nb[4];
    for(int i=0;i<4;i++) nb[i]=BSWAP32(nonce[i]);
    w[3]=_mm_loadu_si128((const __m128i*)nb);
    w[4]=_mm_set1_epi32((int)0x80000000U);
    for(int i=5;i<=14;i++) w[i]=_mm_setzero_si128();
    w[15]=_mm_set1_epi32((int)0x00000280U);
    sha256_compress4(h,w);

    __m128i s[8];
    static const uint32_t IV[8]={
        0x6a09e667U,0xbb67ae85U,0x3c6ef372U,0xa54ff53AU,
        0x510e527fU,0x9b05688cU,0x1f83d9abU,0x5be0cd19U
    };
    for(int i=0;i<8;i++) s[i]=_mm_set1_epi32((int)IV[i]);
    for(int i=0;i<8;i++) w[i]=h[i];
    w[8]=_mm_set1_epi32((int)0x80000000U);
    for(int i=9;i<=14;i++) w[i]=_mm_setzero_si128();
    w[15]=_mm_set1_epi32((int)0x00000100U);
    sha256_compress4(s,w);

    uint32_t hv[8][4];
    for(int i=0;i<8;i++) _mm_storeu_si128((__m128i*)hv[i],s[i]);
    for(int lane=0;lane<4;lane++) hit_mask[lane]=(uint8_t)le_target_lane(hv,lane,target_words);
}

#if defined(__AVX2__)
#include <immintrin.h>
static inline __m256i avx_rotr(__m256i x,int n){return _mm256_or_si256(_mm256_srli_epi32(x,n),_mm256_slli_epi32(x,32-n));}
static inline __m256i avx_ch(__m256i x,__m256i y,__m256i z){return _mm256_xor_si256(_mm256_and_si256(x,y),_mm256_andnot_si256(x,z));}
static inline __m256i avx_maj(__m256i x,__m256i y,__m256i z){return _mm256_xor_si256(_mm256_xor_si256(_mm256_and_si256(x,y),_mm256_and_si256(x,z)),_mm256_and_si256(y,z));}
static inline __m256i avx_s0(__m256i x){return _mm256_xor_si256(_mm256_xor_si256(avx_rotr(x,2),avx_rotr(x,13)),avx_rotr(x,22));}
static inline __m256i avx_s1(__m256i x){return _mm256_xor_si256(_mm256_xor_si256(avx_rotr(x,6),avx_rotr(x,11)),avx_rotr(x,25));}
static inline __m256i avx_l0(__m256i x){return _mm256_xor_si256(_mm256_xor_si256(avx_rotr(x,7),avx_rotr(x,18)),_mm256_srli_epi32(x,3));}
static inline __m256i avx_l1(__m256i x){return _mm256_xor_si256(_mm256_xor_si256(avx_rotr(x,17),avx_rotr(x,19)),_mm256_srli_epi32(x,10));}

static inline void sha256_compress8(__m256i h[8],const __m256i in[16]){
    __m256i w[16];
    for(int i=0;i<16;i++) w[i]=in[i];
    __m256i a=h[0],b=h[1],c=h[2],d=h[3],e=h[4],f=h[5],g=h[6],hh=h[7];
    for(int i=0;i<64;i++){
        __m256i wi;
        if(i>=16){
            __m256i x=w[(i-15)&15],y=w[(i-2)&15];
            wi=_mm256_add_epi32(_mm256_add_epi32(w[i&15],avx_l0(x)),
                                _mm256_add_epi32(w[(i-7)&15],avx_l1(y)));
            w[i&15]=wi;
        } else wi=w[i];
        __m256i t1=_mm256_add_epi32(
            _mm256_add_epi32(_mm256_add_epi32(hh,avx_s1(e)),avx_ch(e,f,g)),
            _mm256_add_epi32(_mm256_set1_epi32((int)K[i]),wi));
        __m256i t2=_mm256_add_epi32(avx_s0(a),avx_maj(a,b,c));
        hh=g;g=f;f=e;e=_mm256_add_epi32(d,t1);
        d=c;c=b;b=a;a=_mm256_add_epi32(t1,t2);
    }
    h[0]=_mm256_add_epi32(h[0],a);h[1]=_mm256_add_epi32(h[1],b);
    h[2]=_mm256_add_epi32(h[2],c);h[3]=_mm256_add_epi32(h[3],d);
    h[4]=_mm256_add_epi32(h[4],e);h[5]=_mm256_add_epi32(h[5],f);
    h[6]=_mm256_add_epi32(h[6],g);h[7]=_mm256_add_epi32(h[7],hh);
}

static inline int le_target_lane8(const uint32_t hv[8][8],int lane,const uint32_t target_words[8]){
    for(int i=7;i>=0;i--){
        uint32_t hvv=BSWAP32(hv[i][lane]),tv=target_words[i];
        if(hvv!=tv) return hvv<tv;
    }
    return 1;
}

static inline void sha256_8_hashes(const SHA256_CTX *base,
                                    uint32_t t0,uint32_t t1,uint32_t t2,
                                    const uint32_t nonce[8],
                                    const uint32_t target_words[8],uint8_t hit_mask[8]){
    __m256i h[8],w[16];
    for(int i=0;i<8;i++) h[i]=_mm256_set1_epi32((int)base->h[i]);
    w[0]=_mm256_set1_epi32((int)t0);w[1]=_mm256_set1_epi32((int)t1);w[2]=_mm256_set1_epi32((int)t2);
    uint32_t nb[8];
    for(int i=0;i<8;i++) nb[i]=BSWAP32(nonce[i]);
    w[3]=_mm256_loadu_si256((const __m256i*)nb);
    w[4]=_mm256_set1_epi32((int)0x80000000U);
    for(int i=5;i<=14;i++) w[i]=_mm256_setzero_si256();
    w[15]=_mm256_set1_epi32((int)0x00000280U);
    sha256_compress8(h,w);

    __m256i s[8];
    static const uint32_t IV[8]={0x6a09e667U,0xbb67ae85U,0x3c6ef372U,0xa54ff53AU,
                                 0x510e527fU,0x9b05688cU,0x1f83d9abU,0x5be0cd19U};
    for(int i=0;i<8;i++) s[i]=_mm256_set1_epi32((int)IV[i]);
    for(int i=0;i<8;i++) w[i]=h[i];
    w[8]=_mm256_set1_epi32((int)0x80000000U);
    for(int i=9;i<=14;i++) w[i]=_mm256_setzero_si256();
    w[15]=_mm256_set1_epi32((int)0x00000100U);
    sha256_compress8(s,w);

    uint32_t hv[8][8];
    for(int i=0;i<8;i++) _mm256_storeu_si256((__m256i*)hv[i],s[i]);
    for(int lane=0;lane<8;lane++) hit_mask[lane]=(uint8_t)le_target_lane8(hv,lane,target_words);
}
#endif

#endif


#if defined(__aarch64__) && defined(__ARM_FEATURE_SHA2)
#include <arm_neon.h>

/*
 * ARMv8 SHA-256 hardware path.
 * The A07 reports the ARMv8 SHA2 extension, so these intrinsics map to
 * the CPU's SHA-256 instructions rather than the scalar C round function.
 */
static inline void arm_sha256_compress(uint32_t h[8], const uint32_t w[16]) {
    uint32x4_t state0 = vld1q_u32(&h[0]);
    uint32x4_t state1 = vld1q_u32(&h[4]);
    const uint32x4_t save0 = state0;
    const uint32x4_t save1 = state1;

    uint32x4_t m0 = vld1q_u32(&w[0]);
    uint32x4_t m1 = vld1q_u32(&w[4]);
    uint32x4_t m2 = vld1q_u32(&w[8]);
    uint32x4_t m3 = vld1q_u32(&w[12]);
    uint32x4_t tmp0, tmp1, tmp2;

#define ARM_SHA_ROUND(MSG, KOFF) do { \
    tmp2 = state0; \
    tmp0 = vaddq_u32((MSG), vld1q_u32(&K[(KOFF)])); \
    state0 = vsha256hq_u32(state0, state1, tmp0); \
    state1 = vsha256h2q_u32(state1, tmp2, tmp0); \
} while (0)

    ARM_SHA_ROUND(m0, 0);
    m0 = vsha256su0q_u32(m0, m1);
    m0 = vsha256su1q_u32(m0, m2, m3);

    ARM_SHA_ROUND(m1, 4);
    m1 = vsha256su0q_u32(m1, m2);
    m1 = vsha256su1q_u32(m1, m3, m0);

    ARM_SHA_ROUND(m2, 8);
    m2 = vsha256su0q_u32(m2, m3);
    m2 = vsha256su1q_u32(m2, m0, m1);

    ARM_SHA_ROUND(m3, 12);
    m3 = vsha256su0q_u32(m3, m0);
    m3 = vsha256su1q_u32(m3, m1, m2);

    ARM_SHA_ROUND(m0, 16);
    m0 = vsha256su0q_u32(m0, m1);
    m0 = vsha256su1q_u32(m0, m2, m3);

    ARM_SHA_ROUND(m1, 20);
    m1 = vsha256su0q_u32(m1, m2);
    m1 = vsha256su1q_u32(m1, m3, m0);

    ARM_SHA_ROUND(m2, 24);
    m2 = vsha256su0q_u32(m2, m3);
    m2 = vsha256su1q_u32(m2, m0, m1);

    ARM_SHA_ROUND(m3, 28);
    m3 = vsha256su0q_u32(m3, m0);
    m3 = vsha256su1q_u32(m3, m1, m2);

    ARM_SHA_ROUND(m0, 32);
    m0 = vsha256su0q_u32(m0, m1);
    m0 = vsha256su1q_u32(m0, m2, m3);

    ARM_SHA_ROUND(m1, 36);
    m1 = vsha256su0q_u32(m1, m2);
    m1 = vsha256su1q_u32(m1, m3, m0);

    ARM_SHA_ROUND(m2, 40);
    m2 = vsha256su0q_u32(m2, m3);
    m2 = vsha256su1q_u32(m2, m0, m1);

    ARM_SHA_ROUND(m3, 44);
    m3 = vsha256su0q_u32(m3, m0);
    m3 = vsha256su1q_u32(m3, m1, m2);

    ARM_SHA_ROUND(m0, 48);
    ARM_SHA_ROUND(m1, 52);
    ARM_SHA_ROUND(m2, 56);
    ARM_SHA_ROUND(m3, 60);

#undef ARM_SHA_ROUND

    state0 = vaddq_u32(state0, save0);
    state1 = vaddq_u32(state1, save1);
    vst1q_u32(&h[0], state0);
    vst1q_u32(&h[4], state1);
}

static inline int hash_nonce_arm(const SHA256_CTX *base,
                                 uint32_t tail0, uint32_t tail1, uint32_t tail2,
                                 const uint8_t target[32], uint32_t nonce) {
    uint32_t w[16];

    w[0] = tail0;
    w[1] = tail1;
    w[2] = tail2;
    w[3] = BSWAP32(nonce);
    w[4] = 0x80000000U;
    w[5] = 0; w[6] = 0; w[7] = 0; w[8] = 0;
    w[9] = 0; w[10] = 0; w[11] = 0;
    w[12] = 0; w[13] = 0; w[14] = 0;
    w[15] = 0x00000280U;

    uint32_t first[8];
    memcpy(first, base->h, sizeof(first));
    arm_sha256_compress(first, w);

    uint32_t second[16];
    second[0] = first[0]; second[1] = first[1];
    second[2] = first[2]; second[3] = first[3];
    second[4] = first[4]; second[5] = first[5];
    second[6] = first[6]; second[7] = first[7];
    second[8] = 0x80000000U;
    second[9] = 0; second[10] = 0; second[11] = 0;
    second[12] = 0; second[13] = 0; second[14] = 0;
    second[15] = 0x00000100U;

    uint32_t digest_state[8] = {
        0x6a09e667U, 0xbb67ae85U, 0x3c6ef372U, 0xa54ff53AU,
        0x510e527fU, 0x9b05688cU, 0x1f83d9abU, 0x5be0cd19U
    };
    arm_sha256_compress(digest_state, second);

    return le_target_words(digest_state, target);
}
#endif

static int hash_nonce(const uint8_t prefix[76],const SHA256_CTX *base,
                      const uint8_t target[32],uint32_t nonce){
 uint32_t t0,t1,t2; const uint8_t *p=prefix+64;
 t0=((uint32_t)p[0]<<24)|((uint32_t)p[1]<<16)|((uint32_t)p[2]<<8)|p[3];
 t1=((uint32_t)p[4]<<24)|((uint32_t)p[5]<<16)|((uint32_t)p[6]<<8)|p[7];
 t2=((uint32_t)p[8]<<24)|((uint32_t)p[9]<<16)|((uint32_t)p[10]<<8)|p[11];
#if defined(__aarch64__) && defined(__ARM_FEATURE_SHA2)
 return hash_nonce_arm(base,t0,t1,t2,target,nonce);
#else
 return hash_nonce_fast(base,t0,t1,t2,target,nonce);
#endif
}
typedef struct {
 const uint8_t *prefix;
 const uint8_t *target;
 SHA256_CTX base;
 uint32_t thread_id;
 uint32_t thread_count;
 uint64_t max_hashes;
 volatile uint64_t *next_nonce;
 volatile uint64_t *total_hashes;
 volatile int *stop;
 volatile int *found_valid;
 uint32_t *found_nonce;
 uint64_t local_hashes;
} BM_PARALLEL_ARG;

#define BM_CHUNK 262144ULL

static void bm_parallel_run(BM_PARALLEL_ARG *a) {
 /*
  * Reserve nonce ranges atomically. This gives each thread a contiguous
  * chunk, removes the shared counter increment from the hot hash loop,
  * and guarantees that the global hash limit is not overrun by design.
  */
 while (!*a->stop) {
  uint64_t n = __atomic_fetch_add(a->next_nonce, BM_CHUNK, __ATOMIC_RELAXED);
  if (n >= 0x100000000ULL) return;

  uint64_t end = n + BM_CHUNK;
  if (end > 0x100000000ULL) end = 0x100000000ULL;
  uint64_t limit = a->max_hashes
      ? (uint64_t)a->max_hashes
      : 0x100000000ULL;
  if (end > limit) end = limit;
  a->local_hashes = 0;

  for (; n < end && !*a->stop; ++n) {
   if (hash_nonce(a->prefix, &a->base, a->target, (uint32_t)n)) {
#ifdef _WIN32
    if (InterlockedCompareExchange((volatile LONG*)a->found_valid, 1, 0) == 0)
#else
    if (__sync_bool_compare_and_swap(a->found_valid, 0, 1))
#endif
    {
     *a->found_nonce = (uint32_t)n;
     *a->stop = 1;
    }
    __atomic_fetch_add(a->total_hashes, 1, __ATOMIC_RELAXED);
    return;
   }
   ++a->local_hashes;
  }
  __atomic_fetch_add(a->total_hashes, a->local_hashes, __ATOMIC_RELAXED);
 }
}

#ifdef _WIN32
static unsigned __stdcall bm_parallel_win(void *p) {
 bm_parallel_run((BM_PARALLEL_ARG*)p);
 return 0;
}
#else
static void *bm_parallel_posix(void *p) {
 bm_parallel_run((BM_PARALLEL_ARG*)p);
 return NULL;
}
#endif

int b_m_mine_parallel(const uint8_t prefix[76], const uint8_t target[32],
                      uint32_t start, uint32_t thread_count,
                      uint64_t max_hashes, uint32_t *found, uint64_t *hashes) {
 if (thread_count == 0) thread_count = 1;
 if (thread_count > 64) thread_count = 64;

 SHA256_CTX base;
 init(&base);
 update(&base, prefix, 64);

 volatile int stop = 0;
 volatile int found_valid = 0;
 uint32_t found_nonce = 0;
 volatile uint64_t next_nonce = start;
 volatile uint64_t total_hashes = 0;

 BM_PARALLEL_ARG args[64];

#ifdef _WIN32
 HANDLE threads[64];
#else
 pthread_t threads[64];
#endif
 uint32_t created = 0;

 for (uint32_t i = 0; i < thread_count; ++i) {
  args[i].prefix = prefix;
  args[i].target = target;
  args[i].base = base;
  args[i].thread_id = start + i;
  args[i].thread_count = thread_count;
  args[i].max_hashes = max_hashes ? (uint64_t)start + max_hashes : 0;
  args[i].next_nonce = &next_nonce;
  args[i].total_hashes = &total_hashes;
  args[i].stop = &stop;
  args[i].found_valid = &found_valid;
  args[i].found_nonce = &found_nonce;

#ifdef _WIN32
  uintptr_t h = _beginthreadex(NULL, 0, bm_parallel_win, &args[i], 0, NULL);
  if (!h) break;
  threads[created++] = (HANDLE)h;
#else
  if (pthread_create(&threads[created], NULL, bm_parallel_posix, &args[i]) != 0)
   break;
  created++;
#endif
 }

#ifdef _WIN32
 for (uint32_t i = 0; i < created; ++i) {
  WaitForSingleObject(threads[i], INFINITE);
  CloseHandle(threads[i]);
 }
#else
 for (uint32_t i = 0; i < created; ++i) pthread_join(threads[i], NULL);
#endif

 *hashes = total_hashes;
 if (found_valid) {
  *found = found_nonce;
  return 1;
 }
 return 0;
}


/* Persistent native mining engine: worker threads live across Stratum jobs. */
typedef struct BM_ENGINE BM_ENGINE;
typedef struct { BM_ENGINE *engine; uint32_t id; } BM_ENGINE_ARG;

struct BM_ENGINE {
    uint32_t thread_count;
    uint64_t job_generation;
    uint64_t next_nonce;
    uint64_t total_hashes;
    int job_ready;
    int stop_job;
    int shutdown;
    int found_valid;
    uint32_t found_nonce;
    uint8_t prefix[76];
    uint8_t target[32];
    BM_ENGINE_ARG *args;
#ifdef _WIN32
    CRITICAL_SECTION lock;
    CONDITION_VARIABLE cond;
    HANDLE *threads;
#else
    pthread_mutex_t lock;
    pthread_cond_t cond;
    pthread_t *threads;
#endif
};

static void engine_lock(BM_ENGINE *e) {
#ifdef _WIN32
    EnterCriticalSection(&e->lock);
#else
    pthread_mutex_lock(&e->lock);
#endif
}
static void engine_unlock(BM_ENGINE *e) {
#ifdef _WIN32
    LeaveCriticalSection(&e->lock);
#else
    pthread_mutex_unlock(&e->lock);
#endif
}
static void engine_wake(BM_ENGINE *e) {
#ifdef _WIN32
    WakeAllConditionVariable(&e->cond);
#else
    pthread_cond_broadcast(&e->cond);
#endif
}
static void engine_wait(BM_ENGINE *e) {
#ifdef _WIN32
    SleepConditionVariableCS(&e->cond, &e->lock, INFINITE);
#else
    pthread_cond_wait(&e->cond, &e->lock);
#endif
}

static void engine_scan(BM_ENGINE_ARG *a) {
    BM_ENGINE *e = a->engine;
    uint8_t prefix[76], target[32];
    SHA256_CTX base;
    uint64_t generation;

    engine_lock(e);
    memcpy(prefix, e->prefix, 76);
    memcpy(target, e->target, 32);
    generation = e->job_generation;
    engine_unlock(e);

    init(&base);
    update(&base, prefix, 64);

    /* Decode the Bitcoin target once per Stratum job. */
    uint32_t target_words[8];
    for (int i = 0; i < 8; ++i) {
        target_words[i] = (uint32_t)target[i*4] |
                          ((uint32_t)target[i*4+1] << 8) |
                          ((uint32_t)target[i*4+2] << 16) |
                          ((uint32_t)target[i*4+3] << 24);
    }

    for (;;) {
        if (__atomic_load_n(&e->shutdown, __ATOMIC_RELAXED) ||
            __atomic_load_n(&e->stop_job, __ATOMIC_RELAXED) ||
            !__atomic_load_n(&e->job_ready, __ATOMIC_RELAXED) ||
            __atomic_load_n(&e->job_generation, __ATOMIC_RELAXED) != generation) {
            return;
        }

        uint64_t start = __atomic_fetch_add(&e->next_nonce, BM_CHUNK, __ATOMIC_RELAXED);
        if (start >= 0x100000000ULL)
            return;

        uint64_t end = start + BM_CHUNK;
        if (end > 0x100000000ULL) end = 0x100000000ULL;

        uint64_t n = start;
        uint64_t local = 0;
        const uint8_t *tail = prefix + 64;
        const uint32_t tail0 = ((uint32_t)tail[0]<<24)|((uint32_t)tail[1]<<16)|((uint32_t)tail[2]<<8)|tail[3];
        const uint32_t tail1 = ((uint32_t)tail[4]<<24)|((uint32_t)tail[5]<<16)|((uint32_t)tail[6]<<8)|tail[7];
        const uint32_t tail2 = ((uint32_t)tail[8]<<24)|((uint32_t)tail[9]<<16)|((uint32_t)tail[10]<<8)|tail[11];

#if defined(__SSE2__) || defined(_M_X64) || defined(_M_IX86_FP)
#if defined(__AVX2__)
        for (; n + 8 <= end; n += 8) {
            uint32_t nonces[8]={(uint32_t)n,(uint32_t)n+1U,(uint32_t)n+2U,(uint32_t)n+3U,
                                (uint32_t)n+4U,(uint32_t)n+5U,(uint32_t)n+6U,(uint32_t)n+7U};
            uint8_t hits[8];
            sha256_8_hashes(&base,tail0,tail1,tail2,nonces,target_words,hits);
            local += 8;
            for(int lane=0;lane<8;lane++) if(hits[lane]){
                engine_lock(e);
                if(!e->found_valid && !e->stop_job && !e->shutdown){
                    e->found_valid=1;e->found_nonce=nonces[lane];e->stop_job=1;
                }
                engine_unlock(e);
                __atomic_fetch_add(&e->total_hashes,local,__ATOMIC_RELAXED);
                return;
            }
            if((local & 0x3FFFF)==0){
                int stop=__atomic_load_n(&e->stop_job,__ATOMIC_RELAXED) ||
                         __atomic_load_n(&e->shutdown,__ATOMIC_RELAXED) ||
                         !__atomic_load_n(&e->job_ready,__ATOMIC_RELAXED) ||
                         __atomic_load_n(&e->job_generation,__ATOMIC_RELAXED) != generation;
                if(stop){if(local)__atomic_fetch_add(&e->total_hashes,local,__ATOMIC_RELAXED);return;}
            }
        }
#endif
        for (; n + 4 <= end; n += 4) {
            uint32_t nonces[4]={(uint32_t)n,(uint32_t)n+1U,(uint32_t)n+2U,(uint32_t)n+3U};
            uint8_t hits[4];
            sha256_4_hashes(&base,tail0,tail1,tail2,nonces,target_words,hits);
            local += 4;
            for (int lane=0;lane<4;lane++) if (hits[lane]) {
                engine_lock(e);
                if (!e->found_valid && !e->stop_job && !e->shutdown) {
                    e->found_valid=1;
                    e->found_nonce=nonces[lane];
                    e->stop_job=1;
                }
                engine_unlock(e);
                __atomic_fetch_add(&e->total_hashes,local,__ATOMIC_RELAXED);
                return;
            }
            if ((local & 0x3FFFF)==0) {
                int stop=__atomic_load_n(&e->stop_job,__ATOMIC_RELAXED) ||
                         __atomic_load_n(&e->shutdown,__ATOMIC_RELAXED) ||
                         !__atomic_load_n(&e->job_ready,__ATOMIC_RELAXED) ||
                         __atomic_load_n(&e->job_generation,__ATOMIC_RELAXED) != generation;
                if(stop) {
                    if(local) __atomic_fetch_add(&e->total_hashes,local,__ATOMIC_RELAXED);
                    return;
                }
            }
        }
#endif
        for (; n < end; ++n) {
            if (hash_nonce_fast(&base,tail0,tail1,tail2,target,(uint32_t)n)) {
                engine_lock(e);
                if (!e->found_valid && !e->stop_job && !e->shutdown) {
                    e->found_valid=1;
                    e->found_nonce=(uint32_t)n;
                    e->stop_job=1;
                }
                engine_unlock(e);
                __atomic_fetch_add(&e->total_hashes,local+1,__ATOMIC_RELAXED);
                return;
            }
            ++local;
            if ((local & 0x3FFF)==0) {
                int stop=__atomic_load_n(&e->stop_job,__ATOMIC_RELAXED) ||
                         __atomic_load_n(&e->shutdown,__ATOMIC_RELAXED) ||
                         !__atomic_load_n(&e->job_ready,__ATOMIC_RELAXED);
                if(stop) {
                    if(local) __atomic_fetch_add(&e->total_hashes,local,__ATOMIC_RELAXED);
                    return;
                }
            }
        }

        if (local)
            __atomic_fetch_add(&e->total_hashes, local, __ATOMIC_RELAXED);

        if (end >= 0x100000000ULL) {
            __atomic_store_n(&e->stop_job, 1, __ATOMIC_RELAXED);
            return;
        }
    }
}

#ifdef _WIN32
static unsigned __stdcall engine_thread(void *p) {
    BM_ENGINE *e = ((BM_ENGINE_ARG*)p)->engine;
    while (1) {
        engine_lock(e);
        while (!e->shutdown && !e->job_ready)
            engine_wait(e);
        if (e->shutdown) {
            engine_unlock(e);
            return 0;
        }
        engine_unlock(e);

        engine_scan((BM_ENGINE_ARG*)p);

        engine_lock(e);
        while (!e->shutdown && (e->stop_job || !e->job_ready))
            engine_wait(e);
        engine_unlock(e);
    }
}
#else
static void *engine_thread(void *p) {
    BM_ENGINE *e = ((BM_ENGINE_ARG*)p)->engine;
    while (1) {
        engine_lock(e);
        while (!e->shutdown && !e->job_ready)
            engine_wait(e);
        if (e->shutdown) {
            engine_unlock(e);
            return NULL;
        }
        engine_unlock(e);

        engine_scan((BM_ENGINE_ARG*)p);

        engine_lock(e);
        while (!e->shutdown && (e->stop_job || !e->job_ready))
            engine_wait(e);
        engine_unlock(e);
    }
}
#endif

BM_ENGINE *b_m_engine_create(uint32_t thread_count) {
    if (thread_count == 0) thread_count = 1;
    if (thread_count > 64) thread_count = 64;

    BM_ENGINE *e = (BM_ENGINE*)calloc(1, sizeof(BM_ENGINE));
    if (!e) return NULL;
    e->thread_count = thread_count;

#ifdef _WIN32
    InitializeCriticalSection(&e->lock);
    InitializeConditionVariable(&e->cond);
    e->threads = (HANDLE*)calloc(thread_count, sizeof(HANDLE));
#else
    pthread_mutex_init(&e->lock, NULL);
    pthread_cond_init(&e->cond, NULL);
    e->threads = (pthread_t*)calloc(thread_count, sizeof(pthread_t));
#endif
    e->args = (BM_ENGINE_ARG*)calloc(thread_count, sizeof(BM_ENGINE_ARG));

    if (!e->threads || !e->args) {
        free(e->threads); free(e->args);
#ifdef _WIN32
        DeleteCriticalSection(&e->lock);
#else
        pthread_cond_destroy(&e->cond);
        pthread_mutex_destroy(&e->lock);
#endif
        free(e);
        return NULL;
    }

    for (uint32_t i = 0; i < thread_count; ++i) {
        e->args[i].engine = e;
        e->args[i].id = i;
#ifdef _WIN32
        uintptr_t h = _beginthreadex(NULL, 0, engine_thread, &e->args[i], 0, NULL);
        if (!h) {
            engine_lock(e); e->shutdown = 1; engine_wake(e); engine_unlock(e);
            for (uint32_t j = 0; j < i; ++j) {
                WaitForSingleObject(e->threads[j], INFINITE);
                CloseHandle(e->threads[j]);
            }
            free(e->threads); free(e->args);
            DeleteCriticalSection(&e->lock);
            free(e);
            return NULL;
        }
        e->threads[i] = (HANDLE)h;
#else
        if (pthread_create(&e->threads[i], NULL, engine_thread, &e->args[i]) != 0) {
            engine_lock(e); e->shutdown = 1; engine_wake(e); engine_unlock(e);
            for (uint32_t j = 0; j < i; ++j) pthread_join(e->threads[j], NULL);
            free(e->threads); free(e->args);
            pthread_cond_destroy(&e->cond);
            pthread_mutex_destroy(&e->lock);
            free(e);
            return NULL;
        }
#endif
    }
    return e;
}

int b_m_engine_set_job(BM_ENGINE *e, const uint8_t prefix[76], const uint8_t target[32]) {
    if (!e) return 0;
    engine_lock(e);
    memcpy(e->prefix, prefix, 76);
    memcpy(e->target, target, 32);
    e->job_generation++;
    e->next_nonce = 0;
    e->total_hashes = 0;
    e->found_valid = 0;
    e->found_nonce = 0;
    e->stop_job = 0;
    e->job_ready = 1;
    engine_wake(e);
    engine_unlock(e);
    return 1;
}

int b_m_engine_poll(BM_ENGINE *e, uint32_t *found, uint64_t *hashes) {
    if (!e || !found || !hashes) return 0;
    *hashes = __atomic_exchange_n(&e->total_hashes, 0, __ATOMIC_RELAXED);
    engine_lock(e);
    int hit = e->found_valid;
    if (hit) *found = e->found_nonce;
    engine_unlock(e);
    return hit;
}

void b_m_engine_stop_job(BM_ENGINE *e) {
    if (!e) return;
    engine_lock(e);
    e->stop_job = 1;
    e->job_ready = 0;
    engine_wake(e);
    engine_unlock(e);
}

void b_m_engine_destroy(BM_ENGINE *e) {
    if (!e) return;
    engine_lock(e);
    e->shutdown = 1;
    e->job_ready = 0;
    e->stop_job = 1;
    engine_wake(e);
    engine_unlock(e);

#ifdef _WIN32
    for (uint32_t i = 0; i < e->thread_count; ++i) {
        WaitForSingleObject(e->threads[i], INFINITE);
        CloseHandle(e->threads[i]);
    }
    DeleteCriticalSection(&e->lock);
#else
    for (uint32_t i = 0; i < e->thread_count; ++i)
        pthread_join(e->threads[i], NULL);
    pthread_cond_destroy(&e->cond);
    pthread_mutex_destroy(&e->lock);
#endif
    free(e->threads);
    free(e->args);
    free(e);
}


/* Persistent-engine integration self-test.
 * Returns 0 on success, 1 on create/set-job failure, 2 on timeout,
 * 3 if the engine reports a wrong nonce. */
int b_m_engine_selftest(void) {
    uint8_t prefix[76], target[32];
    const uint32_t expected_nonce = 0;
    for (int i=0;i<76;i++) prefix[i]=(uint8_t)i;
    /* Every nonce is valid. The engine must therefore report the first
     * nonce (zero), which also avoids racing a worker by modifying its
     * private scan cursor after set_job(). Target comparison itself is
     * covered by b_m_selftest(). */
    memset(target, 0xff, sizeof(target));

    BM_ENGINE *e = b_m_engine_create(1);
    if (!e) return 1;
    if (!b_m_engine_set_job(e, prefix, target)) {
        b_m_engine_destroy(e);
        return 1;
    }


    uint32_t found = 0;
    uint64_t hashes = 0;
    int result = 2;
    for (int i=0; i<200; ++i) {
        if (b_m_engine_poll(e, &found, &hashes)) {
            result = (found == expected_nonce) ? 0 : 3;
            break;
        }
#ifdef _WIN32
        Sleep(1);
#else
        struct timespec ts = {0, 1000000L};
        nanosleep(&ts, NULL);
#endif
    }
    b_m_engine_destroy(e);
    return result;
}

/* Built-in correctness self-test.
 * Return codes identify the failing optimized path:
 * 1 = SHA256d/fast path, 2 = SSE2 path, 3 = AVX2 path. */
int b_m_selftest(void) {
    uint8_t prefix[76], target[32], header[80], d1[32], expected[32];
    const uint32_t nonce = 0x12345678U;
    static const uint8_t expected_digest[32] = {
        0xb9,0x5e,0x5a,0x66,0x20,0x5c,0xb3,0x42,
        0x7c,0x2a,0xb6,0x40,0x0b,0xf8,0xbb,0x52,
        0xbc,0x9f,0x0c,0x86,0x11,0x09,0x33,0x85,
        0x31,0x3f,0x7c,0x2d,0x1a,0xd8,0xd0,0x79
    };

    for (int i = 0; i < 76; ++i) prefix[i] = (uint8_t)i;
    memcpy(header, prefix, 76);
    header[76]=(uint8_t)nonce; header[77]=(uint8_t)(nonce>>8);
    header[78]=(uint8_t)(nonce>>16); header[79]=(uint8_t)(nonce>>24);

    SHA256_CTX base;
    init(&base);
    update(&base, prefix, 64);

    SHA256_CTX a = base;
    update(&a, header + 64, 16);
    final(&a, d1);
    SHA256_CTX b;
    init(&b);
    update(&b, d1, 32);
    final(&b, expected);

    if (memcmp(expected, expected_digest, 32) != 0) return -1;

    memcpy(target, expected, 32);
    uint32_t t0=((uint32_t)prefix[64]<<24)|((uint32_t)prefix[65]<<16)|((uint32_t)prefix[66]<<8)|prefix[67];
    uint32_t t1=((uint32_t)prefix[68]<<24)|((uint32_t)prefix[69]<<16)|((uint32_t)prefix[70]<<8)|prefix[71];
    uint32_t t2=((uint32_t)prefix[72]<<24)|((uint32_t)prefix[73]<<16)|((uint32_t)prefix[74]<<8)|prefix[75];

    if (!hash_nonce_fast(&base, t0, t1, t2, target, nonce)) return 1;

#if defined(__AVX2__)
    {
        uint32_t ns[8]={nonce,nonce+1U,nonce+2U,nonce+3U,nonce+4U,nonce+5U,nonce+6U,nonce+7U};
        uint32_t tw[8]; uint8_t hits[8];
        for(int i=0;i<8;i++) tw[i]=(uint32_t)target[i*4]|((uint32_t)target[i*4+1]<<8)|((uint32_t)target[i*4+2]<<16)|((uint32_t)target[i*4+3]<<24);
        sha256_8_hashes(&base,t0,t1,t2,ns,tw,hits);
        if(!hits[0]) return 3;
    }
#elif defined(__SSE2__) || defined(_M_X64) || defined(_M_IX86_FP)
    {
        uint32_t ns[4]={nonce,nonce+1U,nonce+2U,nonce+3U};
        uint32_t tw[8]; uint8_t hits[4];
        for(int i=0;i<8;i++) tw[i]=(uint32_t)target[i*4]|((uint32_t)target[i*4+1]<<8)|((uint32_t)target[i*4+2]<<16)|((uint32_t)target[i*4+3]<<24);
        sha256_4_hashes(&base,t0,t1,t2,ns,tw,hits);
        if(!hits[0]) return 2;
    }
#endif
    return 0;
}
