
native/libb_m_sha256.so:	file format elf64-littleaarch64

Disassembly of section .text:

0000000000007600 <engine_thread>:
    7600: 6db63bef     	stp	d15, d14, [sp, #-0xa0]!
    7604: 6d0133ed     	stp	d13, d12, [sp, #0x10]
    7608: 6d022beb     	stp	d11, d10, [sp, #0x20]
    760c: 6d0323e9     	stp	d9, d8, [sp, #0x30]
    7610: a9047bfd     	stp	x29, x30, [sp, #0x40]
    7614: a9056ffc     	stp	x28, x27, [sp, #0x50]
    7618: a90667fa     	stp	x26, x25, [sp, #0x60]
    761c: a9075ff8     	stp	x24, x23, [sp, #0x70]
    7620: a90857f6     	stp	x22, x21, [sp, #0x80]
    7624: a9094ff4     	stp	x20, x19, [sp, #0x90]
    7628: d10843ff     	sub	sp, sp, #0x210
    762c: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    7630: 3dc34100     	ldr	q0, [x8, #0xd00]
    7634: 3d803fe0     	str	q0, [sp, #0xf0]
    7638: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    763c: 3dc39500     	ldr	q0, [x8, #0xe50]
    7640: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    7644: 3dc33501     	ldr	q1, [x8, #0xcd0]
    7648: 6f00e402     	movi	v2.2d, #0000000000000000
    764c: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    7650: 3dc33103     	ldr	q3, [x8, #0xcc0]
    7654: 6f00e404     	movi	v4.2d, #0000000000000000
    7658: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    765c: 3dc36105     	ldr	q5, [x8, #0xd80]
    7660: 3d803be5     	str	q5, [sp, #0xe0]
    7664: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    7668: b0ffffc9     	adrp	x9, 0x0 <pthread_mutex_unlock>
    766c: 3dc38105     	ldr	q5, [x8, #0xe00]
    7670: 3d8037e5     	str	q5, [sp, #0xd0]
    7674: 3dc36525     	ldr	q5, [x9, #0xd90]
    7678: 3d8033e5     	str	q5, [sp, #0xc0]
    767c: 4ea01c05     	mov	v5.16b, v0.16b
    7680: ad0483e1     	stp	q1, q0, [sp, #0x90]
    7684: 5e282824     	sha256su0	v4.4s, v1.4s
    7688: 3d8063e4     	str	q4, [sp, #0x180]
    768c: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    7690: 3dc39901     	ldr	q1, [x8, #0xe60]
    7694: 3d806fe1     	str	q1, [sp, #0x1b0]
    7698: 5e282845     	sha256su0	v5.4s, v2.4s
    769c: 3d805fe5     	str	q5, [sp, #0x170]
    76a0: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    76a4: 3dc3bd01     	ldr	q1, [x8, #0xef0]
    76a8: ad038fe1     	stp	q1, q3, [sp, #0x70]
    76ac: 5e282860     	sha256su0	v0.4s, v3.4s
    76b0: 3d807fe0     	str	q0, [sp, #0x1f0]
    76b4: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    76b8: 3dc38500     	ldr	q0, [x8, #0xe10]
    76bc: 3d801be0     	str	q0, [sp, #0x60]
    76c0: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    76c4: 3dc38900     	ldr	q0, [x8, #0xe20]
    76c8: 3d8017e0     	str	q0, [sp, #0x50]
    76cc: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    76d0: 3dc3a900     	ldr	q0, [x8, #0xea0]
    76d4: 3d8013e0     	str	q0, [sp, #0x40]
    76d8: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    76dc: 3dc38d00     	ldr	q0, [x8, #0xe30]
    76e0: 3d800fe0     	str	q0, [sp, #0x30]
    76e4: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    76e8: 3dc35100     	ldr	q0, [x8, #0xd40]
    76ec: 3d800be0     	str	q0, [sp, #0x20]
    76f0: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    76f4: 3dc34900     	ldr	q0, [x8, #0xd20]
    76f8: 3d805be0     	str	q0, [sp, #0x160]
    76fc: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    7700: 3dc36900     	ldr	q0, [x8, #0xda0]
    7704: 3d8057e0     	str	q0, [sp, #0x150]
    7708: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    770c: 3dc33900     	ldr	q0, [x8, #0xce0]
    7710: 3d8053e0     	str	q0, [sp, #0x140]
    7714: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    7718: 3dc36d00     	ldr	q0, [x8, #0xdb0]
    771c: 3d804fe0     	str	q0, [sp, #0x130]
    7720: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    7724: 3dc35500     	ldr	q0, [x8, #0xd50]
    7728: 3d807be0     	str	q0, [sp, #0x1e0]
    772c: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    7730: 3dc39d00     	ldr	q0, [x8, #0xe70]
    7734: 3d804be0     	str	q0, [sp, #0x120]
    7738: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    773c: 3dc3b100     	ldr	q0, [x8, #0xec0]
    7740: 3d802fe0     	str	q0, [sp, #0xb0]
    7744: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    7748: 3dc32900     	ldr	q0, [x8, #0xca0]
    774c: 3d8077e0     	str	q0, [sp, #0x1d0]
    7750: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    7754: 3dc35900     	ldr	q0, [x8, #0xd60]
    7758: 3d8047e0     	str	q0, [sp, #0x110]
    775c: b0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    7760: 3dc39100     	ldr	q0, [x8, #0xe40]
    7764: 3d8043e0     	str	q0, [sp, #0x100]
    7768: f90007e0     	str	x0, [sp, #0x8]
    776c: f9400018     	ldr	x24, [x0]
    7770: 91054300     	add	x0, x24, #0x150
    7774: 94000bcb     	bl	0xa6a0 <pthread_mutex_lock@plt>
    7778: b9402f08     	ldr	w8, [x24, #0x2c]
    777c: 35000108     	cbnz	w8, 0x779c <engine_thread+0x19c>
    7780: b9402308     	ldr	w8, [x24, #0x20]
    7784: 350000c8     	cbnz	w8, 0x779c <engine_thread+0x19c>
    7788: 9105e300     	add	x0, x24, #0x178
    778c: 91054301     	add	x1, x24, #0x150
    7790: 94000bc0     	bl	0xa690 <pthread_cond_wait@plt>
    7794: b9402f08     	ldr	w8, [x24, #0x2c]
    7798: 34ffff48     	cbz	w8, 0x7780 <engine_thread+0x180>
    779c: b9402f13     	ldr	w19, [x24, #0x2c]
    77a0: 91054300     	add	x0, x24, #0x150
    77a4: 94000bc7     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    77a8: 35007e33     	cbnz	w19, 0x876c <engine_thread+0x116c>
    77ac: f94007e8     	ldr	x8, [sp, #0x8]
    77b0: f9400119     	ldr	x25, [x8]
    77b4: 91054320     	add	x0, x25, #0x150
    77b8: 94000bba     	bl	0xa6a0 <pthread_mutex_lock@plt>
    77bc: 3cca8320     	ldur	q0, [x25, #0xa8]
    77c0: 3d8073e0     	str	q0, [sp, #0x1c0]
    77c4: 3ccb8321     	ldur	q1, [x25, #0xb8]
    77c8: b9412729     	ldr	w9, [x25, #0x124]
    77cc: b9412b28     	ldr	w8, [x25, #0x128]
    77d0: 2902a3e9     	stp	w9, w8, [sp, #0x14]
    77d4: b9412f28     	ldr	w8, [x25, #0x12c]
    77d8: b9001fe8     	str	w8, [sp, #0x1c]
    77dc: b9413337     	ldr	w23, [x25, #0x130]
    77e0: b9413733     	ldr	w19, [x25, #0x134]
    77e4: b9413b3b     	ldr	w27, [x25, #0x138]
    77e8: b9413f3c     	ldr	w28, [x25, #0x13c]
    77ec: b941433d     	ldr	w29, [x25, #0x140]
    77f0: fd408f20     	ldr	d0, [x25, #0x118]
    77f4: 91048328     	add	x8, x25, #0x120
    77f8: 4d408100     	ld1	{ v0.s }[2], [x8]
    77fc: ad0c87e0     	stp	q0, q1, [sp, #0x190]
    7800: f940073a     	ldr	x26, [x25, #0x8]
    7804: 91054320     	add	x0, x25, #0x150
    7808: 94000bae     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    780c: 3dc03fe0     	ldr	q0, [sp, #0xf0]
    7810: 3dc073e1     	ldr	q1, [sp, #0x1c0]
    7814: 4ea08420     	add	v0.4s, v1.4s, v0.4s
    7818: 3d8083e0     	str	q0, [sp, #0x200]
    781c: b9402f28     	ldr	w8, [x25, #0x2c]
    7820: 35007728     	cbnz	w8, 0x8704 <engine_thread+0x1104>
    7824: b9402728     	ldr	w8, [x25, #0x24]
    7828: 350076e8     	cbnz	w8, 0x8704 <engine_thread+0x1104>
    782c: b9402328     	ldr	w8, [x25, #0x20]
    7830: 340076a8     	cbz	w8, 0x8704 <engine_thread+0x1104>
    7834: f9400728     	ldr	x8, [x25, #0x8]
    7838: eb1a011f     	cmp	x8, x26
    783c: 54007641     	b.ne	0x8704 <engine_thread+0x1104>
    7840: 91004321     	add	x1, x25, #0x10
    7844: 52a00080     	mov	w0, #0x40000            // =262144
    7848: 97fff7d6     	bl	0x57a0 <__aarch64_ldadd8_relax>
    784c: d360fc08     	lsr	x8, x0, #32
    7850: b50075a8     	cbnz	x8, 0x8704 <engine_thread+0x1104>
    7854: 52bfff88     	mov	w8, #-0x40000           // =-262144
    7858: eb08001f     	cmp	x0, x8
    785c: 9a883008     	csel	x8, x0, x8, lo
    7860: 91410108     	add	x8, x8, #0x40, lsl #12  // =0x40000
    7864: 91000409     	add	x9, x0, #0x1
    7868: eb08013f     	cmp	x9, x8
    786c: 54004ca2     	b.hs	0x8200 <engine_thread+0xc00>
    7870: aa1f03f4     	mov	x20, xzr
    7874: aa0003f6     	mov	x22, x0
    7878: ad475bf9     	ldp	q25, q22, [sp, #0xe0]
    787c: ad44d3e8     	ldp	q8, q20, [sp, #0x90]
    7880: 6f00e418     	movi	v24.2d, #0000000000000000
    7884: ad43bfed     	ldp	q13, q15, [sp, #0x70]
    7888: ad466bfd     	ldp	q29, q26, [sp, #0xc0]
    788c: 3dc06ffe     	ldr	q30, [sp, #0x1b0]
    7890: ad42bbe9     	ldp	q9, q14, [sp, #0x50]
    7894: ad41abeb     	ldp	q11, q10, [sp, #0x30]
    7898: 3dc00bf5     	ldr	q21, [sp, #0x20]
    789c: 3dc02ffc     	ldr	q28, [sp, #0xb0]
    78a0: 14000007     	b	0x78bc <engine_thread+0x2bc>
    78a4: 91000ad5     	add	x21, x22, #0x2
    78a8: 91000ec9     	add	x9, x22, #0x3
    78ac: 91000a94     	add	x20, x20, #0x2
    78b0: eb08013f     	cmp	x9, x8
    78b4: aa1503f6     	mov	x22, x21
    78b8: 54004bc2     	b.hs	0x8230 <engine_thread+0xc30>
    78bc: 4ebe1fd3     	mov	v19.16b, v30.16b
    78c0: 910006c9     	add	x9, x22, #0x1
    78c4: ad4cfbe1     	ldp	q1, q30, [sp, #0x190]
    78c8: 4ea11c24     	mov	v4.16b, v1.16b
    78cc: 5ac0092a     	rev	w10, w9
    78d0: 4e1c1d44     	mov	v4.s[3], w10
    78d4: 3dc073fb     	ldr	q27, [sp, #0x1c0]
    78d8: 4ebb1f63     	mov	v3.16b, v27.16b
    78dc: 4eb68480     	add	v0.4s, v4.4s, v22.4s
    78e0: 5e0043c3     	sha256h	q3, q30, v0.4s
    78e4: 4ebe1fc2     	mov	v2.16b, v30.16b
    78e8: 5e005362     	sha256h2	q2, q27, v0.4s
    78ec: 5ac00aca     	rev	w10, w22
    78f0: 4ea11c20     	mov	v0.16b, v1.16b
    78f4: 4e1c1d40     	mov	v0.s[3], w10
    78f8: 4eb68405     	add	v5.4s, v0.4s, v22.4s
    78fc: 4ebb1f66     	mov	v6.16b, v27.16b
    7900: 5e0543c6     	sha256h	q6, q30, v5.4s
    7904: 4ebe1fc1     	mov	v1.16b, v30.16b
    7908: 5e055361     	sha256h2	q1, q27, v5.4s
    790c: 4ea31c65     	mov	v5.16b, v3.16b
    7910: 5e194045     	sha256h	q5, q2, v25.4s
    7914: 5e195062     	sha256h2	q2, q3, v25.4s
    7918: 4ea61cc3     	mov	v3.16b, v6.16b
    791c: 5e194023     	sha256h	q3, q1, v25.4s
    7920: 5e1950c1     	sha256h2	q1, q6, v25.4s
    7924: 4ea51ca6     	mov	v6.16b, v5.16b
    7928: 5e1a4046     	sha256h	q6, q2, v26.4s
    792c: 5e1a50a2     	sha256h2	q2, q5, v26.4s
    7930: 4ea31c65     	mov	v5.16b, v3.16b
    7934: 5e1a4025     	sha256h	q5, q1, v26.4s
    7938: 5e1a5061     	sha256h2	q1, q3, v26.4s
    793c: 5e282a84     	sha256su0	v4.4s, v20.4s
    7940: 5e086304     	sha256su1	v4.4s, v24.4s, v8.4s
    7944: 5e282a80     	sha256su0	v0.4s, v20.4s
    7948: 5e086300     	sha256su1	v0.4s, v24.4s, v8.4s
    794c: 4ea61cd0     	mov	v16.16b, v6.16b
    7950: 5e1d4050     	sha256h	q16, q2, v29.4s
    7954: 5e1d50c2     	sha256h2	q2, q6, v29.4s
    7958: 4ea51cb1     	mov	v17.16b, v5.16b
    795c: 5e1d4031     	sha256h	q17, q1, v29.4s
    7960: 5e1d50a1     	sha256h2	q1, q5, v29.4s
    7964: ad4bdfec     	ldp	q12, q23, [sp, #0x170]
    7968: 4eac1d87     	mov	v7.16b, v12.16b
    796c: 4eb71ee6     	mov	v6.16b, v23.16b
    7970: 4ea81d03     	mov	v3.16b, v8.16b
    7974: 5e006107     	sha256su1	v7.4s, v8.4s, v0.4s
    7978: 4eb38405     	add	v5.4s, v0.4s, v19.4s
    797c: 5e076006     	sha256su1	v6.4s, v0.4s, v7.4s
    7980: 4eb11e32     	mov	v18.16b, v17.16b
    7984: 5e054032     	sha256h	q18, q1, v5.4s
    7988: 5e282803     	sha256su0	v3.4s, v0.4s
    798c: 5e055221     	sha256h2	q1, q17, v5.4s
    7990: 4eb38491     	add	v17.4s, v4.4s, v19.4s
    7994: 5e0660e3     	sha256su1	v3.4s, v7.4s, v6.4s
    7998: 4eb01e05     	mov	v5.16b, v16.16b
    799c: 5e114045     	sha256h	q5, q2, v17.4s
    79a0: 5e2828e0     	sha256su0	v0.4s, v7.4s
    79a4: 5e115202     	sha256h2	q2, q16, v17.4s
    79a8: 4ead84f0     	add	v16.4s, v7.4s, v13.4s
    79ac: 5e0360c0     	sha256su1	v0.4s, v6.4s, v3.4s
    79b0: 4eb21e51     	mov	v17.16b, v18.16b
    79b4: 5e104031     	sha256h	q17, q1, v16.4s
    79b8: 5e2828c7     	sha256su0	v7.4s, v6.4s
    79bc: 5e105241     	sha256h2	q1, q18, v16.4s
    79c0: 4eae84d0     	add	v16.4s, v6.4s, v14.4s
    79c4: 5e006067     	sha256su1	v7.4s, v3.4s, v0.4s
    79c8: 4eb11e32     	mov	v18.16b, v17.16b
    79cc: 5e104032     	sha256h	q18, q1, v16.4s
    79d0: 5e282866     	sha256su0	v6.4s, v3.4s
    79d4: 5e105221     	sha256h2	q1, q17, v16.4s
    79d8: 4ea98470     	add	v16.4s, v3.4s, v9.4s
    79dc: 5e076006     	sha256su1	v6.4s, v0.4s, v7.4s
    79e0: 4eb21e51     	mov	v17.16b, v18.16b
    79e4: 5e104031     	sha256h	q17, q1, v16.4s
    79e8: 5e282803     	sha256su0	v3.4s, v0.4s
    79ec: 5e105241     	sha256h2	q1, q18, v16.4s
    79f0: 4eaa8410     	add	v16.4s, v0.4s, v10.4s
    79f4: 5e0660e3     	sha256su1	v3.4s, v7.4s, v6.4s
    79f8: 4eb11e32     	mov	v18.16b, v17.16b
    79fc: 5e104032     	sha256h	q18, q1, v16.4s
    7a00: 5e2828e0     	sha256su0	v0.4s, v7.4s
    7a04: 5e105221     	sha256h2	q1, q17, v16.4s
    7a08: 4eab84f0     	add	v16.4s, v7.4s, v11.4s
    7a0c: 5e0360c0     	sha256su1	v0.4s, v6.4s, v3.4s
    7a10: 4eb21e51     	mov	v17.16b, v18.16b
    7a14: 5e104031     	sha256h	q17, q1, v16.4s
    7a18: 5e2828c7     	sha256su0	v7.4s, v6.4s
    7a1c: 5e105241     	sha256h2	q1, q18, v16.4s
    7a20: 4eb584d0     	add	v16.4s, v6.4s, v21.4s
    7a24: 5e006067     	sha256su1	v7.4s, v3.4s, v0.4s
    7a28: 4eb11e32     	mov	v18.16b, v17.16b
    7a2c: 5e104032     	sha256h	q18, q1, v16.4s
    7a30: 5e282866     	sha256su0	v6.4s, v3.4s
    7a34: 5e105221     	sha256h2	q1, q17, v16.4s
    7a38: ad4acff6     	ldp	q22, q19, [sp, #0x150]
    7a3c: 4eb38470     	add	v16.4s, v3.4s, v19.4s
    7a40: 5e076006     	sha256su1	v6.4s, v0.4s, v7.4s
    7a44: 5e282803     	sha256su0	v3.4s, v0.4s
    7a48: 5e0660e3     	sha256su1	v3.4s, v7.4s, v6.4s
    7a4c: 4eb21e51     	mov	v17.16b, v18.16b
    7a50: 5e104031     	sha256h	q17, q1, v16.4s
    7a54: 4eb68400     	add	v0.4s, v0.4s, v22.4s
    7a58: 5e105241     	sha256h2	q1, q18, v16.4s
    7a5c: 4eb11e30     	mov	v16.16b, v17.16b
    7a60: 5e004030     	sha256h	q16, q1, v0.4s
    7a64: ad49f7ff     	ldp	q31, q29, [sp, #0x130]
    7a68: 4ebd84e7     	add	v7.4s, v7.4s, v29.4s
    7a6c: 5e005221     	sha256h2	q1, q17, v0.4s
    7a70: 4eb01e00     	mov	v0.16b, v16.16b
    7a74: 5e074020     	sha256h	q0, q1, v7.4s
    7a78: 4ebf84c6     	add	v6.4s, v6.4s, v31.4s
    7a7c: 5e075201     	sha256h2	q1, q16, v7.4s
    7a80: 4ea01c07     	mov	v7.16b, v0.16b
    7a84: 5e064027     	sha256h	q7, q1, v6.4s
    7a88: 3dc07bf0     	ldr	q16, [sp, #0x1e0]
    7a8c: 4eb08463     	add	v3.4s, v3.4s, v16.4s
    7a90: 5e065001     	sha256h2	q1, q0, v6.4s
    7a94: 4ea71cf0     	mov	v16.16b, v7.16b
    7a98: 5e034030     	sha256h	q16, q1, v3.4s
    7a9c: 4ebc1f91     	mov	v17.16b, v28.16b
    7aa0: 5e0350e1     	sha256h2	q1, q7, v3.4s
    7aa4: ad48e3f9     	ldp	q25, q24, [sp, #0x110]
    7aa8: 4eb81f00     	mov	v0.16b, v24.16b
    7aac: 4ebb8606     	add	v6.4s, v16.4s, v27.4s
    7ab0: 4ebe8421     	add	v1.4s, v1.4s, v30.4s
    7ab4: 3dc083e3     	ldr	q3, [sp, #0x200]
    7ab8: 4ea38603     	add	v3.4s, v16.4s, v3.4s
    7abc: 5e034311     	sha256h	q17, q24, v3.4s
    7ac0: 5e282826     	sha256su0	v6.4s, v1.4s
    7ac4: 5e035380     	sha256h2	q0, q28, v3.4s
    7ac8: 3dc077e3     	ldr	q3, [sp, #0x1d0]
    7acc: 4ea38423     	add	v3.4s, v1.4s, v3.4s
    7ad0: 5e0f6286     	sha256su1	v6.4s, v20.4s, v15.4s
    7ad4: 4eb11e27     	mov	v7.16b, v17.16b
    7ad8: 5e034007     	sha256h	q7, q0, v3.4s
    7adc: 5e035220     	sha256h2	q0, q17, v3.4s
    7ae0: 5e282a81     	sha256su0	v1.4s, v20.4s
    7ae4: 5e0661e1     	sha256su1	v1.4s, v15.4s, v6.4s
    7ae8: 4ea71cf0     	mov	v16.16b, v7.16b
    7aec: 5e194010     	sha256h	q16, q0, v25.4s
    7af0: 3dc07ff1     	ldr	q17, [sp, #0x1f0]
    7af4: 5e1950e0     	sha256h2	q0, q7, v25.4s
    7af8: 4eaf1de3     	mov	v3.16b, v15.16b
    7afc: 5e0160d1     	sha256su1	v17.4s, v6.4s, v1.4s
    7b00: 4eb01e07     	mov	v7.16b, v16.16b
    7b04: 3dc043fa     	ldr	q26, [sp, #0x100]
    7b08: 5e1a4007     	sha256h	q7, q0, v26.4s
    7b0c: 3dc06ff2     	ldr	q18, [sp, #0x1b0]
    7b10: 4eb284d2     	add	v18.4s, v6.4s, v18.4s
    7b14: 5e1a5200     	sha256h2	q0, q16, v26.4s
    7b18: 4ea71cf0     	mov	v16.16b, v7.16b
    7b1c: 5e124010     	sha256h	q16, q0, v18.4s
    7b20: 5e2828c3     	sha256su0	v3.4s, v6.4s
    7b24: 5e1250e0     	sha256h2	q0, q7, v18.4s
    7b28: 4ead8427     	add	v7.4s, v1.4s, v13.4s
    7b2c: 5e116023     	sha256su1	v3.4s, v1.4s, v17.4s
    7b30: 4eb01e12     	mov	v18.16b, v16.16b
    7b34: 5e074012     	sha256h	q18, q0, v7.4s
    7b38: 5e282826     	sha256su0	v6.4s, v1.4s
    7b3c: 5e075200     	sha256h2	q0, q16, v7.4s
    7b40: 4eae8627     	add	v7.4s, v17.4s, v14.4s
    7b44: 5e036226     	sha256su1	v6.4s, v17.4s, v3.4s
    7b48: 4eb21e50     	mov	v16.16b, v18.16b
    7b4c: 5e074010     	sha256h	q16, q0, v7.4s
    7b50: 5e282a21     	sha256su0	v1.4s, v17.4s
    7b54: 5e075240     	sha256h2	q0, q18, v7.4s
    7b58: 4ea98467     	add	v7.4s, v3.4s, v9.4s
    7b5c: 5e066061     	sha256su1	v1.4s, v3.4s, v6.4s
    7b60: 4eb01e12     	mov	v18.16b, v16.16b
    7b64: 5e074012     	sha256h	q18, q0, v7.4s
    7b68: 5e282871     	sha256su0	v17.4s, v3.4s
    7b6c: 5e075200     	sha256h2	q0, q16, v7.4s
    7b70: 4eaa84c7     	add	v7.4s, v6.4s, v10.4s
    7b74: 5e0160d1     	sha256su1	v17.4s, v6.4s, v1.4s
    7b78: 4eb21e50     	mov	v16.16b, v18.16b
    7b7c: 5e074010     	sha256h	q16, q0, v7.4s
    7b80: 5e2828c3     	sha256su0	v3.4s, v6.4s
    7b84: 5e075240     	sha256h2	q0, q18, v7.4s
    7b88: 4eab8427     	add	v7.4s, v1.4s, v11.4s
    7b8c: 5e116023     	sha256su1	v3.4s, v1.4s, v17.4s
    7b90: 4eb01e12     	mov	v18.16b, v16.16b
    7b94: 5e074012     	sha256h	q18, q0, v7.4s
    7b98: 5e282826     	sha256su0	v6.4s, v1.4s
    7b9c: 5e075200     	sha256h2	q0, q16, v7.4s
    7ba0: 4eb58627     	add	v7.4s, v17.4s, v21.4s
    7ba4: 5e036226     	sha256su1	v6.4s, v17.4s, v3.4s
    7ba8: 4eb21e50     	mov	v16.16b, v18.16b
    7bac: 5e074010     	sha256h	q16, q0, v7.4s
    7bb0: 5e282a21     	sha256su0	v1.4s, v17.4s
    7bb4: 5e075240     	sha256h2	q0, q18, v7.4s
    7bb8: 4eb38467     	add	v7.4s, v3.4s, v19.4s
    7bbc: 5e066061     	sha256su1	v1.4s, v3.4s, v6.4s
    7bc0: 4eb01e12     	mov	v18.16b, v16.16b
    7bc4: 5e074012     	sha256h	q18, q0, v7.4s
    7bc8: 5e075200     	sha256h2	q0, q16, v7.4s
    7bcc: 4eb684c7     	add	v7.4s, v6.4s, v22.4s
    7bd0: 4eb21e50     	mov	v16.16b, v18.16b
    7bd4: 5e074010     	sha256h	q16, q0, v7.4s
    7bd8: 5e075240     	sha256h2	q0, q18, v7.4s
    7bdc: 4ebd8427     	add	v7.4s, v1.4s, v29.4s
    7be0: 4eb01e12     	mov	v18.16b, v16.16b
    7be4: 5e074012     	sha256h	q18, q0, v7.4s
    7be8: 5e075200     	sha256h2	q0, q16, v7.4s
    7bec: 5e04610c     	sha256su1	v12.4s, v8.4s, v4.4s
    7bf0: 5e282871     	sha256su0	v17.4s, v3.4s
    7bf4: 5e2828c3     	sha256su0	v3.4s, v6.4s
    7bf8: 5e0160d1     	sha256su1	v17.4s, v6.4s, v1.4s
    7bfc: 4ea81d06     	mov	v6.16b, v8.16b
    7c00: 5e0c6097     	sha256su1	v23.4s, v4.4s, v12.4s
    7c04: 5e282886     	sha256su0	v6.4s, v4.4s
    7c08: 5e176186     	sha256su1	v6.4s, v12.4s, v23.4s
    7c0c: 5e116023     	sha256su1	v3.4s, v1.4s, v17.4s
    7c10: 4ebf8631     	add	v17.4s, v17.4s, v31.4s
    7c14: 4eb21e41     	mov	v1.16b, v18.16b
    7c18: 5e114001     	sha256h	q1, q0, v17.4s
    7c1c: 5e282984     	sha256su0	v4.4s, v12.4s
    7c20: 5e115240     	sha256h2	q0, q18, v17.4s
    7c24: 5e0662e4     	sha256su1	v4.4s, v23.4s, v6.4s
    7c28: 4ead8591     	add	v17.4s, v12.4s, v13.4s
    7c2c: 4ea51cb2     	mov	v18.16b, v5.16b
    7c30: 5e114052     	sha256h	q18, q2, v17.4s
    7c34: 5e282aec     	sha256su0	v12.4s, v23.4s
    7c38: 5e1150a2     	sha256h2	q2, q5, v17.4s
    7c3c: 5e0460cc     	sha256su1	v12.4s, v6.4s, v4.4s
    7c40: 4eae86e5     	add	v5.4s, v23.4s, v14.4s
    7c44: 4eb21e51     	mov	v17.16b, v18.16b
    7c48: 5e054051     	sha256h	q17, q2, v5.4s
    7c4c: 5e2828d7     	sha256su0	v23.4s, v6.4s
    7c50: 5e055242     	sha256h2	q2, q18, v5.4s
    7c54: 5e0c6097     	sha256su1	v23.4s, v4.4s, v12.4s
    7c58: 4ea984c5     	add	v5.4s, v6.4s, v9.4s
    7c5c: 4eb11e32     	mov	v18.16b, v17.16b
    7c60: 5e054052     	sha256h	q18, q2, v5.4s
    7c64: 5e282886     	sha256su0	v6.4s, v4.4s
    7c68: 5e055222     	sha256h2	q2, q17, v5.4s
    7c6c: 5e176186     	sha256su1	v6.4s, v12.4s, v23.4s
    7c70: 4eaa8485     	add	v5.4s, v4.4s, v10.4s
    7c74: 4eb21e51     	mov	v17.16b, v18.16b
    7c78: 5e054051     	sha256h	q17, q2, v5.4s
    7c7c: 5e282984     	sha256su0	v4.4s, v12.4s
    7c80: 5e055242     	sha256h2	q2, q18, v5.4s
    7c84: 5e0662e4     	sha256su1	v4.4s, v23.4s, v6.4s
    7c88: 4eab8585     	add	v5.4s, v12.4s, v11.4s
    7c8c: 4eb11e32     	mov	v18.16b, v17.16b
    7c90: 5e054052     	sha256h	q18, q2, v5.4s
    7c94: 5e282aec     	sha256su0	v12.4s, v23.4s
    7c98: 5e055222     	sha256h2	q2, q17, v5.4s
    7c9c: 5e0460cc     	sha256su1	v12.4s, v6.4s, v4.4s
    7ca0: 4eb586e5     	add	v5.4s, v23.4s, v21.4s
    7ca4: 4eb21e51     	mov	v17.16b, v18.16b
    7ca8: 5e054051     	sha256h	q17, q2, v5.4s
    7cac: 5e2828d7     	sha256su0	v23.4s, v6.4s
    7cb0: 5e055242     	sha256h2	q2, q18, v5.4s
    7cb4: 5e0c6097     	sha256su1	v23.4s, v4.4s, v12.4s
    7cb8: 4eb384c5     	add	v5.4s, v6.4s, v19.4s
    7cbc: 4eb11e32     	mov	v18.16b, v17.16b
    7cc0: 5e054052     	sha256h	q18, q2, v5.4s
    7cc4: 5e282886     	sha256su0	v6.4s, v4.4s
    7cc8: 5e055222     	sha256h2	q2, q17, v5.4s
    7ccc: 5e176186     	sha256su1	v6.4s, v12.4s, v23.4s
    7cd0: 4eb68484     	add	v4.4s, v4.4s, v22.4s
    7cd4: 4eb21e45     	mov	v5.16b, v18.16b
    7cd8: 5e044045     	sha256h	q5, q2, v4.4s
    7cdc: 5e045242     	sha256h2	q2, q18, v4.4s
    7ce0: 4ebd8584     	add	v4.4s, v12.4s, v29.4s
    7ce4: 4ea51cb0     	mov	v16.16b, v5.16b
    7ce8: 5e044050     	sha256h	q16, q2, v4.4s
    7cec: 5e0450a2     	sha256h2	q2, q5, v4.4s
    7cf0: 4ebf86e4     	add	v4.4s, v23.4s, v31.4s
    7cf4: 4eb01e05     	mov	v5.16b, v16.16b
    7cf8: 5e044045     	sha256h	q5, q2, v4.4s
    7cfc: 5e045202     	sha256h2	q2, q16, v4.4s
    7d00: 3dc07bf7     	ldr	q23, [sp, #0x1e0]
    7d04: 4eb784c4     	add	v4.4s, v6.4s, v23.4s
    7d08: 4ea51ca6     	mov	v6.16b, v5.16b
    7d0c: 5e044046     	sha256h	q6, q2, v4.4s
    7d10: 5e0450a2     	sha256h2	q2, q5, v4.4s
    7d14: 4ebb84c4     	add	v4.4s, v6.4s, v27.4s
    7d18: 4ebe8445     	add	v5.4s, v2.4s, v30.4s
    7d1c: 3dc083e2     	ldr	q2, [sp, #0x200]
    7d20: 4ea284c6     	add	v6.4s, v6.4s, v2.4s
    7d24: 3dc06ff2     	ldr	q18, [sp, #0x1b0]
    7d28: 5e2828a4     	sha256su0	v4.4s, v5.4s
    7d2c: 4ebc1f87     	mov	v7.16b, v28.16b
    7d30: 5e064307     	sha256h	q7, q24, v6.4s
    7d34: 4eb81f02     	mov	v2.16b, v24.16b
    7d38: 5e065382     	sha256h2	q2, q28, v6.4s
    7d3c: 5e0f6284     	sha256su1	v4.4s, v20.4s, v15.4s
    7d40: 3dc077e6     	ldr	q6, [sp, #0x1d0]
    7d44: 4ea684a6     	add	v6.4s, v5.4s, v6.4s
    7d48: 4ea71cf0     	mov	v16.16b, v7.16b
    7d4c: 5e064050     	sha256h	q16, q2, v6.4s
    7d50: 5e0650e2     	sha256h2	q2, q7, v6.4s
    7d54: 5e282a85     	sha256su0	v5.4s, v20.4s
    7d58: 5e0461e5     	sha256su1	v5.4s, v15.4s, v4.4s
    7d5c: 4eb01e11     	mov	v17.16b, v16.16b
    7d60: 5e194051     	sha256h	q17, q2, v25.4s
    7d64: 5e195202     	sha256h2	q2, q16, v25.4s
    7d68: 3dc07fe7     	ldr	q7, [sp, #0x1f0]
    7d6c: 5e056087     	sha256su1	v7.4s, v4.4s, v5.4s
    7d70: 4eaf1de6     	mov	v6.16b, v15.16b
    7d74: 4eb11e30     	mov	v16.16b, v17.16b
    7d78: 5e1a4050     	sha256h	q16, q2, v26.4s
    7d7c: 5e282886     	sha256su0	v6.4s, v4.4s
    7d80: 5e1a5222     	sha256h2	q2, q17, v26.4s
    7d84: 5e0760a6     	sha256su1	v6.4s, v5.4s, v7.4s
    7d88: 4eb21e5e     	mov	v30.16b, v18.16b
    7d8c: 4eb28491     	add	v17.4s, v4.4s, v18.4s
    7d90: 4eb01e12     	mov	v18.16b, v16.16b
    7d94: 5e114052     	sha256h	q18, q2, v17.4s
    7d98: 5e2828a4     	sha256su0	v4.4s, v5.4s
    7d9c: 5e115202     	sha256h2	q2, q16, v17.4s
    7da0: 5e0660e4     	sha256su1	v4.4s, v7.4s, v6.4s
    7da4: 4ead84b0     	add	v16.4s, v5.4s, v13.4s
    7da8: 4eb21e51     	mov	v17.16b, v18.16b
    7dac: 5e104051     	sha256h	q17, q2, v16.4s
    7db0: 5e2828e5     	sha256su0	v5.4s, v7.4s
    7db4: 5e105242     	sha256h2	q2, q18, v16.4s
    7db8: 5e0460c5     	sha256su1	v5.4s, v6.4s, v4.4s
    7dbc: 4eae84f0     	add	v16.4s, v7.4s, v14.4s
    7dc0: 4eb11e32     	mov	v18.16b, v17.16b
    7dc4: 5e104052     	sha256h	q18, q2, v16.4s
    7dc8: 5e2828c7     	sha256su0	v7.4s, v6.4s
    7dcc: 5e105222     	sha256h2	q2, q17, v16.4s
    7dd0: 5e056087     	sha256su1	v7.4s, v4.4s, v5.4s
    7dd4: 4ea984d0     	add	v16.4s, v6.4s, v9.4s
    7dd8: 4eb21e51     	mov	v17.16b, v18.16b
    7ddc: 5e104051     	sha256h	q17, q2, v16.4s
    7de0: 5e282886     	sha256su0	v6.4s, v4.4s
    7de4: 5e105242     	sha256h2	q2, q18, v16.4s
    7de8: 5e0760a6     	sha256su1	v6.4s, v5.4s, v7.4s
    7dec: 4eaa8490     	add	v16.4s, v4.4s, v10.4s
    7df0: 4eb11e32     	mov	v18.16b, v17.16b
    7df4: 5e104052     	sha256h	q18, q2, v16.4s
    7df8: 5e2828a4     	sha256su0	v4.4s, v5.4s
    7dfc: 5e105222     	sha256h2	q2, q17, v16.4s
    7e00: 5e0660e4     	sha256su1	v4.4s, v7.4s, v6.4s
    7e04: 4eab84b0     	add	v16.4s, v5.4s, v11.4s
    7e08: 4eb21e51     	mov	v17.16b, v18.16b
    7e0c: 5e104051     	sha256h	q17, q2, v16.4s
    7e10: 5e2828e5     	sha256su0	v5.4s, v7.4s
    7e14: 5e105242     	sha256h2	q2, q18, v16.4s
    7e18: 5e0460c5     	sha256su1	v5.4s, v6.4s, v4.4s
    7e1c: 4eb584f0     	add	v16.4s, v7.4s, v21.4s
    7e20: 4eb11e32     	mov	v18.16b, v17.16b
    7e24: 5e104052     	sha256h	q18, q2, v16.4s
    7e28: 5e105222     	sha256h2	q2, q17, v16.4s
    7e2c: 4eb384d0     	add	v16.4s, v6.4s, v19.4s
    7e30: 4eb21e51     	mov	v17.16b, v18.16b
    7e34: 5e104051     	sha256h	q17, q2, v16.4s
    7e38: 5e105242     	sha256h2	q2, q18, v16.4s
    7e3c: 4eb68490     	add	v16.4s, v4.4s, v22.4s
    7e40: 4eb11e32     	mov	v18.16b, v17.16b
    7e44: 5e104052     	sha256h	q18, q2, v16.4s
    7e48: 5e105222     	sha256h2	q2, q17, v16.4s
    7e4c: 4ebd84b0     	add	v16.4s, v5.4s, v29.4s
    7e50: 4eb21e51     	mov	v17.16b, v18.16b
    7e54: 5e104051     	sha256h	q17, q2, v16.4s
    7e58: 5e105242     	sha256h2	q2, q18, v16.4s
    7e5c: 5e2828c7     	sha256su0	v7.4s, v6.4s
    7e60: 5e282886     	sha256su0	v6.4s, v4.4s
    7e64: 5e056087     	sha256su1	v7.4s, v4.4s, v5.4s
    7e68: 5e0760a6     	sha256su1	v6.4s, v5.4s, v7.4s
    7e6c: 4ebf84e7     	add	v7.4s, v7.4s, v31.4s
    7e70: 4eb11e24     	mov	v4.16b, v17.16b
    7e74: 5e074044     	sha256h	q4, q2, v7.4s
    7e78: 4eb78465     	add	v5.4s, v3.4s, v23.4s
    7e7c: 5e075222     	sha256h2	q2, q17, v7.4s
    7e80: 4ea01c03     	mov	v3.16b, v0.16b
    7e84: 5e055023     	sha256h2	q3, q1, v5.4s
    7e88: 4eb88467     	add	v7.4s, v3.4s, v24.4s
    7e8c: 4eb784c3     	add	v3.4s, v6.4s, v23.4s
    7e90: 4ea21c46     	mov	v6.16b, v2.16b
    7e94: 5e035086     	sha256h2	q6, q4, v3.4s
    7e98: 4eb884c6     	add	v6.4s, v6.4s, v24.4s
    7e9c: 0e1c3cea     	mov	w10, v7.s[3]
    7ea0: 5ac0094d     	rev	w13, w10
    7ea4: 0e1c3cca     	mov	w10, v6.s[3]
    7ea8: 5ac0094c     	rev	w12, w10
    7eac: 6b0c03bf     	cmp	w29, w12
    7eb0: 1a9f97ea     	cset	w10, hi
    7eb4: 5a9f214b     	csinv	w11, w10, wzr, hs
    7eb8: 6b0d03bf     	cmp	w29, w13
    7ebc: 1a9f97ea     	cset	w10, hi
    7ec0: 5a9f214a     	csinv	w10, w10, wzr, hs
    7ec4: 54000100     	b.eq	0x7ee4 <engine_thread+0x8e4>
    7ec8: 6b0c03bf     	cmp	w29, w12
    7ecc: 540000c0     	b.eq	0x7ee4 <engine_thread+0x8e4>
    7ed0: ad45f7fc     	ldp	q28, q29, [sp, #0xb0]
    7ed4: ad475bf9     	ldp	q25, q22, [sp, #0xe0]
    7ed8: 6f00e418     	movi	v24.2d, #0000000000000000
    7edc: 3dc037fa     	ldr	q26, [sp, #0xd0]
    7ee0: 140000b8     	b	0x81c0 <engine_thread+0xbc0>
    7ee4: 6b0d03bf     	cmp	w29, w13
    7ee8: ad45f7fc     	ldp	q28, q29, [sp, #0xb0]
    7eec: ad475bf9     	ldp	q25, q22, [sp, #0xe0]
    7ef0: 6f00e418     	movi	v24.2d, #0000000000000000
    7ef4: 3dc037fa     	ldr	q26, [sp, #0xd0]
    7ef8: 54000141     	b.ne	0x7f20 <engine_thread+0x920>
    7efc: 0e143cea     	mov	w10, v7.s[2]
    7f00: 5ac0094a     	rev	w10, w10
    7f04: 6b1c015f     	cmp	w10, w28
    7f08: 540001e2     	b.hs	0x7f44 <engine_thread+0x944>
    7f0c: 5280002a     	mov	w10, #0x1               // =1
    7f10: 6b0c03bf     	cmp	w29, w12
    7f14: 54000261     	b.ne	0x7f60 <engine_thread+0x960>
    7f18: 14000004     	b	0x7f28 <engine_thread+0x928>
    7f1c: d503201f     	nop
    7f20: 6b0c03bf     	cmp	w29, w12
    7f24: 540001e1     	b.ne	0x7f60 <engine_thread+0x960>
    7f28: 0e143ccb     	mov	w11, v6.s[2]
    7f2c: 5ac0096b     	rev	w11, w11
    7f30: 6b1c017f     	cmp	w11, w28
    7f34: 540005c2     	b.hs	0x7fec <engine_thread+0x9ec>
    7f38: 5280002b     	mov	w11, #0x1               // =1
    7f3c: 3500014a     	cbnz	w10, 0x7f64 <engine_thread+0x964>
    7f40: 1400000a     	b	0x7f68 <engine_thread+0x968>
    7f44: 5a9f93ea     	csetm	w10, hi
    7f48: 6b0c03bf     	cmp	w29, w12
    7f4c: 54fffee0     	b.eq	0x7f28 <engine_thread+0x928>
    7f50: d503201f     	nop
    7f54: d503201f     	nop
    7f58: d503201f     	nop
    7f5c: d503201f     	nop
    7f60: 3400004a     	cbz	w10, 0x7f68 <engine_thread+0x968>
    7f64: 350012eb     	cbnz	w11, 0x81c0 <engine_thread+0xbc0>
    7f68: 3400048a     	cbz	w10, 0x7ff8 <engine_thread+0x9f8>
    7f6c: 3400066b     	cbz	w11, 0x8038 <engine_thread+0xa38>
    7f70: 3400004a     	cbz	w10, 0x7f78 <engine_thread+0x978>
    7f74: 3500126b     	cbnz	w11, 0x81c0 <engine_thread+0xbc0>
    7f78: 340004ea     	cbz	w10, 0x8014 <engine_thread+0xa14>
    7f7c: 3400088b     	cbz	w11, 0x808c <engine_thread+0xa8c>
    7f80: 3400004a     	cbz	w10, 0x7f88 <engine_thread+0x988>
    7f84: 350011eb     	cbnz	w11, 0x81c0 <engine_thread+0xbc0>
    7f88: 5e054001     	sha256h	q1, q0, v5.4s
    7f8c: 4ebc8420     	add	v0.4s, v1.4s, v28.4s
    7f90: 3400068a     	cbz	w10, 0x8060 <engine_thread+0xa60>
    7f94: 5e034044     	sha256h	q4, q2, v3.4s
    7f98: 4ebc8481     	add	v1.4s, v4.4s, v28.4s
    7f9c: 34000a4b     	cbz	w11, 0x80e4 <engine_thread+0xae4>
    7fa0: 3400004a     	cbz	w10, 0x7fa8 <engine_thread+0x9a8>
    7fa4: 350010eb     	cbnz	w11, 0x81c0 <engine_thread+0xbc0>
    7fa8: 3400086a     	cbz	w10, 0x80b4 <engine_thread+0xab4>
    7fac: 34000c4b     	cbz	w11, 0x8134 <engine_thread+0xb34>
    7fb0: 3400004a     	cbz	w10, 0x7fb8 <engine_thread+0x9b8>
    7fb4: 3500106b     	cbnz	w11, 0x81c0 <engine_thread+0xbc0>
    7fb8: 34000aaa     	cbz	w10, 0x810c <engine_thread+0xb0c>
    7fbc: 34000e6b     	cbz	w11, 0x8188 <engine_thread+0xb88>
    7fc0: 3400004a     	cbz	w10, 0x7fc8 <engine_thread+0x9c8>
    7fc4: 35000feb     	cbnz	w11, 0x81c0 <engine_thread+0xbc0>
    7fc8: 34000cca     	cbz	w10, 0x8160 <engine_thread+0xb60>
    7fcc: 35000fab     	cbnz	w11, 0x81c0 <engine_thread+0xbc0>
    7fd0: 1e26002b     	fmov	w11, s1
    7fd4: 5ac0096b     	rev	w11, w11
    7fd8: b94017ec     	ldr	w12, [sp, #0x14]
    7fdc: 6b0c017f     	cmp	w11, w12
    7fe0: 54003c03     	b.lo	0x8760 <engine_thread+0x1160>
    7fe4: 5a9f93eb     	csetm	w11, hi
    7fe8: 14000076     	b	0x81c0 <engine_thread+0xbc0>
    7fec: 5a9f93eb     	csetm	w11, hi
    7ff0: 35fffbaa     	cbnz	w10, 0x7f64 <engine_thread+0x964>
    7ff4: 17ffffdd     	b	0x7f68 <engine_thread+0x968>
    7ff8: 0e0c3cea     	mov	w10, v7.s[1]
    7ffc: 5ac0094a     	rev	w10, w10
    8000: 6b1b015f     	cmp	w10, w27
    8004: 54000162     	b.hs	0x8030 <engine_thread+0xa30>
    8008: 5280002a     	mov	w10, #0x1               // =1
    800c: 35fffb2b     	cbnz	w11, 0x7f70 <engine_thread+0x970>
    8010: 1400000a     	b	0x8038 <engine_thread+0xa38>
    8014: 1e2600ea     	fmov	w10, s7
    8018: 5ac0094a     	rev	w10, w10
    801c: 6b13015f     	cmp	w10, w19
    8020: 54000322     	b.hs	0x8084 <engine_thread+0xa84>
    8024: 5280002a     	mov	w10, #0x1               // =1
    8028: 35fffacb     	cbnz	w11, 0x7f80 <engine_thread+0x980>
    802c: 14000018     	b	0x808c <engine_thread+0xa8c>
    8030: 5a9f93ea     	csetm	w10, hi
    8034: 35fff9eb     	cbnz	w11, 0x7f70 <engine_thread+0x970>
    8038: 0e0c3ccb     	mov	w11, v6.s[1]
    803c: 5ac0096b     	rev	w11, w11
    8040: 6b1b017f     	cmp	w11, w27
    8044: 54000082     	b.hs	0x8054 <engine_thread+0xa54>
    8048: 5280002b     	mov	w11, #0x1               // =1
    804c: 35fff94a     	cbnz	w10, 0x7f74 <engine_thread+0x974>
    8050: 17ffffca     	b	0x7f78 <engine_thread+0x978>
    8054: 5a9f93eb     	csetm	w11, hi
    8058: 35fff8ea     	cbnz	w10, 0x7f74 <engine_thread+0x974>
    805c: 17ffffc7     	b	0x7f78 <engine_thread+0x978>
    8060: 0e1c3c0a     	mov	w10, v0.s[3]
    8064: 5ac0094a     	rev	w10, w10
    8068: 6b17015f     	cmp	w10, w23
    806c: 54000342     	b.hs	0x80d4 <engine_thread+0xad4>
    8070: 5280002a     	mov	w10, #0x1               // =1
    8074: 5e034044     	sha256h	q4, q2, v3.4s
    8078: 4ebc8481     	add	v1.4s, v4.4s, v28.4s
    807c: 35fff92b     	cbnz	w11, 0x7fa0 <engine_thread+0x9a0>
    8080: 14000019     	b	0x80e4 <engine_thread+0xae4>
    8084: 5a9f93ea     	csetm	w10, hi
    8088: 35fff7cb     	cbnz	w11, 0x7f80 <engine_thread+0x980>
    808c: 1e2600cb     	fmov	w11, s6
    8090: 5ac0096b     	rev	w11, w11
    8094: 6b13017f     	cmp	w11, w19
    8098: 54000082     	b.hs	0x80a8 <engine_thread+0xaa8>
    809c: 5280002b     	mov	w11, #0x1               // =1
    80a0: 35fff72a     	cbnz	w10, 0x7f84 <engine_thread+0x984>
    80a4: 17ffffb9     	b	0x7f88 <engine_thread+0x988>
    80a8: 5a9f93eb     	csetm	w11, hi
    80ac: 35fff6ca     	cbnz	w10, 0x7f84 <engine_thread+0x984>
    80b0: 17ffffb6     	b	0x7f88 <engine_thread+0x988>
    80b4: 0e143c0a     	mov	w10, v0.s[2]
    80b8: 5ac0094a     	rev	w10, w10
    80bc: b9401fec     	ldr	w12, [sp, #0x1c]
    80c0: 6b0c015f     	cmp	w10, w12
    80c4: 54000342     	b.hs	0x812c <engine_thread+0xb2c>
    80c8: 5280002a     	mov	w10, #0x1               // =1
    80cc: 35fff72b     	cbnz	w11, 0x7fb0 <engine_thread+0x9b0>
    80d0: 14000019     	b	0x8134 <engine_thread+0xb34>
    80d4: 5a9f93ea     	csetm	w10, hi
    80d8: 5e034044     	sha256h	q4, q2, v3.4s
    80dc: 4ebc8481     	add	v1.4s, v4.4s, v28.4s
    80e0: 35fff60b     	cbnz	w11, 0x7fa0 <engine_thread+0x9a0>
    80e4: 0e1c3c2b     	mov	w11, v1.s[3]
    80e8: 5ac0096b     	rev	w11, w11
    80ec: 6b17017f     	cmp	w11, w23
    80f0: 54000082     	b.hs	0x8100 <engine_thread+0xb00>
    80f4: 5280002b     	mov	w11, #0x1               // =1
    80f8: 35fff56a     	cbnz	w10, 0x7fa4 <engine_thread+0x9a4>
    80fc: 17ffffab     	b	0x7fa8 <engine_thread+0x9a8>
    8100: 5a9f93eb     	csetm	w11, hi
    8104: 35fff50a     	cbnz	w10, 0x7fa4 <engine_thread+0x9a4>
    8108: 17ffffa8     	b	0x7fa8 <engine_thread+0x9a8>
    810c: 0e0c3c0a     	mov	w10, v0.s[1]
    8110: 5ac0094a     	rev	w10, w10
    8114: b9401bec     	ldr	w12, [sp, #0x18]
    8118: 6b0c015f     	cmp	w10, w12
    811c: 54000322     	b.hs	0x8180 <engine_thread+0xb80>
    8120: 5280002a     	mov	w10, #0x1               // =1
    8124: 35fff4eb     	cbnz	w11, 0x7fc0 <engine_thread+0x9c0>
    8128: 14000018     	b	0x8188 <engine_thread+0xb88>
    812c: 5a9f93ea     	csetm	w10, hi
    8130: 35fff40b     	cbnz	w11, 0x7fb0 <engine_thread+0x9b0>
    8134: 0e143c2b     	mov	w11, v1.s[2]
    8138: 5ac0096b     	rev	w11, w11
    813c: b9401fec     	ldr	w12, [sp, #0x1c]
    8140: 6b0c017f     	cmp	w11, w12
    8144: 54000082     	b.hs	0x8154 <engine_thread+0xb54>
    8148: 5280002b     	mov	w11, #0x1               // =1
    814c: 35fff34a     	cbnz	w10, 0x7fb4 <engine_thread+0x9b4>
    8150: 17ffff9a     	b	0x7fb8 <engine_thread+0x9b8>
    8154: 5a9f93eb     	csetm	w11, hi
    8158: 35fff2ea     	cbnz	w10, 0x7fb4 <engine_thread+0x9b4>
    815c: 17ffff97     	b	0x7fb8 <engine_thread+0x9b8>
    8160: 1e26000a     	fmov	w10, s0
    8164: 5ac0094a     	rev	w10, w10
    8168: b94017ec     	ldr	w12, [sp, #0x14]
    816c: 6b0c015f     	cmp	w10, w12
    8170: 54000222     	b.hs	0x81b4 <engine_thread+0xbb4>
    8174: 5280002a     	mov	w10, #0x1               // =1
    8178: 3500024b     	cbnz	w11, 0x81c0 <engine_thread+0xbc0>
    817c: 17ffff95     	b	0x7fd0 <engine_thread+0x9d0>
    8180: 5a9f93ea     	csetm	w10, hi
    8184: 35fff1eb     	cbnz	w11, 0x7fc0 <engine_thread+0x9c0>
    8188: 0e0c3c2b     	mov	w11, v1.s[1]
    818c: 5ac0096b     	rev	w11, w11
    8190: b9401bec     	ldr	w12, [sp, #0x18]
    8194: 6b0c017f     	cmp	w11, w12
    8198: 54000082     	b.hs	0x81a8 <engine_thread+0xba8>
    819c: 5280002b     	mov	w11, #0x1               // =1
    81a0: 35fff12a     	cbnz	w10, 0x7fc4 <engine_thread+0x9c4>
    81a4: 17ffff89     	b	0x7fc8 <engine_thread+0x9c8>
    81a8: 5a9f93eb     	csetm	w11, hi
    81ac: 35fff0ca     	cbnz	w10, 0x7fc4 <engine_thread+0x9c4>
    81b0: 17ffff86     	b	0x7fc8 <engine_thread+0x9c8>
    81b4: 5a9f93ea     	csetm	w10, hi
    81b8: 34fff0cb     	cbz	w11, 0x7fd0 <engine_thread+0x9d0>
    81bc: d503201f     	nop
    81c0: 36f8276b     	tbz	w11, #0x1f, 0x86ac <engine_thread+0x10ac>
    81c4: 91000a95     	add	x21, x20, #0x2
    81c8: 36f827ea     	tbz	w10, #0x1f, 0x86c4 <engine_thread+0x10c4>
    81cc: f27f32bf     	tst	x21, #0x3ffe
    81d0: 54ffb6a1     	b.ne	0x78a4 <engine_thread+0x2a4>
    81d4: b9402729     	ldr	w9, [x25, #0x24]
    81d8: 35002649     	cbnz	w9, 0x86a0 <engine_thread+0x10a0>
    81dc: b9402f29     	ldr	w9, [x25, #0x2c]
    81e0: 35002609     	cbnz	w9, 0x86a0 <engine_thread+0x10a0>
    81e4: b9402329     	ldr	w9, [x25, #0x20]
    81e8: 340025c9     	cbz	w9, 0x86a0 <engine_thread+0x10a0>
    81ec: f9400729     	ldr	x9, [x25, #0x8]
    81f0: eb1a013f     	cmp	x9, x26
    81f4: 54ffb580     	b.eq	0x78a4 <engine_thread+0x2a4>
    81f8: 1400012a     	b	0x86a0 <engine_thread+0x10a0>
    81fc: d503201f     	nop
    8200: aa1f03f4     	mov	x20, xzr
    8204: aa0003f5     	mov	x21, x0
    8208: ad475bf9     	ldp	q25, q22, [sp, #0xe0]
    820c: ad44d3e8     	ldp	q8, q20, [sp, #0x90]
    8210: 6f00e418     	movi	v24.2d, #0000000000000000
    8214: ad43bfed     	ldp	q13, q15, [sp, #0x70]
    8218: ad466bfd     	ldp	q29, q26, [sp, #0xc0]
    821c: 3dc06ffe     	ldr	q30, [sp, #0x1b0]
    8220: ad42bbe9     	ldp	q9, q14, [sp, #0x50]
    8224: ad41abeb     	ldp	q11, q10, [sp, #0x30]
    8228: 3dc00bf5     	ldr	q21, [sp, #0x20]
    822c: 3dc02ffc     	ldr	q28, [sp, #0xb0]
    8230: eb0802bf     	cmp	x21, x8
    8234: 54001e42     	b.hs	0x85fc <engine_thread+0xffc>
    8238: 8b140109     	add	x9, x8, x20
    823c: cb150129     	sub	x9, x9, x21
    8240: 14000005     	b	0x8254 <engine_thread+0xc54>
    8244: 91000694     	add	x20, x20, #0x1
    8248: 910006b5     	add	x21, x21, #0x1
    824c: eb15011f     	cmp	x8, x21
    8250: 54001d40     	b.eq	0x85f8 <engine_thread+0xff8>
    8254: 5ac00aaa     	rev	w10, w21
    8258: ad4ccfe1     	ldp	q1, q19, [sp, #0x190]
    825c: 4e1c1d41     	mov	v1.s[3], w10
    8260: 4eb68422     	add	v2.4s, v1.4s, v22.4s
    8264: 3dc073f2     	ldr	q18, [sp, #0x1c0]
    8268: 4eb21e43     	mov	v3.16b, v18.16b
    826c: 5e024263     	sha256h	q3, q19, v2.4s
    8270: 4eb31e60     	mov	v0.16b, v19.16b
    8274: 5e025240     	sha256h2	q0, q18, v2.4s
    8278: 5e282a81     	sha256su0	v1.4s, v20.4s
    827c: 5e086301     	sha256su1	v1.4s, v24.4s, v8.4s
    8280: 4ea31c62     	mov	v2.16b, v3.16b
    8284: 5e194002     	sha256h	q2, q0, v25.4s
    8288: 5e195060     	sha256h2	q0, q3, v25.4s
    828c: ad4b93e3     	ldp	q3, q4, [sp, #0x170]
    8290: 5e016103     	sha256su1	v3.4s, v8.4s, v1.4s
    8294: 4ea21c45     	mov	v5.16b, v2.16b
    8298: 5e1a4005     	sha256h	q5, q0, v26.4s
    829c: 5e1a5040     	sha256h2	q0, q2, v26.4s
    82a0: 5e036024     	sha256su1	v4.4s, v1.4s, v3.4s
    82a4: 4ea81d02     	mov	v2.16b, v8.16b
    82a8: 4ea51ca6     	mov	v6.16b, v5.16b
    82ac: 5e1d4006     	sha256h	q6, q0, v29.4s
    82b0: 5e282822     	sha256su0	v2.4s, v1.4s
    82b4: 5e1d50a0     	sha256h2	q0, q5, v29.4s
    82b8: 5e046062     	sha256su1	v2.4s, v3.4s, v4.4s
    82bc: 4ebe8425     	add	v5.4s, v1.4s, v30.4s
    82c0: 4ea61cc7     	mov	v7.16b, v6.16b
    82c4: 5e054007     	sha256h	q7, q0, v5.4s
    82c8: 5e282861     	sha256su0	v1.4s, v3.4s
    82cc: 5e0550c0     	sha256h2	q0, q6, v5.4s
    82d0: 5e026081     	sha256su1	v1.4s, v4.4s, v2.4s
    82d4: 4ead8465     	add	v5.4s, v3.4s, v13.4s
    82d8: 4ea71ce6     	mov	v6.16b, v7.16b
    82dc: 5e054006     	sha256h	q6, q0, v5.4s
    82e0: 5e282883     	sha256su0	v3.4s, v4.4s
    82e4: 5e0550e0     	sha256h2	q0, q7, v5.4s
    82e8: 5e016043     	sha256su1	v3.4s, v2.4s, v1.4s
    82ec: 4eae8485     	add	v5.4s, v4.4s, v14.4s
    82f0: 4ea61cc7     	mov	v7.16b, v6.16b
    82f4: 5e054007     	sha256h	q7, q0, v5.4s
    82f8: 5e282844     	sha256su0	v4.4s, v2.4s
    82fc: 5e0550c0     	sha256h2	q0, q6, v5.4s
    8300: 5e036024     	sha256su1	v4.4s, v1.4s, v3.4s
    8304: 4ea98445     	add	v5.4s, v2.4s, v9.4s
    8308: 4ea71ce6     	mov	v6.16b, v7.16b
    830c: 5e054006     	sha256h	q6, q0, v5.4s
    8310: 5e282822     	sha256su0	v2.4s, v1.4s
    8314: 5e0550e0     	sha256h2	q0, q7, v5.4s
    8318: 5e046062     	sha256su1	v2.4s, v3.4s, v4.4s
    831c: 4eaa8425     	add	v5.4s, v1.4s, v10.4s
    8320: 4ea61cc7     	mov	v7.16b, v6.16b
    8324: 5e054007     	sha256h	q7, q0, v5.4s
    8328: 5e282861     	sha256su0	v1.4s, v3.4s
    832c: 5e0550c0     	sha256h2	q0, q6, v5.4s
    8330: 5e026081     	sha256su1	v1.4s, v4.4s, v2.4s
    8334: 4eab8465     	add	v5.4s, v3.4s, v11.4s
    8338: 4ea71ce6     	mov	v6.16b, v7.16b
    833c: 5e054006     	sha256h	q6, q0, v5.4s
    8340: 5e282883     	sha256su0	v3.4s, v4.4s
    8344: 5e0550e0     	sha256h2	q0, q7, v5.4s
    8348: 5e016043     	sha256su1	v3.4s, v2.4s, v1.4s
    834c: 4eb58485     	add	v5.4s, v4.4s, v21.4s
    8350: 4ea61cc7     	mov	v7.16b, v6.16b
    8354: 5e054007     	sha256h	q7, q0, v5.4s
    8358: 5e282844     	sha256su0	v4.4s, v2.4s
    835c: 5e0550c0     	sha256h2	q0, q6, v5.4s
    8360: 5e036024     	sha256su1	v4.4s, v1.4s, v3.4s
    8364: ad4adffb     	ldp	q27, q23, [sp, #0x150]
    8368: 4eb78445     	add	v5.4s, v2.4s, v23.4s
    836c: 4ea71ce6     	mov	v6.16b, v7.16b
    8370: 5e054006     	sha256h	q6, q0, v5.4s
    8374: 5e282822     	sha256su0	v2.4s, v1.4s
    8378: 5e0550e0     	sha256h2	q0, q7, v5.4s
    837c: 5e046062     	sha256su1	v2.4s, v3.4s, v4.4s
    8380: 4ebb8421     	add	v1.4s, v1.4s, v27.4s
    8384: 4ea61cc5     	mov	v5.16b, v6.16b
    8388: 5e014005     	sha256h	q5, q0, v1.4s
    838c: 5e0150c0     	sha256h2	q0, q6, v1.4s
    8390: ad49b3f0     	ldp	q16, q12, [sp, #0x130]
    8394: 4eac8461     	add	v1.4s, v3.4s, v12.4s
    8398: 4ea51ca3     	mov	v3.16b, v5.16b
    839c: 5e014003     	sha256h	q3, q0, v1.4s
    83a0: 5e0150a0     	sha256h2	q0, q5, v1.4s
    83a4: 4eb08481     	add	v1.4s, v4.4s, v16.4s
    83a8: 4ea31c64     	mov	v4.16b, v3.16b
    83ac: 5e014004     	sha256h	q4, q0, v1.4s
    83b0: 5e015060     	sha256h2	q0, q3, v1.4s
    83b4: 3dc07bf1     	ldr	q17, [sp, #0x1e0]
    83b8: 4eb18441     	add	v1.4s, v2.4s, v17.4s
    83bc: 4ea41c83     	mov	v3.16b, v4.16b
    83c0: 5e014003     	sha256h	q3, q0, v1.4s
    83c4: 5e015080     	sha256h2	q0, q4, v1.4s
    83c8: 4eb28461     	add	v1.4s, v3.4s, v18.4s
    83cc: 4eb38402     	add	v2.4s, v0.4s, v19.4s
    83d0: 3dc083e0     	ldr	q0, [sp, #0x200]
    83d4: 4ea08463     	add	v3.4s, v3.4s, v0.4s
    83d8: 5e282841     	sha256su0	v1.4s, v2.4s
    83dc: 4ebc1f84     	mov	v4.16b, v28.16b
    83e0: 3dc04bf2     	ldr	q18, [sp, #0x120]
    83e4: 5e034244     	sha256h	q4, q18, v3.4s
    83e8: 4eb21e40     	mov	v0.16b, v18.16b
    83ec: 5e035380     	sha256h2	q0, q28, v3.4s
    83f0: 5e0f6281     	sha256su1	v1.4s, v20.4s, v15.4s
    83f4: 3dc077e3     	ldr	q3, [sp, #0x1d0]
    83f8: 4ea38443     	add	v3.4s, v2.4s, v3.4s
    83fc: 4ea41c85     	mov	v5.16b, v4.16b
    8400: 5e034005     	sha256h	q5, q0, v3.4s
    8404: 5e035080     	sha256h2	q0, q4, v3.4s
    8408: 5e282a82     	sha256su0	v2.4s, v20.4s
    840c: 5e0161e2     	sha256su1	v2.4s, v15.4s, v1.4s
    8410: 4ea51ca6     	mov	v6.16b, v5.16b
    8414: ad480fe7     	ldp	q7, q3, [sp, #0x100]
    8418: 5e034006     	sha256h	q6, q0, v3.4s
    841c: 5e0350a0     	sha256h2	q0, q5, v3.4s
    8420: 3dc07fe4     	ldr	q4, [sp, #0x1f0]
    8424: 5e026024     	sha256su1	v4.4s, v1.4s, v2.4s
    8428: 4eaf1de3     	mov	v3.16b, v15.16b
    842c: 4ea61cc5     	mov	v5.16b, v6.16b
    8430: 5e074005     	sha256h	q5, q0, v7.4s
    8434: 5e282823     	sha256su0	v3.4s, v1.4s
    8438: 5e0750c0     	sha256h2	q0, q6, v7.4s
    843c: 5e046043     	sha256su1	v3.4s, v2.4s, v4.4s
    8440: 4ebe8426     	add	v6.4s, v1.4s, v30.4s
    8444: 4ea51ca7     	mov	v7.16b, v5.16b
    8448: 5e064007     	sha256h	q7, q0, v6.4s
    844c: 5e282841     	sha256su0	v1.4s, v2.4s
    8450: 5e0650a0     	sha256h2	q0, q5, v6.4s
    8454: 5e036081     	sha256su1	v1.4s, v4.4s, v3.4s
    8458: 4ead8445     	add	v5.4s, v2.4s, v13.4s
    845c: 4ea71ce6     	mov	v6.16b, v7.16b
    8460: 5e054006     	sha256h	q6, q0, v5.4s
    8464: 5e282882     	sha256su0	v2.4s, v4.4s
    8468: 5e0550e0     	sha256h2	q0, q7, v5.4s
    846c: 5e016062     	sha256su1	v2.4s, v3.4s, v1.4s
    8470: 4eae8485     	add	v5.4s, v4.4s, v14.4s
    8474: 4ea61cc7     	mov	v7.16b, v6.16b
    8478: 5e054007     	sha256h	q7, q0, v5.4s
    847c: 5e282864     	sha256su0	v4.4s, v3.4s
    8480: 5e0550c0     	sha256h2	q0, q6, v5.4s
    8484: 5e026024     	sha256su1	v4.4s, v1.4s, v2.4s
    8488: 4ea98465     	add	v5.4s, v3.4s, v9.4s
    848c: 4ea71ce6     	mov	v6.16b, v7.16b
    8490: 5e054006     	sha256h	q6, q0, v5.4s
    8494: 5e282823     	sha256su0	v3.4s, v1.4s
    8498: 5e0550e0     	sha256h2	q0, q7, v5.4s
    849c: 5e046043     	sha256su1	v3.4s, v2.4s, v4.4s
    84a0: 4eaa8425     	add	v5.4s, v1.4s, v10.4s
    84a4: 4ea61cc7     	mov	v7.16b, v6.16b
    84a8: 5e054007     	sha256h	q7, q0, v5.4s
    84ac: 5e282841     	sha256su0	v1.4s, v2.4s
    84b0: 5e0550c0     	sha256h2	q0, q6, v5.4s
    84b4: 5e036081     	sha256su1	v1.4s, v4.4s, v3.4s
    84b8: 4eab8445     	add	v5.4s, v2.4s, v11.4s
    84bc: 4ea71ce6     	mov	v6.16b, v7.16b
    84c0: 5e054006     	sha256h	q6, q0, v5.4s
    84c4: 5e282882     	sha256su0	v2.4s, v4.4s
    84c8: 5e0550e0     	sha256h2	q0, q7, v5.4s
    84cc: 5e016062     	sha256su1	v2.4s, v3.4s, v1.4s
    84d0: 4eb58485     	add	v5.4s, v4.4s, v21.4s
    84d4: 4ea61cc7     	mov	v7.16b, v6.16b
    84d8: 5e054007     	sha256h	q7, q0, v5.4s
    84dc: 5e0550c0     	sha256h2	q0, q6, v5.4s
    84e0: 4eb78465     	add	v5.4s, v3.4s, v23.4s
    84e4: 4ea71ce6     	mov	v6.16b, v7.16b
    84e8: 5e054006     	sha256h	q6, q0, v5.4s
    84ec: 5e0550e0     	sha256h2	q0, q7, v5.4s
    84f0: 4ebb8425     	add	v5.4s, v1.4s, v27.4s
    84f4: 4ea61cc7     	mov	v7.16b, v6.16b
    84f8: 5e054007     	sha256h	q7, q0, v5.4s
    84fc: 5e0550c0     	sha256h2	q0, q6, v5.4s
    8500: 4eac8445     	add	v5.4s, v2.4s, v12.4s
    8504: 4ea71ce6     	mov	v6.16b, v7.16b
    8508: 5e054006     	sha256h	q6, q0, v5.4s
    850c: 5e0550e0     	sha256h2	q0, q7, v5.4s
    8510: 5e282864     	sha256su0	v4.4s, v3.4s
    8514: 5e026024     	sha256su1	v4.4s, v1.4s, v2.4s
    8518: 5e282823     	sha256su0	v3.4s, v1.4s
    851c: 5e046043     	sha256su1	v3.4s, v2.4s, v4.4s
    8520: 4eb08482     	add	v2.4s, v4.4s, v16.4s
    8524: 4ea61cc1     	mov	v1.16b, v6.16b
    8528: 5e024001     	sha256h	q1, q0, v2.4s
    852c: 5e0250c0     	sha256h2	q0, q6, v2.4s
    8530: 4eb18462     	add	v2.4s, v3.4s, v17.4s
    8534: 4ea01c03     	mov	v3.16b, v0.16b
    8538: 5e025023     	sha256h2	q3, q1, v2.4s
    853c: 4eb28463     	add	v3.4s, v3.4s, v18.4s
    8540: 0e1c3c6a     	mov	w10, v3.s[3]
    8544: 5ac0094a     	rev	w10, w10
    8548: 6b1d015f     	cmp	w10, w29
    854c: 540008c3     	b.lo	0x8664 <engine_thread+0x1064>
    8550: 54ffe7a8     	b.hi	0x8244 <engine_thread+0xc44>
    8554: 0e143c6a     	mov	w10, v3.s[2]
    8558: 5ac0094a     	rev	w10, w10
    855c: 6b1c015f     	cmp	w10, w28
    8560: 54000823     	b.lo	0x8664 <engine_thread+0x1064>
    8564: 54ffe708     	b.hi	0x8244 <engine_thread+0xc44>
    8568: 0e0c3c6a     	mov	w10, v3.s[1]
    856c: 5ac0094a     	rev	w10, w10
    8570: 6b1b015f     	cmp	w10, w27
    8574: 54000783     	b.lo	0x8664 <engine_thread+0x1064>
    8578: 54ffe668     	b.hi	0x8244 <engine_thread+0xc44>
    857c: 1e26006a     	fmov	w10, s3
    8580: 5ac0094a     	rev	w10, w10
    8584: 6b13015f     	cmp	w10, w19
    8588: 540006e3     	b.lo	0x8664 <engine_thread+0x1064>
    858c: 54ffe5c8     	b.hi	0x8244 <engine_thread+0xc44>
    8590: 5e024001     	sha256h	q1, q0, v2.4s
    8594: 4ebc8420     	add	v0.4s, v1.4s, v28.4s
    8598: 0e1c3c0a     	mov	w10, v0.s[3]
    859c: 5ac0094a     	rev	w10, w10
    85a0: 6b17015f     	cmp	w10, w23
    85a4: 54000603     	b.lo	0x8664 <engine_thread+0x1064>
    85a8: 54ffe4e8     	b.hi	0x8244 <engine_thread+0xc44>
    85ac: 0e143c0a     	mov	w10, v0.s[2]
    85b0: 5ac0094a     	rev	w10, w10
    85b4: b9401feb     	ldr	w11, [sp, #0x1c]
    85b8: 6b0b015f     	cmp	w10, w11
    85bc: 54000543     	b.lo	0x8664 <engine_thread+0x1064>
    85c0: 54ffe428     	b.hi	0x8244 <engine_thread+0xc44>
    85c4: 0e0c3c0a     	mov	w10, v0.s[1]
    85c8: 5ac0094a     	rev	w10, w10
    85cc: b9401beb     	ldr	w11, [sp, #0x18]
    85d0: 6b0b015f     	cmp	w10, w11
    85d4: 54000483     	b.lo	0x8664 <engine_thread+0x1064>
    85d8: 1e26000b     	fmov	w11, s0
    85dc: 5ac0096b     	rev	w11, w11
    85e0: b9401bec     	ldr	w12, [sp, #0x18]
    85e4: 6b0c015f     	cmp	w10, w12
    85e8: b94017ea     	ldr	w10, [sp, #0x14]
    85ec: 7a4a9162     	ccmp	w11, w10, #0x2, ls
    85f0: 54ffe2a8     	b.hi	0x8244 <engine_thread+0xc44>
    85f4: 1400001c     	b	0x8664 <engine_thread+0x1064>
    85f8: aa0903f4     	mov	x20, x9
    85fc: b40000d4     	cbz	x20, 0x8614 <engine_thread+0x1014>
    8600: 91006321     	add	x1, x25, #0x18
    8604: aa0003f5     	mov	x21, x0
    8608: aa1403e0     	mov	x0, x20
    860c: 97fff465     	bl	0x57a0 <__aarch64_ldadd8_relax>
    8610: aa1503e0     	mov	x0, x21
    8614: 52bfff88     	mov	w8, #-0x40000           // =-262144
    8618: eb08001f     	cmp	x0, x8
    861c: 54ff9003     	b.lo	0x781c <engine_thread+0x21c>
    8620: 91054320     	add	x0, x25, #0x150
    8624: 9400081f     	bl	0xa6a0 <pthread_mutex_lock@plt>
    8628: b9403328     	ldr	w8, [x25, #0x30]
    862c: 35000128     	cbnz	w8, 0x8650 <engine_thread+0x1050>
    8630: b9402f28     	ldr	w8, [x25, #0x2c]
    8634: 350000e8     	cbnz	w8, 0x8650 <engine_thread+0x1050>
    8638: f9400728     	ldr	x8, [x25, #0x8]
    863c: eb1a011f     	cmp	x8, x26
    8640: 54000081     	b.ne	0x8650 <engine_thread+0x1050>
    8644: 52800028     	mov	w8, #0x1                // =1
    8648: b9002b28     	str	w8, [x25, #0x28]
    864c: b9002728     	str	w8, [x25, #0x24]
    8650: 9105e320     	add	x0, x25, #0x178
    8654: 94000817     	bl	0xa6b0 <pthread_cond_broadcast@plt>
    8658: 91054320     	add	x0, x25, #0x150
    865c: 94000819     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    8660: 14000029     	b	0x8704 <engine_thread+0x1104>
    8664: 91054320     	add	x0, x25, #0x150
    8668: 9400080e     	bl	0xa6a0 <pthread_mutex_lock@plt>
    866c: b9403328     	ldr	w8, [x25, #0x30]
    8670: 35000108     	cbnz	w8, 0x8690 <engine_thread+0x1090>
    8674: b9402728     	ldr	w8, [x25, #0x24]
    8678: 350000c8     	cbnz	w8, 0x8690 <engine_thread+0x1090>
    867c: b9402f28     	ldr	w8, [x25, #0x2c]
    8680: 35000088     	cbnz	w8, 0x8690 <engine_thread+0x1090>
    8684: 52800028     	mov	w8, #0x1                // =1
    8688: 29065728     	stp	w8, w21, [x25, #0x30]
    868c: b9002728     	str	w8, [x25, #0x24]
    8690: 91054320     	add	x0, x25, #0x150
    8694: 9400080b     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    8698: 91000680     	add	x0, x20, #0x1
    869c: 14000002     	b	0x86a4 <engine_thread+0x10a4>
    86a0: 91000a80     	add	x0, x20, #0x2
    86a4: 91006321     	add	x1, x25, #0x18
    86a8: 14000016     	b	0x8700 <engine_thread+0x1100>
    86ac: 2a2a03e8     	mvn	w8, w10
    86b0: 531f7d08     	lsr	w8, w8, #31
    86b4: 110006c9     	add	w9, w22, #0x1
    86b8: 91000a95     	add	x21, x20, #0x2
    86bc: 7100011f     	cmp	w8, #0x0
    86c0: 1a8912d6     	csel	w22, w22, w9, ne
    86c4: 91054320     	add	x0, x25, #0x150
    86c8: 940007f6     	bl	0xa6a0 <pthread_mutex_lock@plt>
    86cc: b9403328     	ldr	w8, [x25, #0x30]
    86d0: 35000108     	cbnz	w8, 0x86f0 <engine_thread+0x10f0>
    86d4: b9402728     	ldr	w8, [x25, #0x24]
    86d8: 350000c8     	cbnz	w8, 0x86f0 <engine_thread+0x10f0>
    86dc: b9402f28     	ldr	w8, [x25, #0x2c]
    86e0: 35000088     	cbnz	w8, 0x86f0 <engine_thread+0x10f0>
    86e4: 52800028     	mov	w8, #0x1                // =1
    86e8: 29065b28     	stp	w8, w22, [x25, #0x30]
    86ec: b9002728     	str	w8, [x25, #0x24]
    86f0: 91054320     	add	x0, x25, #0x150
    86f4: 940007f3     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    86f8: 91006321     	add	x1, x25, #0x18
    86fc: aa1503e0     	mov	x0, x21
    8700: 97fff428     	bl	0x57a0 <__aarch64_ldadd8_relax>
    8704: 91054300     	add	x0, x24, #0x150
    8708: 940007e6     	bl	0xa6a0 <pthread_mutex_lock@plt>
    870c: 14000008     	b	0x872c <engine_thread+0x112c>
    8710: d503201f     	nop
    8714: d503201f     	nop
    8718: d503201f     	nop
    871c: d503201f     	nop
    8720: 9105e300     	add	x0, x24, #0x178
    8724: 91054301     	add	x1, x24, #0x150
    8728: 940007da     	bl	0xa690 <pthread_cond_wait@plt>
    872c: b9402f08     	ldr	w8, [x24, #0x2c]
    8730: 350000a8     	cbnz	w8, 0x8744 <engine_thread+0x1144>
    8734: b9402708     	ldr	w8, [x24, #0x24]
    8738: 35ffff48     	cbnz	w8, 0x8720 <engine_thread+0x1120>
    873c: b9402308     	ldr	w8, [x24, #0x20]
    8740: 34ffff08     	cbz	w8, 0x8720 <engine_thread+0x1120>
    8744: 91054300     	add	x0, x24, #0x150
    8748: 940007de     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    874c: 91054300     	add	x0, x24, #0x150
    8750: 940007d4     	bl	0xa6a0 <pthread_mutex_lock@plt>
    8754: b9402f08     	ldr	w8, [x24, #0x2c]
    8758: 34ff8148     	cbz	w8, 0x7780 <engine_thread+0x180>
    875c: 17fffc10     	b	0x779c <engine_thread+0x19c>
    8760: 2a2a03e8     	mvn	w8, w10
    8764: 531f7d08     	lsr	w8, w8, #31
    8768: 17ffffd4     	b	0x86b8 <engine_thread+0x10b8>
    876c: aa1f03e0     	mov	x0, xzr
    8770: 910843ff     	add	sp, sp, #0x210
    8774: a9494ff4     	ldp	x20, x19, [sp, #0x90]
    8778: a94857f6     	ldp	x22, x21, [sp, #0x80]
    877c: a9475ff8     	ldp	x24, x23, [sp, #0x70]
    8780: a94667fa     	ldp	x26, x25, [sp, #0x60]
    8784: a9456ffc     	ldp	x28, x27, [sp, #0x50]
    8788: a9447bfd     	ldp	x29, x30, [sp, #0x40]
    878c: 6d4323e9     	ldp	d9, d8, [sp, #0x30]
    8790: 6d422beb     	ldp	d11, d10, [sp, #0x20]
    8794: 6d4133ed     	ldp	d13, d12, [sp, #0x10]
    8798: 6cca3bef     	ldp	d15, d14, [sp], #0xa0
    879c: d65f03c0     	ret
