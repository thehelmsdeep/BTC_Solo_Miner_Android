/* AArch64 SHA-256 compression using ARMv8 Crypto instructions.
 * Arguments: x0 = state[8], x1 = message words[16], x2 = K[64].
 * Compiled only for the ARM64 native engine; the C intrinsic path remains
 * available as a fallback when the compiler target lacks SHA2 support.
 */
#if defined(__aarch64__)
    .arch armv8-a+crypto
    .text
    .p2align 2
    .global b_m_arm_sha256_compress_asm
    .type b_m_arm_sha256_compress_asm, %function
b_m_arm_sha256_compress_asm:
    ldr q0, [x0]
    ldr q1, [x0, #16]
    mov v2.16b, v0.16b
    mov v3.16b, v1.16b
    ldr q4, [x1]
    ldr q5, [x1, #16]
    ldr q6, [x1, #32]
    ldr q7, [x1, #48]
    ldr q16, [x2, #0]
    add v16.4s, v4.4s, v16.4s
    mov v17.16b, v0.16b
    sha256su0 v4.4s, v5.4s
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    sha256su1 v4.4s, v6.4s, v7.4s
    ldr q16, [x2, #16]
    add v16.4s, v5.4s, v16.4s
    mov v17.16b, v0.16b
    sha256su0 v5.4s, v6.4s
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    sha256su1 v5.4s, v7.4s, v4.4s
    ldr q16, [x2, #32]
    add v16.4s, v6.4s, v16.4s
    mov v17.16b, v0.16b
    sha256su0 v6.4s, v7.4s
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    sha256su1 v6.4s, v4.4s, v5.4s
    ldr q16, [x2, #48]
    add v16.4s, v7.4s, v16.4s
    mov v17.16b, v0.16b
    sha256su0 v7.4s, v4.4s
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    sha256su1 v7.4s, v5.4s, v6.4s
    ldr q16, [x2, #64]
    add v16.4s, v4.4s, v16.4s
    mov v17.16b, v0.16b
    sha256su0 v4.4s, v5.4s
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    sha256su1 v4.4s, v6.4s, v7.4s
    ldr q16, [x2, #80]
    add v16.4s, v5.4s, v16.4s
    mov v17.16b, v0.16b
    sha256su0 v5.4s, v6.4s
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    sha256su1 v5.4s, v7.4s, v4.4s
    ldr q16, [x2, #96]
    add v16.4s, v6.4s, v16.4s
    mov v17.16b, v0.16b
    sha256su0 v6.4s, v7.4s
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    sha256su1 v6.4s, v4.4s, v5.4s
    ldr q16, [x2, #112]
    add v16.4s, v7.4s, v16.4s
    mov v17.16b, v0.16b
    sha256su0 v7.4s, v4.4s
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    sha256su1 v7.4s, v5.4s, v6.4s
    ldr q16, [x2, #128]
    add v16.4s, v4.4s, v16.4s
    mov v17.16b, v0.16b
    sha256su0 v4.4s, v5.4s
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    sha256su1 v4.4s, v6.4s, v7.4s
    ldr q16, [x2, #144]
    add v16.4s, v5.4s, v16.4s
    mov v17.16b, v0.16b
    sha256su0 v5.4s, v6.4s
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    sha256su1 v5.4s, v7.4s, v4.4s
    ldr q16, [x2, #160]
    add v16.4s, v6.4s, v16.4s
    mov v17.16b, v0.16b
    sha256su0 v6.4s, v7.4s
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    sha256su1 v6.4s, v4.4s, v5.4s
    ldr q16, [x2, #176]
    add v16.4s, v7.4s, v16.4s
    mov v17.16b, v0.16b
    sha256su0 v7.4s, v4.4s
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    sha256su1 v7.4s, v5.4s, v6.4s
    ldr q16, [x2, #192]
    add v16.4s, v4.4s, v16.4s
    mov v17.16b, v0.16b
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    ldr q16, [x2, #208]
    add v16.4s, v5.4s, v16.4s
    mov v17.16b, v0.16b
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    ldr q16, [x2, #224]
    add v16.4s, v6.4s, v16.4s
    mov v17.16b, v0.16b
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    ldr q16, [x2, #240]
    add v16.4s, v7.4s, v16.4s
    mov v17.16b, v0.16b
    sha256h q0, q1, v16.4s
    sha256h2 q1, q17, v16.4s
    add v0.4s, v0.4s, v2.4s
    add v1.4s, v1.4s, v3.4s
    str q0, [x0]
    str q1, [x0, #16]
    ret
    .size b_m_arm_sha256_compress_asm, .-b_m_arm_sha256_compress_asm
#endif
