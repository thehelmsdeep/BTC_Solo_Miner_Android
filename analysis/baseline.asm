
native/libb_m_sha256.so:	file format elf64-littleaarch64

Disassembly of section .text:

0000000000005740 <__on_dlclose>:
    5740: d503245f     	bti	c
    5744: d503201f     	nop
    5748: 10047ec0     	adr	x0, 0xe720 <__dso_handle>
    574c: 14001399     	b	0xa5b0 <__cxa_finalize@plt>

0000000000005750 <__emutls_unregister_key>:
    5750: d503245f     	bti	c
    5754: d65f03c0     	ret

0000000000005758 <__on_dlclose_late>:
    5758: d503245f     	bti	c
    575c: 17fffffd     	b	0x5750 <__emutls_unregister_key>

0000000000005760 <__atexit_handler_wrapper>:
    5760: d503245f     	bti	c
    5764: b4000060     	cbz	x0, 0x5770 <__atexit_handler_wrapper+0x10>
    5768: aa0003f0     	mov	x16, x0
    576c: d61f0200     	br	x16
    5770: d65f03c0     	ret

0000000000005774 <atexit>:
    5774: d503245f     	bti	c
    5778: aa0003e1     	mov	x1, x0
    577c: d503201f     	nop
    5780: 10ffff00     	adr	x0, 0x5760 <__atexit_handler_wrapper>
    5784: d503201f     	nop
    5788: 10047cc2     	adr	x2, 0xe720 <__dso_handle>
    578c: 1400138d     	b	0xa5c0 <__cxa_atexit@plt>

0000000000005790 <pthread_atfork>:
    5790: d503245f     	bti	c
    5794: d503201f     	nop
    5798: 10047c43     	adr	x3, 0xe720 <__dso_handle>
    579c: 1400138d     	b	0xa5d0 <__register_atfork@plt>

00000000000057a0 <__aarch64_ldadd8_relax>:
    57a0: b0000070     	adrp	x16, 0x12000 <pthread_mutex_unlock+0x12000>
    57a4: 39678210     	ldrb	w16, [x16, #0x9e0]
    57a8: 34000070     	cbz	w16, 0x57b4 <__aarch64_ldadd8_relax+0x14>
    57ac: f8200020     	ldadd	x0, x0, [x1]
    57b0: d65f03c0     	ret
    57b4: aa0003f0     	mov	x16, x0
    57b8: c85f7c20     	ldxr	x0, [x1]
    57bc: 8b100011     	add	x17, x0, x16
    57c0: c80f7c31     	stxr	w15, x17, [x1]
    57c4: 35ffffaf     	cbnz	w15, 0x57b8 <__aarch64_ldadd8_relax+0x18>
    57c8: d65f03c0     	ret

00000000000057cc <init_have_lse_atomics>:
    57cc: d10243ff     	sub	sp, sp, #0x90
    57d0: a9077bfd     	stp	x29, x30, [sp, #0x70]
    57d4: f90043f3     	str	x19, [sp, #0x80]
    57d8: 9101c3fd     	add	x29, sp, #0x70
    57dc: d53bd053     	mrs	x19, TPIDR_EL0
    57e0: 52800200     	mov	w0, #0x10               // =16
    57e4: f9401668     	ldr	x8, [x19, #0x28]
    57e8: f81f83a8     	stur	x8, [x29, #-0x8]
    57ec: 940013bd     	bl	0xa6e0 <getauxval@plt>
    57f0: 37400100     	tbnz	w0, #0x8, 0x5810 <init_have_lse_atomics+0x44>
    57f4: b0000069     	adrp	x9, 0x12000 <pthread_mutex_unlock+0x12000>
    57f8: 3927813f     	strb	wzr, [x9, #0x9e0]
    57fc: f9401668     	ldr	x8, [x19, #0x28]
    5800: f85f83a9     	ldur	x9, [x29, #-0x8]
    5804: eb09011f     	cmp	x8, x9
    5808: 54000460     	b.eq	0x5894 <init_have_lse_atomics+0xc8>
    580c: 1400002d     	b	0x58c0 <init_have_lse_atomics+0xf4>
    5810: d503201f     	nop
    5814: 10fdb7e0     	adr	x0, 0xf10 <pthread_mutex_unlock+0xf10>
    5818: 910033e1     	add	x1, sp, #0xc
    581c: 940013ad     	bl	0xa6d0 <__system_property_get@plt>
    5820: 7100041f     	cmp	w0, #0x1
    5824: 5400040b     	b.lt	0x58a4 <init_have_lse_atomics+0xd8>
    5828: d2872709     	mov	x9, #0x3938             // =14648
    582c: f840c3e8     	ldur	x8, [sp, #0xc]
    5830: f2adee69     	movk	x9, #0x6f73, lsl #16
    5834: f2cf2dc9     	movk	x9, #0x796e, lsl #32
    5838: dac00d08     	rev	x8, x8
    583c: f2ecaf09     	movk	x9, #0x6578, lsl #48
    5840: eb09011f     	cmp	x8, x9
    5844: 54000121     	b.ne	0x5868 <init_have_lse_atomics+0x9c>
    5848: 79402be8     	ldrh	w8, [sp, #0x14]
    584c: 52862609     	mov	w9, #0x3130             // =12592
    5850: 5ac00908     	rev	w8, w8
    5854: 53107d08     	lsr	w8, w8, #16
    5858: 6b09011f     	cmp	w8, w9
    585c: 54000061     	b.ne	0x5868 <init_have_lse_atomics+0x9c>
    5860: 2a1f03e8     	mov	w8, wzr
    5864: 14000004     	b	0x5874 <init_have_lse_atomics+0xa8>
    5868: eb09011f     	cmp	x8, x9
    586c: 12800008     	mov	w8, #-0x1               // =-1
    5870: 5a883508     	cneg	w8, w8, hs
    5874: 7100011f     	cmp	w8, #0x0
    5878: 1a9f07e8     	cset	w8, ne
    587c: b0000069     	adrp	x9, 0x12000 <pthread_mutex_unlock+0x12000>
    5880: 39278128     	strb	w8, [x9, #0x9e0]
    5884: f9401668     	ldr	x8, [x19, #0x28]
    5888: f85f83a9     	ldur	x9, [x29, #-0x8]
    588c: eb09011f     	cmp	x8, x9
    5890: 54000181     	b.ne	0x58c0 <init_have_lse_atomics+0xf4>
    5894: a9477bfd     	ldp	x29, x30, [sp, #0x70]
    5898: f94043f3     	ldr	x19, [sp, #0x80]
    589c: 910243ff     	add	sp, sp, #0x90
    58a0: d65f03c0     	ret
    58a4: 52800028     	mov	w8, #0x1                // =1
    58a8: b0000069     	adrp	x9, 0x12000 <pthread_mutex_unlock+0x12000>
    58ac: 39278128     	strb	w8, [x9, #0x9e0]
    58b0: f9401668     	ldr	x8, [x19, #0x28]
    58b4: f85f83a9     	ldur	x9, [x29, #-0x8]
    58b8: eb09011f     	cmp	x8, x9
    58bc: 54fffec0     	b.eq	0x5894 <init_have_lse_atomics+0xc8>
    58c0: 94001394     	bl	0xa710 <__stack_chk_fail@plt>

00000000000058c4 <__init_cpu_features_resolver>:
    58c4: b0000068     	adrp	x8, 0x12000 <pthread_mutex_unlock+0x12000>
    58c8: b0000049     	adrp	x9, 0xe000 <__stack_chk_fail@plt+0x38f0>
    58cc: f9448529     	ldr	x9, [x9, #0x908]
    58d0: f944f508     	ldr	x8, [x8, #0x9e8]
    58d4: b4000069     	cbz	x9, 0x58e0 <__init_cpu_features_resolver+0x1c>
    58d8: b5000048     	cbnz	x8, 0x58e0 <__init_cpu_features_resolver+0x1c>
    58dc: 14000002     	b	0x58e4 <__init_cpu_features_constructor>
    58e0: d65f03c0     	ret

00000000000058e4 <__init_cpu_features_constructor>:
    58e4: b7f00060     	tbnz	x0, #0x3e, 0x58f0 <__init_cpu_features_constructor+0xc>
    58e8: aa1f03e8     	mov	x8, xzr
    58ec: 14000002     	b	0x58f4 <__init_cpu_features_constructor+0x10>
    58f0: f9400828     	ldr	x8, [x1, #0x10]
    58f4: f81b0ffb     	str	x27, [sp, #-0x50]!
    58f8: a90167fa     	stp	x26, x25, [sp, #0x10]
    58fc: a9025ff8     	stp	x24, x23, [sp, #0x20]
    5900: a90357f6     	stp	x22, x21, [sp, #0x30]
    5904: a9044ff4     	stp	x20, x19, [sp, #0x40]
    5908: 4e080d00     	dup	v0.2d, x8
    590c: f0ffffca     	adrp	x10, 0x0 <pthread_mutex_unlock>
    5910: f0ffffc9     	adrp	x9, 0x0 <pthread_mutex_unlock>
    5914: 3dc3ad41     	ldr	q1, [x10, #0xeb0]
    5918: f0ffffcb     	adrp	x11, 0x0 <pthread_mutex_unlock>
    591c: f0ffffcc     	adrp	x12, 0x0 <pthread_mutex_unlock>
    5920: f0ffffd0     	adrp	x16, 0x0 <pthread_mutex_unlock>
    5924: d373c90d     	lsl	x13, x8, #13
    5928: 3dc3a582     	ldr	q2, [x12, #0xe90]
    592c: 6ee14401     	ushl	v1.2d, v0.2d, v1.2d
    5930: 3dc37563     	ldr	q3, [x11, #0xdd0]
    5934: 3dc37d24     	ldr	q4, [x9, #0xdf0]
    5938: 3dc37206     	ldr	q6, [x16, #0xdc0]
    593c: f0ffffce     	adrp	x14, 0x0 <pthread_mutex_unlock>
    5940: f0ffffcf     	adrp	x15, 0x0 <pthread_mutex_unlock>
    5944: f0ffffcc     	adrp	x12, 0x0 <pthread_mutex_unlock>
    5948: 6ee24402     	ushl	v2.2d, v0.2d, v2.2d
    594c: 6ee34403     	ushl	v3.2d, v0.2d, v3.2d
    5950: 4e180427     	dup	v7.2d, v1.d[1]
    5954: 6ee44400     	ushl	v0.2d, v0.2d, v4.2d
    5958: 4e261c21     	and	v1.16b, v1.16b, v6.16b
    595c: 9e6701a6     	fmov	d6, x13
    5960: 3dc37985     	ldr	q5, [x12, #0xde0]
    5964: 3dc3a1d0     	ldr	q16, [x14, #0xe80]
    5968: 3dc325e4     	ldr	q4, [x15, #0xc90]
    596c: d350fd0a     	lsr	x10, x8, #16
    5970: f0ffffc9     	adrp	x9, 0x0 <pthread_mutex_unlock>
    5974: 4e251c45     	and	v5.16b, v2.16b, v5.16b
    5978: d350fc11     	lsr	x17, x0, #16
    597c: d37df002     	lsl	x2, x0, #3
    5980: 6e184446     	mov	v6.d[1], v2.d[1]
    5984: 4e301c62     	and	v2.16b, v3.16b, v16.16b
    5988: 4e241c00     	and	v0.16b, v0.16b, v4.16b
    598c: 4e181d47     	mov	v7.d[1], x10
    5990: f0ffffca     	adrp	x10, 0x0 <pthread_mutex_unlock>
    5994: 3dc3b923     	ldr	q3, [x9, #0xee0]
    5998: 4ea51c21     	orr	v1.16b, v1.16b, v5.16b
    599c: 3dc34544     	ldr	q4, [x10, #0xd10]
    59a0: d35afc04     	lsr	x4, x0, #26
    59a4: 4ea21c00     	orr	v0.16b, v0.16b, v2.16b
    59a8: d345fd05     	lsr	x5, x8, #5
    59ac: d34efc06     	lsr	x6, x0, #14
    59b0: 4e231cc2     	and	v2.16b, v6.16b, v3.16b
    59b4: d379e013     	lsl	x19, x0, #7
    59b8: d34efd09     	lsr	x9, x8, #14
    59bc: 4e241ce3     	and	v3.16b, v7.16b, v4.16b
    59c0: d36efd0d     	lsr	x13, x8, #46
    59c4: d352fd01     	lsr	x1, x8, #18
    59c8: 4ea11c00     	orr	v0.16b, v0.16b, v1.16b
    59cc: d36ba814     	lsl	x20, x0, #21
    59d0: d35d710e     	lsl	x14, x8, #35
    59d4: d357fd16     	lsr	x22, x8, #23
    59d8: 92760048     	and	x8, x2, #0x400
    59dc: 927f0082     	and	x2, x4, #0x2
    59e0: 4ea21c61     	orr	v1.16b, v3.16b, v2.16b
    59e4: 927e00a4     	and	x4, x5, #0x4
    59e8: 927b00c5     	and	x5, x6, #0x20
    59ec: 6e004002     	ext	v2.16b, v0.16b, v0.16b, #0x8
    59f0: 927c0226     	and	x6, x17, #0x10
    59f4: d35dfc0c     	lsr	x12, x0, #29
    59f8: d354fc07     	lsr	x7, x0, #20
    59fc: 926c0678     	and	x24, x19, #0x300000
    5a00: aa0600a5     	orr	x5, x5, x6
    5a04: 6e014023     	ext	v3.16b, v1.16b, v1.16b, #0x8
    5a08: 926a0266     	and	x6, x19, #0x400000
    5a0c: d343fc13     	lsr	x19, x0, #3
    5a10: d349fc10     	lsr	x16, x0, #9
    5a14: d346fc0f     	lsr	x15, x0, #6
    5a18: d347fc03     	lsr	x3, x0, #7
    5a1c: 0ea21c00     	orr	v0.8b, v0.8b, v2.8b
    5a20: d341fc15     	lsr	x21, x0, #1
    5a24: 924f0294     	and	x20, x20, #0x2000000000000
    5a28: b36e0226     	bfi	x6, x17, #18, #1
    5a2c: d356fc0a     	lsr	x10, x0, #22
    5a30: d344fc0b     	lsr	x11, x0, #4
    5a34: 927d00e7     	and	x7, x7, #0x8
    5a38: 0ea31c21     	orr	v1.8b, v1.8b, v3.8b
    5a3c: b3520194     	bfi	x20, x12, #46, #1
    5a40: 9269026c     	and	x12, x19, #0x800000
    5a44: 926f0063     	and	x3, x3, #0x20000
    5a48: 927a01f7     	and	x23, x15, #0x40
    5a4c: 927902b5     	and	x21, x21, #0x80
    5a50: 9e66001a     	fmov	x26, d0
    5a54: b3700207     	bfi	x7, x16, #16, #1
    5a58: b37401f8     	bfi	x24, x15, #12, #1
    5a5c: aa0c00cc     	orr	x12, x6, x12
    5a60: 925a0dd9     	and	x25, x14, #0x3c000000000
    5a64: b3710162     	bfi	x2, x11, #15, #1
    5a68: aa170070     	orr	x16, x3, x23
    5a6c: aa0402af     	orr	x15, x21, x4
    5a70: b362014c     	bfi	x12, x10, #30, #1
    5a74: 927502d6     	and	x22, x22, #0x800
    5a78: 9e66003b     	fmov	x27, d1
    5a7c: b3540039     	bfi	x25, x1, #44, #1
    5a80: aa0700a1     	orr	x1, x5, x7
    5a84: aa18020a     	orr	x10, x16, x24
    5a88: aa0f028f     	orr	x15, x20, x15
    5a8c: 9273016b     	and	x11, x11, #0x2000
    5a90: aa1a02d1     	orr	x17, x22, x26
    5a94: aa010050     	orr	x16, x2, x1
    5a98: aa0f014a     	orr	x10, x10, x15
    5a9c: aa0b018b     	orr	x11, x12, x11
    5aa0: aa11032c     	orr	x12, x25, x17
    5aa4: aa0a020a     	orr	x10, x16, x10
    5aa8: b34601ab     	bfi	x11, x13, #58, #1
    5aac: aa080368     	orr	x8, x27, x8
    5ab0: aa0c014a     	orr	x10, x10, x12
    5ab4: f240001f     	tst	x0, #0x1
    5ab8: aa0a0108     	orr	x8, x8, x10
    5abc: b365012b     	bfi	x11, x9, #27, #1
    5ac0: 925c01ca     	and	x10, x14, #0x1000000000
    5ac4: b2780509     	orr	x9, x8, #0x300
    5ac8: 9a890108     	csel	x8, x8, x9, eq
    5acc: aa0a0169     	orr	x9, x11, x10
    5ad0: aa080128     	orr	x8, x9, x8
    5ad4: b0000069     	adrp	x9, 0x12000 <pthread_mutex_unlock+0x12000>
    5ad8: b2410108     	orr	x8, x8, #0x8000000000000000
    5adc: f904f528     	str	x8, [x9, #0x9e8]
    5ae0: a9444ff4     	ldp	x20, x19, [sp, #0x40]
    5ae4: a94357f6     	ldp	x22, x21, [sp, #0x30]
    5ae8: a9425ff8     	ldp	x24, x23, [sp, #0x20]
    5aec: a94167fa     	ldp	x26, x25, [sp, #0x10]
    5af0: f84507fb     	ldr	x27, [sp], #0x50
    5af4: d65f03c0     	ret

0000000000005af8 <__init_cpu_features>:
    5af8: d10243ff     	sub	sp, sp, #0x90
    5afc: a9077bfd     	stp	x29, x30, [sp, #0x70]
    5b00: a9084ff4     	stp	x20, x19, [sp, #0x80]
    5b04: 9101c3fd     	add	x29, sp, #0x70
    5b08: d53bd054     	mrs	x20, TPIDR_EL0
    5b0c: f9401688     	ldr	x8, [x20, #0x28]
    5b10: f81f83a8     	stur	x8, [x29, #-0x8]
    5b14: b0000068     	adrp	x8, 0x12000 <pthread_mutex_unlock+0x12000>
    5b18: f944f508     	ldr	x8, [x8, #0x9e8]
    5b1c: b5000388     	cbnz	x8, 0x5b8c <__init_cpu_features+0x94>
    5b20: d503201f     	nop
    5b24: 10fd9f60     	adr	x0, 0xf10 <pthread_mutex_unlock+0xf10>
    5b28: 910023e1     	add	x1, sp, #0x8
    5b2c: 940012e9     	bl	0xa6d0 <__system_property_get@plt>
    5b30: 7100001f     	cmp	w0, #0x0
    5b34: 5400016d     	b.le	0x5b60 <__init_cpu_features+0x68>
    5b38: d28f0caa     	mov	x10, #0x7865            // =30821
    5b3c: f94007e8     	ldr	x8, [sp, #0x8]
    5b40: 794023e9     	ldrh	w9, [sp, #0x10]
    5b44: f2adcf2a     	movk	x10, #0x6e79, lsl #16
    5b48: f2ce6dea     	movk	x10, #0x736f, lsl #32
    5b4c: f2e7072a     	movk	x10, #0x3839, lsl #48
    5b50: eb0a011f     	cmp	x8, x10
    5b54: 52860628     	mov	w8, #0x3031             // =12337
    5b58: 7a480120     	ccmp	w9, w8, #0x0, eq
    5b5c: 54000180     	b.eq	0x5b8c <__init_cpu_features+0x94>
    5b60: 52800200     	mov	w0, #0x10               // =16
    5b64: 940012df     	bl	0xa6e0 <getauxval@plt>
    5b68: aa0003f3     	mov	x19, x0
    5b6c: 52800340     	mov	w0, #0x1a               // =26
    5b70: 940012dc     	bl	0xa6e0 <getauxval@plt>
    5b74: 52800308     	mov	w8, #0x18               // =24
    5b78: f9000fe0     	str	x0, [sp, #0x18]
    5b7c: b2420260     	orr	x0, x19, #0x4000000000000000
    5b80: 910023e1     	add	x1, sp, #0x8
    5b84: a900cfe8     	stp	x8, x19, [sp, #0x8]
    5b88: 97ffff57     	bl	0x58e4 <__init_cpu_features_constructor>
    5b8c: f9401688     	ldr	x8, [x20, #0x28]
    5b90: f85f83a9     	ldur	x9, [x29, #-0x8]
    5b94: eb09011f     	cmp	x8, x9
    5b98: 540000a1     	b.ne	0x5bac <__init_cpu_features+0xb4>
    5b9c: a9484ff4     	ldp	x20, x19, [sp, #0x80]
    5ba0: a9477bfd     	ldp	x29, x30, [sp, #0x70]
    5ba4: 910243ff     	add	sp, sp, #0x90
    5ba8: d65f03c0     	ret
    5bac: 940012d9     	bl	0xa710 <__stack_chk_fail@plt>

0000000000005bb0 <__aarch64_cas4_acq_rel>:
    5bb0: b0000070     	adrp	x16, 0x12000 <pthread_mutex_unlock+0x12000>
    5bb4: 39678210     	ldrb	w16, [x16, #0x9e0]
    5bb8: 34000070     	cbz	w16, 0x5bc4 <__aarch64_cas4_acq_rel+0x14>
    5bbc: 88e0fc41     	casal	w0, w1, [x2]
    5bc0: d65f03c0     	ret
    5bc4: 2a0003f0     	mov	w16, w0
    5bc8: 885ffc40     	ldaxr	w0, [x2]
    5bcc: 6b10001f     	cmp	w0, w16
    5bd0: 54000061     	b.ne	0x5bdc <__aarch64_cas4_acq_rel+0x2c>
    5bd4: 8811fc41     	stlxr	w17, w1, [x2]
    5bd8: 35ffff91     	cbnz	w17, 0x5bc8 <__aarch64_cas4_acq_rel+0x18>
    5bdc: d65f03c0     	ret

0000000000005be0 <__aarch64_swp8_relax>:
    5be0: b0000070     	adrp	x16, 0x12000 <pthread_mutex_unlock+0x12000>
    5be4: 39678210     	ldrb	w16, [x16, #0x9e0]
    5be8: 34000070     	cbz	w16, 0x5bf4 <__aarch64_swp8_relax+0x14>
    5bec: f8208020     	swp	x0, x0, [x1]
    5bf0: d65f03c0     	ret
    5bf4: aa0003f0     	mov	x16, x0
    5bf8: c85f7c20     	ldxr	x0, [x1]
    5bfc: c8117c30     	stxr	w17, x16, [x1]
    5c00: 35ffffd1     	cbnz	w17, 0x5bf8 <__aarch64_swp8_relax+0x18>
    5c04: d65f03c0     	ret
		...

0000000000005c20 <b_m_mine>:
    5c20: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
    5c24: a9016ffc     	stp	x28, x27, [sp, #0x10]
    5c28: a90267fa     	stp	x26, x25, [sp, #0x20]
    5c2c: a9035ff8     	stp	x24, x23, [sp, #0x30]
    5c30: a90457f6     	stp	x22, x21, [sp, #0x40]
    5c34: a9054ff4     	stp	x20, x19, [sp, #0x50]
    5c38: d10843ff     	sub	sp, sp, #0x210
    5c3c: a9011be5     	stp	x5, x6, [sp, #0x10]
    5c40: aa0403f8     	mov	x24, x4
    5c44: 2a0303f7     	mov	w23, w3
    5c48: 2a0203f6     	mov	w22, w2
    5c4c: f90027e1     	str	x1, [sp, #0x48]
    5c50: ad408001     	ldp	q1, q0, [x0, #0x10]
    5c54: ad410803     	ldp	q3, q2, [x0, #0x20]
    5c58: ad0f0be0     	stp	q0, q2, [sp, #0x1e0]
    5c5c: 9104c3e8     	add	x8, sp, #0x130
    5c60: 3cc3c000     	ldur	q0, [x0, #0x3c]
    5c64: 3c8cc100     	stur	q0, [x8, #0xcc]
    5c68: ad400800     	ldp	q0, q2, [x0]
    5c6c: 3dc00004     	ldr	q4, [x0]
    5c70: ad0e0be0     	stp	q0, q2, [sp, #0x1c0]
    5c74: d503201f     	nop
    5c78: 10fd9829     	adr	x9, 0xf7c <init.h>
    5c7c: 3c828104     	stur	q4, [x8, #0x28]
    5c80: 3c838101     	stur	q1, [x8, #0x38]
    5c84: ad400520     	ldp	q0, q1, [x9]
    5c88: ad0103e1     	stp	q1, q0, [sp, #0x20]
    5c8c: ad0987e0     	stp	q0, q1, [sp, #0x130]
    5c90: 3c848103     	stur	q3, [x8, #0x48]
    5c94: 3dc00c00     	ldr	q0, [x0, #0x30]
    5c98: 52800819     	mov	w25, #0x40              // =64
    5c9c: 52804009     	mov	w9, #0x200              // =512
    5ca0: f900cff9     	str	x25, [sp, #0x198]
    5ca4: f900abe9     	str	x9, [sp, #0x150]
    5ca8: 3c858100     	stur	q0, [x8, #0x58]
    5cac: 9104c3e0     	add	x0, sp, #0x130
    5cb0: 9100a101     	add	x1, x8, #0x28
    5cb4: 9400005b     	bl	0x5e20 <transform>
    5cb8: aa1f03fa     	mov	x26, xzr
    5cbc: 2a1603fb     	mov	w27, w22
    5cc0: f900cfff     	str	xzr, [sp, #0x198]
    5cc4: 910703e8     	add	x8, sp, #0x1c0
    5cc8: 9101011c     	add	x28, x8, #0x40
    5ccc: 910303e8     	add	x8, sp, #0xc0
    5cd0: 9100a116     	add	x22, x8, #0x28
    5cd4: d1000714     	sub	x20, x24, #0x1
    5cd8: 2a3703f3     	mvn	w19, w23
    5cdc: 2a1703fd     	mov	w29, w23
    5ce0: ad4c03e1     	ldp	q1, q0, [sp, #0x180]
    5ce4: ad0883e1     	stp	q1, q0, [sp, #0x110]
    5ce8: 3dc05fe2     	ldr	q2, [sp, #0x170]
    5cec: ad4987e0     	ldp	q0, q1, [sp, #0x130]
    5cf0: ad0607e0     	stp	q0, q1, [sp, #0xc0]
    5cf4: b9020ffb     	str	w27, [sp, #0x20c]
    5cf8: ad4a83e1     	ldp	q1, q0, [sp, #0x150]
    5cfc: f94097e8     	ldr	x8, [sp, #0x128]
    5d00: 52800215     	mov	w21, #0x10              // =16
    5d04: aa1c03f7     	mov	x23, x28
    5d08: ad078be0     	stp	q0, q2, [sp, #0xf0]
    5d0c: 3d803be1     	str	q1, [sp, #0xe0]
    5d10: 14000007     	b	0x5d2c <b_m_mine+0x10c>
    5d14: d503201f     	nop
    5d18: d503201f     	nop
    5d1c: d503201f     	nop
    5d20: 8b1802f7     	add	x23, x23, x24
    5d24: cb1802b5     	sub	x21, x21, x24
    5d28: b40002d5     	cbz	x21, 0x5d80 <b_m_mine+0x160>
    5d2c: cb080329     	sub	x9, x25, x8
    5d30: eb15013f     	cmp	x9, x21
    5d34: 9a953138     	csel	x24, x9, x21, lo
    5d38: 8b0802c0     	add	x0, x22, x8
    5d3c: aa1703e1     	mov	x1, x23
    5d40: aa1803e2     	mov	x2, x24
    5d44: 9400126b     	bl	0xa6f0 <memcpy@plt>
    5d48: f94097e8     	ldr	x8, [sp, #0x128]
    5d4c: f94073e9     	ldr	x9, [sp, #0xe0]
    5d50: 8b180108     	add	x8, x8, x24
    5d54: 8b180d29     	add	x9, x9, x24, lsl #3
    5d58: f90097e8     	str	x8, [sp, #0x128]
    5d5c: f90073e9     	str	x9, [sp, #0xe0]
    5d60: f101011f     	cmp	x8, #0x40
    5d64: 54fffde1     	b.ne	0x5d20 <b_m_mine+0x100>
    5d68: 910303e0     	add	x0, sp, #0xc0
    5d6c: aa1603e1     	mov	x1, x22
    5d70: 9400002c     	bl	0x5e20 <transform>
    5d74: aa1f03e8     	mov	x8, xzr
    5d78: f90097ff     	str	xzr, [sp, #0x128]
    5d7c: 17ffffe9     	b	0x5d20 <b_m_mine+0x100>
    5d80: 910303e0     	add	x0, sp, #0xc0
    5d84: 910143e8     	add	x8, sp, #0x50
    5d88: 9100a101     	add	x1, x8, #0x28
    5d8c: 940000a5     	bl	0x6020 <final>
    5d90: 52800408     	mov	w8, #0x20               // =32
    5d94: f9005fe8     	str	x8, [sp, #0xb8]
    5d98: 52802008     	mov	w8, #0x100              // =256
    5d9c: f9003be8     	str	x8, [sp, #0x70]
    5da0: ad4107e0     	ldp	q0, q1, [sp, #0x20]
    5da4: ad0283e1     	stp	q1, q0, [sp, #0x50]
    5da8: 910143e0     	add	x0, sp, #0x50
    5dac: 910683e1     	add	x1, sp, #0x1a0
    5db0: 9400009c     	bl	0x6020 <final>
    5db4: 9100075a     	add	x26, x26, #0x1
    5db8: 910683e0     	add	x0, sp, #0x1a0
    5dbc: f94027e1     	ldr	x1, [sp, #0x48]
    5dc0: 9400010c     	bl	0x61f0 <le_target>
    5dc4: 35000140     	cbnz	w0, 0x5dec <b_m_mine+0x1cc>
    5dc8: eb1a029f     	cmp	x20, x26
    5dcc: 540000c3     	b.lo	0x5de4 <b_m_mine+0x1c4>
    5dd0: eb13037f     	cmp	x27, x19
    5dd4: 54000088     	b.hi	0x5de4 <b_m_mine+0x1c4>
    5dd8: 8b1d037b     	add	x27, x27, x29
    5ddc: d360ff68     	lsr	x8, x27, #32
    5de0: b4fff808     	cbz	x8, 0x5ce0 <b_m_mine+0xc0>
    5de4: 2a1f03e0     	mov	w0, wzr
    5de8: 14000004     	b	0x5df8 <b_m_mine+0x1d8>
    5dec: f9400be8     	ldr	x8, [sp, #0x10]
    5df0: b900011b     	str	w27, [x8]
    5df4: 52800020     	mov	w0, #0x1                // =1
    5df8: f9400fe8     	ldr	x8, [sp, #0x18]
    5dfc: f900011a     	str	x26, [x8]
    5e00: 910843ff     	add	sp, sp, #0x210
    5e04: a9454ff4     	ldp	x20, x19, [sp, #0x50]
    5e08: a94457f6     	ldp	x22, x21, [sp, #0x40]
    5e0c: a9435ff8     	ldp	x24, x23, [sp, #0x30]
    5e10: a94267fa     	ldp	x26, x25, [sp, #0x20]
    5e14: a9416ffc     	ldp	x28, x27, [sp, #0x10]
    5e18: a8c67bfd     	ldp	x29, x30, [sp], #0x60
    5e1c: d65f03c0     	ret

0000000000005e20 <transform>:
    5e20: d104c3ff     	sub	sp, sp, #0x130
    5e24: a9105ffd     	stp	x29, x23, [sp, #0x100]
    5e28: a91157f6     	stp	x22, x21, [sp, #0x110]
    5e2c: a9124ff4     	stp	x20, x19, [sp, #0x120]
    5e30: aa1f03e8     	mov	x8, xzr
    5e34: 29402829     	ldp	w9, w10, [x1]
    5e38: 5ac00929     	rev	w9, w9
    5e3c: 5ac0094a     	rev	w10, w10
    5e40: 29002be9     	stp	w9, w10, [sp]
    5e44: 29412c2a     	ldp	w10, w11, [x1, #0x8]
    5e48: 5ac0094a     	rev	w10, w10
    5e4c: 5ac0096b     	rev	w11, w11
    5e50: 29012fea     	stp	w10, w11, [sp, #0x8]
    5e54: 29422c2a     	ldp	w10, w11, [x1, #0x10]
    5e58: 5ac0094a     	rev	w10, w10
    5e5c: 5ac0096b     	rev	w11, w11
    5e60: 29022fea     	stp	w10, w11, [sp, #0x10]
    5e64: 29432c2a     	ldp	w10, w11, [x1, #0x18]
    5e68: 5ac0094a     	rev	w10, w10
    5e6c: 5ac0096b     	rev	w11, w11
    5e70: 29032fea     	stp	w10, w11, [sp, #0x18]
    5e74: 29442c2a     	ldp	w10, w11, [x1, #0x20]
    5e78: 5ac0094a     	rev	w10, w10
    5e7c: 5ac0096b     	rev	w11, w11
    5e80: 29042fea     	stp	w10, w11, [sp, #0x20]
    5e84: 29452c2a     	ldp	w10, w11, [x1, #0x28]
    5e88: 5ac0094a     	rev	w10, w10
    5e8c: 5ac0096b     	rev	w11, w11
    5e90: 2946342c     	ldp	w12, w13, [x1, #0x30]
    5e94: 5ac0098c     	rev	w12, w12
    5e98: 5ac009ad     	rev	w13, w13
    5e9c: 29052fea     	stp	w10, w11, [sp, #0x28]
    5ea0: 290637ec     	stp	w12, w13, [sp, #0x30]
    5ea4: 29472c2a     	ldp	w10, w11, [x1, #0x38]
    5ea8: 5ac0094a     	rev	w10, w10
    5eac: 5ac0096b     	rev	w11, w11
    5eb0: 29072fea     	stp	w10, w11, [sp, #0x38]
    5eb4: 910003ea     	mov	x10, sp
    5eb8: d503201f     	nop
    5ebc: d503201f     	nop
    5ec0: 8b08014b     	add	x11, x10, x8
    5ec4: b940256c     	ldr	w12, [x11, #0x24]
    5ec8: 0b0c0129     	add	w9, w9, w12
    5ecc: b940056c     	ldr	w12, [x11, #0x4]
    5ed0: b940396d     	ldr	w13, [x11, #0x38]
    5ed4: 138c1d8e     	ror	w14, w12, #0x7
    5ed8: 138d45af     	ror	w15, w13, #0x11
    5edc: 4acc49ce     	eor	w14, w14, w12, ror #18
    5ee0: 4acd4def     	eor	w15, w15, w13, ror #19
    5ee4: 4a4c0dce     	eor	w14, w14, w12, lsr #3
    5ee8: 4a4d29ed     	eor	w13, w15, w13, lsr #10
    5eec: 0b0901c9     	add	w9, w14, w9
    5ef0: 0b0d0129     	add	w9, w9, w13
    5ef4: b9004169     	str	w9, [x11, #0x40]
    5ef8: 91001108     	add	x8, x8, #0x4
    5efc: f103011f     	cmp	x8, #0xc0
    5f00: 2a0c03e9     	mov	w9, w12
    5f04: 54fffde1     	b.ne	0x5ec0 <transform+0xa0>
    5f08: aa1f03ec     	mov	x12, xzr
    5f0c: 29402809     	ldp	w9, w10, [x0]
    5f10: 2941200b     	ldp	w11, w8, [x0, #0x8]
    5f14: d503201f     	nop
    5f18: 10fd8431     	adr	x17, 0xf9c <K>
    5f1c: 910003e2     	mov	x2, sp
    5f20: 2a0903f3     	mov	w19, w9
    5f24: 2a0a03e3     	mov	w3, w10
    5f28: 2a0b03e1     	mov	w1, w11
    5f2c: 2943340e     	ldp	w14, w13, [x0, #0x18]
    5f30: 2a0803e7     	mov	w7, w8
    5f34: 2a0d03f5     	mov	w21, w13
    5f38: 2a0e03f6     	mov	w22, w14
    5f3c: 29423c10     	ldp	w16, w15, [x0, #0x10]
    5f40: 2a0f03f7     	mov	w23, w15
    5f44: 2a1003f4     	mov	w20, w16
    5f48: 2a1403e4     	mov	w4, w20
    5f4c: 13941a94     	ror	w20, w20, #0x6
    5f50: 2a1703e6     	mov	w6, w23
    5f54: 2a1603e5     	mov	w5, w22
    5f58: 0a0402f6     	and	w22, w23, w4
    5f5c: 0a2400b7     	bic	w23, w5, w4
    5f60: 2a1602f6     	orr	w22, w23, w22
    5f64: b86c6a37     	ldr	w23, [x17, x12]
    5f68: 0b1602b5     	add	w21, w21, w22
    5f6c: b86c6856     	ldr	w22, [x2, x12]
    5f70: 4ac42e94     	eor	w20, w20, w4, ror #11
    5f74: 4ac46694     	eor	w20, w20, w4, ror #25
    5f78: 0b1402b4     	add	w20, w21, w20
    5f7c: 0b170294     	add	w20, w20, w23
    5f80: 0b160295     	add	w21, w20, w22
    5f84: 0b0702b4     	add	w20, w21, w7
    5f88: 2a0103e7     	mov	w7, w1
    5f8c: 2a0303e1     	mov	w1, w3
    5f90: 2a1303e3     	mov	w3, w19
    5f94: 13930a73     	ror	w19, w19, #0x2
    5f98: 4ac33673     	eor	w19, w19, w3, ror #13
    5f9c: 4a070036     	eor	w22, w1, w7
    5fa0: 0a070037     	and	w23, w1, w7
    5fa4: 0a160076     	and	w22, w3, w22
    5fa8: 4ac35a73     	eor	w19, w19, w3, ror #22
    5fac: 9100118c     	add	x12, x12, #0x4
    5fb0: 4a1702d6     	eor	w22, w22, w23
    5fb4: f104019f     	cmp	x12, #0x100
    5fb8: 0b160273     	add	w19, w19, w22
    5fbc: 0b150273     	add	w19, w19, w21
    5fc0: 2a0503f5     	mov	w21, w5
    5fc4: 2a0603f6     	mov	w22, w6
    5fc8: 2a0403f7     	mov	w23, w4
    5fcc: 54fffbe1     	b.ne	0x5f48 <transform+0x128>
    5fd0: 0b090269     	add	w9, w19, w9
    5fd4: 0b0a006a     	add	w10, w3, w10
    5fd8: 0b0b002b     	add	w11, w1, w11
    5fdc: 29002809     	stp	w9, w10, [x0]
    5fe0: 0b0800e8     	add	w8, w7, w8
    5fe4: 2901200b     	stp	w11, w8, [x0, #0x8]
    5fe8: 0b100288     	add	w8, w20, w16
    5fec: 0b0f0089     	add	w9, w4, w15
    5ff0: 29022408     	stp	w8, w9, [x0, #0x10]
    5ff4: 0b0e00c8     	add	w8, w6, w14
    5ff8: 0b0d00a9     	add	w9, w5, w13
    5ffc: 29032408     	stp	w8, w9, [x0, #0x18]
    6000: a9524ff4     	ldp	x20, x19, [sp, #0x120]
    6004: a95157f6     	ldp	x22, x21, [sp, #0x110]
    6008: a9505ffd     	ldp	x29, x23, [sp, #0x100]
    600c: 9104c3ff     	add	sp, sp, #0x130
    6010: d65f03c0     	ret
		...

0000000000006020 <final>:
    6020: a9be57fe     	stp	x30, x21, [sp, #-0x20]!
    6024: a9014ff4     	stp	x20, x19, [sp, #0x10]
    6028: aa0103f3     	mov	x19, x1
    602c: aa0003f4     	mov	x20, x0
    6030: f9403409     	ldr	x9, [x0, #0x68]
    6034: 9100a015     	add	x21, x0, #0x28
    6038: 91000528     	add	x8, x9, #0x1
    603c: 5280100a     	mov	w10, #0x80              // =128
    6040: 38296aaa     	strb	w10, [x21, x9]
    6044: f100e51f     	cmp	x8, #0x39
    6048: 540001c3     	b.lo	0x6080 <final+0x60>
    604c: f100fd1f     	cmp	x8, #0x3f
    6050: 540000e8     	b.hi	0x606c <final+0x4c>
    6054: 8b090288     	add	x8, x20, x9
    6058: 528007ea     	mov	w10, #0x3f              // =63
    605c: cb090142     	sub	x2, x10, x9
    6060: 9100a500     	add	x0, x8, #0x29
    6064: 2a1f03e1     	mov	w1, wzr
    6068: 940011a6     	bl	0xa700 <memset@plt>
    606c: aa1403e0     	mov	x0, x20
    6070: aa1503e1     	mov	x1, x21
    6074: 97ffff6b     	bl	0x5e20 <transform>
    6078: aa1f03e8     	mov	x8, xzr
    607c: 14000003     	b	0x6088 <final+0x68>
    6080: f100e11f     	cmp	x8, #0x38
    6084: 540000e0     	b.eq	0x60a0 <final+0x80>
    6088: 8b080289     	add	x9, x20, x8
    608c: 5280070a     	mov	w10, #0x38              // =56
    6090: cb080142     	sub	x2, x10, x8
    6094: 9100a120     	add	x0, x9, #0x28
    6098: 2a1f03e1     	mov	w1, wzr
    609c: 94001199     	bl	0xa700 <memset@plt>
    60a0: f9401288     	ldr	x8, [x20, #0x20]
    60a4: dac00d08     	rev	x8, x8
    60a8: f9003288     	str	x8, [x20, #0x60]
    60ac: aa1403e0     	mov	x0, x20
    60b0: aa1503e1     	mov	x1, x21
    60b4: 97ffff5b     	bl	0x5e20 <transform>
    60b8: 39400e88     	ldrb	w8, [x20, #0x3]
    60bc: 39000268     	strb	w8, [x19]
    60c0: 79400688     	ldrh	w8, [x20, #0x2]
    60c4: 39000668     	strb	w8, [x19, #0x1]
    60c8: b9400288     	ldr	w8, [x20]
    60cc: 53087d08     	lsr	w8, w8, #8
    60d0: 39000a68     	strb	w8, [x19, #0x2]
    60d4: b9400288     	ldr	w8, [x20]
    60d8: 39000e68     	strb	w8, [x19, #0x3]
    60dc: 39401e88     	ldrb	w8, [x20, #0x7]
    60e0: 39001268     	strb	w8, [x19, #0x4]
    60e4: 79400e88     	ldrh	w8, [x20, #0x6]
    60e8: 39001668     	strb	w8, [x19, #0x5]
    60ec: b9400688     	ldr	w8, [x20, #0x4]
    60f0: 53087d08     	lsr	w8, w8, #8
    60f4: 39001a68     	strb	w8, [x19, #0x6]
    60f8: b9400688     	ldr	w8, [x20, #0x4]
    60fc: 39001e68     	strb	w8, [x19, #0x7]
    6100: 39402e88     	ldrb	w8, [x20, #0xb]
    6104: 39002268     	strb	w8, [x19, #0x8]
    6108: 79401688     	ldrh	w8, [x20, #0xa]
    610c: 39002668     	strb	w8, [x19, #0x9]
    6110: b9400a88     	ldr	w8, [x20, #0x8]
    6114: 53087d08     	lsr	w8, w8, #8
    6118: 39002a68     	strb	w8, [x19, #0xa]
    611c: b9400a88     	ldr	w8, [x20, #0x8]
    6120: 39002e68     	strb	w8, [x19, #0xb]
    6124: 39403e88     	ldrb	w8, [x20, #0xf]
    6128: 39003268     	strb	w8, [x19, #0xc]
    612c: 79401e88     	ldrh	w8, [x20, #0xe]
    6130: 39003668     	strb	w8, [x19, #0xd]
    6134: b9400e88     	ldr	w8, [x20, #0xc]
    6138: 53087d08     	lsr	w8, w8, #8
    613c: 39003a68     	strb	w8, [x19, #0xe]
    6140: b9400e88     	ldr	w8, [x20, #0xc]
    6144: 39003e68     	strb	w8, [x19, #0xf]
    6148: 39404e88     	ldrb	w8, [x20, #0x13]
    614c: 39004268     	strb	w8, [x19, #0x10]
    6150: 79402688     	ldrh	w8, [x20, #0x12]
    6154: 39004668     	strb	w8, [x19, #0x11]
    6158: b9401288     	ldr	w8, [x20, #0x10]
    615c: 53087d08     	lsr	w8, w8, #8
    6160: 39004a68     	strb	w8, [x19, #0x12]
    6164: b9401288     	ldr	w8, [x20, #0x10]
    6168: 39004e68     	strb	w8, [x19, #0x13]
    616c: 39405e88     	ldrb	w8, [x20, #0x17]
    6170: 39005268     	strb	w8, [x19, #0x14]
    6174: 79402e88     	ldrh	w8, [x20, #0x16]
    6178: 39005668     	strb	w8, [x19, #0x15]
    617c: b9401688     	ldr	w8, [x20, #0x14]
    6180: 53087d08     	lsr	w8, w8, #8
    6184: 39005a68     	strb	w8, [x19, #0x16]
    6188: b9401688     	ldr	w8, [x20, #0x14]
    618c: 39005e68     	strb	w8, [x19, #0x17]
    6190: 39406e88     	ldrb	w8, [x20, #0x1b]
    6194: 39006268     	strb	w8, [x19, #0x18]
    6198: 79403688     	ldrh	w8, [x20, #0x1a]
    619c: 39006668     	strb	w8, [x19, #0x19]
    61a0: b9401a88     	ldr	w8, [x20, #0x18]
    61a4: 53087d08     	lsr	w8, w8, #8
    61a8: 39006a68     	strb	w8, [x19, #0x1a]
    61ac: b9401a88     	ldr	w8, [x20, #0x18]
    61b0: 39006e68     	strb	w8, [x19, #0x1b]
    61b4: 39407e88     	ldrb	w8, [x20, #0x1f]
    61b8: 39007268     	strb	w8, [x19, #0x1c]
    61bc: 79403e88     	ldrh	w8, [x20, #0x1e]
    61c0: 39007668     	strb	w8, [x19, #0x1d]
    61c4: b9401e88     	ldr	w8, [x20, #0x1c]
    61c8: 53087d08     	lsr	w8, w8, #8
    61cc: 39007a68     	strb	w8, [x19, #0x1e]
    61d0: b9401e88     	ldr	w8, [x20, #0x1c]
    61d4: 39007e68     	strb	w8, [x19, #0x1f]
    61d8: a9414ff4     	ldp	x20, x19, [sp, #0x10]
    61dc: a8c257fe     	ldp	x30, x21, [sp], #0x20
    61e0: d65f03c0     	ret
		...

00000000000061f0 <le_target>:
    61f0: 39407c08     	ldrb	w8, [x0, #0x1f]
    61f4: 39407c29     	ldrb	w9, [x1, #0x1f]
    61f8: 6b09011f     	cmp	w8, w9
    61fc: 54000062     	b.hs	0x6208 <le_target+0x18>
    6200: 52800020     	mov	w0, #0x1                // =1
    6204: d65f03c0     	ret
    6208: 54000069     	b.ls	0x6214 <le_target+0x24>
    620c: 2a1f03e0     	mov	w0, wzr
    6210: d65f03c0     	ret
    6214: 39407808     	ldrb	w8, [x0, #0x1e]
    6218: 39407829     	ldrb	w9, [x1, #0x1e]
    621c: 6b09011f     	cmp	w8, w9
    6220: 54000062     	b.hs	0x622c <le_target+0x3c>
    6224: 52800020     	mov	w0, #0x1                // =1
    6228: d65f03c0     	ret
    622c: 54ffff08     	b.hi	0x620c <le_target+0x1c>
    6230: 39407408     	ldrb	w8, [x0, #0x1d]
    6234: 39407429     	ldrb	w9, [x1, #0x1d]
    6238: 6b09011f     	cmp	w8, w9
    623c: 54000062     	b.hs	0x6248 <le_target+0x58>
    6240: 52800020     	mov	w0, #0x1                // =1
    6244: d65f03c0     	ret
    6248: 54fffe28     	b.hi	0x620c <le_target+0x1c>
    624c: 39407008     	ldrb	w8, [x0, #0x1c]
    6250: 39407029     	ldrb	w9, [x1, #0x1c]
    6254: 6b09011f     	cmp	w8, w9
    6258: 54000062     	b.hs	0x6264 <le_target+0x74>
    625c: 52800020     	mov	w0, #0x1                // =1
    6260: d65f03c0     	ret
    6264: 54fffd48     	b.hi	0x620c <le_target+0x1c>
    6268: 39406c08     	ldrb	w8, [x0, #0x1b]
    626c: 39406c29     	ldrb	w9, [x1, #0x1b]
    6270: 6b09011f     	cmp	w8, w9
    6274: 54000062     	b.hs	0x6280 <le_target+0x90>
    6278: 52800020     	mov	w0, #0x1                // =1
    627c: d65f03c0     	ret
    6280: 54fffc68     	b.hi	0x620c <le_target+0x1c>
    6284: 39406808     	ldrb	w8, [x0, #0x1a]
    6288: 39406829     	ldrb	w9, [x1, #0x1a]
    628c: 6b09011f     	cmp	w8, w9
    6290: 54000062     	b.hs	0x629c <le_target+0xac>
    6294: 52800020     	mov	w0, #0x1                // =1
    6298: d65f03c0     	ret
    629c: 54fffb88     	b.hi	0x620c <le_target+0x1c>
    62a0: 39406408     	ldrb	w8, [x0, #0x19]
    62a4: 39406429     	ldrb	w9, [x1, #0x19]
    62a8: 6b09011f     	cmp	w8, w9
    62ac: 54000062     	b.hs	0x62b8 <le_target+0xc8>
    62b0: 52800020     	mov	w0, #0x1                // =1
    62b4: d65f03c0     	ret
    62b8: 54fffaa8     	b.hi	0x620c <le_target+0x1c>
    62bc: 39406008     	ldrb	w8, [x0, #0x18]
    62c0: 39406029     	ldrb	w9, [x1, #0x18]
    62c4: 6b09011f     	cmp	w8, w9
    62c8: 54000062     	b.hs	0x62d4 <le_target+0xe4>
    62cc: 52800020     	mov	w0, #0x1                // =1
    62d0: d65f03c0     	ret
    62d4: 54fff9c8     	b.hi	0x620c <le_target+0x1c>
    62d8: 39405c08     	ldrb	w8, [x0, #0x17]
    62dc: 39405c29     	ldrb	w9, [x1, #0x17]
    62e0: 6b09011f     	cmp	w8, w9
    62e4: 54000062     	b.hs	0x62f0 <le_target+0x100>
    62e8: 52800020     	mov	w0, #0x1                // =1
    62ec: d65f03c0     	ret
    62f0: 54fff8e8     	b.hi	0x620c <le_target+0x1c>
    62f4: 39405808     	ldrb	w8, [x0, #0x16]
    62f8: 39405829     	ldrb	w9, [x1, #0x16]
    62fc: 6b09011f     	cmp	w8, w9
    6300: 54000062     	b.hs	0x630c <le_target+0x11c>
    6304: 52800020     	mov	w0, #0x1                // =1
    6308: d65f03c0     	ret
    630c: 54fff808     	b.hi	0x620c <le_target+0x1c>
    6310: 39405408     	ldrb	w8, [x0, #0x15]
    6314: 39405429     	ldrb	w9, [x1, #0x15]
    6318: 6b09011f     	cmp	w8, w9
    631c: 54000062     	b.hs	0x6328 <le_target+0x138>
    6320: 52800020     	mov	w0, #0x1                // =1
    6324: d65f03c0     	ret
    6328: 54fff728     	b.hi	0x620c <le_target+0x1c>
    632c: 39405008     	ldrb	w8, [x0, #0x14]
    6330: 39405029     	ldrb	w9, [x1, #0x14]
    6334: 6b09011f     	cmp	w8, w9
    6338: 54000062     	b.hs	0x6344 <le_target+0x154>
    633c: 52800020     	mov	w0, #0x1                // =1
    6340: d65f03c0     	ret
    6344: 54fff648     	b.hi	0x620c <le_target+0x1c>
    6348: 39404c08     	ldrb	w8, [x0, #0x13]
    634c: 39404c29     	ldrb	w9, [x1, #0x13]
    6350: 6b09011f     	cmp	w8, w9
    6354: 54000062     	b.hs	0x6360 <le_target+0x170>
    6358: 52800020     	mov	w0, #0x1                // =1
    635c: d65f03c0     	ret
    6360: 54fff568     	b.hi	0x620c <le_target+0x1c>
    6364: 39404808     	ldrb	w8, [x0, #0x12]
    6368: 39404829     	ldrb	w9, [x1, #0x12]
    636c: 6b09011f     	cmp	w8, w9
    6370: 54000062     	b.hs	0x637c <le_target+0x18c>
    6374: 52800020     	mov	w0, #0x1                // =1
    6378: d65f03c0     	ret
    637c: 54fff488     	b.hi	0x620c <le_target+0x1c>
    6380: 39404408     	ldrb	w8, [x0, #0x11]
    6384: 39404429     	ldrb	w9, [x1, #0x11]
    6388: 6b09011f     	cmp	w8, w9
    638c: 54000062     	b.hs	0x6398 <le_target+0x1a8>
    6390: 52800020     	mov	w0, #0x1                // =1
    6394: d65f03c0     	ret
    6398: 54fff3a8     	b.hi	0x620c <le_target+0x1c>
    639c: 39404008     	ldrb	w8, [x0, #0x10]
    63a0: 39404029     	ldrb	w9, [x1, #0x10]
    63a4: 6b09011f     	cmp	w8, w9
    63a8: 54000062     	b.hs	0x63b4 <le_target+0x1c4>
    63ac: 52800020     	mov	w0, #0x1                // =1
    63b0: d65f03c0     	ret
    63b4: 54fff2c8     	b.hi	0x620c <le_target+0x1c>
    63b8: 39403c08     	ldrb	w8, [x0, #0xf]
    63bc: 39403c29     	ldrb	w9, [x1, #0xf]
    63c0: 6b09011f     	cmp	w8, w9
    63c4: 54000062     	b.hs	0x63d0 <le_target+0x1e0>
    63c8: 52800020     	mov	w0, #0x1                // =1
    63cc: d65f03c0     	ret
    63d0: 54fff1e8     	b.hi	0x620c <le_target+0x1c>
    63d4: 39403808     	ldrb	w8, [x0, #0xe]
    63d8: 39403829     	ldrb	w9, [x1, #0xe]
    63dc: 6b09011f     	cmp	w8, w9
    63e0: 54000062     	b.hs	0x63ec <le_target+0x1fc>
    63e4: 52800020     	mov	w0, #0x1                // =1
    63e8: d65f03c0     	ret
    63ec: 54fff108     	b.hi	0x620c <le_target+0x1c>
    63f0: 39403408     	ldrb	w8, [x0, #0xd]
    63f4: 39403429     	ldrb	w9, [x1, #0xd]
    63f8: 6b09011f     	cmp	w8, w9
    63fc: 54000062     	b.hs	0x6408 <le_target+0x218>
    6400: 52800020     	mov	w0, #0x1                // =1
    6404: d65f03c0     	ret
    6408: 54fff028     	b.hi	0x620c <le_target+0x1c>
    640c: 39403008     	ldrb	w8, [x0, #0xc]
    6410: 39403029     	ldrb	w9, [x1, #0xc]
    6414: 6b09011f     	cmp	w8, w9
    6418: 54000062     	b.hs	0x6424 <le_target+0x234>
    641c: 52800020     	mov	w0, #0x1                // =1
    6420: d65f03c0     	ret
    6424: 54ffef48     	b.hi	0x620c <le_target+0x1c>
    6428: 39402c08     	ldrb	w8, [x0, #0xb]
    642c: 39402c29     	ldrb	w9, [x1, #0xb]
    6430: 6b09011f     	cmp	w8, w9
    6434: 54000062     	b.hs	0x6440 <le_target+0x250>
    6438: 52800020     	mov	w0, #0x1                // =1
    643c: d65f03c0     	ret
    6440: 54ffee68     	b.hi	0x620c <le_target+0x1c>
    6444: 39402808     	ldrb	w8, [x0, #0xa]
    6448: 39402829     	ldrb	w9, [x1, #0xa]
    644c: 6b09011f     	cmp	w8, w9
    6450: 54000062     	b.hs	0x645c <le_target+0x26c>
    6454: 52800020     	mov	w0, #0x1                // =1
    6458: d65f03c0     	ret
    645c: 54ffed88     	b.hi	0x620c <le_target+0x1c>
    6460: 39402408     	ldrb	w8, [x0, #0x9]
    6464: 39402429     	ldrb	w9, [x1, #0x9]
    6468: 6b09011f     	cmp	w8, w9
    646c: 54000062     	b.hs	0x6478 <le_target+0x288>
    6470: 52800020     	mov	w0, #0x1                // =1
    6474: d65f03c0     	ret
    6478: 54ffeca8     	b.hi	0x620c <le_target+0x1c>
    647c: 39402008     	ldrb	w8, [x0, #0x8]
    6480: 39402029     	ldrb	w9, [x1, #0x8]
    6484: 6b09011f     	cmp	w8, w9
    6488: 54000062     	b.hs	0x6494 <le_target+0x2a4>
    648c: 52800020     	mov	w0, #0x1                // =1
    6490: d65f03c0     	ret
    6494: 54ffebc8     	b.hi	0x620c <le_target+0x1c>
    6498: 39401c08     	ldrb	w8, [x0, #0x7]
    649c: 39401c29     	ldrb	w9, [x1, #0x7]
    64a0: 6b09011f     	cmp	w8, w9
    64a4: 54000062     	b.hs	0x64b0 <le_target+0x2c0>
    64a8: 52800020     	mov	w0, #0x1                // =1
    64ac: d65f03c0     	ret
    64b0: 54ffeae8     	b.hi	0x620c <le_target+0x1c>
    64b4: 39401808     	ldrb	w8, [x0, #0x6]
    64b8: 39401829     	ldrb	w9, [x1, #0x6]
    64bc: 6b09011f     	cmp	w8, w9
    64c0: 54000062     	b.hs	0x64cc <le_target+0x2dc>
    64c4: 52800020     	mov	w0, #0x1                // =1
    64c8: d65f03c0     	ret
    64cc: 54ffea08     	b.hi	0x620c <le_target+0x1c>
    64d0: 39401408     	ldrb	w8, [x0, #0x5]
    64d4: 39401429     	ldrb	w9, [x1, #0x5]
    64d8: 6b09011f     	cmp	w8, w9
    64dc: 54000062     	b.hs	0x64e8 <le_target+0x2f8>
    64e0: 52800020     	mov	w0, #0x1                // =1
    64e4: d65f03c0     	ret
    64e8: 54ffe928     	b.hi	0x620c <le_target+0x1c>
    64ec: 39401008     	ldrb	w8, [x0, #0x4]
    64f0: 39401029     	ldrb	w9, [x1, #0x4]
    64f4: 6b09011f     	cmp	w8, w9
    64f8: 54000062     	b.hs	0x6504 <le_target+0x314>
    64fc: 52800020     	mov	w0, #0x1                // =1
    6500: d65f03c0     	ret
    6504: 54ffe848     	b.hi	0x620c <le_target+0x1c>
    6508: 39400c08     	ldrb	w8, [x0, #0x3]
    650c: 39400c29     	ldrb	w9, [x1, #0x3]
    6510: 6b09011f     	cmp	w8, w9
    6514: 54000062     	b.hs	0x6520 <le_target+0x330>
    6518: 52800020     	mov	w0, #0x1                // =1
    651c: d65f03c0     	ret
    6520: 54ffe768     	b.hi	0x620c <le_target+0x1c>
    6524: 39400808     	ldrb	w8, [x0, #0x2]
    6528: 39400829     	ldrb	w9, [x1, #0x2]
    652c: 6b09011f     	cmp	w8, w9
    6530: 54000062     	b.hs	0x653c <le_target+0x34c>
    6534: 52800020     	mov	w0, #0x1                // =1
    6538: d65f03c0     	ret
    653c: 54ffe688     	b.hi	0x620c <le_target+0x1c>
    6540: 39400408     	ldrb	w8, [x0, #0x1]
    6544: 39400429     	ldrb	w9, [x1, #0x1]
    6548: 6b09011f     	cmp	w8, w9
    654c: 54000062     	b.hs	0x6558 <le_target+0x368>
    6550: 52800020     	mov	w0, #0x1                // =1
    6554: d65f03c0     	ret
    6558: 54ffe5a8     	b.hi	0x620c <le_target+0x1c>
    655c: 39400008     	ldrb	w8, [x0]
    6560: 39400029     	ldrb	w9, [x1]
    6564: 6b09011f     	cmp	w8, w9
    6568: 54000062     	b.hs	0x6574 <le_target+0x384>
    656c: 52800020     	mov	w0, #0x1                // =1
    6570: d65f03c0     	ret
    6574: 1a9f87e0     	cset	w0, ls
    6578: d65f03c0     	ret
    657c: 00000000     	udf	#0x0

0000000000006580 <b_m_debug_sha256d_scalar_base>:
    6580: d10503ff     	sub	sp, sp, #0x140
    6584: a9107bfd     	stp	x29, x30, [sp, #0x100]
    6588: a9115ff8     	stp	x24, x23, [sp, #0x110]
    658c: a91257f6     	stp	x22, x21, [sp, #0x120]
    6590: a9134ff4     	stp	x20, x19, [sp, #0x130]
    6594: aa0203f3     	mov	x19, x2
    6598: 2a0103f4     	mov	w20, w1
    659c: aa0003f5     	mov	x21, x0
    65a0: 910243e8     	add	x8, sp, #0x90
    65a4: ad400400     	ldp	q0, q1, [x0]
    65a8: 3c828100     	stur	q0, [x8, #0x28]
    65ac: 3c838101     	stur	q1, [x8, #0x38]
    65b0: d503201f     	nop
    65b4: 10fd4e49     	adr	x9, 0xf7c <init.h>
    65b8: ad410400     	ldp	q0, q1, [x0, #0x20]
    65bc: 3c848100     	stur	q0, [x8, #0x48]
    65c0: ad400920     	ldp	q0, q2, [x9]
    65c4: ad0003e2     	stp	q2, q0, [sp]
    65c8: 53087c36     	lsr	w22, w1, #8
    65cc: 53107c37     	lsr	w23, w1, #16
    65d0: 53187c38     	lsr	w24, w1, #24
    65d4: ad048be0     	stp	q0, q2, [sp, #0x90]
    65d8: 52800809     	mov	w9, #0x40               // =64
    65dc: 5280400a     	mov	w10, #0x200             // =512
    65e0: f9007fe9     	str	x9, [sp, #0xf8]
    65e4: f9005bea     	str	x10, [sp, #0xb0]
    65e8: 3c858101     	stur	q1, [x8, #0x58]
    65ec: 910243e0     	add	x0, sp, #0x90
    65f0: 9100a101     	add	x1, x8, #0x28
    65f4: 97fffe0b     	bl	0x5e20 <transform>
    65f8: 390313f4     	strb	w20, [sp, #0xc4]
    65fc: f94022a8     	ldr	x8, [x21, #0x40]
    6600: 390317f6     	strb	w22, [sp, #0xc5]
    6604: b9404aa9     	ldr	w9, [x21, #0x48]
    6608: 39031bf7     	strb	w23, [sp, #0xc6]
    660c: 39031ff8     	strb	w24, [sp, #0xc7]
    6610: 5280020a     	mov	w10, #0x10              // =16
    6614: b900c3e9     	str	w9, [sp, #0xc0]
    6618: f9007fea     	str	x10, [sp, #0xf8]
    661c: f9405be9     	ldr	x9, [sp, #0xb0]
    6620: 91020129     	add	x9, x9, #0x80
    6624: 910083ea     	add	x10, sp, #0x20
    6628: a90b23e9     	stp	x9, x8, [sp, #0xb0]
    662c: 910243e0     	add	x0, sp, #0x90
    6630: 9100a141     	add	x1, x10, #0x28
    6634: 97fffe7b     	bl	0x6020 <final>
    6638: 52800408     	mov	w8, #0x20               // =32
    663c: 52802009     	mov	w9, #0x100              // =256
    6640: f90047e8     	str	x8, [sp, #0x88]
    6644: f90023e9     	str	x9, [sp, #0x40]
    6648: ad4007e0     	ldp	q0, q1, [sp]
    664c: ad0103e1     	stp	q1, q0, [sp, #0x20]
    6650: 910083e0     	add	x0, sp, #0x20
    6654: aa1303e1     	mov	x1, x19
    6658: 97fffe72     	bl	0x6020 <final>
    665c: a9534ff4     	ldp	x20, x19, [sp, #0x130]
    6660: a95257f6     	ldp	x22, x21, [sp, #0x120]
    6664: a9515ff8     	ldp	x24, x23, [sp, #0x110]
    6668: a9507bfd     	ldp	x29, x30, [sp, #0x100]
    666c: 910503ff     	add	sp, sp, #0x140
    6670: d65f03c0     	ret
		...

0000000000006680 <b_m_debug_sha256d_scalar>:
    6680: d10643ff     	sub	sp, sp, #0x190
    6684: a9157bfd     	stp	x29, x30, [sp, #0x150]
    6688: a9165ff8     	stp	x24, x23, [sp, #0x160]
    668c: a91757f6     	stp	x22, x21, [sp, #0x170]
    6690: a9184ff4     	stp	x20, x19, [sp, #0x180]
    6694: aa0203f3     	mov	x19, x2
    6698: aa1f03e8     	mov	x8, xzr
    669c: ad410400     	ldp	q0, q1, [x0, #0x20]
    66a0: ad0907e0     	stp	q0, q1, [sp, #0x120]
    66a4: 3cc3c000     	ldur	q0, [x0, #0x3c]
    66a8: 9100f7e9     	add	x9, sp, #0x3d
    66ac: 3c8ff120     	stur	q0, [x9, #0xff]
    66b0: ad400001     	ldp	q1, q0, [x0]
    66b4: ad0803e1     	stp	q1, q0, [sp, #0x100]
    66b8: b9014fe1     	str	w1, [sp, #0x14c]
    66bc: d503201f     	nop
    66c0: 10fd45e9     	adr	x9, 0xf7c <init.h>
    66c4: ad400520     	ldp	q0, q1, [x9]
    66c8: f9005bff     	str	xzr, [sp, #0xb0]
    66cc: f9007fff     	str	xzr, [sp, #0xf8]
    66d0: 910243e9     	add	x9, sp, #0x90
    66d4: 9100a134     	add	x20, x9, #0x28
    66d8: 910403f5     	add	x21, sp, #0x100
    66dc: 52800a17     	mov	w23, #0x50              // =80
    66e0: 52800818     	mov	w24, #0x40              // =64
    66e4: ad0003e1     	stp	q1, q0, [sp]
    66e8: ad0487e0     	stp	q0, q1, [sp, #0x90]
    66ec: 14000008     	b	0x670c <b_m_debug_sha256d_scalar+0x8c>
    66f0: d503201f     	nop
    66f4: d503201f     	nop
    66f8: d503201f     	nop
    66fc: d503201f     	nop
    6700: 8b1602b5     	add	x21, x21, x22
    6704: cb1602f7     	sub	x23, x23, x22
    6708: b40002d7     	cbz	x23, 0x6760 <b_m_debug_sha256d_scalar+0xe0>
    670c: cb080309     	sub	x9, x24, x8
    6710: eb17013f     	cmp	x9, x23
    6714: 9a973136     	csel	x22, x9, x23, lo
    6718: 8b080280     	add	x0, x20, x8
    671c: aa1503e1     	mov	x1, x21
    6720: aa1603e2     	mov	x2, x22
    6724: 94000ff3     	bl	0xa6f0 <memcpy@plt>
    6728: f9407fe8     	ldr	x8, [sp, #0xf8]
    672c: f9405be9     	ldr	x9, [sp, #0xb0]
    6730: 8b160108     	add	x8, x8, x22
    6734: 8b160d29     	add	x9, x9, x22, lsl #3
    6738: f9007fe8     	str	x8, [sp, #0xf8]
    673c: f9005be9     	str	x9, [sp, #0xb0]
    6740: f101011f     	cmp	x8, #0x40
    6744: 54fffde1     	b.ne	0x6700 <b_m_debug_sha256d_scalar+0x80>
    6748: 910243e0     	add	x0, sp, #0x90
    674c: aa1403e1     	mov	x1, x20
    6750: 97fffdb4     	bl	0x5e20 <transform>
    6754: aa1f03e8     	mov	x8, xzr
    6758: f9007fff     	str	xzr, [sp, #0xf8]
    675c: 17ffffe9     	b	0x6700 <b_m_debug_sha256d_scalar+0x80>
    6760: 910083e8     	add	x8, sp, #0x20
    6764: 910243e0     	add	x0, sp, #0x90
    6768: 9100a101     	add	x1, x8, #0x28
    676c: 97fffe2d     	bl	0x6020 <final>
    6770: 52800408     	mov	w8, #0x20               // =32
    6774: 52802009     	mov	w9, #0x100              // =256
    6778: f90047e8     	str	x8, [sp, #0x88]
    677c: f90023e9     	str	x9, [sp, #0x40]
    6780: ad4007e0     	ldp	q0, q1, [sp]
    6784: ad0103e1     	stp	q1, q0, [sp, #0x20]
    6788: 910083e0     	add	x0, sp, #0x20
    678c: aa1303e1     	mov	x1, x19
    6790: 97fffe24     	bl	0x6020 <final>
    6794: a9584ff4     	ldp	x20, x19, [sp, #0x180]
    6798: a95757f6     	ldp	x22, x21, [sp, #0x170]
    679c: a9565ff8     	ldp	x24, x23, [sp, #0x160]
    67a0: a9557bfd     	ldp	x29, x30, [sp, #0x150]
    67a4: 910643ff     	add	sp, sp, #0x190
    67a8: d65f03c0     	ret
    67ac: 00000000     	udf	#0x0

00000000000067b0 <b_m_debug_sha256d_optimized>:
    67b0: d10243ff     	sub	sp, sp, #0x90
    67b4: a90757fe     	stp	x30, x21, [sp, #0x70]
    67b8: a9084ff4     	stp	x20, x19, [sp, #0x80]
    67bc: aa0203f3     	mov	x19, x2
    67c0: 2a0103f4     	mov	w20, w1
    67c4: aa0003f5     	mov	x21, x0
    67c8: ad400400     	ldp	q0, q1, [x0]
    67cc: 3c8283e0     	stur	q0, [sp, #0x28]
    67d0: d503201f     	nop
    67d4: 10fd3d48     	adr	x8, 0xf7c <init.h>
    67d8: 3c8383e1     	stur	q1, [sp, #0x38]
    67dc: ad400500     	ldp	q0, q1, [x8]
    67e0: ad0007e0     	stp	q0, q1, [sp]
    67e4: ad410400     	ldp	q0, q1, [x0, #0x20]
    67e8: 3c8483e0     	stur	q0, [sp, #0x48]
    67ec: 910003e8     	mov	x8, sp
    67f0: 52800809     	mov	w9, #0x40               // =64
    67f4: f90037e9     	str	x9, [sp, #0x68]
    67f8: 52804009     	mov	w9, #0x200              // =512
    67fc: f90013e9     	str	x9, [sp, #0x20]
    6800: 3c8583e1     	stur	q1, [sp, #0x58]
    6804: 910003e0     	mov	x0, sp
    6808: 9100a101     	add	x1, x8, #0x28
    680c: 97fffd85     	bl	0x5e20 <transform>
    6810: 294826a8     	ldp	w8, w9, [x21, #0x40]
    6814: 5ac00908     	rev	w8, w8
    6818: 5ac00929     	rev	w9, w9
    681c: 1e270110     	fmov	s16, w8
    6820: 4e0c1d30     	mov	v16.s[1], w9
    6824: b9404aa8     	ldr	w8, [x21, #0x48]
    6828: 5ac00908     	rev	w8, w8
    682c: 4e141d10     	mov	v16.s[2], w8
    6830: 5ac00a88     	rev	w8, w20
    6834: 4e1c1d10     	mov	v16.s[3], w8
    6838: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    683c: 3dc34103     	ldr	q3, [x8, #0xd00]
    6840: ad4007e4     	ldp	q4, q1, [sp]
    6844: 4ea38600     	add	v0.4s, v16.4s, v3.4s
    6848: 4ea41c85     	mov	v5.16b, v4.16b
    684c: 5e004025     	sha256h	q5, q1, v0.4s
    6850: 4ea11c22     	mov	v2.16b, v1.16b
    6854: 5e005082     	sha256h2	q2, q4, v0.4s
    6858: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    685c: 3dc36100     	ldr	q0, [x8, #0xd80]
    6860: 4ea51ca6     	mov	v6.16b, v5.16b
    6864: 5e004046     	sha256h	q6, q2, v0.4s
    6868: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    686c: 5e0050a2     	sha256h2	q2, q5, v0.4s
    6870: 3dc38105     	ldr	q5, [x8, #0xe00]
    6874: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6878: 3dc39500     	ldr	q0, [x8, #0xe50]
    687c: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6880: 4ea61cc7     	mov	v7.16b, v6.16b
    6884: 5e054047     	sha256h	q7, q2, v5.4s
    6888: 3dc33519     	ldr	q25, [x8, #0xcd0]
    688c: 5e0550c2     	sha256h2	q2, q6, v5.4s
    6890: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6894: 6f00e41a     	movi	v26.2d, #0000000000000000
    6898: 3dc36506     	ldr	q6, [x8, #0xd90]
    689c: 5e282810     	sha256su0	v16.4s, v0.4s
    68a0: 5e196350     	sha256su1	v16.4s, v26.4s, v25.4s
    68a4: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    68a8: 3dc39905     	ldr	q5, [x8, #0xe60]
    68ac: 4ea71cf1     	mov	v17.16b, v7.16b
    68b0: 5e064051     	sha256h	q17, q2, v6.4s
    68b4: 4ea01c1b     	mov	v27.16b, v0.16b
    68b8: 5e0650e2     	sha256h2	q2, q7, v6.4s
    68bc: 5e282b5b     	sha256su0	v27.4s, v26.4s
    68c0: 4ea58606     	add	v6.4s, v16.4s, v5.4s
    68c4: 5e10633b     	sha256su1	v27.4s, v25.4s, v16.4s
    68c8: 4eb11e32     	mov	v18.16b, v17.16b
    68cc: 5e064052     	sha256h	q18, q2, v6.4s
    68d0: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    68d4: 5e065222     	sha256h2	q2, q17, v6.4s
    68d8: 3dc3bd06     	ldr	q6, [x8, #0xef0]
    68dc: 5e282b3a     	sha256su0	v26.4s, v25.4s
    68e0: 4ea68771     	add	v17.4s, v27.4s, v6.4s
    68e4: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    68e8: 5e1b621a     	sha256su1	v26.4s, v16.4s, v27.4s
    68ec: 4eb21e53     	mov	v19.16b, v18.16b
    68f0: 5e114053     	sha256h	q19, q2, v17.4s
    68f4: 3dc38507     	ldr	q7, [x8, #0xe10]
    68f8: 5e115242     	sha256h2	q2, q18, v17.4s
    68fc: 5e282a19     	sha256su0	v25.4s, v16.4s
    6900: 4ea78752     	add	v18.4s, v26.4s, v7.4s
    6904: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6908: 5e1a6379     	sha256su1	v25.4s, v27.4s, v26.4s
    690c: 3dc38911     	ldr	q17, [x8, #0xe20]
    6910: 4eb31e74     	mov	v20.16b, v19.16b
    6914: 5e124054     	sha256h	q20, q2, v18.4s
    6918: 5e125262     	sha256h2	q2, q19, v18.4s
    691c: 5e282b70     	sha256su0	v16.4s, v27.4s
    6920: 4eb18732     	add	v18.4s, v25.4s, v17.4s
    6924: 5e196350     	sha256su1	v16.4s, v26.4s, v25.4s
    6928: 4eb41e95     	mov	v21.16b, v20.16b
    692c: 5e124055     	sha256h	q21, q2, v18.4s
    6930: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6934: 5e125282     	sha256h2	q2, q20, v18.4s
    6938: 3dc3a912     	ldr	q18, [x8, #0xea0]
    693c: 5e282b5b     	sha256su0	v27.4s, v26.4s
    6940: 4eb28614     	add	v20.4s, v16.4s, v18.4s
    6944: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6948: 5e10633b     	sha256su1	v27.4s, v25.4s, v16.4s
    694c: 4eb51eb6     	mov	v22.16b, v21.16b
    6950: 5e144056     	sha256h	q22, q2, v20.4s
    6954: 3dc38d13     	ldr	q19, [x8, #0xe30]
    6958: 5e1452a2     	sha256h2	q2, q21, v20.4s
    695c: 5e282b3a     	sha256su0	v26.4s, v25.4s
    6960: 4eb38775     	add	v21.4s, v27.4s, v19.4s
    6964: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6968: 5e1b621a     	sha256su1	v26.4s, v16.4s, v27.4s
    696c: 3dc35114     	ldr	q20, [x8, #0xd40]
    6970: 4eb61ed7     	mov	v23.16b, v22.16b
    6974: 5e154057     	sha256h	q23, q2, v21.4s
    6978: 5e1552c2     	sha256h2	q2, q22, v21.4s
    697c: 5e282a19     	sha256su0	v25.4s, v16.4s
    6980: 4eb48755     	add	v21.4s, v26.4s, v20.4s
    6984: 5e1a6379     	sha256su1	v25.4s, v27.4s, v26.4s
    6988: 4eb71ef8     	mov	v24.16b, v23.16b
    698c: 5e154058     	sha256h	q24, q2, v21.4s
    6990: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6994: 5e1552e2     	sha256h2	q2, q23, v21.4s
    6998: 3dc34915     	ldr	q21, [x8, #0xd20]
    699c: 5e282b70     	sha256su0	v16.4s, v27.4s
    69a0: 4eb58737     	add	v23.4s, v25.4s, v21.4s
    69a4: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    69a8: 5e196350     	sha256su1	v16.4s, v26.4s, v25.4s
    69ac: 4eb81f1c     	mov	v28.16b, v24.16b
    69b0: 5e17405c     	sha256h	q28, q2, v23.4s
    69b4: 3dc36916     	ldr	q22, [x8, #0xda0]
    69b8: 5e175302     	sha256h2	q2, q24, v23.4s
    69bc: 5e282b5b     	sha256su0	v27.4s, v26.4s
    69c0: 4eb68618     	add	v24.4s, v16.4s, v22.4s
    69c4: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    69c8: 5e10633b     	sha256su1	v27.4s, v25.4s, v16.4s
    69cc: 3dc33917     	ldr	q23, [x8, #0xce0]
    69d0: 4ebc1f9d     	mov	v29.16b, v28.16b
    69d4: 5e18405d     	sha256h	q29, q2, v24.4s
    69d8: 5e185382     	sha256h2	q2, q28, v24.4s
    69dc: 5e282b3a     	sha256su0	v26.4s, v25.4s
    69e0: 4eb78778     	add	v24.4s, v27.4s, v23.4s
    69e4: 5e1b621a     	sha256su1	v26.4s, v16.4s, v27.4s
    69e8: 4ebd1fbc     	mov	v28.16b, v29.16b
    69ec: 5e18405c     	sha256h	q28, q2, v24.4s
    69f0: 5e1853a2     	sha256h2	q2, q29, v24.4s
    69f4: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    69f8: 3dc36d18     	ldr	q24, [x8, #0xdb0]
    69fc: 5e282a19     	sha256su0	v25.4s, v16.4s
    6a00: 4eb88750     	add	v16.4s, v26.4s, v24.4s
    6a04: 5e1a6379     	sha256su1	v25.4s, v27.4s, v26.4s
    6a08: 4ebc1f9b     	mov	v27.16b, v28.16b
    6a0c: 5e10405b     	sha256h	q27, q2, v16.4s
    6a10: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6a14: 5e105382     	sha256h2	q2, q28, v16.4s
    6a18: 3dc35510     	ldr	q16, [x8, #0xd50]
    6a1c: 4eb0873c     	add	v28.4s, v25.4s, v16.4s
    6a20: 4ebb1f7a     	mov	v26.16b, v27.16b
    6a24: 5e1c405a     	sha256h	q26, q2, v28.4s
    6a28: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6a2c: d0ffffc9     	adrp	x9, 0x0 <pthread_mutex_unlock>
    6a30: 3dc3b119     	ldr	q25, [x8, #0xec0]
    6a34: 4ea4875a     	add	v26.4s, v26.4s, v4.4s
    6a38: 3dc39d24     	ldr	q4, [x9, #0xe70]
    6a3c: 5e1c5362     	sha256h2	q2, q27, v28.4s
    6a40: 4ea3875b     	add	v27.4s, v26.4s, v3.4s
    6a44: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6a48: 3dc3291c     	ldr	q28, [x8, #0xca0]
    6a4c: 4eb91f3d     	mov	v29.16b, v25.16b
    6a50: 5e1b409d     	sha256h	q29, q4, v27.4s
    6a54: 4ea41c83     	mov	v3.16b, v4.16b
    6a58: 5e1b5323     	sha256h2	q3, q25, v27.4s
    6a5c: 4ea18441     	add	v1.4s, v2.4s, v1.4s
    6a60: 4ebc8422     	add	v2.4s, v1.4s, v28.4s
    6a64: 4ebd1fbb     	mov	v27.16b, v29.16b
    6a68: 5e02407b     	sha256h	q27, q3, v2.4s
    6a6c: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6a70: 5e0253a3     	sha256h2	q3, q29, v2.4s
    6a74: 3dc3591c     	ldr	q28, [x8, #0xd60]
    6a78: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6a7c: 4ebb1f7d     	mov	v29.16b, v27.16b
    6a80: 3dc33102     	ldr	q2, [x8, #0xcc0]
    6a84: 5e1c407d     	sha256h	q29, q3, v28.4s
    6a88: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6a8c: 5e1c5363     	sha256h2	q3, q27, v28.4s
    6a90: 3dc3911b     	ldr	q27, [x8, #0xe40]
    6a94: 5e28283a     	sha256su0	v26.4s, v1.4s
    6a98: 5e02601a     	sha256su1	v26.4s, v0.4s, v2.4s
    6a9c: 4ebd1fbc     	mov	v28.16b, v29.16b
    6aa0: 5e1b407c     	sha256h	q28, q3, v27.4s
    6aa4: 5e1b53a3     	sha256h2	q3, q29, v27.4s
    6aa8: 5e282801     	sha256su0	v1.4s, v0.4s
    6aac: 4ea58745     	add	v5.4s, v26.4s, v5.4s
    6ab0: 5e1a6041     	sha256su1	v1.4s, v2.4s, v26.4s
    6ab4: 4ebc1f9b     	mov	v27.16b, v28.16b
    6ab8: 5e05407b     	sha256h	q27, q3, v5.4s
    6abc: 5e055383     	sha256h2	q3, q28, v5.4s
    6ac0: 5e282840     	sha256su0	v0.4s, v2.4s
    6ac4: 4ea68425     	add	v5.4s, v1.4s, v6.4s
    6ac8: 5e016340     	sha256su1	v0.4s, v26.4s, v1.4s
    6acc: 4ebb1f66     	mov	v6.16b, v27.16b
    6ad0: 5e054066     	sha256h	q6, q3, v5.4s
    6ad4: 5e055363     	sha256h2	q3, q27, v5.4s
    6ad8: 5e282b42     	sha256su0	v2.4s, v26.4s
    6adc: 4ea78405     	add	v5.4s, v0.4s, v7.4s
    6ae0: 5e006022     	sha256su1	v2.4s, v1.4s, v0.4s
    6ae4: 4ea61cc7     	mov	v7.16b, v6.16b
    6ae8: 5e054067     	sha256h	q7, q3, v5.4s
    6aec: 5e0550c3     	sha256h2	q3, q6, v5.4s
    6af0: 5e28283a     	sha256su0	v26.4s, v1.4s
    6af4: 4eb18445     	add	v5.4s, v2.4s, v17.4s
    6af8: 5e02601a     	sha256su1	v26.4s, v0.4s, v2.4s
    6afc: 4ea71ce6     	mov	v6.16b, v7.16b
    6b00: 5e054066     	sha256h	q6, q3, v5.4s
    6b04: 5e0550e3     	sha256h2	q3, q7, v5.4s
    6b08: 5e282801     	sha256su0	v1.4s, v0.4s
    6b0c: 4eb28745     	add	v5.4s, v26.4s, v18.4s
    6b10: 5e1a6041     	sha256su1	v1.4s, v2.4s, v26.4s
    6b14: 4ea61cc7     	mov	v7.16b, v6.16b
    6b18: 5e054067     	sha256h	q7, q3, v5.4s
    6b1c: 5e0550c3     	sha256h2	q3, q6, v5.4s
    6b20: 5e282840     	sha256su0	v0.4s, v2.4s
    6b24: 4eb38425     	add	v5.4s, v1.4s, v19.4s
    6b28: 5e016340     	sha256su1	v0.4s, v26.4s, v1.4s
    6b2c: 4ea71ce6     	mov	v6.16b, v7.16b
    6b30: 5e054066     	sha256h	q6, q3, v5.4s
    6b34: 5e0550e3     	sha256h2	q3, q7, v5.4s
    6b38: 5e282b42     	sha256su0	v2.4s, v26.4s
    6b3c: 4eb48405     	add	v5.4s, v0.4s, v20.4s
    6b40: 5e006022     	sha256su1	v2.4s, v1.4s, v0.4s
    6b44: 4ea61cc7     	mov	v7.16b, v6.16b
    6b48: 5e054067     	sha256h	q7, q3, v5.4s
    6b4c: 5e0550c3     	sha256h2	q3, q6, v5.4s
    6b50: 5e28283a     	sha256su0	v26.4s, v1.4s
    6b54: 4eb58445     	add	v5.4s, v2.4s, v21.4s
    6b58: 5e02601a     	sha256su1	v26.4s, v0.4s, v2.4s
    6b5c: 4ea71ce6     	mov	v6.16b, v7.16b
    6b60: 5e054066     	sha256h	q6, q3, v5.4s
    6b64: 5e0550e3     	sha256h2	q3, q7, v5.4s
    6b68: 5e282801     	sha256su0	v1.4s, v0.4s
    6b6c: 4eb68745     	add	v5.4s, v26.4s, v22.4s
    6b70: 5e1a6041     	sha256su1	v1.4s, v2.4s, v26.4s
    6b74: 4ea61cc7     	mov	v7.16b, v6.16b
    6b78: 5e054067     	sha256h	q7, q3, v5.4s
    6b7c: 5e0550c3     	sha256h2	q3, q6, v5.4s
    6b80: 5e282840     	sha256su0	v0.4s, v2.4s
    6b84: 4eb78425     	add	v5.4s, v1.4s, v23.4s
    6b88: 5e016340     	sha256su1	v0.4s, v26.4s, v1.4s
    6b8c: 4ea71ce6     	mov	v6.16b, v7.16b
    6b90: 5e054066     	sha256h	q6, q3, v5.4s
    6b94: 5e0550e3     	sha256h2	q3, q7, v5.4s
    6b98: 5e282b42     	sha256su0	v2.4s, v26.4s
    6b9c: 4eb88405     	add	v5.4s, v0.4s, v24.4s
    6ba0: 5e006022     	sha256su1	v2.4s, v1.4s, v0.4s
    6ba4: 4ea61cc0     	mov	v0.16b, v6.16b
    6ba8: 5e054060     	sha256h	q0, q3, v5.4s
    6bac: 5e0550c3     	sha256h2	q3, q6, v5.4s
    6bb0: 4eb08441     	add	v1.4s, v2.4s, v16.4s
    6bb4: 4ea01c02     	mov	v2.16b, v0.16b
    6bb8: 5e014062     	sha256h	q2, q3, v1.4s
    6bbc: 5e015003     	sha256h2	q3, q0, v1.4s
    6bc0: 4eb98440     	add	v0.4s, v2.4s, v25.4s
    6bc4: 4ea48461     	add	v1.4s, v3.4s, v4.4s
    6bc8: 6e200800     	rev32	v0.16b, v0.16b
    6bcc: 6e200821     	rev32	v1.16b, v1.16b
    6bd0: ad000660     	stp	q0, q1, [x19]
    6bd4: a9484ff4     	ldp	x20, x19, [sp, #0x80]
    6bd8: a94757fe     	ldp	x30, x21, [sp, #0x70]
    6bdc: 910243ff     	add	sp, sp, #0x90
    6be0: d65f03c0     	ret
		...

0000000000006c00 <b_m_mine_parallel>:
    6c00: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
    6c04: a9016ffc     	stp	x28, x27, [sp, #0x10]
    6c08: a90267fa     	stp	x26, x25, [sp, #0x20]
    6c0c: a9035ff8     	stp	x24, x23, [sp, #0x30]
    6c10: a90457f6     	stp	x22, x21, [sp, #0x40]
    6c14: a9054ff4     	stp	x20, x19, [sp, #0x50]
    6c18: d1400fff     	sub	sp, sp, #0x3, lsl #12   // =0x3000
    6c1c: d10ac3ff     	sub	sp, sp, #0x2b0
    6c20: a9011be5     	stp	x5, x6, [sp, #0x10]
    6c24: aa0403f8     	mov	x24, x4
    6c28: 2a0303f9     	mov	w25, w3
    6c2c: 2a0203f7     	mov	w23, w2
    6c30: aa0103f5     	mov	x21, x1
    6c34: aa0003f6     	mov	x22, x0
    6c38: 91400fe8     	add	x8, sp, #0x3, lsl #12   // =0x3000
    6c3c: 91090108     	add	x8, x8, #0x240
    6c40: ad400400     	ldp	q0, q1, [x0]
    6c44: 3c828100     	stur	q0, [x8, #0x28]
    6c48: d503201f     	nop
    6c4c: 10fd1989     	adr	x9, 0xf7c <init.h>
    6c50: ad400920     	ldp	q0, q2, [x9]
    6c54: 3d8c93e0     	str	q0, [sp, #0x3240]
    6c58: 3d8c97e2     	str	q2, [sp, #0x3250]
    6c5c: 3c838101     	stur	q1, [x8, #0x38]
    6c60: ad410400     	ldp	q0, q1, [x0, #0x20]
    6c64: 3c848100     	stur	q0, [x8, #0x48]
    6c68: 52800813     	mov	w19, #0x40              // =64
    6c6c: 52804009     	mov	w9, #0x200              // =512
    6c70: f91957f3     	str	x19, [sp, #0x32a8]
    6c74: f91933e9     	str	x9, [sp, #0x3260]
    6c78: 3c858101     	stur	q1, [x8, #0x58]
    6c7c: 91400fe0     	add	x0, sp, #0x3, lsl #12   // =0x3000
    6c80: 91090000     	add	x0, x0, #0x240
    6c84: 9100a101     	add	x1, x8, #0x28
    6c88: 97fffc66     	bl	0x5e20 <transform>
    6c8c: aa1f03fa     	mov	x26, xzr
    6c90: 7100073f     	cmp	w25, #0x1
    6c94: f91957ff     	str	xzr, [sp, #0x32a8]
    6c98: 2a1703fc     	mov	w28, w23
    6c9c: 910083f7     	add	x23, sp, #0x20
    6ca0: b9323fff     	str	wzr, [sp, #0x323c]
    6ca4: 1a9f8728     	csinc	w8, w25, wzr, hi
    6ca8: 8b1c0309     	add	x9, x24, x28
    6cac: b9323bff     	str	wzr, [sp, #0x3238]
    6cb0: 7101011f     	cmp	w8, #0x40
    6cb4: 1a93311b     	csel	w27, w8, w19, lo
    6cb8: b93237ff     	str	wzr, [sp, #0x3234]
    6cbc: f100031f     	cmp	x24, #0x0
    6cc0: 9a8903fd     	csel	x29, xzr, x9, eq
    6cc4: f91917fc     	str	x28, [sp, #0x3228]
    6cc8: 910883f8     	add	x24, sp, #0x220
    6ccc: f91913ff     	str	xzr, [sp, #0x3220]
    6cd0: 91400ff4     	add	x20, sp, #0x3, lsl #12  // =0x3000
    6cd4: 9108e294     	add	x20, x20, #0x238
    6cd8: 91400ff3     	add	x19, sp, #0x3, lsl #12  // =0x3000
    6cdc: 9108d273     	add	x19, x19, #0x234
    6ce0: d503201f     	nop
    6ce4: 100008f9     	adr	x25, 0x6e00 <bm_parallel_posix>
    6ce8: 3dcca3e0     	ldr	q0, [sp, #0x3280]
    6cec: 3dcca7e1     	ldr	q1, [sp, #0x3290]
    6cf0: 3dccabe2     	ldr	q2, [sp, #0x32a0]
    6cf4: ad028700     	stp	q0, q1, [x24, #0x50]
    6cf8: 3d801f02     	str	q2, [x24, #0x70]
    6cfc: 3dcc93e0     	ldr	q0, [sp, #0x3240]
    6d00: 3dcc97e1     	ldr	q1, [sp, #0x3250]
    6d04: ad008700     	stp	q0, q1, [x24, #0x10]
    6d08: a9005716     	stp	x22, x21, [x24]
    6d0c: 3dcc9fe0     	ldr	q0, [sp, #0x3270]
    6d10: 3dcc9be1     	ldr	q1, [sp, #0x3260]
    6d14: 0b1a0388     	add	w8, w28, w26
    6d18: 29106f08     	stp	w8, w27, [x24, #0x80]
    6d1c: 91400fe8     	add	x8, sp, #0x3, lsl #12   // =0x3000
    6d20: 9108a108     	add	x8, x8, #0x228
    6d24: a908a31d     	stp	x29, x8, [x24, #0x88]
    6d28: 91400fe8     	add	x8, sp, #0x3, lsl #12   // =0x3000
    6d2c: 91088108     	add	x8, x8, #0x220
    6d30: f9004f08     	str	x8, [x24, #0x98]
    6d34: 91400fe8     	add	x8, sp, #0x3, lsl #12   // =0x3000
    6d38: 9108f108     	add	x8, x8, #0x23c
    6d3c: a90a5308     	stp	x8, x20, [x24, #0xa0]
    6d40: f9005b13     	str	x19, [x24, #0xb0]
    6d44: ad018301     	stp	q1, q0, [x24, #0x30]
    6d48: aa1703e0     	mov	x0, x23
    6d4c: aa1f03e1     	mov	x1, xzr
    6d50: aa1903e2     	mov	x2, x25
    6d54: aa1803e3     	mov	x3, x24
    6d58: 94000e2a     	bl	0xa600 <pthread_create@plt>
    6d5c: 35000100     	cbnz	w0, 0x6d7c <b_m_mine_parallel+0x17c>
    6d60: 9100075a     	add	x26, x26, #0x1
    6d64: 910022f7     	add	x23, x23, #0x8
    6d68: 91030318     	add	x24, x24, #0xc0
    6d6c: eb1a037f     	cmp	x27, x26
    6d70: 54fffbc1     	b.ne	0x6ce8 <b_m_mine_parallel+0xe8>
    6d74: f9400ff4     	ldr	x20, [sp, #0x18]
    6d78: 14000004     	b	0x6d88 <b_m_mine_parallel+0x188>
    6d7c: f9400ff4     	ldr	x20, [sp, #0x18]
    6d80: b400011a     	cbz	x26, 0x6da0 <b_m_mine_parallel+0x1a0>
    6d84: 2a1a03fb     	mov	w27, w26
    6d88: 910083f3     	add	x19, sp, #0x20
    6d8c: f8408660     	ldr	x0, [x19], #0x8
    6d90: aa1f03e1     	mov	x1, xzr
    6d94: 94000e1f     	bl	0xa610 <pthread_join@plt>
    6d98: f100077b     	subs	x27, x27, #0x1
    6d9c: 54ffff81     	b.ne	0x6d8c <b_m_mine_parallel+0x18c>
    6da0: f95913e8     	ldr	x8, [sp, #0x3220]
    6da4: f9000288     	str	x8, [x20]
    6da8: b9723be8     	ldr	w8, [sp, #0x3238]
    6dac: 340000c8     	cbz	w8, 0x6dc4 <b_m_mine_parallel+0x1c4>
    6db0: b97237e8     	ldr	w8, [sp, #0x3234]
    6db4: f9400be9     	ldr	x9, [sp, #0x10]
    6db8: b9000128     	str	w8, [x9]
    6dbc: 52800020     	mov	w0, #0x1                // =1
    6dc0: 14000002     	b	0x6dc8 <b_m_mine_parallel+0x1c8>
    6dc4: 2a1f03e0     	mov	w0, wzr
    6dc8: 91400fff     	add	sp, sp, #0x3, lsl #12   // =0x3000
    6dcc: 910ac3ff     	add	sp, sp, #0x2b0
    6dd0: a9454ff4     	ldp	x20, x19, [sp, #0x50]
    6dd4: a94457f6     	ldp	x22, x21, [sp, #0x40]
    6dd8: a9435ff8     	ldp	x24, x23, [sp, #0x30]
    6ddc: a94267fa     	ldp	x26, x25, [sp, #0x20]
    6de0: a9416ffc     	ldp	x28, x27, [sp, #0x10]
    6de4: a8c67bfd     	ldp	x29, x30, [sp], #0x60
    6de8: d65f03c0     	ret
		...

0000000000006e00 <bm_parallel_posix>:
    6e00: d10783ff     	sub	sp, sp, #0x1e0
    6e04: fd00dbe8     	str	d8, [sp, #0x1b0]
    6e08: f900dffd     	str	x29, [sp, #0x1b8]
    6e0c: a91c57fe     	stp	x30, x21, [sp, #0x1c0]
    6e10: a91d4ff4     	stp	x20, x19, [sp, #0x1d0]
    6e14: f9405008     	ldr	x8, [x0, #0xa0]
    6e18: b9400108     	ldr	w8, [x8]
    6e1c: 35003108     	cbnz	w8, 0x743c <bm_parallel_posix+0x63c>
    6e20: aa0003f3     	mov	x19, x0
    6e24: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6e28: 3dc39500     	ldr	q0, [x8, #0xe50]
    6e2c: 52bfff94     	mov	w20, #-0x40000          // =-262144
    6e30: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6e34: 3dc33501     	ldr	q1, [x8, #0xcd0]
    6e38: d2c00035     	mov	x21, #0x100000000       // =4294967296
    6e3c: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6e40: 3dc34102     	ldr	q2, [x8, #0xd00]
    6e44: 3d806be2     	str	q2, [sp, #0x1a0]
    6e48: 6f00e402     	movi	v2.2d, #0000000000000000
    6e4c: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6e50: 3dc33103     	ldr	q3, [x8, #0xcc0]
    6e54: 6f00e404     	movi	v4.2d, #0000000000000000
    6e58: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6e5c: 3dc36105     	ldr	q5, [x8, #0xd80]
    6e60: 3d8053e5     	str	q5, [sp, #0x140]
    6e64: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6e68: 3dc38105     	ldr	q5, [x8, #0xe00]
    6e6c: 3d804fe5     	str	q5, [sp, #0x130]
    6e70: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6e74: 3dc36505     	ldr	q5, [x8, #0xd90]
    6e78: 3d804be5     	str	q5, [sp, #0x120]
    6e7c: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6e80: 4ea01c05     	mov	v5.16b, v0.16b
    6e84: 3dc39906     	ldr	q6, [x8, #0xe60]
    6e88: ad0b83e1     	stp	q1, q0, [sp, #0x170]
    6e8c: 5e282824     	sha256su0	v4.4s, v1.4s
    6e90: 3d8057e4     	str	q4, [sp, #0x150]
    6e94: 5e282845     	sha256su0	v5.4s, v2.4s
    6e98: ad0817e6     	stp	q6, q5, [sp, #0x100]
    6e9c: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6ea0: 3dc3bd01     	ldr	q1, [x8, #0xef0]
    6ea4: 3d805be3     	str	q3, [sp, #0x160]
    6ea8: 5e282860     	sha256su0	v0.4s, v3.4s
    6eac: ad0703e1     	stp	q1, q0, [sp, #0xe0]
    6eb0: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6eb4: 3dc38500     	ldr	q0, [x8, #0xe10]
    6eb8: 3d8037e0     	str	q0, [sp, #0xd0]
    6ebc: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6ec0: 3dc38900     	ldr	q0, [x8, #0xe20]
    6ec4: 3d8033e0     	str	q0, [sp, #0xc0]
    6ec8: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6ecc: 3dc3a900     	ldr	q0, [x8, #0xea0]
    6ed0: 3d802fe0     	str	q0, [sp, #0xb0]
    6ed4: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6ed8: 3dc38d00     	ldr	q0, [x8, #0xe30]
    6edc: 3d802be0     	str	q0, [sp, #0xa0]
    6ee0: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6ee4: 3dc35100     	ldr	q0, [x8, #0xd40]
    6ee8: 3d8027e0     	str	q0, [sp, #0x90]
    6eec: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6ef0: 3dc34900     	ldr	q0, [x8, #0xd20]
    6ef4: 3d8023e0     	str	q0, [sp, #0x80]
    6ef8: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6efc: 3dc36900     	ldr	q0, [x8, #0xda0]
    6f00: 3d801fe0     	str	q0, [sp, #0x70]
    6f04: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6f08: 3dc33900     	ldr	q0, [x8, #0xce0]
    6f0c: 3d801be0     	str	q0, [sp, #0x60]
    6f10: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6f14: 3dc36d00     	ldr	q0, [x8, #0xdb0]
    6f18: 3d8017e0     	str	q0, [sp, #0x50]
    6f1c: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6f20: 3dc35500     	ldr	q0, [x8, #0xd50]
    6f24: 3d8013e0     	str	q0, [sp, #0x40]
    6f28: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6f2c: 3dc39d00     	ldr	q0, [x8, #0xe70]
    6f30: 3d800fe0     	str	q0, [sp, #0x30]
    6f34: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6f38: 3dc3b100     	ldr	q0, [x8, #0xec0]
    6f3c: 3d8067e0     	str	q0, [sp, #0x190]
    6f40: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6f44: 3dc32900     	ldr	q0, [x8, #0xca0]
    6f48: 3d800be0     	str	q0, [sp, #0x20]
    6f4c: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6f50: 3dc35900     	ldr	q0, [x8, #0xd60]
    6f54: 3d8007e0     	str	q0, [sp, #0x10]
    6f58: d0ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    6f5c: 3dc39100     	ldr	q0, [x8, #0xe40]
    6f60: 3d8003e0     	str	q0, [sp]
    6f64: f9404a61     	ldr	x1, [x19, #0x90]
    6f68: 52a00080     	mov	w0, #0x40000            // =262144
    6f6c: 97fffa0d     	bl	0x57a0 <__aarch64_ldadd8_relax>
    6f70: d360fc08     	lsr	x8, x0, #32
    6f74: b5002648     	cbnz	x8, 0x743c <bm_parallel_posix+0x63c>
    6f78: eb14001f     	cmp	x0, x20
    6f7c: 9a943008     	csel	x8, x0, x20, lo
    6f80: 91410108     	add	x8, x8, #0x40, lsl #12  // =0x40000
    6f84: f9404669     	ldr	x9, [x19, #0x88]
    6f88: f100013f     	cmp	x9, #0x0
    6f8c: 9a8902a9     	csel	x9, x21, x9, eq
    6f90: eb09011f     	cmp	x8, x9
    6f94: 9a893108     	csel	x8, x8, x9, lo
    6f98: f9005e7f     	str	xzr, [x19, #0xb8]
    6f9c: eb08001f     	cmp	x0, x8
    6fa0: 54000082     	b.hs	0x6fb0 <bm_parallel_posix+0x1b0>
    6fa4: f9405269     	ldr	x9, [x19, #0xa0]
    6fa8: b940012a     	ldr	w10, [x9]
    6fac: 3400012a     	cbz	w10, 0x6fd0 <bm_parallel_posix+0x1d0>
    6fb0: aa1f03e8     	mov	x8, xzr
    6fb4: f9404e61     	ldr	x1, [x19, #0x98]
    6fb8: aa0803e0     	mov	x0, x8
    6fbc: 97fff9f9     	bl	0x57a0 <__aarch64_ldadd8_relax>
    6fc0: f9405268     	ldr	x8, [x19, #0xa0]
    6fc4: b9400108     	ldr	w8, [x8]
    6fc8: 34fffce8     	cbz	w8, 0x6f64 <bm_parallel_posix+0x164>
    6fcc: 1400011c     	b	0x743c <bm_parallel_posix+0x63c>
    6fd0: a9402e6a     	ldp	x10, x11, [x19]
    6fd4: ad408660     	ldp	q0, q1, [x19, #0x10]
    6fd8: 3dc06be2     	ldr	q2, [sp, #0x1a0]
    6fdc: 4ea28402     	add	v2.4s, v0.4s, v2.4s
    6fe0: d100050c     	sub	x12, x8, #0x1
    6fe4: 29483548     	ldp	w8, w13, [x10, #0x40]
    6fe8: 5ac00908     	rev	w8, w8
    6fec: 5ac009ad     	rev	w13, w13
    6ff0: b940494e     	ldr	w14, [x10, #0x48]
    6ff4: 5ac009ce     	rev	w14, w14
    6ff8: 1e270104     	fmov	s4, w8
    6ffc: 4e0c1da4     	mov	v4.s[1], w13
    7000: 5ac00808     	rev	w8, w0
    7004: 4e141dc4     	mov	v4.s[2], w14
    7008: 4e1c1d04     	mov	v4.s[3], w8
    700c: 3dc06be3     	ldr	q3, [sp, #0x1a0]
    7010: 4ea38485     	add	v5.4s, v4.4s, v3.4s
    7014: 4ea01c06     	mov	v6.16b, v0.16b
    7018: 5e054026     	sha256h	q6, q1, v5.4s
    701c: 4ea11c23     	mov	v3.16b, v1.16b
    7020: 5e055003     	sha256h2	q3, q0, v5.4s
    7024: ad4bcff1     	ldp	q17, q19, [sp, #0x170]
    7028: 5e282a64     	sha256su0	v4.4s, v19.4s
    702c: 6f00e405     	movi	v5.2d, #0000000000000000
    7030: 5e1160a4     	sha256su1	v4.4s, v5.4s, v17.4s
    7034: 4ea61cc5     	mov	v5.16b, v6.16b
    7038: 3dc053e7     	ldr	q7, [sp, #0x140]
    703c: 5e074065     	sha256h	q5, q3, v7.4s
    7040: 5e0750c3     	sha256h2	q3, q6, v7.4s
    7044: ad48cbe6     	ldp	q6, q18, [sp, #0x110]
    7048: 5e046226     	sha256su1	v6.4s, v17.4s, v4.4s
    704c: 4ea51cb0     	mov	v16.16b, v5.16b
    7050: 3dc04fe7     	ldr	q7, [sp, #0x130]
    7054: 5e074070     	sha256h	q16, q3, v7.4s
    7058: 5e0750a3     	sha256h2	q3, q5, v7.4s
    705c: 3dc057e7     	ldr	q7, [sp, #0x150]
    7060: 5e066087     	sha256su1	v7.4s, v4.4s, v6.4s
    7064: 4eb11e25     	mov	v5.16b, v17.16b
    7068: 4eb01e11     	mov	v17.16b, v16.16b
    706c: 5e124071     	sha256h	q17, q3, v18.4s
    7070: 5e282885     	sha256su0	v5.4s, v4.4s
    7074: 5e125203     	sha256h2	q3, q16, v18.4s
    7078: 5e0760c5     	sha256su1	v5.4s, v6.4s, v7.4s
    707c: 3dc043f4     	ldr	q20, [sp, #0x100]
    7080: 4eb48490     	add	v16.4s, v4.4s, v20.4s
    7084: 4eb11e32     	mov	v18.16b, v17.16b
    7088: 5e104072     	sha256h	q18, q3, v16.4s
    708c: 5e2828c4     	sha256su0	v4.4s, v6.4s
    7090: 5e105223     	sha256h2	q3, q17, v16.4s
    7094: 5e0560e4     	sha256su1	v4.4s, v7.4s, v5.4s
    7098: ad46d7f6     	ldp	q22, q21, [sp, #0xd0]
    709c: 4eb584d0     	add	v16.4s, v6.4s, v21.4s
    70a0: 4eb21e51     	mov	v17.16b, v18.16b
    70a4: 5e104071     	sha256h	q17, q3, v16.4s
    70a8: 5e2828e6     	sha256su0	v6.4s, v7.4s
    70ac: 5e105243     	sha256h2	q3, q18, v16.4s
    70b0: 5e0460a6     	sha256su1	v6.4s, v5.4s, v4.4s
    70b4: 4eb684f0     	add	v16.4s, v7.4s, v22.4s
    70b8: 4eb11e32     	mov	v18.16b, v17.16b
    70bc: 5e104072     	sha256h	q18, q3, v16.4s
    70c0: 5e2828a7     	sha256su0	v7.4s, v5.4s
    70c4: 5e105223     	sha256h2	q3, q17, v16.4s
    70c8: 5e066087     	sha256su1	v7.4s, v4.4s, v6.4s
    70cc: ad45dff8     	ldp	q24, q23, [sp, #0xb0]
    70d0: 4eb784b0     	add	v16.4s, v5.4s, v23.4s
    70d4: 4eb21e51     	mov	v17.16b, v18.16b
    70d8: 5e104071     	sha256h	q17, q3, v16.4s
    70dc: 5e282885     	sha256su0	v5.4s, v4.4s
    70e0: 5e105243     	sha256h2	q3, q18, v16.4s
    70e4: 5e0760c5     	sha256su1	v5.4s, v6.4s, v7.4s
    70e8: 4eb88490     	add	v16.4s, v4.4s, v24.4s
    70ec: 4eb11e32     	mov	v18.16b, v17.16b
    70f0: 5e104072     	sha256h	q18, q3, v16.4s
    70f4: 5e2828c4     	sha256su0	v4.4s, v6.4s
    70f8: 5e105223     	sha256h2	q3, q17, v16.4s
    70fc: 5e0560e4     	sha256su1	v4.4s, v7.4s, v5.4s
    7100: ad44e7fa     	ldp	q26, q25, [sp, #0x90]
    7104: 4eb984d0     	add	v16.4s, v6.4s, v25.4s
    7108: 4eb21e51     	mov	v17.16b, v18.16b
    710c: 5e104071     	sha256h	q17, q3, v16.4s
    7110: 5e2828e6     	sha256su0	v6.4s, v7.4s
    7114: 5e105243     	sha256h2	q3, q18, v16.4s
    7118: 5e0460a6     	sha256su1	v6.4s, v5.4s, v4.4s
    711c: 4eba84f0     	add	v16.4s, v7.4s, v26.4s
    7120: 4eb11e32     	mov	v18.16b, v17.16b
    7124: 5e104072     	sha256h	q18, q3, v16.4s
    7128: 5e2828a7     	sha256su0	v7.4s, v5.4s
    712c: 5e105223     	sha256h2	q3, q17, v16.4s
    7130: 5e066087     	sha256su1	v7.4s, v4.4s, v6.4s
    7134: ad43effc     	ldp	q28, q27, [sp, #0x70]
    7138: 4ebb84b0     	add	v16.4s, v5.4s, v27.4s
    713c: 4eb21e51     	mov	v17.16b, v18.16b
    7140: 5e104071     	sha256h	q17, q3, v16.4s
    7144: 5e282885     	sha256su0	v5.4s, v4.4s
    7148: 5e105243     	sha256h2	q3, q18, v16.4s
    714c: 5e0760c5     	sha256su1	v5.4s, v6.4s, v7.4s
    7150: 4ebc8484     	add	v4.4s, v4.4s, v28.4s
    7154: 4eb11e30     	mov	v16.16b, v17.16b
    7158: 5e044070     	sha256h	q16, q3, v4.4s
    715c: 5e045223     	sha256h2	q3, q17, v4.4s
    7160: ad42f7fe     	ldp	q30, q29, [sp, #0x50]
    7164: 4ebd84c4     	add	v4.4s, v6.4s, v29.4s
    7168: 4eb01e06     	mov	v6.16b, v16.16b
    716c: 5e044066     	sha256h	q6, q3, v4.4s
    7170: 5e045203     	sha256h2	q3, q16, v4.4s
    7174: 4ebe84e4     	add	v4.4s, v7.4s, v30.4s
    7178: 4ea61cc7     	mov	v7.16b, v6.16b
    717c: 5e044067     	sha256h	q7, q3, v4.4s
    7180: 5e0450c3     	sha256h2	q3, q6, v4.4s
    7184: ad41ffe8     	ldp	q8, q31, [sp, #0x30]
    7188: 4ebf84a4     	add	v4.4s, v5.4s, v31.4s
    718c: 4ea71ce6     	mov	v6.16b, v7.16b
    7190: 5e044066     	sha256h	q6, q3, v4.4s
    7194: 5e0450e3     	sha256h2	q3, q7, v4.4s
    7198: 4ea084c4     	add	v4.4s, v6.4s, v0.4s
    719c: 4ea18465     	add	v5.4s, v3.4s, v1.4s
    71a0: 4ea284c6     	add	v6.4s, v6.4s, v2.4s
    71a4: 5e2828a4     	sha256su0	v4.4s, v5.4s
    71a8: 3dc067f0     	ldr	q16, [sp, #0x190]
    71ac: 4eb01e07     	mov	v7.16b, v16.16b
    71b0: 5e064107     	sha256h	q7, q8, v6.4s
    71b4: 4ea81d03     	mov	v3.16b, v8.16b
    71b8: 5e065203     	sha256h2	q3, q16, v6.4s
    71bc: 3dc05bf2     	ldr	q18, [sp, #0x160]
    71c0: 5e126264     	sha256su1	v4.4s, v19.4s, v18.4s
    71c4: 3dc00be6     	ldr	q6, [sp, #0x20]
    71c8: 4ea684a6     	add	v6.4s, v5.4s, v6.4s
    71cc: 4ea71cf0     	mov	v16.16b, v7.16b
    71d0: 5e064070     	sha256h	q16, q3, v6.4s
    71d4: 5e0650e3     	sha256h2	q3, q7, v6.4s
    71d8: 5e282a65     	sha256su0	v5.4s, v19.4s
    71dc: 5e046245     	sha256su1	v5.4s, v18.4s, v4.4s
    71e0: 4eb01e11     	mov	v17.16b, v16.16b
    71e4: 3dc007e6     	ldr	q6, [sp, #0x10]
    71e8: 5e064071     	sha256h	q17, q3, v6.4s
    71ec: 5e065203     	sha256h2	q3, q16, v6.4s
    71f0: 3dc03fe7     	ldr	q7, [sp, #0xf0]
    71f4: 5e056087     	sha256su1	v7.4s, v4.4s, v5.4s
    71f8: 4eb21e46     	mov	v6.16b, v18.16b
    71fc: 4eb11e30     	mov	v16.16b, v17.16b
    7200: 3dc003f2     	ldr	q18, [sp]
    7204: 5e124070     	sha256h	q16, q3, v18.4s
    7208: 5e282886     	sha256su0	v6.4s, v4.4s
    720c: 5e125223     	sha256h2	q3, q17, v18.4s
    7210: 5e0760a6     	sha256su1	v6.4s, v5.4s, v7.4s
    7214: 4eb48491     	add	v17.4s, v4.4s, v20.4s
    7218: 4eb01e12     	mov	v18.16b, v16.16b
    721c: 5e114072     	sha256h	q18, q3, v17.4s
    7220: 5e2828a4     	sha256su0	v4.4s, v5.4s
    7224: 5e115203     	sha256h2	q3, q16, v17.4s
    7228: 5e0660e4     	sha256su1	v4.4s, v7.4s, v6.4s
    722c: 4eb584b0     	add	v16.4s, v5.4s, v21.4s
    7230: 4eb21e51     	mov	v17.16b, v18.16b
    7234: 5e104071     	sha256h	q17, q3, v16.4s
    7238: 5e2828e5     	sha256su0	v5.4s, v7.4s
    723c: 5e105243     	sha256h2	q3, q18, v16.4s
    7240: 5e0460c5     	sha256su1	v5.4s, v6.4s, v4.4s
    7244: 4eb684f0     	add	v16.4s, v7.4s, v22.4s
    7248: 4eb11e32     	mov	v18.16b, v17.16b
    724c: 5e104072     	sha256h	q18, q3, v16.4s
    7250: 5e2828c7     	sha256su0	v7.4s, v6.4s
    7254: 5e105223     	sha256h2	q3, q17, v16.4s
    7258: 5e056087     	sha256su1	v7.4s, v4.4s, v5.4s
    725c: 4eb784d0     	add	v16.4s, v6.4s, v23.4s
    7260: 4eb21e51     	mov	v17.16b, v18.16b
    7264: 5e104071     	sha256h	q17, q3, v16.4s
    7268: 5e282886     	sha256su0	v6.4s, v4.4s
    726c: 5e105243     	sha256h2	q3, q18, v16.4s
    7270: 5e0760a6     	sha256su1	v6.4s, v5.4s, v7.4s
    7274: 4eb88490     	add	v16.4s, v4.4s, v24.4s
    7278: 4eb11e32     	mov	v18.16b, v17.16b
    727c: 5e104072     	sha256h	q18, q3, v16.4s
    7280: 5e2828a4     	sha256su0	v4.4s, v5.4s
    7284: 5e105223     	sha256h2	q3, q17, v16.4s
    7288: 5e0660e4     	sha256su1	v4.4s, v7.4s, v6.4s
    728c: 4eb984b0     	add	v16.4s, v5.4s, v25.4s
    7290: 4eb21e51     	mov	v17.16b, v18.16b
    7294: 5e104071     	sha256h	q17, q3, v16.4s
    7298: 5e2828e5     	sha256su0	v5.4s, v7.4s
    729c: 5e105243     	sha256h2	q3, q18, v16.4s
    72a0: 5e0460c5     	sha256su1	v5.4s, v6.4s, v4.4s
    72a4: 4eba84f0     	add	v16.4s, v7.4s, v26.4s
    72a8: 4eb11e32     	mov	v18.16b, v17.16b
    72ac: 5e104072     	sha256h	q18, q3, v16.4s
    72b0: 5e105223     	sha256h2	q3, q17, v16.4s
    72b4: 4ebb84d0     	add	v16.4s, v6.4s, v27.4s
    72b8: 4eb21e51     	mov	v17.16b, v18.16b
    72bc: 5e104071     	sha256h	q17, q3, v16.4s
    72c0: 5e105243     	sha256h2	q3, q18, v16.4s
    72c4: 4ebc8490     	add	v16.4s, v4.4s, v28.4s
    72c8: 4eb11e32     	mov	v18.16b, v17.16b
    72cc: 5e104072     	sha256h	q18, q3, v16.4s
    72d0: 5e105223     	sha256h2	q3, q17, v16.4s
    72d4: 4ebd84b0     	add	v16.4s, v5.4s, v29.4s
    72d8: 4eb21e51     	mov	v17.16b, v18.16b
    72dc: 5e104071     	sha256h	q17, q3, v16.4s
    72e0: 5e105243     	sha256h2	q3, q18, v16.4s
    72e4: 5e2828c7     	sha256su0	v7.4s, v6.4s
    72e8: 5e056087     	sha256su1	v7.4s, v4.4s, v5.4s
    72ec: 5e282886     	sha256su0	v6.4s, v4.4s
    72f0: 5e0760a6     	sha256su1	v6.4s, v5.4s, v7.4s
    72f4: 4ebe84e5     	add	v5.4s, v7.4s, v30.4s
    72f8: 4eb11e24     	mov	v4.16b, v17.16b
    72fc: 5e054064     	sha256h	q4, q3, v5.4s
    7300: 5e055223     	sha256h2	q3, q17, v5.4s
    7304: 4ebf84c5     	add	v5.4s, v6.4s, v31.4s
    7308: 4ea31c66     	mov	v6.16b, v3.16b
    730c: 5e055086     	sha256h2	q6, q4, v5.4s
    7310: 4ea884c6     	add	v6.4s, v6.4s, v8.4s
    7314: 0e1c3cc8     	mov	w8, v6.s[3]
    7318: b9401d6d     	ldr	w13, [x11, #0x1c]
    731c: 5ac00908     	rev	w8, w8
    7320: 6b0d011f     	cmp	w8, w13
    7324: 54000703     	b.lo	0x7404 <bm_parallel_posix+0x604>
    7328: 540005c8     	b.hi	0x73e0 <bm_parallel_posix+0x5e0>
    732c: 0e143cc8     	mov	w8, v6.s[2]
    7330: b940196d     	ldr	w13, [x11, #0x18]
    7334: 5ac00908     	rev	w8, w8
    7338: 6b0d011f     	cmp	w8, w13
    733c: 54000643     	b.lo	0x7404 <bm_parallel_posix+0x604>
    7340: 54000508     	b.hi	0x73e0 <bm_parallel_posix+0x5e0>
    7344: 0e0c3cc8     	mov	w8, v6.s[1]
    7348: b940156d     	ldr	w13, [x11, #0x14]
    734c: 5ac00908     	rev	w8, w8
    7350: 6b0d011f     	cmp	w8, w13
    7354: 54000583     	b.lo	0x7404 <bm_parallel_posix+0x604>
    7358: 54000448     	b.hi	0x73e0 <bm_parallel_posix+0x5e0>
    735c: b9401168     	ldr	w8, [x11, #0x10]
    7360: 1e2600cd     	fmov	w13, s6
    7364: 5ac009ad     	rev	w13, w13
    7368: 6b0801bf     	cmp	w13, w8
    736c: 540004c3     	b.lo	0x7404 <bm_parallel_posix+0x604>
    7370: 54000388     	b.hi	0x73e0 <bm_parallel_posix+0x5e0>
    7374: 5e054064     	sha256h	q4, q3, v5.4s
    7378: 3dc067e3     	ldr	q3, [sp, #0x190]
    737c: 4ea38483     	add	v3.4s, v4.4s, v3.4s
    7380: 0e1c3c68     	mov	w8, v3.s[3]
    7384: b9400d6d     	ldr	w13, [x11, #0xc]
    7388: 5ac00908     	rev	w8, w8
    738c: 6b0d011f     	cmp	w8, w13
    7390: 540003a3     	b.lo	0x7404 <bm_parallel_posix+0x604>
    7394: 54000268     	b.hi	0x73e0 <bm_parallel_posix+0x5e0>
    7398: 0e143c68     	mov	w8, v3.s[2]
    739c: b940096d     	ldr	w13, [x11, #0x8]
    73a0: 5ac00908     	rev	w8, w8
    73a4: 6b0d011f     	cmp	w8, w13
    73a8: 540002e3     	b.lo	0x7404 <bm_parallel_posix+0x604>
    73ac: 540001a8     	b.hi	0x73e0 <bm_parallel_posix+0x5e0>
    73b0: 0e0c3c6d     	mov	w13, v3.s[1]
    73b4: b9400568     	ldr	w8, [x11, #0x4]
    73b8: 5ac009ad     	rev	w13, w13
    73bc: 6b0801bf     	cmp	w13, w8
    73c0: 54000223     	b.lo	0x7404 <bm_parallel_posix+0x604>
    73c4: b940016e     	ldr	w14, [x11]
    73c8: 1e26006f     	fmov	w15, s3
    73cc: 5ac009ef     	rev	w15, w15
    73d0: 6b0801bf     	cmp	w13, w8
    73d4: 7a4e91e2     	ccmp	w15, w14, #0x2, ls
    73d8: 54000169     	b.ls	0x7404 <bm_parallel_posix+0x604>
    73dc: d503201f     	nop
    73e0: f9405e68     	ldr	x8, [x19, #0xb8]
    73e4: 91000508     	add	x8, x8, #0x1
    73e8: f9005e68     	str	x8, [x19, #0xb8]
    73ec: eb00019f     	cmp	x12, x0
    73f0: 54ffde20     	b.eq	0x6fb4 <bm_parallel_posix+0x1b4>
    73f4: b940012d     	ldr	w13, [x9]
    73f8: 91000400     	add	x0, x0, #0x1
    73fc: 34ffdf4d     	cbz	w13, 0x6fe4 <bm_parallel_posix+0x1e4>
    7400: 17fffeed     	b	0x6fb4 <bm_parallel_posix+0x1b4>
    7404: aa0003f4     	mov	x20, x0
    7408: f9405662     	ldr	x2, [x19, #0xa8]
    740c: 52800035     	mov	w21, #0x1               // =1
    7410: 2a1f03e0     	mov	w0, wzr
    7414: 52800021     	mov	w1, #0x1                // =1
    7418: 97fff9e6     	bl	0x5bb0 <__aarch64_cas4_acq_rel>
    741c: 350000a0     	cbnz	w0, 0x7430 <bm_parallel_posix+0x630>
    7420: f9405a68     	ldr	x8, [x19, #0xb0]
    7424: b9000114     	str	w20, [x8]
    7428: f9405268     	ldr	x8, [x19, #0xa0]
    742c: b9000115     	str	w21, [x8]
    7430: f9404e61     	ldr	x1, [x19, #0x98]
    7434: 52800020     	mov	w0, #0x1                // =1
    7438: 97fff8da     	bl	0x57a0 <__aarch64_ldadd8_relax>
    743c: aa1f03e0     	mov	x0, xzr
    7440: a95d4ff4     	ldp	x20, x19, [sp, #0x1d0]
    7444: a95c57fe     	ldp	x30, x21, [sp, #0x1c0]
    7448: f940dffd     	ldr	x29, [sp, #0x1b8]
    744c: fd40dbe8     	ldr	d8, [sp, #0x1b0]
    7450: 910783ff     	add	sp, sp, #0x1e0
    7454: d65f03c0     	ret
		...

0000000000007460 <b_m_engine_create>:
    7460: f81c0ffe     	str	x30, [sp, #-0x40]!
    7464: a9015ff8     	stp	x24, x23, [sp, #0x10]
    7468: a90257f6     	stp	x22, x21, [sp, #0x20]
    746c: a9034ff4     	stp	x20, x19, [sp, #0x30]
    7470: 2a0003f4     	mov	w20, w0
    7474: 52800020     	mov	w0, #0x1                // =1
    7478: 52803601     	mov	w1, #0x1b0              // =432
    747c: 94000c69     	bl	0xa620 <calloc@plt>
    7480: aa0003f3     	mov	x19, x0
    7484: b40005c0     	cbz	x0, 0x753c <b_m_engine_create+0xdc>
    7488: 7100069f     	cmp	w20, #0x1
    748c: 1a9f8688     	csinc	w8, w20, wzr, hi
    7490: 7101011f     	cmp	w8, #0x40
    7494: 52800809     	mov	w9, #0x40               // =64
    7498: 1a893114     	csel	w20, w8, w9, lo
    749c: b9000274     	str	w20, [x19]
    74a0: 91054260     	add	x0, x19, #0x150
    74a4: aa1f03e1     	mov	x1, xzr
    74a8: 94000c62     	bl	0xa630 <pthread_mutex_init@plt>
    74ac: 9105e260     	add	x0, x19, #0x178
    74b0: aa1f03e1     	mov	x1, xzr
    74b4: 94000c63     	bl	0xa640 <pthread_cond_init@plt>
    74b8: aa1403e0     	mov	x0, x20
    74bc: 52800101     	mov	w1, #0x8                // =8
    74c0: 94000c58     	bl	0xa620 <calloc@plt>
    74c4: aa0003f5     	mov	x21, x0
    74c8: f900d660     	str	x0, [x19, #0x1a8]
    74cc: aa1403e0     	mov	x0, x20
    74d0: 52800201     	mov	w1, #0x10               // =16
    74d4: 94000c53     	bl	0xa620 <calloc@plt>
    74d8: f900a660     	str	x0, [x19, #0x148]
    74dc: b40003d5     	cbz	x21, 0x7554 <b_m_engine_create+0xf4>
    74e0: b40003a0     	cbz	x0, 0x7554 <b_m_engine_create+0xf4>
    74e4: aa1f03f7     	mov	x23, xzr
    74e8: aa1f03f8     	mov	x24, xzr
    74ec: aa1f03f6     	mov	x22, xzr
    74f0: d503201f     	nop
    74f4: 10000875     	adr	x21, 0x7600 <engine_thread>
    74f8: d503201f     	nop
    74fc: d503201f     	nop
    7500: f940a668     	ldr	x8, [x19, #0x148]
    7504: 8b170103     	add	x3, x8, x23
    7508: f9000073     	str	x19, [x3]
    750c: b9000876     	str	w22, [x3, #0x8]
    7510: f940d668     	ldr	x8, [x19, #0x1a8]
    7514: 8b180100     	add	x0, x8, x24
    7518: aa1f03e1     	mov	x1, xzr
    751c: aa1503e2     	mov	x2, x21
    7520: 94000c38     	bl	0xa600 <pthread_create@plt>
    7524: 35000220     	cbnz	w0, 0x7568 <b_m_engine_create+0x108>
    7528: 910006d6     	add	x22, x22, #0x1
    752c: 91002318     	add	x24, x24, #0x8
    7530: 910042f7     	add	x23, x23, #0x10
    7534: eb16029f     	cmp	x20, x22
    7538: 54fffe41     	b.ne	0x7500 <b_m_engine_create+0xa0>
    753c: aa1303e0     	mov	x0, x19
    7540: a9434ff4     	ldp	x20, x19, [sp, #0x30]
    7544: a94257f6     	ldp	x22, x21, [sp, #0x20]
    7548: a9415ff8     	ldp	x24, x23, [sp, #0x10]
    754c: f84407fe     	ldr	x30, [sp], #0x40
    7550: d65f03c0     	ret
    7554: aa0003f4     	mov	x20, x0
    7558: aa1503e0     	mov	x0, x21
    755c: 94000c3d     	bl	0xa650 <free@plt>
    7560: aa1403e0     	mov	x0, x20
    7564: 14000019     	b	0x75c8 <b_m_engine_create+0x168>
    7568: 91054260     	add	x0, x19, #0x150
    756c: 94000c4d     	bl	0xa6a0 <pthread_mutex_lock@plt>
    7570: 52800028     	mov	w8, #0x1                // =1
    7574: b9002e68     	str	w8, [x19, #0x2c]
    7578: 9105e260     	add	x0, x19, #0x178
    757c: 94000c4d     	bl	0xa6b0 <pthread_cond_broadcast@plt>
    7580: 91054260     	add	x0, x19, #0x150
    7584: 94000c4f     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    7588: b40001b6     	cbz	x22, 0x75bc <b_m_engine_create+0x15c>
    758c: aa1f03f4     	mov	x20, xzr
    7590: d503201f     	nop
    7594: d503201f     	nop
    7598: d503201f     	nop
    759c: d503201f     	nop
    75a0: f940d668     	ldr	x8, [x19, #0x1a8]
    75a4: f8747900     	ldr	x0, [x8, x20, lsl #3]
    75a8: aa1f03e1     	mov	x1, xzr
    75ac: 94000c19     	bl	0xa610 <pthread_join@plt>
    75b0: 91000694     	add	x20, x20, #0x1
    75b4: eb1402df     	cmp	x22, x20
    75b8: 54ffff41     	b.ne	0x75a0 <b_m_engine_create+0x140>
    75bc: f940d660     	ldr	x0, [x19, #0x1a8]
    75c0: 94000c24     	bl	0xa650 <free@plt>
    75c4: f940a660     	ldr	x0, [x19, #0x148]
    75c8: 94000c22     	bl	0xa650 <free@plt>
    75cc: 9105e260     	add	x0, x19, #0x178
    75d0: 94000c24     	bl	0xa660 <pthread_cond_destroy@plt>
    75d4: 91054260     	add	x0, x19, #0x150
    75d8: 94000c26     	bl	0xa670 <pthread_mutex_destroy@plt>
    75dc: aa1303e0     	mov	x0, x19
    75e0: 94000c1c     	bl	0xa650 <free@plt>
    75e4: aa1f03f3     	mov	x19, xzr
    75e8: aa1303e0     	mov	x0, x19
    75ec: a9434ff4     	ldp	x20, x19, [sp, #0x30]
    75f0: a94257f6     	ldp	x22, x21, [sp, #0x20]
    75f4: a9415ff8     	ldp	x24, x23, [sp, #0x10]
    75f8: f84407fe     	ldr	x30, [sp], #0x40
    75fc: d65f03c0     	ret

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

00000000000087a0 <b_m_engine_set_job>:
    87a0: d10343ff     	sub	sp, sp, #0xd0
    87a4: f9004bfe     	str	x30, [sp, #0x90]
    87a8: a90a5ff8     	stp	x24, x23, [sp, #0xa0]
    87ac: a90b57f6     	stp	x22, x21, [sp, #0xb0]
    87b0: a90c4ff4     	stp	x20, x19, [sp, #0xc0]
    87b4: 2a1f03f5     	mov	w21, wzr
    87b8: b40009c0     	cbz	x0, 0x88f0 <b_m_engine_set_job+0x150>
    87bc: b40009a1     	cbz	x1, 0x88f0 <b_m_engine_set_job+0x150>
    87c0: aa0203f4     	mov	x20, x2
    87c4: b4000962     	cbz	x2, 0x88f0 <b_m_engine_set_job+0x150>
    87c8: aa0003f3     	mov	x19, x0
    87cc: ad400420     	ldp	q0, q1, [x1]
    87d0: 3c8483e0     	stur	q0, [sp, #0x48]
    87d4: d503201f     	nop
    87d8: 10fc3d28     	adr	x8, 0xf7c <init.h>
    87dc: 3c8583e1     	stur	q1, [sp, #0x58]
    87e0: ad400500     	ldp	q0, q1, [x8]
    87e4: ad0107e0     	stp	q0, q1, [sp, #0x20]
    87e8: ad410420     	ldp	q0, q1, [x1, #0x20]
    87ec: 3c8683e0     	stur	q0, [sp, #0x68]
    87f0: 910083e8     	add	x8, sp, #0x20
    87f4: 52800809     	mov	w9, #0x40               // =64
    87f8: f90047e9     	str	x9, [sp, #0x88]
    87fc: 52804009     	mov	w9, #0x200              // =512
    8800: f90023e9     	str	x9, [sp, #0x40]
    8804: 3c8783e1     	stur	q1, [sp, #0x78]
    8808: 910083e0     	add	x0, sp, #0x20
    880c: aa0103f5     	mov	x21, x1
    8810: 9100a101     	add	x1, x8, #0x28
    8814: 97fff583     	bl	0x5e20 <transform>
    8818: ad400680     	ldp	q0, q1, [x20]
    881c: f90047ff     	str	xzr, [sp, #0x88]
    8820: 294826a8     	ldp	w8, w9, [x21, #0x40]
    8824: 5ac00916     	rev	w22, w8
    8828: ad0007e0     	stp	q0, q1, [sp]
    882c: b9404aa8     	ldr	w8, [x21, #0x48]
    8830: 5ac00937     	rev	w23, w9
    8834: 5ac00918     	rev	w24, w8
    8838: 91054260     	add	x0, x19, #0x150
    883c: 94000799     	bl	0xa6a0 <pthread_mutex_lock@plt>
    8840: 3dc002a0     	ldr	q0, [x21]
    8844: 3c838260     	stur	q0, [x19, #0x38]
    8848: ad4102a2     	ldp	q2, q0, [x21, #0x20]
    884c: 3cc3c2a1     	ldur	q1, [x21, #0x3c]
    8850: 3dc006a3     	ldr	q3, [x21, #0x10]
    8854: 3c848263     	stur	q3, [x19, #0x48]
    8858: 3c874261     	stur	q1, [x19, #0x74]
    885c: 3c868260     	stur	q0, [x19, #0x68]
    8860: 3c858262     	stur	q2, [x19, #0x58]
    8864: ad4203e1     	ldp	q1, q0, [sp, #0x40]
    8868: ad400a83     	ldp	q3, q2, [x20]
    886c: 3c8d8260     	stur	q0, [x19, #0xd8]
    8870: ad4313e0     	ldp	q0, q4, [sp, #0x60]
    8874: 3c8e8260     	stur	q0, [x19, #0xe8]
    8878: 9102a268     	add	x8, x19, #0xa8
    887c: 3c884263     	stur	q3, [x19, #0x84]
    8880: 3dc023e0     	ldr	q0, [sp, #0x80]
    8884: 3c894262     	stur	q2, [x19, #0x94]
    8888: 3d801900     	str	q0, [x8, #0x60]
    888c: 3c8f8264     	stur	q4, [x19, #0xf8]
    8890: ad410be0     	ldp	q0, q2, [sp, #0x20]
    8894: 3c8a8260     	stur	q0, [x19, #0xa8]
    8898: 3c8b8262     	stur	q2, [x19, #0xb8]
    889c: 3c8c8261     	stur	q1, [x19, #0xc8]
    88a0: b9011a76     	str	w22, [x19, #0x118]
    88a4: b9011e77     	str	w23, [x19, #0x11c]
    88a8: b9012278     	str	w24, [x19, #0x120]
    88ac: 91049268     	add	x8, x19, #0x124
    88b0: ad4003e1     	ldp	q1, q0, [sp]
    88b4: ad000101     	stp	q1, q0, [x8]
    88b8: 52800035     	mov	w21, #0x1               // =1
    88bc: 91002261     	add	x1, x19, #0x8
    88c0: 52800020     	mov	w0, #0x1                // =1
    88c4: 97fff3b7     	bl	0x57a0 <__aarch64_ldadd8_relax>
    88c8: f9000a7f     	str	xzr, [x19, #0x10]
    88cc: f9000e7f     	str	xzr, [x19, #0x18]
    88d0: f9001a7f     	str	xzr, [x19, #0x30]
    88d4: b900267f     	str	wzr, [x19, #0x24]
    88d8: b9002a7f     	str	wzr, [x19, #0x28]
    88dc: b9002275     	str	w21, [x19, #0x20]
    88e0: 9105e260     	add	x0, x19, #0x178
    88e4: 94000773     	bl	0xa6b0 <pthread_cond_broadcast@plt>
    88e8: 91054260     	add	x0, x19, #0x150
    88ec: 94000775     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    88f0: 2a1503e0     	mov	w0, w21
    88f4: a94c4ff4     	ldp	x20, x19, [sp, #0xc0]
    88f8: a94b57f6     	ldp	x22, x21, [sp, #0xb0]
    88fc: a94a5ff8     	ldp	x24, x23, [sp, #0xa0]
    8900: f9404bfe     	ldr	x30, [sp, #0x90]
    8904: 910343ff     	add	sp, sp, #0xd0
    8908: d65f03c0     	ret
    890c: 00000000     	udf	#0x0

0000000000008910 <b_m_engine_poll>:
    8910: f81d0ffe     	str	x30, [sp, #-0x30]!
    8914: a90157f6     	stp	x22, x21, [sp, #0x10]
    8918: a9024ff4     	stp	x20, x19, [sp, #0x20]
    891c: 2a1f03f5     	mov	w21, wzr
    8920: b4000240     	cbz	x0, 0x8968 <b_m_engine_poll+0x58>
    8924: aa0103f4     	mov	x20, x1
    8928: b4000201     	cbz	x1, 0x8968 <b_m_engine_poll+0x58>
    892c: aa0203f6     	mov	x22, x2
    8930: b40001c2     	cbz	x2, 0x8968 <b_m_engine_poll+0x58>
    8934: aa0003f3     	mov	x19, x0
    8938: 91006001     	add	x1, x0, #0x18
    893c: aa1f03e0     	mov	x0, xzr
    8940: 97fff4a8     	bl	0x5be0 <__aarch64_swp8_relax>
    8944: f90002c0     	str	x0, [x22]
    8948: 91054260     	add	x0, x19, #0x150
    894c: 94000755     	bl	0xa6a0 <pthread_mutex_lock@plt>
    8950: b9403275     	ldr	w21, [x19, #0x30]
    8954: 34000075     	cbz	w21, 0x8960 <b_m_engine_poll+0x50>
    8958: b9403668     	ldr	w8, [x19, #0x34]
    895c: b9000288     	str	w8, [x20]
    8960: 91054260     	add	x0, x19, #0x150
    8964: 94000757     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    8968: 2a1503e0     	mov	w0, w21
    896c: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    8970: a94157f6     	ldp	x22, x21, [sp, #0x10]
    8974: f84307fe     	ldr	x30, [sp], #0x30
    8978: d65f03c0     	ret
    897c: 00000000     	udf	#0x0

0000000000008980 <b_m_engine_exhausted>:
    8980: f81e0ffe     	str	x30, [sp, #-0x20]!
    8984: a9014ff4     	stp	x20, x19, [sp, #0x10]
    8988: b4000160     	cbz	x0, 0x89b4 <b_m_engine_exhausted+0x34>
    898c: aa0003f4     	mov	x20, x0
    8990: 91054000     	add	x0, x0, #0x150
    8994: 94000743     	bl	0xa6a0 <pthread_mutex_lock@plt>
    8998: b9402a93     	ldr	w19, [x20, #0x28]
    899c: 91054280     	add	x0, x20, #0x150
    89a0: 94000748     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    89a4: 2a1303e0     	mov	w0, w19
    89a8: a9414ff4     	ldp	x20, x19, [sp, #0x10]
    89ac: f84207fe     	ldr	x30, [sp], #0x20
    89b0: d65f03c0     	ret
    89b4: 2a1f03f3     	mov	w19, wzr
    89b8: 2a1303e0     	mov	w0, w19
    89bc: a9414ff4     	ldp	x20, x19, [sp, #0x10]
    89c0: f84207fe     	ldr	x30, [sp], #0x20
    89c4: d65f03c0     	ret
		...

00000000000089d0 <b_m_engine_next_nonce>:
    89d0: b4000040     	cbz	x0, 0x89d8 <b_m_engine_next_nonce+0x8>
    89d4: f9400800     	ldr	x0, [x0, #0x10]
    89d8: d65f03c0     	ret
    89dc: 00000000     	udf	#0x0

00000000000089e0 <b_m_engine_stop_job>:
    89e0: b40001a0     	cbz	x0, 0x8a14 <b_m_engine_stop_job+0x34>
    89e4: a9bf4ffe     	stp	x30, x19, [sp, #-0x10]!
    89e8: aa0003f3     	mov	x19, x0
    89ec: 91054000     	add	x0, x0, #0x150
    89f0: 9400072c     	bl	0xa6a0 <pthread_mutex_lock@plt>
    89f4: 52800028     	mov	w8, #0x1                // =1
    89f8: b9002668     	str	w8, [x19, #0x24]
    89fc: b900227f     	str	wzr, [x19, #0x20]
    8a00: 9105e260     	add	x0, x19, #0x178
    8a04: 9400072b     	bl	0xa6b0 <pthread_cond_broadcast@plt>
    8a08: 91054260     	add	x0, x19, #0x150
    8a0c: a8c14ffe     	ldp	x30, x19, [sp], #0x10
    8a10: 1400072c     	b	0xa6c0 <pthread_mutex_unlock@plt>
    8a14: d65f03c0     	ret
		...

0000000000008a20 <b_m_engine_destroy>:
    8a20: b40004a0     	cbz	x0, 0x8ab4 <b_m_engine_destroy+0x94>
    8a24: f81e0ffe     	str	x30, [sp, #-0x20]!
    8a28: a9014ff4     	stp	x20, x19, [sp, #0x10]
    8a2c: aa0003f3     	mov	x19, x0
    8a30: 91054000     	add	x0, x0, #0x150
    8a34: 9400071b     	bl	0xa6a0 <pthread_mutex_lock@plt>
    8a38: 52800028     	mov	w8, #0x1                // =1
    8a3c: b9002e68     	str	w8, [x19, #0x2c]
    8a40: b900227f     	str	wzr, [x19, #0x20]
    8a44: b9002668     	str	w8, [x19, #0x24]
    8a48: 9105e260     	add	x0, x19, #0x178
    8a4c: 94000719     	bl	0xa6b0 <pthread_cond_broadcast@plt>
    8a50: 91054260     	add	x0, x19, #0x150
    8a54: 9400071b     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    8a58: b9400268     	ldr	w8, [x19]
    8a5c: 34000148     	cbz	w8, 0x8a84 <b_m_engine_destroy+0x64>
    8a60: aa1f03f4     	mov	x20, xzr
    8a64: f940d668     	ldr	x8, [x19, #0x1a8]
    8a68: f8747900     	ldr	x0, [x8, x20, lsl #3]
    8a6c: aa1f03e1     	mov	x1, xzr
    8a70: 940006e8     	bl	0xa610 <pthread_join@plt>
    8a74: 91000694     	add	x20, x20, #0x1
    8a78: b9400268     	ldr	w8, [x19]
    8a7c: eb08029f     	cmp	x20, x8
    8a80: 54ffff23     	b.lo	0x8a64 <b_m_engine_destroy+0x44>
    8a84: 9105e260     	add	x0, x19, #0x178
    8a88: 940006f6     	bl	0xa660 <pthread_cond_destroy@plt>
    8a8c: 91054260     	add	x0, x19, #0x150
    8a90: 940006f8     	bl	0xa670 <pthread_mutex_destroy@plt>
    8a94: f940d660     	ldr	x0, [x19, #0x1a8]
    8a98: 940006ee     	bl	0xa650 <free@plt>
    8a9c: f940a660     	ldr	x0, [x19, #0x148]
    8aa0: 940006ec     	bl	0xa650 <free@plt>
    8aa4: aa1303e0     	mov	x0, x19
    8aa8: a9414ff4     	ldp	x20, x19, [sp, #0x10]
    8aac: f84207fe     	ldr	x30, [sp], #0x20
    8ab0: 140006e8     	b	0xa650 <free@plt>
    8ab4: d65f03c0     	ret
		...

0000000000008ac0 <b_m_engine_selftest>:
    8ac0: fc1b0fe8     	str	d8, [sp, #-0x50]!
    8ac4: f90007fd     	str	x29, [sp, #0x8]
    8ac8: a90167fe     	stp	x30, x25, [sp, #0x10]
    8acc: a9025ff8     	stp	x24, x23, [sp, #0x20]
    8ad0: a90357f6     	stp	x22, x21, [sp, #0x30]
    8ad4: a9044ff4     	stp	x20, x19, [sp, #0x40]
    8ad8: d10943ff     	sub	sp, sp, #0x250
    8adc: 910543f5     	add	x21, sp, #0x150
    8ae0: 6f00e400     	movi	v0.2d, #0000000000000000
    8ae4: d503201f     	nop
    8ae8: 10fc24a8     	adr	x8, 0xf7c <init.h>
    8aec: ad0e03e0     	stp	q0, q0, [sp, #0x1c0]
    8af0: 90ffffc9     	adrp	x9, 0x0 <pthread_mutex_unlock>
    8af4: ad400500     	ldp	q0, q1, [x8]
    8af8: ad0283e1     	stp	q1, q0, [sp, #0x50]
    8afc: ad0a87e0     	stp	q0, q1, [sp, #0x150]
    8b00: 3dc3c120     	ldr	q0, [x9, #0xf00]
    8b04: 3d8013e0     	str	q0, [sp, #0x40]
    8b08: 3c8282a0     	stur	q0, [x21, #0x28]
    8b0c: 90ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    8b10: 3dc3b500     	ldr	q0, [x8, #0xed0]
    8b14: 3d800fe0     	str	q0, [sp, #0x30]
    8b18: 3c8382a0     	stur	q0, [x21, #0x38]
    8b1c: 90ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    8b20: 3dc32100     	ldr	q0, [x8, #0xc80]
    8b24: 3d800be0     	str	q0, [sp, #0x20]
    8b28: 3c8482a0     	stur	q0, [x21, #0x48]
    8b2c: 90ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    8b30: 3dc34d00     	ldr	q0, [x8, #0xd30]
    8b34: 52800808     	mov	w8, #0x40               // =64
    8b38: 52804009     	mov	w9, #0x200              // =512
    8b3c: f900dfe8     	str	x8, [sp, #0x1b8]
    8b40: f900bbe9     	str	x9, [sp, #0x170]
    8b44: 3d8007e0     	str	q0, [sp, #0x10]
    8b48: 3c8582a0     	stur	q0, [x21, #0x58]
    8b4c: 910543e0     	add	x0, sp, #0x150
    8b50: 9100a2a1     	add	x1, x21, #0x28
    8b54: 97fff4b3     	bl	0x5e20 <transform>
    8b58: 90ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    8b5c: 90ffffc9     	adrp	x9, 0x0 <pthread_mutex_unlock>
    8b60: b90187ff     	str	wzr, [sp, #0x184]
    8b64: 5280020a     	mov	w10, #0x10              // =16
    8b68: f940bbeb     	ldr	x11, [sp, #0x170]
    8b6c: fd479908     	ldr	d8, [x8, #0xf30]
    8b70: f900dfea     	str	x10, [sp, #0x1b8]
    8b74: fd00bfe8     	str	d8, [sp, #0x178]
    8b78: fd479520     	ldr	d0, [x9, #0xf28]
    8b7c: 3d8003e0     	str	q0, [sp]
    8b80: bd0183e0     	str	s0, [sp, #0x180]
    8b84: 91020168     	add	x8, x11, #0x80
    8b88: f900bbe8     	str	x8, [sp, #0x170]
    8b8c: 910783f6     	add	x22, sp, #0x1e0
    8b90: 910543e0     	add	x0, sp, #0x150
    8b94: 9100a2c1     	add	x1, x22, #0x28
    8b98: 97fff522     	bl	0x6020 <final>
    8b9c: 52800408     	mov	w8, #0x20               // =32
    8ba0: 52802009     	mov	w9, #0x100              // =256
    8ba4: f90127e8     	str	x8, [sp, #0x248]
    8ba8: f90103e9     	str	x9, [sp, #0x200]
    8bac: ad4287e0     	ldp	q0, q1, [sp, #0x50]
    8bb0: ad0f03e1     	stp	q1, q0, [sp, #0x1e0]
    8bb4: 910783e0     	add	x0, sp, #0x1e0
    8bb8: 910703e1     	add	x1, sp, #0x1c0
    8bbc: 97fff519     	bl	0x6020 <final>
    8bc0: 52800100     	mov	w0, #0x8                // =8
    8bc4: 94000687     	bl	0xa5e0 <b_m_engine_create@plt>
    8bc8: 52800034     	mov	w20, #0x1               // =1
    8bcc: b4001460     	cbz	x0, 0x8e58 <b_m_engine_selftest+0x398>
    8bd0: aa0003f3     	mov	x19, x0
    8bd4: ad4287e0     	ldp	q0, q1, [sp, #0x50]
    8bd8: ad0f03e1     	stp	q1, q0, [sp, #0x1e0]
    8bdc: ad4187e0     	ldp	q0, q1, [sp, #0x30]
    8be0: 3c8b82a1     	stur	q1, [x21, #0xb8]
    8be4: 3c8c82a0     	stur	q0, [x21, #0xc8]
    8be8: ad4087e0     	ldp	q0, q1, [sp, #0x10]
    8bec: 3c8d82a1     	stur	q1, [x21, #0xd8]
    8bf0: 52800808     	mov	w8, #0x40               // =64
    8bf4: 52804009     	mov	w9, #0x200              // =512
    8bf8: f90127e8     	str	x8, [sp, #0x248]
    8bfc: f90103e9     	str	x9, [sp, #0x200]
    8c00: 3c8e82a0     	stur	q0, [x21, #0xe8]
    8c04: 910783e0     	add	x0, sp, #0x1e0
    8c08: 9100a2c1     	add	x1, x22, #0x28
    8c0c: 97fff485     	bl	0x5e20 <transform>
    8c10: f90127ff     	str	xzr, [sp, #0x248]
    8c14: 91054260     	add	x0, x19, #0x150
    8c18: 940006a2     	bl	0xa6a0 <pthread_mutex_lock@plt>
    8c1c: ad4187e0     	ldp	q0, q1, [sp, #0x30]
    8c20: 3c838261     	stur	q1, [x19, #0x38]
    8c24: 3c848260     	stur	q0, [x19, #0x48]
    8c28: ad4087e0     	ldp	q0, q1, [sp, #0x10]
    8c2c: 3c858261     	stur	q1, [x19, #0x58]
    8c30: 3c868260     	stur	q0, [x19, #0x68]
    8c34: ad4e03e2     	ldp	q2, q0, [sp, #0x1c0]
    8c38: 3c884262     	stur	q2, [x19, #0x84]
    8c3c: ad4e0be1     	ldp	q1, q2, [sp, #0x1c0]
    8c40: 3c894260     	stur	q0, [x19, #0x94]
    8c44: ad5003e3     	ldp	q3, q0, [sp, #0x200]
    8c48: 3c8d8260     	stur	q0, [x19, #0xd8]
    8c4c: 9102a268     	add	x8, x19, #0xa8
    8c50: ad5113e0     	ldp	q0, q4, [sp, #0x220]
    8c54: 3c8e8260     	stur	q0, [x19, #0xe8]
    8c58: 3dc093e0     	ldr	q0, [sp, #0x240]
    8c5c: 3d801900     	str	q0, [x8, #0x60]
    8c60: 3c8f8264     	stur	q4, [x19, #0xf8]
    8c64: ad4f13e0     	ldp	q0, q4, [sp, #0x1e0]
    8c68: 3c8a8260     	stur	q0, [x19, #0xa8]
    8c6c: 3c8b8264     	stur	q4, [x19, #0xb8]
    8c70: 3c8c8263     	stur	q3, [x19, #0xc8]
    8c74: 90ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    8c78: fd47a100     	ldr	d0, [x8, #0xf40]
    8c7c: fd008e60     	str	d0, [x19, #0x118]
    8c80: fd003e68     	str	d8, [x19, #0x78]
    8c84: 3dc003e0     	ldr	q0, [sp]
    8c88: bd008260     	str	s0, [x19, #0x80]
    8c8c: 52894968     	mov	w8, #0x4a4b             // =19019
    8c90: 72a90928     	movk	w8, #0x4849, lsl #16
    8c94: b9012268     	str	w8, [x19, #0x120]
    8c98: 91049268     	add	x8, x19, #0x124
    8c9c: ad000901     	stp	q1, q2, [x8]
    8ca0: 91002261     	add	x1, x19, #0x8
    8ca4: 52800020     	mov	w0, #0x1                // =1
    8ca8: 97fff2be     	bl	0x57a0 <__aarch64_ldadd8_relax>
    8cac: f9000a7f     	str	xzr, [x19, #0x10]
    8cb0: f9000e7f     	str	xzr, [x19, #0x18]
    8cb4: f9001a7f     	str	xzr, [x19, #0x30]
    8cb8: b900267f     	str	wzr, [x19, #0x24]
    8cbc: b9002a7f     	str	wzr, [x19, #0x28]
    8cc0: b9002274     	str	w20, [x19, #0x20]
    8cc4: 9105e260     	add	x0, x19, #0x178
    8cc8: 9400067a     	bl	0xa6b0 <pthread_cond_broadcast@plt>
    8ccc: 91054260     	add	x0, x19, #0x150
    8cd0: 9400067c     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    8cd4: 52801914     	mov	w20, #0xc8              // =200
    8cd8: 90ffffd5     	adrp	x21, 0x0 <pthread_mutex_unlock>
    8cdc: 9132c2b5     	add	x21, x21, #0xcb0
    8ce0: 91006261     	add	x1, x19, #0x18
    8ce4: aa1f03e0     	mov	x0, xzr
    8ce8: 97fff3be     	bl	0x5be0 <__aarch64_swp8_relax>
    8cec: 91054260     	add	x0, x19, #0x150
    8cf0: 9400066c     	bl	0xa6a0 <pthread_mutex_lock@plt>
    8cf4: b9403268     	ldr	w8, [x19, #0x30]
    8cf8: 35000188     	cbnz	w8, 0x8d28 <b_m_engine_selftest+0x268>
    8cfc: 91054260     	add	x0, x19, #0x150
    8d00: 94000670     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    8d04: 3dc002a0     	ldr	q0, [x21]
    8d08: 3d807be0     	str	q0, [sp, #0x1e0]
    8d0c: 910783e0     	add	x0, sp, #0x1e0
    8d10: aa1f03e1     	mov	x1, xzr
    8d14: 9400065b     	bl	0xa680 <nanosleep@plt>
    8d18: 71000694     	subs	w20, w20, #0x1
    8d1c: 54fffe21     	b.ne	0x8ce0 <b_m_engine_selftest+0x220>
    8d20: 52800054     	mov	w20, #0x2               // =2
    8d24: 1400004b     	b	0x8e50 <b_m_engine_selftest+0x390>
    8d28: b9403677     	ldr	w23, [x19, #0x34]
    8d2c: 91054260     	add	x0, x19, #0x150
    8d30: 94000664     	bl	0xa6c0 <pthread_mutex_unlock@plt>
    8d34: aa1f03e8     	mov	x8, xzr
    8d38: fd00a3e8     	str	d8, [sp, #0x140]
    8d3c: ad4187e0     	ldp	q0, q1, [sp, #0x30]
    8d40: ad0803e1     	stp	q1, q0, [sp, #0x100]
    8d44: ad4087e0     	ldp	q0, q1, [sp, #0x10]
    8d48: ad0903e1     	stp	q1, q0, [sp, #0x120]
    8d4c: 3dc003e0     	ldr	q0, [sp]
    8d50: bd014be0     	str	s0, [sp, #0x148]
    8d54: 390533f7     	strb	w23, [sp, #0x14c]
    8d58: 53087ee9     	lsr	w9, w23, #8
    8d5c: 390537e9     	strb	w9, [sp, #0x14d]
    8d60: 53107ee9     	lsr	w9, w23, #16
    8d64: 39053be9     	strb	w9, [sp, #0x14e]
    8d68: 53187ee9     	lsr	w9, w23, #24
    8d6c: 39053fe9     	strb	w9, [sp, #0x14f]
    8d70: f90103ff     	str	xzr, [sp, #0x200]
    8d74: f90127ff     	str	xzr, [sp, #0x248]
    8d78: 910783e9     	add	x9, sp, #0x1e0
    8d7c: 9100a134     	add	x20, x9, #0x28
    8d80: 910403f5     	add	x21, sp, #0x100
    8d84: 52800a18     	mov	w24, #0x50              // =80
    8d88: 52800819     	mov	w25, #0x40              // =64
    8d8c: ad4287e0     	ldp	q0, q1, [sp, #0x50]
    8d90: ad0f03e1     	stp	q1, q0, [sp, #0x1e0]
    8d94: 14000006     	b	0x8dac <b_m_engine_selftest+0x2ec>
    8d98: d503201f     	nop
    8d9c: d503201f     	nop
    8da0: 8b1602b5     	add	x21, x21, x22
    8da4: cb160318     	sub	x24, x24, x22
    8da8: b40002d8     	cbz	x24, 0x8e00 <b_m_engine_selftest+0x340>
    8dac: cb080329     	sub	x9, x25, x8
    8db0: eb18013f     	cmp	x9, x24
    8db4: 9a983136     	csel	x22, x9, x24, lo
    8db8: 8b080280     	add	x0, x20, x8
    8dbc: aa1503e1     	mov	x1, x21
    8dc0: aa1603e2     	mov	x2, x22
    8dc4: 9400064b     	bl	0xa6f0 <memcpy@plt>
    8dc8: f94127e8     	ldr	x8, [sp, #0x248]
    8dcc: f94103e9     	ldr	x9, [sp, #0x200]
    8dd0: 8b160108     	add	x8, x8, x22
    8dd4: 8b160d29     	add	x9, x9, x22, lsl #3
    8dd8: f90127e8     	str	x8, [sp, #0x248]
    8ddc: f90103e9     	str	x9, [sp, #0x200]
    8de0: f101011f     	cmp	x8, #0x40
    8de4: 54fffde1     	b.ne	0x8da0 <b_m_engine_selftest+0x2e0>
    8de8: 910783e0     	add	x0, sp, #0x1e0
    8dec: aa1403e1     	mov	x1, x20
    8df0: 97fff40c     	bl	0x5e20 <transform>
    8df4: aa1f03e8     	mov	x8, xzr
    8df8: f90127ff     	str	xzr, [sp, #0x248]
    8dfc: 17ffffe9     	b	0x8da0 <b_m_engine_selftest+0x2e0>
    8e00: 9101c3e8     	add	x8, sp, #0x70
    8e04: 910783e0     	add	x0, sp, #0x1e0
    8e08: 9100a101     	add	x1, x8, #0x28
    8e0c: 97fff485     	bl	0x6020 <final>
    8e10: 52800408     	mov	w8, #0x20               // =32
    8e14: 52802009     	mov	w9, #0x100              // =256
    8e18: f9006fe8     	str	x8, [sp, #0xd8]
    8e1c: f9004be9     	str	x9, [sp, #0x90]
    8e20: ad4287e0     	ldp	q0, q1, [sp, #0x50]
    8e24: ad0383e1     	stp	q1, q0, [sp, #0x70]
    8e28: 9101c3e0     	add	x0, sp, #0x70
    8e2c: 910383e1     	add	x1, sp, #0xe0
    8e30: 97fff47c     	bl	0x6020 <final>
    8e34: 910383e0     	add	x0, sp, #0xe0
    8e38: 910703e1     	add	x1, sp, #0x1c0
    8e3c: 97fff4ed     	bl	0x61f0 <le_target>
    8e40: 12003ee8     	and	w8, w23, #0xffff
    8e44: 11064108     	add	w8, w8, #0x190
    8e48: 7100001f     	cmp	w0, #0x0
    8e4c: 1a9f0114     	csel	w20, w8, wzr, eq
    8e50: aa1303e0     	mov	x0, x19
    8e54: 940005e7     	bl	0xa5f0 <b_m_engine_destroy@plt>
    8e58: 2a1403e0     	mov	w0, w20
    8e5c: 910943ff     	add	sp, sp, #0x250
    8e60: a9444ff4     	ldp	x20, x19, [sp, #0x40]
    8e64: a94357f6     	ldp	x22, x21, [sp, #0x30]
    8e68: a9425ff8     	ldp	x24, x23, [sp, #0x20]
    8e6c: a94167fe     	ldp	x30, x25, [sp, #0x10]
    8e70: f94007fd     	ldr	x29, [sp, #0x8]
    8e74: fc4507e8     	ldr	d8, [sp], #0x50
    8e78: d65f03c0     	ret
    8e7c: 00000000     	udf	#0x0

0000000000008e80 <b_m_selftest>:
    8e80: fc190fe8     	str	d8, [sp, #-0x70]!
    8e84: a9017bfd     	stp	x29, x30, [sp, #0x10]
    8e88: a9026ffc     	stp	x28, x27, [sp, #0x20]
    8e8c: a90367fa     	stp	x26, x25, [sp, #0x30]
    8e90: a9045ff8     	stp	x24, x23, [sp, #0x40]
    8e94: a90557f6     	stp	x22, x21, [sp, #0x50]
    8e98: a9064ff4     	stp	x20, x19, [sp, #0x60]
    8e9c: d11643ff     	sub	sp, sp, #0x590
    8ea0: 90ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    8ea4: 90ffffc9     	adrp	x9, 0x0 <pthread_mutex_unlock>
    8ea8: 3dc3c101     	ldr	q1, [x8, #0xf00]
    8eac: 3dc3b522     	ldr	q2, [x9, #0xed0]
    8eb0: 3d8103e1     	str	q1, [sp, #0x400]
    8eb4: 3d8107e2     	str	q2, [sp, #0x410]
    8eb8: 90ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    8ebc: 90ffffc9     	adrp	x9, 0x0 <pthread_mutex_unlock>
    8ec0: 90ffffca     	adrp	x10, 0x0 <pthread_mutex_unlock>
    8ec4: 3dc32103     	ldr	q3, [x8, #0xc80]
    8ec8: 3dc34d44     	ldr	q4, [x10, #0xd30]
    8ecc: 3d810be3     	str	q3, [sp, #0x420]
    8ed0: 3d810fe4     	str	q4, [sp, #0x430]
    8ed4: 90ffffc8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    8ed8: fd479525     	ldr	d5, [x9, #0xf28]
    8edc: fd479d00     	ldr	d0, [x8, #0xf38]
    8ee0: 910dc3e8     	add	x8, sp, #0x370
    8ee4: 90ffffc9     	adrp	x9, 0x0 <pthread_mutex_unlock>
    8ee8: fd479928     	ldr	d8, [x9, #0xf30]
    8eec: ad0587e2     	stp	q2, q1, [sp, #0xb0]
    8ef0: 3c828101     	stur	q1, [x8, #0x28]
    8ef4: 3d8023e5     	str	q5, [sp, #0x80]
    8ef8: 4ea51ca1     	mov	v1.16b, v5.16b
    8efc: 6e0c0401     	mov	v1.s[1], v0.s[0]
    8f00: fd0223e8     	str	d8, [sp, #0x440]
    8f04: fd0227e1     	str	d1, [sp, #0x448]
    8f08: d503201f     	nop
    8f0c: 10fc0389     	adr	x9, 0xf7c <init.h>
    8f10: 9111c3f6     	add	x22, sp, #0x470
    8f14: ad400520     	ldp	q0, q1, [x9]
    8f18: ad0683e1     	stp	q1, q0, [sp, #0xd0]
    8f1c: ad1b87e0     	stp	q0, q1, [sp, #0x370]
    8f20: 911003e9     	add	x9, sp, #0x400
    8f24: 3c838102     	stur	q2, [x8, #0x38]
    8f28: 91010133     	add	x19, x9, #0x40
    8f2c: ad048fe4     	stp	q4, q3, [sp, #0x90]
    8f30: 3c848103     	stur	q3, [x8, #0x48]
    8f34: 52800817     	mov	w23, #0x40              // =64
    8f38: 52804009     	mov	w9, #0x200              // =512
    8f3c: f901eff7     	str	x23, [sp, #0x3d8]
    8f40: f901cbe9     	str	x9, [sp, #0x390]
    8f44: 3c858104     	stur	q4, [x8, #0x58]
    8f48: 910dc3e0     	add	x0, sp, #0x370
    8f4c: 9100a101     	add	x1, x8, #0x28
    8f50: 97fff3b4     	bl	0x5e20 <transform>
    8f54: f901efff     	str	xzr, [sp, #0x3d8]
    8f58: ad5d87e0     	ldp	q0, q1, [sp, #0x3b0]
    8f5c: 3dc0f7e2     	ldr	q2, [sp, #0x3d0]
    8f60: ad1a07e0     	stp	q0, q1, [sp, #0x340]
    8f64: 3d80dbe2     	str	q2, [sp, #0x360]
    8f68: ad5b87e0     	ldp	q0, q1, [sp, #0x370]
    8f6c: ad1807e0     	stp	q0, q1, [sp, #0x300]
    8f70: ad5c83e1     	ldp	q1, q0, [sp, #0x390]
    8f74: 910c03e8     	add	x8, sp, #0x300
    8f78: 9100a114     	add	x20, x8, #0x28
    8f7c: 52800218     	mov	w24, #0x10              // =16
    8f80: f941b7e8     	ldr	x8, [sp, #0x368]
    8f84: ad1903e1     	stp	q1, q0, [sp, #0x320]
    8f88: 14000004     	b	0x8f98 <b_m_selftest+0x118>
    8f8c: 8b150273     	add	x19, x19, x21
    8f90: cb150318     	sub	x24, x24, x21
    8f94: b40002d8     	cbz	x24, 0x8fec <b_m_selftest+0x16c>
    8f98: cb0802e9     	sub	x9, x23, x8
    8f9c: eb18013f     	cmp	x9, x24
    8fa0: 9a983135     	csel	x21, x9, x24, lo
    8fa4: 8b080280     	add	x0, x20, x8
    8fa8: aa1303e1     	mov	x1, x19
    8fac: aa1503e2     	mov	x2, x21
    8fb0: 940005d0     	bl	0xa6f0 <memcpy@plt>
    8fb4: f941b7e8     	ldr	x8, [sp, #0x368]
    8fb8: f94193e9     	ldr	x9, [sp, #0x320]
    8fbc: 8b150108     	add	x8, x8, x21
    8fc0: 8b150d29     	add	x9, x9, x21, lsl #3
    8fc4: f901b7e8     	str	x8, [sp, #0x368]
    8fc8: f90193e9     	str	x9, [sp, #0x320]
    8fcc: f101011f     	cmp	x8, #0x40
    8fd0: 54fffde1     	b.ne	0x8f8c <b_m_selftest+0x10c>
    8fd4: 910c03e0     	add	x0, sp, #0x300
    8fd8: aa1403e1     	mov	x1, x20
    8fdc: 97fff391     	bl	0x5e20 <transform>
    8fe0: aa1f03e8     	mov	x8, xzr
    8fe4: f901b7ff     	str	xzr, [sp, #0x368]
    8fe8: 17ffffe9     	b	0x8f8c <b_m_selftest+0x10c>
    8fec: d293f793     	mov	x19, #0x9fbc            // =40892
    8ff0: f2b0c193     	movk	x19, #0x860c, lsl #16
    8ff4: f2c12233     	movk	x19, #0x911, lsl #32
    8ff8: f2f0a673     	movk	x19, #0x8533, lsl #48
    8ffc: d287e634     	mov	x20, #0x3f31            // =16177
    9000: f2a5af94     	movk	x20, #0x2d7c, lsl #16
    9004: f2db0354     	movk	x20, #0xd81a, lsl #32
    9008: f2ef3a14     	movk	x20, #0x79d0, lsl #48
    900c: d2854f95     	mov	x21, #0x2a7c            // =10876
    9010: f2a816d5     	movk	x21, #0x40b6, lsl #16
    9014: f2df0175     	movk	x21, #0xf80b, lsl #32
    9018: f2ea5775     	movk	x21, #0x52bb, lsl #48
    901c: d28bd737     	mov	x23, #0x5eb9            // =24249
    9020: f2accb57     	movk	x23, #0x665a, lsl #16
    9024: f2cb8417     	movk	x23, #0x5c20, lsl #32
    9028: f2e85677     	movk	x23, #0x42b3, lsl #48
    902c: 910a43e8     	add	x8, sp, #0x290
    9030: 910c03e0     	add	x0, sp, #0x300
    9034: 9100a101     	add	x1, x8, #0x28
    9038: 97fff3fa     	bl	0x6020 <final>
    903c: 52800408     	mov	w8, #0x20               // =32
    9040: 52802009     	mov	w9, #0x100              // =256
    9044: f9017fe8     	str	x8, [sp, #0x2f8]
    9048: f9015be9     	str	x9, [sp, #0x2b0]
    904c: ad4687e0     	ldp	q0, q1, [sp, #0xd0]
    9050: ad1483e1     	stp	q1, q0, [sp, #0x290]
    9054: 910a43e0     	add	x0, sp, #0x290
    9058: 910f83e1     	add	x1, sp, #0x3e0
    905c: 97fff3f1     	bl	0x6020 <final>
    9060: f941f3e8     	ldr	x8, [sp, #0x3e0]
    9064: f941f7e9     	ldr	x9, [sp, #0x3e8]
    9068: f941fbea     	ldr	x10, [sp, #0x3f0]
    906c: f941ffeb     	ldr	x11, [sp, #0x3f8]
    9070: eb17011f     	cmp	x8, x23
    9074: fa550120     	ccmp	x9, x21, #0x0, eq
    9078: fa530140     	ccmp	x10, x19, #0x0, eq
    907c: fa540160     	ccmp	x11, x20, #0x0, eq
    9080: 54000060     	b.eq	0x908c <b_m_selftest+0x20c>
    9084: 12800000     	mov	w0, #-0x1               // =-1
    9088: 140002e9     	b	0x9c2c <b_m_selftest+0xdac>
    908c: aa1f03e8     	mov	x8, xzr
    9090: ad5f07e0     	ldp	q0, q1, [sp, #0x3e0]
    9094: 3d8117e0     	str	q0, [sp, #0x450]
    9098: 3d811be1     	str	q1, [sp, #0x460]
    909c: b94373e9     	ldr	w9, [sp, #0x370]
    90a0: b94377ea     	ldr	w10, [sp, #0x374]
    90a4: f0ffffab     	adrp	x11, 0x0 <pthread_mutex_unlock>
    90a8: 3dc35d60     	ldr	q0, [x11, #0xd70]
    90ac: 3d8007e0     	str	q0, [sp, #0x10]
    90b0: 3d811fe0     	str	q0, [sp, #0x470]
    90b4: b9437beb     	ldr	w11, [sp, #0x378]
    90b8: b9437fec     	ldr	w12, [sp, #0x37c]
    90bc: 52b0000f     	mov	w15, #-0x80000000       // =-2147483648
    90c0: 6f00e400     	movi	v0.2d, #0000000000000000
    90c4: 3c8142c0     	stur	q0, [x22, #0x14]
    90c8: f80342df     	stur	xzr, [x22, #0x34]
    90cc: 52805010     	mov	w16, #0x280             // =640
    90d0: b94383ed     	ldr	w13, [sp, #0x380]
    90d4: b94387ee     	ldr	w14, [sp, #0x384]
    90d8: b90483ef     	str	w15, [sp, #0x480]
    90dc: b904aff0     	str	w16, [sp, #0x4ac]
    90e0: 52884860     	mov	w0, #0x4243             // =16963
    90e4: 72a80820     	movk	w0, #0x4041, lsl #16
    90e8: 9111c3f1     	add	x17, sp, #0x470
    90ec: b9438bef     	ldr	w15, [sp, #0x388]
    90f0: b9438ff0     	ldr	w16, [sp, #0x38c]
    90f4: 3c8242c0     	stur	q0, [x22, #0x24]
    90f8: d503201f     	nop
    90fc: d503201f     	nop
    9100: 8b080221     	add	x1, x17, x8
    9104: b9402422     	ldr	w2, [x1, #0x24]
    9108: 0b000040     	add	w0, w2, w0
    910c: b9400422     	ldr	w2, [x1, #0x4]
    9110: b9403823     	ldr	w3, [x1, #0x38]
    9114: 13821c44     	ror	w4, w2, #0x7
    9118: 13834465     	ror	w5, w3, #0x11
    911c: 4ac24884     	eor	w4, w4, w2, ror #18
    9120: 4ac34ca5     	eor	w5, w5, w3, ror #19
    9124: 4a420c84     	eor	w4, w4, w2, lsr #3
    9128: 4a4328a3     	eor	w3, w5, w3, lsr #10
    912c: 0b040000     	add	w0, w0, w4
    9130: 0b030000     	add	w0, w0, w3
    9134: b9004020     	str	w0, [x1, #0x40]
    9138: 91001108     	add	x8, x8, #0x4
    913c: f103011f     	cmp	x8, #0xc0
    9140: 2a0203e0     	mov	w0, w2
    9144: 54fffde1     	b.ne	0x9100 <b_m_selftest+0x280>
    9148: aa1f03e1     	mov	x1, xzr
    914c: 9111c3e3     	add	x3, sp, #0x470
    9150: 2a0903e7     	mov	w7, w9
    9154: 2a0a03e2     	mov	w2, w10
    9158: 2a0b03f1     	mov	w17, w11
    915c: 2a0c03e4     	mov	w4, w12
    9160: 2a1003f4     	mov	w20, w16
    9164: 2a0f03f5     	mov	w21, w15
    9168: 2a0e03f7     	mov	w23, w14
    916c: 2a0d03f3     	mov	w19, w13
    9170: d503201f     	nop
    9174: 10fbf148     	adr	x8, 0xf9c <K>
    9178: d503201f     	nop
    917c: d503201f     	nop
    9180: 2a1303e0     	mov	w0, w19
    9184: b8616913     	ldr	w19, [x8, x1]
    9188: 2a1703e5     	mov	w5, w23
    918c: b8616877     	ldr	w23, [x3, x1]
    9190: 2a1503e6     	mov	w6, w21
    9194: 0a050015     	and	w21, w0, w5
    9198: 0a2000d8     	bic	w24, w6, w0
    919c: 2a150315     	orr	w21, w24, w21
    91a0: 13801818     	ror	w24, w0, #0x6
    91a4: 4ac02f18     	eor	w24, w24, w0, ror #11
    91a8: 0b150294     	add	w20, w20, w21
    91ac: 4ac06715     	eor	w21, w24, w0, ror #25
    91b0: 0b170294     	add	w20, w20, w23
    91b4: 0b140273     	add	w19, w19, w20
    91b8: 0b150274     	add	w20, w19, w21
    91bc: 0b040293     	add	w19, w20, w4
    91c0: 2a1103e4     	mov	w4, w17
    91c4: 2a0203f1     	mov	w17, w2
    91c8: 2a0703e2     	mov	w2, w7
    91cc: 138708e7     	ror	w7, w7, #0x2
    91d0: 4ac234e7     	eor	w7, w7, w2, ror #13
    91d4: 4a110095     	eor	w21, w4, w17
    91d8: 0a110097     	and	w23, w4, w17
    91dc: 0a0202b5     	and	w21, w21, w2
    91e0: 4ac258e7     	eor	w7, w7, w2, ror #22
    91e4: 91001021     	add	x1, x1, #0x4
    91e8: 4a1702b5     	eor	w21, w21, w23
    91ec: f104003f     	cmp	x1, #0x100
    91f0: 0b0702a7     	add	w7, w21, w7
    91f4: 0b1400e7     	add	w7, w7, w20
    91f8: 2a0603f4     	mov	w20, w6
    91fc: 2a0503f5     	mov	w21, w5
    9200: 2a0003f7     	mov	w23, w0
    9204: 54fffbe1     	b.ne	0x9180 <b_m_selftest+0x300>
    9208: aa1f03e1     	mov	x1, xzr
    920c: 0b0900e9     	add	w9, w7, w9
    9210: 0b0a004a     	add	w10, w2, w10
    9214: b90473e9     	str	w9, [sp, #0x470]
    9218: b90477ea     	str	w10, [sp, #0x474]
    921c: 0b0b022a     	add	w10, w17, w11
    9220: 0b0c008b     	add	w11, w4, w12
    9224: 0b0d026c     	add	w12, w19, w13
    9228: 0b0e000d     	add	w13, w0, w14
    922c: b9047bea     	str	w10, [sp, #0x478]
    9230: b9047feb     	str	w11, [sp, #0x47c]
    9234: 0b0f00aa     	add	w10, w5, w15
    9238: 0b1000cb     	add	w11, w6, w16
    923c: b90483ec     	str	w12, [sp, #0x480]
    9240: b90487ed     	str	w13, [sp, #0x484]
    9244: b9048bea     	str	w10, [sp, #0x488]
    9248: b9048feb     	str	w11, [sp, #0x48c]
    924c: 52b0000b     	mov	w11, #-0x80000000       // =-2147483648
    9250: f80242df     	stur	xzr, [x22, #0x24]
    9254: f80342df     	stur	xzr, [x22, #0x34]
    9258: f802c2df     	stur	xzr, [x22, #0x2c]
    925c: 5280200c     	mov	w12, #0x100             // =256
    9260: 9111c3ea     	add	x10, sp, #0x470
    9264: b90493eb     	str	w11, [sp, #0x490]
    9268: b904afec     	str	w12, [sp, #0x4ac]
    926c: 8b01014b     	add	x11, x10, x1
    9270: b940256c     	ldr	w12, [x11, #0x24]
    9274: 0b090189     	add	w9, w12, w9
    9278: b940056c     	ldr	w12, [x11, #0x4]
    927c: b940396d     	ldr	w13, [x11, #0x38]
    9280: 138c1d8e     	ror	w14, w12, #0x7
    9284: 138d45af     	ror	w15, w13, #0x11
    9288: 4acc49ce     	eor	w14, w14, w12, ror #18
    928c: 4acd4def     	eor	w15, w15, w13, ror #19
    9290: 4a4c0dce     	eor	w14, w14, w12, lsr #3
    9294: 4a4d29ed     	eor	w13, w15, w13, lsr #10
    9298: 0b0e0129     	add	w9, w9, w14
    929c: 0b0d0129     	add	w9, w9, w13
    92a0: b9004169     	str	w9, [x11, #0x40]
    92a4: 91001021     	add	x1, x1, #0x4
    92a8: f103003f     	cmp	x1, #0xc0
    92ac: 2a0c03e9     	mov	w9, w12
    92b0: 54fffde1     	b.ne	0x926c <b_m_selftest+0x3ec>
    92b4: aa1f03f0     	mov	x16, xzr
    92b8: 5295d0ac     	mov	w12, #0xae85            // =44677
    92bc: 72b76cec     	movk	w12, #0xbb67, lsl #16
    92c0: 529ea74b     	mov	w11, #0xf53a            // =62778
    92c4: 72b4a9eb     	movk	w11, #0xa54f, lsl #16
    92c8: 528d118a     	mov	w10, #0x688c            // =26764
    92cc: 72b360aa     	movk	w10, #0x9b05, lsl #16
    92d0: 529cccf1     	mov	w17, #0xe667            // =58983
    92d4: 72ad4131     	movk	w17, #0x6a09, lsl #16
    92d8: 5299a329     	mov	w9, #0xcd19             // =52505
    92dc: 72ab7c09     	movk	w9, #0x5be0, lsl #16
    92e0: 528a4fed     	mov	w13, #0x527f            // =21119
    92e4: 72aa21cd     	movk	w13, #0x510e, lsl #16
    92e8: 529e6e4f     	mov	w15, #0xf372            // =62322
    92ec: 72a78dcf     	movk	w15, #0x3c6e, lsl #16
    92f0: 529b356e     	mov	w14, #0xd9ab            // =55723
    92f4: 72a3f06e     	movk	w14, #0x1f83, lsl #16
    92f8: 9111c3e4     	add	x4, sp, #0x470
    92fc: 529ccce7     	mov	w7, #0xe667             // =58983
    9300: 72ad4127     	movk	w7, #0x6a09, lsl #16
    9304: 5295d0a2     	mov	w2, #0xae85             // =44677
    9308: 72b76ce2     	movk	w2, #0xbb67, lsl #16
    930c: 529e6e41     	mov	w1, #0xf372             // =62322
    9310: 72a78dc1     	movk	w1, #0x3c6e, lsl #16
    9314: 529ea743     	mov	w3, #0xf53a             // =62778
    9318: 72b4a9e3     	movk	w3, #0xa54f, lsl #16
    931c: 5299a334     	mov	w20, #0xcd19            // =52505
    9320: 72ab7c14     	movk	w20, #0x5be0, lsl #16
    9324: 529b3575     	mov	w21, #0xd9ab            // =55723
    9328: 72a3f075     	movk	w21, #0x1f83, lsl #16
    932c: 528d1196     	mov	w22, #0x688c            // =26764
    9330: 72b360b6     	movk	w22, #0x9b05, lsl #16
    9334: 528a4ff3     	mov	w19, #0x527f            // =21119
    9338: 72aa21d3     	movk	w19, #0x510e, lsl #16
    933c: d503201f     	nop
    9340: 2a1303e0     	mov	w0, w19
    9344: b8706913     	ldr	w19, [x8, x16]
    9348: 2a1603e6     	mov	w6, w22
    934c: b8706896     	ldr	w22, [x4, x16]
    9350: 2a1503e5     	mov	w5, w21
    9354: 0a060015     	and	w21, w0, w6
    9358: 0a2000b7     	bic	w23, w5, w0
    935c: 2a1502f5     	orr	w21, w23, w21
    9360: 13801817     	ror	w23, w0, #0x6
    9364: 4ac02ef7     	eor	w23, w23, w0, ror #11
    9368: 0b150294     	add	w20, w20, w21
    936c: 4ac066f5     	eor	w21, w23, w0, ror #25
    9370: 0b160294     	add	w20, w20, w22
    9374: 0b140273     	add	w19, w19, w20
    9378: 0b150274     	add	w20, w19, w21
    937c: 0b030293     	add	w19, w20, w3
    9380: 2a0103e3     	mov	w3, w1
    9384: 2a0203e1     	mov	w1, w2
    9388: 2a0703e2     	mov	w2, w7
    938c: 138708e7     	ror	w7, w7, #0x2
    9390: 4ac234e7     	eor	w7, w7, w2, ror #13
    9394: 4a010075     	eor	w21, w3, w1
    9398: 0a010076     	and	w22, w3, w1
    939c: 0a0202b5     	and	w21, w21, w2
    93a0: 4ac258e7     	eor	w7, w7, w2, ror #22
    93a4: 91001210     	add	x16, x16, #0x4
    93a8: 4a1602b5     	eor	w21, w21, w22
    93ac: f104021f     	cmp	x16, #0x100
    93b0: 0b0702a7     	add	w7, w21, w7
    93b4: 0b1400e7     	add	w7, w7, w20
    93b8: 2a0503f4     	mov	w20, w5
    93bc: 2a0603f5     	mov	w21, w6
    93c0: 2a0003f6     	mov	w22, w0
    93c4: 54fffbe1     	b.ne	0x9340 <b_m_selftest+0x4c0>
    93c8: 0b1100e8     	add	w8, w7, w17
    93cc: 53187d10     	lsr	w16, w8, #24
    93d0: 3911c3f0     	strb	w16, [sp, #0x470]
    93d4: 53107d10     	lsr	w16, w8, #16
    93d8: 3911c7f0     	strb	w16, [sp, #0x471]
    93dc: 0b0c004c     	add	w12, w2, w12
    93e0: 53087d10     	lsr	w16, w8, #8
    93e4: 3911cbf0     	strb	w16, [sp, #0x472]
    93e8: 0b0f002f     	add	w15, w1, w15
    93ec: 0b0b006b     	add	w11, w3, w11
    93f0: 3911cfe8     	strb	w8, [sp, #0x473]
    93f4: 0b0d0268     	add	w8, w19, w13
    93f8: 53187d8d     	lsr	w13, w12, #24
    93fc: 3911d3ed     	strb	w13, [sp, #0x474]
    9400: 0b0a000a     	add	w10, w0, w10
    9404: 53107d8d     	lsr	w13, w12, #16
    9408: 3911d7ed     	strb	w13, [sp, #0x475]
    940c: 0b0e00cd     	add	w13, w6, w14
    9410: 53087d8e     	lsr	w14, w12, #8
    9414: 3911dbee     	strb	w14, [sp, #0x476]
    9418: 0b0900a9     	add	w9, w5, w9
    941c: 3911dfec     	strb	w12, [sp, #0x477]
    9420: 53187dec     	lsr	w12, w15, #24
    9424: 3911e3ec     	strb	w12, [sp, #0x478]
    9428: 53107dec     	lsr	w12, w15, #16
    942c: 3911e7ec     	strb	w12, [sp, #0x479]
    9430: 53087dec     	lsr	w12, w15, #8
    9434: 3911ebec     	strb	w12, [sp, #0x47a]
    9438: 3911efef     	strb	w15, [sp, #0x47b]
    943c: 53187d6c     	lsr	w12, w11, #24
    9440: 3911f3ec     	strb	w12, [sp, #0x47c]
    9444: 53107d6c     	lsr	w12, w11, #16
    9448: 3911f7ec     	strb	w12, [sp, #0x47d]
    944c: 53087d6c     	lsr	w12, w11, #8
    9450: 3911fbec     	strb	w12, [sp, #0x47e]
    9454: 3911ffeb     	strb	w11, [sp, #0x47f]
    9458: 53187d0b     	lsr	w11, w8, #24
    945c: 391203eb     	strb	w11, [sp, #0x480]
    9460: 53107d0b     	lsr	w11, w8, #16
    9464: 391207eb     	strb	w11, [sp, #0x481]
    9468: 53087d0b     	lsr	w11, w8, #8
    946c: 39120beb     	strb	w11, [sp, #0x482]
    9470: 39120fe8     	strb	w8, [sp, #0x483]
    9474: 53187d48     	lsr	w8, w10, #24
    9478: 391213e8     	strb	w8, [sp, #0x484]
    947c: 53107d48     	lsr	w8, w10, #16
    9480: 391217e8     	strb	w8, [sp, #0x485]
    9484: 53087d48     	lsr	w8, w10, #8
    9488: 39121be8     	strb	w8, [sp, #0x486]
    948c: 39121fea     	strb	w10, [sp, #0x487]
    9490: 53187da8     	lsr	w8, w13, #24
    9494: 391223e8     	strb	w8, [sp, #0x488]
    9498: 53107da8     	lsr	w8, w13, #16
    949c: 391227e8     	strb	w8, [sp, #0x489]
    94a0: 53087da8     	lsr	w8, w13, #8
    94a4: 39122be8     	strb	w8, [sp, #0x48a]
    94a8: 39122fed     	strb	w13, [sp, #0x48b]
    94ac: 53187d28     	lsr	w8, w9, #24
    94b0: 391233e8     	strb	w8, [sp, #0x48c]
    94b4: 53107d28     	lsr	w8, w9, #16
    94b8: 391237e8     	strb	w8, [sp, #0x48d]
    94bc: 53087d28     	lsr	w8, w9, #8
    94c0: 39123be8     	strb	w8, [sp, #0x48e]
    94c4: 39123fe9     	strb	w9, [sp, #0x48f]
    94c8: 9111c3f3     	add	x19, sp, #0x470
    94cc: 9111c3e0     	add	x0, sp, #0x470
    94d0: 911143e1     	add	x1, sp, #0x450
    94d4: 97fff347     	bl	0x61f0 <le_target>
    94d8: 34003a80     	cbz	w0, 0x9c28 <b_m_selftest+0xda8>
    94dc: aa1f03f8     	mov	x24, xzr
    94e0: 910903e8     	add	x8, sp, #0x240
    94e4: 91010108     	add	x8, x8, #0x40
    94e8: f9003fe8     	str	x8, [sp, #0x78]
    94ec: 9100a273     	add	x19, x19, #0x28
    94f0: ad5b83e1     	ldp	q1, q0, [sp, #0x370]
    94f4: ad0887e0     	stp	q0, q1, [sp, #0x110]
    94f8: 52800817     	mov	w23, #0x40              // =64
    94fc: d503201f     	nop
    9500: ad4587e0     	ldp	q0, q1, [sp, #0xb0]
    9504: ad1203e1     	stp	q1, q0, [sp, #0x240]
    9508: ad4487e0     	ldp	q0, q1, [sp, #0x90]
    950c: ad1303e1     	stp	q1, q0, [sp, #0x260]
    9510: d503201f     	nop
    9514: 10fbd2a8     	adr	x8, 0xf68 <b_m_selftest.test_nonces>
    9518: b8787919     	ldr	w25, [x8, x24, lsl #2]
    951c: fd0143e8     	str	d8, [sp, #0x280]
    9520: 3dc023e0     	ldr	q0, [sp, #0x80]
    9524: bd028be0     	str	s0, [sp, #0x288]
    9528: 390a33f9     	strb	w25, [sp, #0x28c]
    952c: 53087f28     	lsr	w8, w25, #8
    9530: 390a37e8     	strb	w8, [sp, #0x28d]
    9534: 53107f28     	lsr	w8, w25, #16
    9538: ad5e03e1     	ldp	q1, q0, [sp, #0x3c0]
    953c: 3d8137e0     	str	q0, [sp, #0x4d0]
    9540: 390a3be8     	strb	w8, [sp, #0x28e]
    9544: 3dc0efe0     	ldr	q0, [sp, #0x3b0]
    9548: 3d812fe0     	str	q0, [sp, #0x4b0]
    954c: 3d8133e1     	str	q1, [sp, #0x4c0]
    9550: 53187f28     	lsr	w8, w25, #24
    9554: ad5b87e0     	ldp	q0, q1, [sp, #0x370]
    9558: 3d811fe0     	str	q0, [sp, #0x470]
    955c: 3d8123e1     	str	q1, [sp, #0x480]
    9560: 390a3fe8     	strb	w8, [sp, #0x28f]
    9564: ad5c83e1     	ldp	q1, q0, [sp, #0x390]
    9568: f9426fe8     	ldr	x8, [sp, #0x4d8]
    956c: 52800214     	mov	w20, #0x10              // =16
    9570: f9403ff5     	ldr	x21, [sp, #0x78]
    9574: 3d812be0     	str	q0, [sp, #0x4a0]
    9578: 3d8127e1     	str	q1, [sp, #0x490]
    957c: 14000004     	b	0x958c <b_m_selftest+0x70c>
    9580: 8b1602b5     	add	x21, x21, x22
    9584: cb160294     	sub	x20, x20, x22
    9588: b40002d4     	cbz	x20, 0x95e0 <b_m_selftest+0x760>
    958c: cb0802e9     	sub	x9, x23, x8
    9590: eb14013f     	cmp	x9, x20
    9594: 9a943136     	csel	x22, x9, x20, lo
    9598: 8b080260     	add	x0, x19, x8
    959c: aa1503e1     	mov	x1, x21
    95a0: aa1603e2     	mov	x2, x22
    95a4: 94000453     	bl	0xa6f0 <memcpy@plt>
    95a8: f9426fe8     	ldr	x8, [sp, #0x4d8]
    95ac: f9424be9     	ldr	x9, [sp, #0x490]
    95b0: 8b160108     	add	x8, x8, x22
    95b4: 8b160d29     	add	x9, x9, x22, lsl #3
    95b8: f9026fe8     	str	x8, [sp, #0x4d8]
    95bc: f9024be9     	str	x9, [sp, #0x490]
    95c0: f101011f     	cmp	x8, #0x40
    95c4: 54fffde1     	b.ne	0x9580 <b_m_selftest+0x700>
    95c8: 9111c3e0     	add	x0, sp, #0x470
    95cc: aa1303e1     	mov	x1, x19
    95d0: 97fff214     	bl	0x5e20 <transform>
    95d4: aa1f03e8     	mov	x8, xzr
    95d8: f9026fff     	str	xzr, [sp, #0x4d8]
    95dc: 17ffffe9     	b	0x9580 <b_m_selftest+0x700>
    95e0: 9111c3e0     	add	x0, sp, #0x470
    95e4: 910883e1     	add	x1, sp, #0x220
    95e8: 97fff28e     	bl	0x6020 <final>
    95ec: ad5107e0     	ldp	q0, q1, [sp, #0x220]
    95f0: ad468fe2     	ldp	q2, q3, [sp, #0xd0]
    95f4: ad098be3     	stp	q3, q2, [sp, #0x130]
    95f8: 9104c3e8     	add	x8, sp, #0x130
    95fc: 3c828100     	stur	q0, [x8, #0x28]
    9600: 52800409     	mov	w9, #0x20               // =32
    9604: f900cfe9     	str	x9, [sp, #0x198]
    9608: 52802009     	mov	w9, #0x100              // =256
    960c: f900abe9     	str	x9, [sp, #0x150]
    9610: 3c838101     	stur	q1, [x8, #0x38]
    9614: 9104c3e0     	add	x0, sp, #0x130
    9618: 910883e1     	add	x1, sp, #0x220
    961c: 97fff281     	bl	0x6020 <final>
    9620: 910883e0     	add	x0, sp, #0x220
    9624: ad4883e1     	ldp	q1, q0, [sp, #0x110]
    9628: 2a1903e1     	mov	w1, w25
    962c: 94000299     	bl	0xa090 <hash_nonce_arm_words>
    9630: 34002fc0     	cbz	w0, 0x9c28 <b_m_selftest+0xda8>
    9634: b9059ff9     	str	w25, [sp, #0x59c]
    9638: f9007ff8     	str	x24, [sp, #0xf8]
    963c: 394883e9     	ldrb	w9, [sp, #0x220]
    9640: 390873e9     	strb	w9, [sp, #0x21c]
    9644: 394887e8     	ldrb	w8, [sp, #0x221]
    9648: b9059be8     	str	w8, [sp, #0x598]
    964c: 390863e8     	strb	w8, [sp, #0x218]
    9650: 39488be8     	ldrb	w8, [sp, #0x222]
    9654: b9010fe8     	str	w8, [sp, #0x10c]
    9658: 390853e8     	strb	w8, [sp, #0x214]
    965c: 39488fe8     	ldrb	w8, [sp, #0x223]
    9660: b9010be8     	str	w8, [sp, #0x108]
    9664: 390843e8     	strb	w8, [sp, #0x210]
    9668: 394893ec     	ldrb	w12, [sp, #0x224]
    966c: 390833ec     	strb	w12, [sp, #0x20c]
    9670: 394897ed     	ldrb	w13, [sp, #0x225]
    9674: 390823ed     	strb	w13, [sp, #0x208]
    9678: 39489bf7     	ldrb	w23, [sp, #0x226]
    967c: 390813f7     	strb	w23, [sp, #0x204]
    9680: 39489feb     	ldrb	w11, [sp, #0x227]
    9684: 390803eb     	strb	w11, [sp, #0x200]
    9688: 3948a3ea     	ldrb	w10, [sp, #0x228]
    968c: 3907f3ea     	strb	w10, [sp, #0x1fc]
    9690: 3948a7e8     	ldrb	w8, [sp, #0x229]
    9694: 3907e3e8     	strb	w8, [sp, #0x1f8]
    9698: 3948abfe     	ldrb	w30, [sp, #0x22a]
    969c: 3907d3fe     	strb	w30, [sp, #0x1f4]
    96a0: 3948affd     	ldrb	w29, [sp, #0x22b]
    96a4: 3907c3fd     	strb	w29, [sp, #0x1f0]
    96a8: 3948b3fc     	ldrb	w28, [sp, #0x22c]
    96ac: 3907b3fc     	strb	w28, [sp, #0x1ec]
    96b0: 3948b7fb     	ldrb	w27, [sp, #0x22d]
    96b4: 3907a3fb     	strb	w27, [sp, #0x1e8]
    96b8: 3948bbfa     	ldrb	w26, [sp, #0x22e]
    96bc: 390793fa     	strb	w26, [sp, #0x1e4]
    96c0: 3948bff9     	ldrb	w25, [sp, #0x22f]
    96c4: 390783f9     	strb	w25, [sp, #0x1e0]
    96c8: 3948c3f8     	ldrb	w24, [sp, #0x230]
    96cc: 390773f8     	strb	w24, [sp, #0x1dc]
    96d0: 3948c7f6     	ldrb	w22, [sp, #0x231]
    96d4: 390763f6     	strb	w22, [sp, #0x1d8]
    96d8: 3948cbf5     	ldrb	w21, [sp, #0x232]
    96dc: 390753f5     	strb	w21, [sp, #0x1d4]
    96e0: 3948cff4     	ldrb	w20, [sp, #0x233]
    96e4: 390743f4     	strb	w20, [sp, #0x1d0]
    96e8: 3948d3e7     	ldrb	w7, [sp, #0x234]
    96ec: 390733e7     	strb	w7, [sp, #0x1cc]
    96f0: 3948d7e6     	ldrb	w6, [sp, #0x235]
    96f4: 390723e6     	strb	w6, [sp, #0x1c8]
    96f8: 3948dbe5     	ldrb	w5, [sp, #0x236]
    96fc: 390713e5     	strb	w5, [sp, #0x1c4]
    9700: 3948dfe4     	ldrb	w4, [sp, #0x237]
    9704: 390703e4     	strb	w4, [sp, #0x1c0]
    9708: 3948e3e3     	ldrb	w3, [sp, #0x238]
    970c: 3906f3e3     	strb	w3, [sp, #0x1bc]
    9710: 3948e7e2     	ldrb	w2, [sp, #0x239]
    9714: 3906e3e2     	strb	w2, [sp, #0x1b8]
    9718: 3948ebe1     	ldrb	w1, [sp, #0x23a]
    971c: 3906d3e1     	strb	w1, [sp, #0x1b4]
    9720: 3948efe0     	ldrb	w0, [sp, #0x23b]
    9724: 3906c3e0     	strb	w0, [sp, #0x1b0]
    9728: 3948f3f1     	ldrb	w17, [sp, #0x23c]
    972c: 3906b3f1     	strb	w17, [sp, #0x1ac]
    9730: 3948f7f0     	ldrb	w16, [sp, #0x23d]
    9734: 3906a3f0     	strb	w16, [sp, #0x1a8]
    9738: 3948fbef     	ldrb	w15, [sp, #0x23e]
    973c: 390693ef     	strb	w15, [sp, #0x1a4]
    9740: 3948ffee     	ldrb	w14, [sp, #0x23f]
    9744: 390683ee     	strb	w14, [sp, #0x1a0]
    9748: 340000c9     	cbz	w9, 0x9760 <b_m_selftest+0x8e0>
    974c: 910873ee     	add	x14, sp, #0x21c
    9750: 2a0903ef     	mov	w15, w9
    9754: 14000014     	b	0x97a4 <b_m_selftest+0x924>
    9758: d503201f     	nop
    975c: d503201f     	nop
    9760: b9410fe9     	ldr	w9, [sp, #0x10c]
    9764: b90107fd     	str	w29, [sp, #0x104]
    9768: 290e73fb     	stp	w27, w28, [sp, #0x70]
    976c: 290d6bf9     	stp	w25, w26, [sp, #0x68]
    9770: 290c63f6     	stp	w22, w24, [sp, #0x60]
    9774: 290b57ee     	stp	w14, w21, [sp, #0x58]
    9778: 29051ff4     	stp	w20, w7, [sp, #0x28]
    977c: 290617e6     	stp	w6, w5, [sp, #0x30]
    9780: 29070fe4     	stp	w4, w3, [sp, #0x38]
    9784: 290807e2     	stp	w2, w1, [sp, #0x40]
    9788: 290947e0     	stp	w0, w17, [sp, #0x48]
    978c: 290a3ff0     	stp	w16, w15, [sp, #0x50]
    9790: 52801fee     	mov	w14, #0xff              // =255
    9794: 390873ee     	strb	w14, [sp, #0x21c]
    9798: b9459bef     	ldr	w15, [sp, #0x598]
    979c: 34000aef     	cbz	w15, 0x98f8 <b_m_selftest+0xa78>
    97a0: 910863ee     	add	x14, sp, #0x218
    97a4: 510005e8     	sub	w8, w15, #0x1
    97a8: 390001c8     	strb	w8, [x14]
    97ac: 394873e9     	ldrb	w9, [sp, #0x21c]
    97b0: 394863e8     	ldrb	w8, [sp, #0x218]
    97b4: b9010be8     	str	w8, [sp, #0x108]
    97b8: 394853e8     	ldrb	w8, [sp, #0x214]
    97bc: b90107e8     	str	w8, [sp, #0x104]
    97c0: 394843e8     	ldrb	w8, [sp, #0x210]
    97c4: b9059be8     	str	w8, [sp, #0x598]
    97c8: 394833fb     	ldrb	w27, [sp, #0x20c]
    97cc: 394823f4     	ldrb	w20, [sp, #0x208]
    97d0: 394813fc     	ldrb	w28, [sp, #0x204]
    97d4: 394803fd     	ldrb	w29, [sp, #0x200]
    97d8: 3947f3fa     	ldrb	w26, [sp, #0x1fc]
    97dc: 3947e3f9     	ldrb	w25, [sp, #0x1f8]
    97e0: 3947d3f8     	ldrb	w24, [sp, #0x1f4]
    97e4: 3947c3fe     	ldrb	w30, [sp, #0x1f0]
    97e8: 3947b3f6     	ldrb	w22, [sp, #0x1ec]
    97ec: 3947a3f5     	ldrb	w21, [sp, #0x1e8]
    97f0: 394793e7     	ldrb	w7, [sp, #0x1e4]
    97f4: 394783e6     	ldrb	w6, [sp, #0x1e0]
    97f8: 394773e5     	ldrb	w5, [sp, #0x1dc]
    97fc: 394763e4     	ldrb	w4, [sp, #0x1d8]
    9800: 394753e3     	ldrb	w3, [sp, #0x1d4]
    9804: 394743e2     	ldrb	w2, [sp, #0x1d0]
    9808: 394733e1     	ldrb	w1, [sp, #0x1cc]
    980c: 394723e0     	ldrb	w0, [sp, #0x1c8]
    9810: 394713f1     	ldrb	w17, [sp, #0x1c4]
    9814: 394703f0     	ldrb	w16, [sp, #0x1c0]
    9818: 3946f3ef     	ldrb	w15, [sp, #0x1bc]
    981c: 3946e3ee     	ldrb	w14, [sp, #0x1b8]
    9820: 3946d3ed     	ldrb	w13, [sp, #0x1b4]
    9824: 3946c3ec     	ldrb	w12, [sp, #0x1b0]
    9828: 3946b3eb     	ldrb	w11, [sp, #0x1ac]
    982c: 3946a3ea     	ldrb	w10, [sp, #0x1a8]
    9830: 394693e8     	ldrb	w8, [sp, #0x1a4]
    9834: b9010fe8     	str	w8, [sp, #0x10c]
    9838: 394683e8     	ldrb	w8, [sp, #0x1a0]
    983c: 3915c3e9     	strb	w9, [sp, #0x570]
    9840: b9410be9     	ldr	w9, [sp, #0x108]
    9844: 3915c7e9     	strb	w9, [sp, #0x571]
    9848: b94107e9     	ldr	w9, [sp, #0x104]
    984c: 3915cbe9     	strb	w9, [sp, #0x572]
    9850: b9459be9     	ldr	w9, [sp, #0x598]
    9854: 3915cfe9     	strb	w9, [sp, #0x573]
    9858: 3915d3fb     	strb	w27, [sp, #0x574]
    985c: 3915d7f4     	strb	w20, [sp, #0x575]
    9860: 3915dbfc     	strb	w28, [sp, #0x576]
    9864: 3915dffd     	strb	w29, [sp, #0x577]
    9868: 3915e3fa     	strb	w26, [sp, #0x578]
    986c: 3915e7f9     	strb	w25, [sp, #0x579]
    9870: 3915ebf8     	strb	w24, [sp, #0x57a]
    9874: 3915effe     	strb	w30, [sp, #0x57b]
    9878: 3915f3f6     	strb	w22, [sp, #0x57c]
    987c: 3915f7f5     	strb	w21, [sp, #0x57d]
    9880: 3915fbe7     	strb	w7, [sp, #0x57e]
    9884: 3915ffe6     	strb	w6, [sp, #0x57f]
    9888: 391603e5     	strb	w5, [sp, #0x580]
    988c: 391607e4     	strb	w4, [sp, #0x581]
    9890: 39160be3     	strb	w3, [sp, #0x582]
    9894: 39160fe2     	strb	w2, [sp, #0x583]
    9898: 391613e1     	strb	w1, [sp, #0x584]
    989c: 391617e0     	strb	w0, [sp, #0x585]
    98a0: 39161bf1     	strb	w17, [sp, #0x586]
    98a4: 39161ff0     	strb	w16, [sp, #0x587]
    98a8: 391623ef     	strb	w15, [sp, #0x588]
    98ac: 391627ee     	strb	w14, [sp, #0x589]
    98b0: 39162bed     	strb	w13, [sp, #0x58a]
    98b4: 39162fec     	strb	w12, [sp, #0x58b]
    98b8: 391633eb     	strb	w11, [sp, #0x58c]
    98bc: 391637ea     	strb	w10, [sp, #0x58d]
    98c0: b9410fe9     	ldr	w9, [sp, #0x10c]
    98c4: 39163be9     	strb	w9, [sp, #0x58e]
    98c8: 39163fe8     	strb	w8, [sp, #0x58f]
    98cc: 9115c3e0     	add	x0, sp, #0x570
    98d0: ad4883e1     	ldp	q1, q0, [sp, #0x110]
    98d4: b9459fe1     	ldr	w1, [sp, #0x59c]
    98d8: 940001ee     	bl	0xa090 <hash_nonce_arm_words>
    98dc: 35001a60     	cbnz	w0, 0x9c28 <b_m_selftest+0xda8>
    98e0: f9407ff8     	ldr	x24, [sp, #0xf8]
    98e4: 91000718     	add	x24, x24, #0x1
    98e8: f100171f     	cmp	x24, #0x5
    98ec: 52800817     	mov	w23, #0x40              // =64
    98f0: 54ffe081     	b.ne	0x9500 <b_m_selftest+0x680>
    98f4: 140000d7     	b	0x9c50 <b_m_selftest+0xdd0>
    98f8: 390863ee     	strb	w14, [sp, #0x218]
    98fc: 34000069     	cbz	w9, 0x9908 <b_m_selftest+0xa88>
    9900: 910853ee     	add	x14, sp, #0x214
    9904: 17ffff93     	b	0x9750 <b_m_selftest+0x8d0>
    9908: 390853ee     	strb	w14, [sp, #0x214]
    990c: b9410bef     	ldr	w15, [sp, #0x108]
    9910: 3400006f     	cbz	w15, 0x991c <b_m_selftest+0xa9c>
    9914: 910843ee     	add	x14, sp, #0x210
    9918: 17ffffa3     	b	0x97a4 <b_m_selftest+0x924>
    991c: 390843ee     	strb	w14, [sp, #0x210]
    9920: 3400008c     	cbz	w12, 0x9930 <b_m_selftest+0xab0>
    9924: 910833ee     	add	x14, sp, #0x20c
    9928: 2a0c03ef     	mov	w15, w12
    992c: 17ffff9e     	b	0x97a4 <b_m_selftest+0x924>
    9930: 390833ee     	strb	w14, [sp, #0x20c]
    9934: 3400008d     	cbz	w13, 0x9944 <b_m_selftest+0xac4>
    9938: 910823ee     	add	x14, sp, #0x208
    993c: 2a0d03ef     	mov	w15, w13
    9940: 17ffff99     	b	0x97a4 <b_m_selftest+0x924>
    9944: 390823ee     	strb	w14, [sp, #0x208]
    9948: 34000097     	cbz	w23, 0x9958 <b_m_selftest+0xad8>
    994c: 910813ee     	add	x14, sp, #0x204
    9950: 2a1703ef     	mov	w15, w23
    9954: 17ffff94     	b	0x97a4 <b_m_selftest+0x924>
    9958: 390813ee     	strb	w14, [sp, #0x204]
    995c: 3400008b     	cbz	w11, 0x996c <b_m_selftest+0xaec>
    9960: 910803ee     	add	x14, sp, #0x200
    9964: 2a0b03ef     	mov	w15, w11
    9968: 17ffff8f     	b	0x97a4 <b_m_selftest+0x924>
    996c: 390803ee     	strb	w14, [sp, #0x200]
    9970: 3400008a     	cbz	w10, 0x9980 <b_m_selftest+0xb00>
    9974: 9107f3ee     	add	x14, sp, #0x1fc
    9978: 2a0a03ef     	mov	w15, w10
    997c: 17ffff8a     	b	0x97a4 <b_m_selftest+0x924>
    9980: 3907f3ee     	strb	w14, [sp, #0x1fc]
    9984: 34000088     	cbz	w8, 0x9994 <b_m_selftest+0xb14>
    9988: 9107e3ee     	add	x14, sp, #0x1f8
    998c: 2a0803ef     	mov	w15, w8
    9990: 17ffff85     	b	0x97a4 <b_m_selftest+0x924>
    9994: 52801fe8     	mov	w8, #0xff               // =255
    9998: 3907e3ee     	strb	w14, [sp, #0x1f8]
    999c: 3400009e     	cbz	w30, 0x99ac <b_m_selftest+0xb2c>
    99a0: 9107d3ee     	add	x14, sp, #0x1f4
    99a4: 2a1e03ef     	mov	w15, w30
    99a8: 17ffff7f     	b	0x97a4 <b_m_selftest+0x924>
    99ac: 3907d3e8     	strb	w8, [sp, #0x1f4]
    99b0: b94107e9     	ldr	w9, [sp, #0x104]
    99b4: 34000089     	cbz	w9, 0x99c4 <b_m_selftest+0xb44>
    99b8: 9107c3ee     	add	x14, sp, #0x1f0
    99bc: b94107ef     	ldr	w15, [sp, #0x104]
    99c0: 17ffff79     	b	0x97a4 <b_m_selftest+0x924>
    99c4: 3907c3e8     	strb	w8, [sp, #0x1f0]
    99c8: b94077e9     	ldr	w9, [sp, #0x74]
    99cc: 34000089     	cbz	w9, 0x99dc <b_m_selftest+0xb5c>
    99d0: 9107b3ee     	add	x14, sp, #0x1ec
    99d4: b94077ef     	ldr	w15, [sp, #0x74]
    99d8: 17ffff73     	b	0x97a4 <b_m_selftest+0x924>
    99dc: 3907b3e8     	strb	w8, [sp, #0x1ec]
    99e0: b94073e9     	ldr	w9, [sp, #0x70]
    99e4: 34000089     	cbz	w9, 0x99f4 <b_m_selftest+0xb74>
    99e8: 9107a3ee     	add	x14, sp, #0x1e8
    99ec: b94073ef     	ldr	w15, [sp, #0x70]
    99f0: 17ffff6d     	b	0x97a4 <b_m_selftest+0x924>
    99f4: 3907a3e8     	strb	w8, [sp, #0x1e8]
    99f8: b9406fe9     	ldr	w9, [sp, #0x6c]
    99fc: 34000089     	cbz	w9, 0x9a0c <b_m_selftest+0xb8c>
    9a00: 910793ee     	add	x14, sp, #0x1e4
    9a04: b9406fef     	ldr	w15, [sp, #0x6c]
    9a08: 17ffff67     	b	0x97a4 <b_m_selftest+0x924>
    9a0c: 390793e8     	strb	w8, [sp, #0x1e4]
    9a10: b9406be9     	ldr	w9, [sp, #0x68]
    9a14: 34000089     	cbz	w9, 0x9a24 <b_m_selftest+0xba4>
    9a18: 910783ee     	add	x14, sp, #0x1e0
    9a1c: b9406bef     	ldr	w15, [sp, #0x68]
    9a20: 17ffff61     	b	0x97a4 <b_m_selftest+0x924>
    9a24: 390783e8     	strb	w8, [sp, #0x1e0]
    9a28: b94067e9     	ldr	w9, [sp, #0x64]
    9a2c: 34000089     	cbz	w9, 0x9a3c <b_m_selftest+0xbbc>
    9a30: 910773ee     	add	x14, sp, #0x1dc
    9a34: b94067ef     	ldr	w15, [sp, #0x64]
    9a38: 17ffff5b     	b	0x97a4 <b_m_selftest+0x924>
    9a3c: 390773e8     	strb	w8, [sp, #0x1dc]
    9a40: b94063e9     	ldr	w9, [sp, #0x60]
    9a44: 34000089     	cbz	w9, 0x9a54 <b_m_selftest+0xbd4>
    9a48: 910763ee     	add	x14, sp, #0x1d8
    9a4c: b94063ef     	ldr	w15, [sp, #0x60]
    9a50: 17ffff55     	b	0x97a4 <b_m_selftest+0x924>
    9a54: 390763e8     	strb	w8, [sp, #0x1d8]
    9a58: b9405fe9     	ldr	w9, [sp, #0x5c]
    9a5c: 34000089     	cbz	w9, 0x9a6c <b_m_selftest+0xbec>
    9a60: 910753ee     	add	x14, sp, #0x1d4
    9a64: b9405fef     	ldr	w15, [sp, #0x5c]
    9a68: 17ffff4f     	b	0x97a4 <b_m_selftest+0x924>
    9a6c: 390753e8     	strb	w8, [sp, #0x1d4]
    9a70: b9402be9     	ldr	w9, [sp, #0x28]
    9a74: 34000089     	cbz	w9, 0x9a84 <b_m_selftest+0xc04>
    9a78: 910743ee     	add	x14, sp, #0x1d0
    9a7c: b9402bef     	ldr	w15, [sp, #0x28]
    9a80: 17ffff49     	b	0x97a4 <b_m_selftest+0x924>
    9a84: 390743e8     	strb	w8, [sp, #0x1d0]
    9a88: b9402fe9     	ldr	w9, [sp, #0x2c]
    9a8c: 34000089     	cbz	w9, 0x9a9c <b_m_selftest+0xc1c>
    9a90: 910733ee     	add	x14, sp, #0x1cc
    9a94: b9402fef     	ldr	w15, [sp, #0x2c]
    9a98: 17ffff43     	b	0x97a4 <b_m_selftest+0x924>
    9a9c: 390733e8     	strb	w8, [sp, #0x1cc]
    9aa0: b94033e9     	ldr	w9, [sp, #0x30]
    9aa4: 34000089     	cbz	w9, 0x9ab4 <b_m_selftest+0xc34>
    9aa8: 910723ee     	add	x14, sp, #0x1c8
    9aac: b94033ef     	ldr	w15, [sp, #0x30]
    9ab0: 17ffff3d     	b	0x97a4 <b_m_selftest+0x924>
    9ab4: 390723e8     	strb	w8, [sp, #0x1c8]
    9ab8: b94037e9     	ldr	w9, [sp, #0x34]
    9abc: 34000089     	cbz	w9, 0x9acc <b_m_selftest+0xc4c>
    9ac0: 910713ee     	add	x14, sp, #0x1c4
    9ac4: b94037ef     	ldr	w15, [sp, #0x34]
    9ac8: 17ffff37     	b	0x97a4 <b_m_selftest+0x924>
    9acc: 390713e8     	strb	w8, [sp, #0x1c4]
    9ad0: b9403be9     	ldr	w9, [sp, #0x38]
    9ad4: 34000089     	cbz	w9, 0x9ae4 <b_m_selftest+0xc64>
    9ad8: 910703ee     	add	x14, sp, #0x1c0
    9adc: b9403bef     	ldr	w15, [sp, #0x38]
    9ae0: 17ffff31     	b	0x97a4 <b_m_selftest+0x924>
    9ae4: 390703e8     	strb	w8, [sp, #0x1c0]
    9ae8: b9403fe9     	ldr	w9, [sp, #0x3c]
    9aec: 34000089     	cbz	w9, 0x9afc <b_m_selftest+0xc7c>
    9af0: 9106f3ee     	add	x14, sp, #0x1bc
    9af4: b9403fef     	ldr	w15, [sp, #0x3c]
    9af8: 17ffff2b     	b	0x97a4 <b_m_selftest+0x924>
    9afc: 3906f3e8     	strb	w8, [sp, #0x1bc]
    9b00: b94043e9     	ldr	w9, [sp, #0x40]
    9b04: 34000089     	cbz	w9, 0x9b14 <b_m_selftest+0xc94>
    9b08: 9106e3ee     	add	x14, sp, #0x1b8
    9b0c: b94043ef     	ldr	w15, [sp, #0x40]
    9b10: 17ffff25     	b	0x97a4 <b_m_selftest+0x924>
    9b14: 3906e3e8     	strb	w8, [sp, #0x1b8]
    9b18: b94047e9     	ldr	w9, [sp, #0x44]
    9b1c: 34000089     	cbz	w9, 0x9b2c <b_m_selftest+0xcac>
    9b20: 9106d3ee     	add	x14, sp, #0x1b4
    9b24: b94047ef     	ldr	w15, [sp, #0x44]
    9b28: 17ffff1f     	b	0x97a4 <b_m_selftest+0x924>
    9b2c: 3906d3e8     	strb	w8, [sp, #0x1b4]
    9b30: b9404be9     	ldr	w9, [sp, #0x48]
    9b34: 34000089     	cbz	w9, 0x9b44 <b_m_selftest+0xcc4>
    9b38: b9404bef     	ldr	w15, [sp, #0x48]
    9b3c: 9106c3ee     	add	x14, sp, #0x1b0
    9b40: 17ffff19     	b	0x97a4 <b_m_selftest+0x924>
    9b44: 3906c3e8     	strb	w8, [sp, #0x1b0]
    9b48: b9404fe9     	ldr	w9, [sp, #0x4c]
    9b4c: 34000089     	cbz	w9, 0x9b5c <b_m_selftest+0xcdc>
    9b50: 9106b3ee     	add	x14, sp, #0x1ac
    9b54: b9404fef     	ldr	w15, [sp, #0x4c]
    9b58: 17ffff13     	b	0x97a4 <b_m_selftest+0x924>
    9b5c: 3906b3e8     	strb	w8, [sp, #0x1ac]
    9b60: b94053e9     	ldr	w9, [sp, #0x50]
    9b64: 34000089     	cbz	w9, 0x9b74 <b_m_selftest+0xcf4>
    9b68: 9106a3ee     	add	x14, sp, #0x1a8
    9b6c: b94053ef     	ldr	w15, [sp, #0x50]
    9b70: 17ffff0d     	b	0x97a4 <b_m_selftest+0x924>
    9b74: 3906a3e8     	strb	w8, [sp, #0x1a8]
    9b78: b94057e8     	ldr	w8, [sp, #0x54]
    9b7c: 34000088     	cbz	w8, 0x9b8c <b_m_selftest+0xd0c>
    9b80: 910693ee     	add	x14, sp, #0x1a4
    9b84: b94057ef     	ldr	w15, [sp, #0x54]
    9b88: 17ffff07     	b	0x97a4 <b_m_selftest+0x924>
    9b8c: 52801fe8     	mov	w8, #0xff               // =255
    9b90: 390693e8     	strb	w8, [sp, #0x1a4]
    9b94: b9405be8     	ldr	w8, [sp, #0x58]
    9b98: 34000088     	cbz	w8, 0x9ba8 <b_m_selftest+0xd28>
    9b9c: 910683ee     	add	x14, sp, #0x1a0
    9ba0: b9405bef     	ldr	w15, [sp, #0x58]
    9ba4: 17ffff00     	b	0x97a4 <b_m_selftest+0x924>
    9ba8: 52801fe8     	mov	w8, #0xff               // =255
    9bac: b9010fe8     	str	w8, [sp, #0x10c]
    9bb0: 52801fea     	mov	w10, #0xff              // =255
    9bb4: 52801feb     	mov	w11, #0xff              // =255
    9bb8: 52801fec     	mov	w12, #0xff              // =255
    9bbc: 52801fed     	mov	w13, #0xff              // =255
    9bc0: 52801fef     	mov	w15, #0xff              // =255
    9bc4: 52801ff0     	mov	w16, #0xff              // =255
    9bc8: 52801ff1     	mov	w17, #0xff              // =255
    9bcc: 52801fe0     	mov	w0, #0xff               // =255
    9bd0: 52801fe1     	mov	w1, #0xff               // =255
    9bd4: 52801fe2     	mov	w2, #0xff               // =255
    9bd8: 52801fe3     	mov	w3, #0xff               // =255
    9bdc: 52801fe4     	mov	w4, #0xff               // =255
    9be0: 52801fe5     	mov	w5, #0xff               // =255
    9be4: 52801fe6     	mov	w6, #0xff               // =255
    9be8: 52801fe7     	mov	w7, #0xff               // =255
    9bec: 52801ff5     	mov	w21, #0xff              // =255
    9bf0: 52801ff6     	mov	w22, #0xff              // =255
    9bf4: 52801ffe     	mov	w30, #0xff              // =255
    9bf8: 52801ff8     	mov	w24, #0xff              // =255
    9bfc: 52801ff9     	mov	w25, #0xff              // =255
    9c00: 52801ffa     	mov	w26, #0xff              // =255
    9c04: 52801ffd     	mov	w29, #0xff              // =255
    9c08: 52801ffc     	mov	w28, #0xff              // =255
    9c0c: 52801ff4     	mov	w20, #0xff              // =255
    9c10: 52801ffb     	mov	w27, #0xff              // =255
    9c14: b9059be8     	str	w8, [sp, #0x598]
    9c18: b90107e8     	str	w8, [sp, #0x104]
    9c1c: b9010be8     	str	w8, [sp, #0x108]
    9c20: 52801fe9     	mov	w9, #0xff               // =255
    9c24: 17ffff06     	b	0x983c <b_m_selftest+0x9bc>
    9c28: 52800020     	mov	w0, #0x1                // =1
    9c2c: 911643ff     	add	sp, sp, #0x590
    9c30: a9464ff4     	ldp	x20, x19, [sp, #0x60]
    9c34: a94557f6     	ldp	x22, x21, [sp, #0x50]
    9c38: a9445ff8     	ldp	x24, x23, [sp, #0x40]
    9c3c: a94367fa     	ldp	x26, x25, [sp, #0x30]
    9c40: a9426ffc     	ldp	x28, x27, [sp, #0x20]
    9c44: a9417bfd     	ldp	x29, x30, [sp, #0x10]
    9c48: fc4707e8     	ldr	d8, [sp], #0x70
    9c4c: d65f03c0     	ret
    9c50: ad5b87e0     	ldp	q0, q1, [sp, #0x370]
    9c54: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9c58: 3dc39502     	ldr	q2, [x8, #0xe50]
    9c5c: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9c60: 3dc33d03     	ldr	q3, [x8, #0xcf0]
    9c64: 4ea01c04     	mov	v4.16b, v0.16b
    9c68: 5e034024     	sha256h	q4, q1, v3.4s
    9c6c: 4ea11c30     	mov	v16.16b, v1.16b
    9c70: 5e035010     	sha256h2	q16, q0, v3.4s
    9c74: 3dc007fa     	ldr	q26, [sp, #0x10]
    9c78: 5e28285a     	sha256su0	v26.4s, v2.4s
    9c7c: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9c80: 3dc33516     	ldr	q22, [x8, #0xcd0]
    9c84: 6f00e418     	movi	v24.2d, #0000000000000000
    9c88: 5e16631a     	sha256su1	v26.4s, v24.4s, v22.4s
    9c8c: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9c90: 3dc36103     	ldr	q3, [x8, #0xd80]
    9c94: 4ea41c85     	mov	v5.16b, v4.16b
    9c98: 5e034205     	sha256h	q5, q16, v3.4s
    9c9c: 4ea21c57     	mov	v23.16b, v2.16b
    9ca0: 5e035090     	sha256h2	q16, q4, v3.4s
    9ca4: 5e282b17     	sha256su0	v23.4s, v24.4s
    9ca8: 5e1a62d7     	sha256su1	v23.4s, v22.4s, v26.4s
    9cac: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9cb0: 3dc38103     	ldr	q3, [x8, #0xe00]
    9cb4: 4ea51ca4     	mov	v4.16b, v5.16b
    9cb8: 5e034204     	sha256h	q4, q16, v3.4s
    9cbc: 5e0350b0     	sha256h2	q16, q5, v3.4s
    9cc0: 5e282ad8     	sha256su0	v24.4s, v22.4s
    9cc4: 5e176358     	sha256su1	v24.4s, v26.4s, v23.4s
    9cc8: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9ccc: 3dc36503     	ldr	q3, [x8, #0xd90]
    9cd0: 4ea41c85     	mov	v5.16b, v4.16b
    9cd4: 5e034205     	sha256h	q5, q16, v3.4s
    9cd8: 5e035090     	sha256h2	q16, q4, v3.4s
    9cdc: 5e282b56     	sha256su0	v22.4s, v26.4s
    9ce0: 5e1862f6     	sha256su1	v22.4s, v23.4s, v24.4s
    9ce4: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9ce8: 3dc39903     	ldr	q3, [x8, #0xe60]
    9cec: 4ea38744     	add	v4.4s, v26.4s, v3.4s
    9cf0: 4ea51ca6     	mov	v6.16b, v5.16b
    9cf4: 5e044206     	sha256h	q6, q16, v4.4s
    9cf8: 5e0450b0     	sha256h2	q16, q5, v4.4s
    9cfc: 5e282afa     	sha256su0	v26.4s, v23.4s
    9d00: 5e16631a     	sha256su1	v26.4s, v24.4s, v22.4s
    9d04: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9d08: 3dc3bd04     	ldr	q4, [x8, #0xef0]
    9d0c: 4ea486e5     	add	v5.4s, v23.4s, v4.4s
    9d10: 4ea61cc7     	mov	v7.16b, v6.16b
    9d14: 5e054207     	sha256h	q7, q16, v5.4s
    9d18: 5e0550d0     	sha256h2	q16, q6, v5.4s
    9d1c: 5e282b17     	sha256su0	v23.4s, v24.4s
    9d20: 5e1a62d7     	sha256su1	v23.4s, v22.4s, v26.4s
    9d24: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9d28: 3dc38505     	ldr	q5, [x8, #0xe10]
    9d2c: 4ea58706     	add	v6.4s, v24.4s, v5.4s
    9d30: 4ea71cf1     	mov	v17.16b, v7.16b
    9d34: 5e064211     	sha256h	q17, q16, v6.4s
    9d38: 5e0650f0     	sha256h2	q16, q7, v6.4s
    9d3c: 5e282ad8     	sha256su0	v24.4s, v22.4s
    9d40: 5e176358     	sha256su1	v24.4s, v26.4s, v23.4s
    9d44: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9d48: 3dc38906     	ldr	q6, [x8, #0xe20]
    9d4c: 4ea686c7     	add	v7.4s, v22.4s, v6.4s
    9d50: 4eb11e32     	mov	v18.16b, v17.16b
    9d54: 5e074212     	sha256h	q18, q16, v7.4s
    9d58: 5e075230     	sha256h2	q16, q17, v7.4s
    9d5c: 5e282b56     	sha256su0	v22.4s, v26.4s
    9d60: 5e1862f6     	sha256su1	v22.4s, v23.4s, v24.4s
    9d64: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9d68: 3dc3a907     	ldr	q7, [x8, #0xea0]
    9d6c: 4ea78751     	add	v17.4s, v26.4s, v7.4s
    9d70: 4eb21e53     	mov	v19.16b, v18.16b
    9d74: 5e114213     	sha256h	q19, q16, v17.4s
    9d78: 5e115250     	sha256h2	q16, q18, v17.4s
    9d7c: 5e282afa     	sha256su0	v26.4s, v23.4s
    9d80: 5e16631a     	sha256su1	v26.4s, v24.4s, v22.4s
    9d84: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9d88: 3dc38d11     	ldr	q17, [x8, #0xe30]
    9d8c: 4eb186f2     	add	v18.4s, v23.4s, v17.4s
    9d90: 4eb31e74     	mov	v20.16b, v19.16b
    9d94: 5e124214     	sha256h	q20, q16, v18.4s
    9d98: 5e125270     	sha256h2	q16, q19, v18.4s
    9d9c: 5e282b17     	sha256su0	v23.4s, v24.4s
    9da0: 5e1a62d7     	sha256su1	v23.4s, v22.4s, v26.4s
    9da4: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9da8: 3dc35112     	ldr	q18, [x8, #0xd40]
    9dac: 4eb28713     	add	v19.4s, v24.4s, v18.4s
    9db0: 4eb41e95     	mov	v21.16b, v20.16b
    9db4: 5e134215     	sha256h	q21, q16, v19.4s
    9db8: 5e135290     	sha256h2	q16, q20, v19.4s
    9dbc: 5e282ad8     	sha256su0	v24.4s, v22.4s
    9dc0: 5e176358     	sha256su1	v24.4s, v26.4s, v23.4s
    9dc4: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9dc8: 3dc34913     	ldr	q19, [x8, #0xd20]
    9dcc: 4eb386d4     	add	v20.4s, v22.4s, v19.4s
    9dd0: 4eb51eb9     	mov	v25.16b, v21.16b
    9dd4: 5e144219     	sha256h	q25, q16, v20.4s
    9dd8: 5e1452b0     	sha256h2	q16, q21, v20.4s
    9ddc: 5e282b56     	sha256su0	v22.4s, v26.4s
    9de0: 5e1862f6     	sha256su1	v22.4s, v23.4s, v24.4s
    9de4: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9de8: 3dc36914     	ldr	q20, [x8, #0xda0]
    9dec: 4eb48755     	add	v21.4s, v26.4s, v20.4s
    9df0: 4eb91f3a     	mov	v26.16b, v25.16b
    9df4: 5e15421a     	sha256h	q26, q16, v21.4s
    9df8: 5e155330     	sha256h2	q16, q25, v21.4s
    9dfc: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9e00: 3dc33915     	ldr	q21, [x8, #0xce0]
    9e04: 4eb586f7     	add	v23.4s, v23.4s, v21.4s
    9e08: 4eba1f59     	mov	v25.16b, v26.16b
    9e0c: 5e174219     	sha256h	q25, q16, v23.4s
    9e10: 5e175350     	sha256h2	q16, q26, v23.4s
    9e14: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9e18: 3dc36d17     	ldr	q23, [x8, #0xdb0]
    9e1c: 4eb78718     	add	v24.4s, v24.4s, v23.4s
    9e20: 4eb91f3a     	mov	v26.16b, v25.16b
    9e24: 5e18421a     	sha256h	q26, q16, v24.4s
    9e28: 5e185330     	sha256h2	q16, q25, v24.4s
    9e2c: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9e30: 3dc35518     	ldr	q24, [x8, #0xd50]
    9e34: 4eb886d6     	add	v22.4s, v22.4s, v24.4s
    9e38: 4eba1f59     	mov	v25.16b, v26.16b
    9e3c: 5e164219     	sha256h	q25, q16, v22.4s
    9e40: 5e165350     	sha256h2	q16, q26, v22.4s
    9e44: 4ea0873b     	add	v27.4s, v25.4s, v0.4s
    9e48: 4ea1861a     	add	v26.4s, v16.4s, v1.4s
    9e4c: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9e50: 3dc34110     	ldr	q16, [x8, #0xd00]
    9e54: 4eb0877c     	add	v28.4s, v27.4s, v16.4s
    9e58: 5e282b5b     	sha256su0	v27.4s, v26.4s
    9e5c: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9e60: 3dc39d10     	ldr	q16, [x8, #0xe70]
    9e64: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9e68: 3dc3b116     	ldr	q22, [x8, #0xec0]
    9e6c: 4eb61edd     	mov	v29.16b, v22.16b
    9e70: 5e1c421d     	sha256h	q29, q16, v28.4s
    9e74: 4eb01e19     	mov	v25.16b, v16.16b
    9e78: 5e1c52d9     	sha256h2	q25, q22, v28.4s
    9e7c: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9e80: 3dc3311c     	ldr	q28, [x8, #0xcc0]
    9e84: 5e1c605b     	sha256su1	v27.4s, v2.4s, v28.4s
    9e88: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9e8c: 3dc3291e     	ldr	q30, [x8, #0xca0]
    9e90: 4ebe875e     	add	v30.4s, v26.4s, v30.4s
    9e94: 4ebd1fbf     	mov	v31.16b, v29.16b
    9e98: 5e1e433f     	sha256h	q31, q25, v30.4s
    9e9c: 5e1e53b9     	sha256h2	q25, q29, v30.4s
    9ea0: 5e28285a     	sha256su0	v26.4s, v2.4s
    9ea4: 5e1b639a     	sha256su1	v26.4s, v28.4s, v27.4s
    9ea8: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9eac: 3dc3591d     	ldr	q29, [x8, #0xd60]
    9eb0: 4ebf1ffe     	mov	v30.16b, v31.16b
    9eb4: 5e1d433e     	sha256h	q30, q25, v29.4s
    9eb8: 5e1d53f9     	sha256h2	q25, q31, v29.4s
    9ebc: 5e282b82     	sha256su0	v2.4s, v28.4s
    9ec0: 5e1a6362     	sha256su1	v2.4s, v27.4s, v26.4s
    9ec4: f0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    9ec8: 3dc3911d     	ldr	q29, [x8, #0xe40]
    9ecc: 4ebe1fdf     	mov	v31.16b, v30.16b
    9ed0: 5e1d433f     	sha256h	q31, q25, v29.4s
    9ed4: 5e282b7c     	sha256su0	v28.4s, v27.4s
    9ed8: 5e1d53d9     	sha256h2	q25, q30, v29.4s
    9edc: 5e02635c     	sha256su1	v28.4s, v26.4s, v2.4s
    9ee0: 4ea38763     	add	v3.4s, v27.4s, v3.4s
    9ee4: 4ebf1ffd     	mov	v29.16b, v31.16b
    9ee8: 5e03433d     	sha256h	q29, q25, v3.4s
    9eec: 5e282b5b     	sha256su0	v27.4s, v26.4s
    9ef0: 5e0353f9     	sha256h2	q25, q31, v3.4s
    9ef4: 5e1c605b     	sha256su1	v27.4s, v2.4s, v28.4s
    9ef8: 4ea48743     	add	v3.4s, v26.4s, v4.4s
    9efc: 4ebd1fa4     	mov	v4.16b, v29.16b
    9f00: 5e034324     	sha256h	q4, q25, v3.4s
    9f04: 5e28285a     	sha256su0	v26.4s, v2.4s
    9f08: 5e0353b9     	sha256h2	q25, q29, v3.4s
    9f0c: 5e1b639a     	sha256su1	v26.4s, v28.4s, v27.4s
    9f10: 4ea58443     	add	v3.4s, v2.4s, v5.4s
    9f14: 4ea41c85     	mov	v5.16b, v4.16b
    9f18: 5e034325     	sha256h	q5, q25, v3.4s
    9f1c: 5e282b82     	sha256su0	v2.4s, v28.4s
    9f20: 5e035099     	sha256h2	q25, q4, v3.4s
    9f24: 5e1a6362     	sha256su1	v2.4s, v27.4s, v26.4s
    9f28: 4ea68783     	add	v3.4s, v28.4s, v6.4s
    9f2c: 4ea51ca4     	mov	v4.16b, v5.16b
    9f30: 5e034324     	sha256h	q4, q25, v3.4s
    9f34: 5e282b7c     	sha256su0	v28.4s, v27.4s
    9f38: 5e0350b9     	sha256h2	q25, q5, v3.4s
    9f3c: 5e02635c     	sha256su1	v28.4s, v26.4s, v2.4s
    9f40: 4ea78763     	add	v3.4s, v27.4s, v7.4s
    9f44: 4ea41c85     	mov	v5.16b, v4.16b
    9f48: 5e034325     	sha256h	q5, q25, v3.4s
    9f4c: 5e282b5b     	sha256su0	v27.4s, v26.4s
    9f50: 5e035099     	sha256h2	q25, q4, v3.4s
    9f54: 5e1c605b     	sha256su1	v27.4s, v2.4s, v28.4s
    9f58: 4eb18743     	add	v3.4s, v26.4s, v17.4s
    9f5c: 4ea51ca4     	mov	v4.16b, v5.16b
    9f60: 5e034324     	sha256h	q4, q25, v3.4s
    9f64: 5e28285a     	sha256su0	v26.4s, v2.4s
    9f68: 5e0350b9     	sha256h2	q25, q5, v3.4s
    9f6c: 5e1b639a     	sha256su1	v26.4s, v28.4s, v27.4s
    9f70: 4eb28443     	add	v3.4s, v2.4s, v18.4s
    9f74: 4ea41c85     	mov	v5.16b, v4.16b
    9f78: 5e034325     	sha256h	q5, q25, v3.4s
    9f7c: 5e282b82     	sha256su0	v2.4s, v28.4s
    9f80: 5e035099     	sha256h2	q25, q4, v3.4s
    9f84: 5e1a6362     	sha256su1	v2.4s, v27.4s, v26.4s
    9f88: 4eb38783     	add	v3.4s, v28.4s, v19.4s
    9f8c: 4ea51ca4     	mov	v4.16b, v5.16b
    9f90: 5e034324     	sha256h	q4, q25, v3.4s
    9f94: 5e282b7c     	sha256su0	v28.4s, v27.4s
    9f98: 5e0350b9     	sha256h2	q25, q5, v3.4s
    9f9c: 5e02635c     	sha256su1	v28.4s, v26.4s, v2.4s
    9fa0: 4eb48763     	add	v3.4s, v27.4s, v20.4s
    9fa4: 4ea41c85     	mov	v5.16b, v4.16b
    9fa8: 5e034325     	sha256h	q5, q25, v3.4s
    9fac: 5e035099     	sha256h2	q25, q4, v3.4s
    9fb0: 4eb58743     	add	v3.4s, v26.4s, v21.4s
    9fb4: 4ea51ca4     	mov	v4.16b, v5.16b
    9fb8: 5e034324     	sha256h	q4, q25, v3.4s
    9fbc: 5e0350b9     	sha256h2	q25, q5, v3.4s
    9fc0: 4eb78442     	add	v2.4s, v2.4s, v23.4s
    9fc4: 4ea41c83     	mov	v3.16b, v4.16b
    9fc8: 5e024323     	sha256h	q3, q25, v2.4s
    9fcc: 5e025099     	sha256h2	q25, q4, v2.4s
    9fd0: 4eb88782     	add	v2.4s, v28.4s, v24.4s
    9fd4: 4ea31c64     	mov	v4.16b, v3.16b
    9fd8: 5e024324     	sha256h	q4, q25, v2.4s
    9fdc: 5e025079     	sha256h2	q25, q3, v2.4s
    9fe0: 4eb68482     	add	v2.4s, v4.4s, v22.4s
    9fe4: 4eb08723     	add	v3.4s, v25.4s, v16.4s
    9fe8: 6e200842     	rev32	v2.16b, v2.16b
    9fec: 6e200863     	rev32	v3.16b, v3.16b
    9ff0: 3d811fe2     	str	q2, [sp, #0x470]
    9ff4: 3d8123e3     	str	q3, [sp, #0x480]
    9ff8: f9423be8     	ldr	x8, [sp, #0x470]
    9ffc: f9423fe9     	ldr	x9, [sp, #0x478]
    a000: f94243ea     	ldr	x10, [sp, #0x480]
    a004: f94247eb     	ldr	x11, [sp, #0x488]
    a008: d28bd72c     	mov	x12, #0x5eb9            // =24249
    a00c: f2accb4c     	movk	x12, #0x665a, lsl #16
    a010: f2cb840c     	movk	x12, #0x5c20, lsl #32
    a014: f2e8566c     	movk	x12, #0x42b3, lsl #48
    a018: eb0c011f     	cmp	x8, x12
    a01c: d2854f88     	mov	x8, #0x2a7c             // =10876
    a020: f2a816c8     	movk	x8, #0x40b6, lsl #16
    a024: f2df0168     	movk	x8, #0xf80b, lsl #32
    a028: f2ea5768     	movk	x8, #0x52bb, lsl #48
    a02c: fa480120     	ccmp	x9, x8, #0x0, eq
    a030: d293f788     	mov	x8, #0x9fbc             // =40892
    a034: f2b0c188     	movk	x8, #0x860c, lsl #16
    a038: f2c12228     	movk	x8, #0x911, lsl #32
    a03c: f2f0a668     	movk	x8, #0x8533, lsl #48
    a040: fa480140     	ccmp	x10, x8, #0x0, eq
    a044: d287e628     	mov	x8, #0x3f31             // =16177
    a048: f2a5af88     	movk	x8, #0x2d7c, lsl #16
    a04c: f2db0348     	movk	x8, #0xd81a, lsl #32
    a050: f2ef3a08     	movk	x8, #0x79d0, lsl #48
    a054: fa480160     	ccmp	x11, x8, #0x0, eq
    a058: 54000060     	b.eq	0xa064 <b_m_selftest+0x11e4>
    a05c: 52800080     	mov	w0, #0x4                // =4
    a060: 17fffef3     	b	0x9c2c <b_m_selftest+0xdac>
    a064: 911143e0     	add	x0, sp, #0x450
    a068: 528acf01     	mov	w1, #0x5678             // =22136
    a06c: 72a24681     	movk	w1, #0x1234, lsl #16
    a070: 94000008     	bl	0xa090 <hash_nonce_arm_words>
    a074: 7100001f     	cmp	w0, #0x0
    a078: 52800088     	mov	w8, #0x4                // =4
    a07c: 1a9f0100     	csel	w0, w8, wzr, eq
    a080: 17fffeeb     	b	0x9c2c <b_m_selftest+0xdac>
		...

000000000000a090 <hash_nonce_arm_words>:
    a090: 52884868     	mov	w8, #0x4243             // =16963
    a094: 72a80828     	movk	w8, #0x4041, lsl #16
    a098: 4e040d15     	dup	v21.4s, w8
    a09c: 5288c8e8     	mov	w8, #0x4647             // =17991
    a0a0: 72a888a8     	movk	w8, #0x4445, lsl #16
    a0a4: 4e0c1d15     	mov	v21.s[1], w8
    a0a8: 52894968     	mov	w8, #0x4a4b             // =19019
    a0ac: 72a90928     	movk	w8, #0x4849, lsl #16
    a0b0: 4e141d15     	mov	v21.s[2], w8
    a0b4: 5ac00828     	rev	w8, w1
    a0b8: 4e1c1d15     	mov	v21.s[3], w8
    a0bc: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a0c0: 3dc34103     	ldr	q3, [x8, #0xd00]
    a0c4: 4ea386a4     	add	v4.4s, v21.4s, v3.4s
    a0c8: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a0cc: 3dc39502     	ldr	q2, [x8, #0xe50]
    a0d0: 4ea01c05     	mov	v5.16b, v0.16b
    a0d4: 5e044025     	sha256h	q5, q1, v4.4s
    a0d8: 4ea11c30     	mov	v16.16b, v1.16b
    a0dc: 5e045010     	sha256h2	q16, q0, v4.4s
    a0e0: 5e282855     	sha256su0	v21.4s, v2.4s
    a0e4: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a0e8: 3dc33517     	ldr	q23, [x8, #0xcd0]
    a0ec: 6f00e419     	movi	v25.2d, #0000000000000000
    a0f0: 5e176335     	sha256su1	v21.4s, v25.4s, v23.4s
    a0f4: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a0f8: 3dc36104     	ldr	q4, [x8, #0xd80]
    a0fc: 4ea51ca6     	mov	v6.16b, v5.16b
    a100: 5e044206     	sha256h	q6, q16, v4.4s
    a104: 4ea21c58     	mov	v24.16b, v2.16b
    a108: 5e0450b0     	sha256h2	q16, q5, v4.4s
    a10c: 5e282b38     	sha256su0	v24.4s, v25.4s
    a110: 5e1562f8     	sha256su1	v24.4s, v23.4s, v21.4s
    a114: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a118: 3dc38104     	ldr	q4, [x8, #0xe00]
    a11c: 4ea61cc5     	mov	v5.16b, v6.16b
    a120: 5e044205     	sha256h	q5, q16, v4.4s
    a124: 5e0450d0     	sha256h2	q16, q6, v4.4s
    a128: 5e282af9     	sha256su0	v25.4s, v23.4s
    a12c: 5e1862b9     	sha256su1	v25.4s, v21.4s, v24.4s
    a130: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a134: 3dc36504     	ldr	q4, [x8, #0xd90]
    a138: 4ea51ca6     	mov	v6.16b, v5.16b
    a13c: 5e044206     	sha256h	q6, q16, v4.4s
    a140: 5e0450b0     	sha256h2	q16, q5, v4.4s
    a144: 5e282ab7     	sha256su0	v23.4s, v21.4s
    a148: 5e196317     	sha256su1	v23.4s, v24.4s, v25.4s
    a14c: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a150: 3dc39904     	ldr	q4, [x8, #0xe60]
    a154: 4ea486a5     	add	v5.4s, v21.4s, v4.4s
    a158: 4ea61cc7     	mov	v7.16b, v6.16b
    a15c: 5e054207     	sha256h	q7, q16, v5.4s
    a160: 5e0550d0     	sha256h2	q16, q6, v5.4s
    a164: 5e282b15     	sha256su0	v21.4s, v24.4s
    a168: 5e176335     	sha256su1	v21.4s, v25.4s, v23.4s
    a16c: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a170: 3dc3bd05     	ldr	q5, [x8, #0xef0]
    a174: 4ea58706     	add	v6.4s, v24.4s, v5.4s
    a178: 4ea71cf1     	mov	v17.16b, v7.16b
    a17c: 5e064211     	sha256h	q17, q16, v6.4s
    a180: 5e0650f0     	sha256h2	q16, q7, v6.4s
    a184: 5e282b38     	sha256su0	v24.4s, v25.4s
    a188: 5e1562f8     	sha256su1	v24.4s, v23.4s, v21.4s
    a18c: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a190: 3dc38506     	ldr	q6, [x8, #0xe10]
    a194: 4ea68727     	add	v7.4s, v25.4s, v6.4s
    a198: 4eb11e32     	mov	v18.16b, v17.16b
    a19c: 5e074212     	sha256h	q18, q16, v7.4s
    a1a0: 5e075230     	sha256h2	q16, q17, v7.4s
    a1a4: 5e282af9     	sha256su0	v25.4s, v23.4s
    a1a8: 5e1862b9     	sha256su1	v25.4s, v21.4s, v24.4s
    a1ac: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a1b0: 3dc38907     	ldr	q7, [x8, #0xe20]
    a1b4: 4ea786f1     	add	v17.4s, v23.4s, v7.4s
    a1b8: 4eb21e53     	mov	v19.16b, v18.16b
    a1bc: 5e114213     	sha256h	q19, q16, v17.4s
    a1c0: 5e115250     	sha256h2	q16, q18, v17.4s
    a1c4: 5e282ab7     	sha256su0	v23.4s, v21.4s
    a1c8: 5e196317     	sha256su1	v23.4s, v24.4s, v25.4s
    a1cc: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a1d0: 3dc3a911     	ldr	q17, [x8, #0xea0]
    a1d4: 4eb186b2     	add	v18.4s, v21.4s, v17.4s
    a1d8: 4eb31e74     	mov	v20.16b, v19.16b
    a1dc: 5e124214     	sha256h	q20, q16, v18.4s
    a1e0: 5e125270     	sha256h2	q16, q19, v18.4s
    a1e4: 5e282b15     	sha256su0	v21.4s, v24.4s
    a1e8: 5e176335     	sha256su1	v21.4s, v25.4s, v23.4s
    a1ec: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a1f0: 3dc38d12     	ldr	q18, [x8, #0xe30]
    a1f4: 4eb28713     	add	v19.4s, v24.4s, v18.4s
    a1f8: 4eb41e96     	mov	v22.16b, v20.16b
    a1fc: 5e134216     	sha256h	q22, q16, v19.4s
    a200: 5e135290     	sha256h2	q16, q20, v19.4s
    a204: 5e282b38     	sha256su0	v24.4s, v25.4s
    a208: 5e1562f8     	sha256su1	v24.4s, v23.4s, v21.4s
    a20c: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a210: 3dc35113     	ldr	q19, [x8, #0xd40]
    a214: 4eb38734     	add	v20.4s, v25.4s, v19.4s
    a218: 4eb61eda     	mov	v26.16b, v22.16b
    a21c: 5e14421a     	sha256h	q26, q16, v20.4s
    a220: 5e1452d0     	sha256h2	q16, q22, v20.4s
    a224: 5e282af9     	sha256su0	v25.4s, v23.4s
    a228: 5e1862b9     	sha256su1	v25.4s, v21.4s, v24.4s
    a22c: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a230: 3dc34914     	ldr	q20, [x8, #0xd20]
    a234: 4eb486f6     	add	v22.4s, v23.4s, v20.4s
    a238: 4eba1f5b     	mov	v27.16b, v26.16b
    a23c: 5e16421b     	sha256h	q27, q16, v22.4s
    a240: 5e165350     	sha256h2	q16, q26, v22.4s
    a244: 5e282ab7     	sha256su0	v23.4s, v21.4s
    a248: 5e196317     	sha256su1	v23.4s, v24.4s, v25.4s
    a24c: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a250: 3dc36916     	ldr	q22, [x8, #0xda0]
    a254: 4eb686b5     	add	v21.4s, v21.4s, v22.4s
    a258: 4ebb1f7a     	mov	v26.16b, v27.16b
    a25c: 5e15421a     	sha256h	q26, q16, v21.4s
    a260: 5e155370     	sha256h2	q16, q27, v21.4s
    a264: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a268: 3dc33915     	ldr	q21, [x8, #0xce0]
    a26c: 4eb58718     	add	v24.4s, v24.4s, v21.4s
    a270: 4eba1f5b     	mov	v27.16b, v26.16b
    a274: 5e18421b     	sha256h	q27, q16, v24.4s
    a278: 5e185350     	sha256h2	q16, q26, v24.4s
    a27c: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a280: 3dc36d18     	ldr	q24, [x8, #0xdb0]
    a284: 4eb88739     	add	v25.4s, v25.4s, v24.4s
    a288: 4ebb1f7a     	mov	v26.16b, v27.16b
    a28c: 5e19421a     	sha256h	q26, q16, v25.4s
    a290: 5e195370     	sha256h2	q16, q27, v25.4s
    a294: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a298: 3dc35519     	ldr	q25, [x8, #0xd50]
    a29c: 4eb986f7     	add	v23.4s, v23.4s, v25.4s
    a2a0: 4eba1f5b     	mov	v27.16b, v26.16b
    a2a4: 5e17421b     	sha256h	q27, q16, v23.4s
    a2a8: 5e175350     	sha256h2	q16, q26, v23.4s
    a2ac: 4ea0877a     	add	v26.4s, v27.4s, v0.4s
    a2b0: 4ea18610     	add	v16.4s, v16.4s, v1.4s
    a2b4: 4ea38757     	add	v23.4s, v26.4s, v3.4s
    a2b8: 5e282a1a     	sha256su0	v26.4s, v16.4s
    a2bc: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a2c0: 3dc39d03     	ldr	q3, [x8, #0xe70]
    a2c4: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a2c8: 3dc3b100     	ldr	q0, [x8, #0xec0]
    a2cc: 4ea01c1b     	mov	v27.16b, v0.16b
    a2d0: 5e17407b     	sha256h	q27, q3, v23.4s
    a2d4: 4ea31c61     	mov	v1.16b, v3.16b
    a2d8: 5e175001     	sha256h2	q1, q0, v23.4s
    a2dc: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a2e0: 3dc33117     	ldr	q23, [x8, #0xcc0]
    a2e4: 5e17605a     	sha256su1	v26.4s, v2.4s, v23.4s
    a2e8: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a2ec: 3dc3291c     	ldr	q28, [x8, #0xca0]
    a2f0: 4ebc861c     	add	v28.4s, v16.4s, v28.4s
    a2f4: 4ebb1f7d     	mov	v29.16b, v27.16b
    a2f8: 5e1c403d     	sha256h	q29, q1, v28.4s
    a2fc: 5e1c5361     	sha256h2	q1, q27, v28.4s
    a300: 5e282850     	sha256su0	v16.4s, v2.4s
    a304: 5e1a62f0     	sha256su1	v16.4s, v23.4s, v26.4s
    a308: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a30c: 3dc3591b     	ldr	q27, [x8, #0xd60]
    a310: 4ebd1fbc     	mov	v28.16b, v29.16b
    a314: 5e1b403c     	sha256h	q28, q1, v27.4s
    a318: 5e1b53a1     	sha256h2	q1, q29, v27.4s
    a31c: 5e282ae2     	sha256su0	v2.4s, v23.4s
    a320: 5e106342     	sha256su1	v2.4s, v26.4s, v16.4s
    a324: d0ffffa8     	adrp	x8, 0x0 <pthread_mutex_unlock>
    a328: 3dc3911b     	ldr	q27, [x8, #0xe40]
    a32c: 4ebc1f9d     	mov	v29.16b, v28.16b
    a330: 5e1b403d     	sha256h	q29, q1, v27.4s
    a334: 5e282b57     	sha256su0	v23.4s, v26.4s
    a338: 5e1b5381     	sha256h2	q1, q28, v27.4s
    a33c: 5e026217     	sha256su1	v23.4s, v16.4s, v2.4s
    a340: 4ea48744     	add	v4.4s, v26.4s, v4.4s
    a344: 4ebd1fbb     	mov	v27.16b, v29.16b
    a348: 5e04403b     	sha256h	q27, q1, v4.4s
    a34c: 5e282a1a     	sha256su0	v26.4s, v16.4s
    a350: 5e0453a1     	sha256h2	q1, q29, v4.4s
    a354: 5e17605a     	sha256su1	v26.4s, v2.4s, v23.4s
    a358: 4ea58604     	add	v4.4s, v16.4s, v5.4s
    a35c: 4ebb1f65     	mov	v5.16b, v27.16b
    a360: 5e044025     	sha256h	q5, q1, v4.4s
    a364: 5e282850     	sha256su0	v16.4s, v2.4s
    a368: 5e045361     	sha256h2	q1, q27, v4.4s
    a36c: 5e1a62f0     	sha256su1	v16.4s, v23.4s, v26.4s
    a370: 4ea68444     	add	v4.4s, v2.4s, v6.4s
    a374: 4ea51ca6     	mov	v6.16b, v5.16b
    a378: 5e044026     	sha256h	q6, q1, v4.4s
    a37c: 5e282ae2     	sha256su0	v2.4s, v23.4s
    a380: 5e0450a1     	sha256h2	q1, q5, v4.4s
    a384: 5e106342     	sha256su1	v2.4s, v26.4s, v16.4s
    a388: 4ea786e4     	add	v4.4s, v23.4s, v7.4s
    a38c: 4ea61cc5     	mov	v5.16b, v6.16b
    a390: 5e044025     	sha256h	q5, q1, v4.4s
    a394: 5e282b57     	sha256su0	v23.4s, v26.4s
    a398: 5e0450c1     	sha256h2	q1, q6, v4.4s
    a39c: 5e026217     	sha256su1	v23.4s, v16.4s, v2.4s
    a3a0: 4eb18744     	add	v4.4s, v26.4s, v17.4s
    a3a4: 4ea51ca6     	mov	v6.16b, v5.16b
    a3a8: 5e044026     	sha256h	q6, q1, v4.4s
    a3ac: 5e282a1a     	sha256su0	v26.4s, v16.4s
    a3b0: 5e0450a1     	sha256h2	q1, q5, v4.4s
    a3b4: 5e17605a     	sha256su1	v26.4s, v2.4s, v23.4s
    a3b8: 4eb28604     	add	v4.4s, v16.4s, v18.4s
    a3bc: 4ea61cc5     	mov	v5.16b, v6.16b
    a3c0: 5e044025     	sha256h	q5, q1, v4.4s
    a3c4: 5e282850     	sha256su0	v16.4s, v2.4s
    a3c8: 5e0450c1     	sha256h2	q1, q6, v4.4s
    a3cc: 5e1a62f0     	sha256su1	v16.4s, v23.4s, v26.4s
    a3d0: 4eb38444     	add	v4.4s, v2.4s, v19.4s
    a3d4: 4ea51ca6     	mov	v6.16b, v5.16b
    a3d8: 5e044026     	sha256h	q6, q1, v4.4s
    a3dc: 5e282ae2     	sha256su0	v2.4s, v23.4s
    a3e0: 5e0450a1     	sha256h2	q1, q5, v4.4s
    a3e4: 5e106342     	sha256su1	v2.4s, v26.4s, v16.4s
    a3e8: 4eb486e4     	add	v4.4s, v23.4s, v20.4s
    a3ec: 4ea61cc5     	mov	v5.16b, v6.16b
    a3f0: 5e044025     	sha256h	q5, q1, v4.4s
    a3f4: 5e282b57     	sha256su0	v23.4s, v26.4s
    a3f8: 5e0450c1     	sha256h2	q1, q6, v4.4s
    a3fc: 5e026217     	sha256su1	v23.4s, v16.4s, v2.4s
    a400: 4eb68744     	add	v4.4s, v26.4s, v22.4s
    a404: 4ea51ca6     	mov	v6.16b, v5.16b
    a408: 5e044026     	sha256h	q6, q1, v4.4s
    a40c: 5e0450a1     	sha256h2	q1, q5, v4.4s
    a410: 4eb58604     	add	v4.4s, v16.4s, v21.4s
    a414: 4ea61cc5     	mov	v5.16b, v6.16b
    a418: 5e044025     	sha256h	q5, q1, v4.4s
    a41c: 5e0450c1     	sha256h2	q1, q6, v4.4s
    a420: 4eb88444     	add	v4.4s, v2.4s, v24.4s
    a424: 4ea51ca2     	mov	v2.16b, v5.16b
    a428: 5e044022     	sha256h	q2, q1, v4.4s
    a42c: 5e0450a1     	sha256h2	q1, q5, v4.4s
    a430: 4eb986e4     	add	v4.4s, v23.4s, v25.4s
    a434: 4ea11c25     	mov	v5.16b, v1.16b
    a438: 5e045045     	sha256h2	q5, q2, v4.4s
    a43c: 4ea384a3     	add	v3.4s, v5.4s, v3.4s
    a440: 0e1c3c68     	mov	w8, v3.s[3]
    a444: 5ac00908     	rev	w8, w8
    a448: b9401c09     	ldr	w9, [x0, #0x1c]
    a44c: 6b09011f     	cmp	w8, w9
    a450: 54000062     	b.hs	0xa45c <hash_nonce_arm_words+0x3cc>
    a454: 52800020     	mov	w0, #0x1                // =1
    a458: d65f03c0     	ret
    a45c: 54000069     	b.ls	0xa468 <hash_nonce_arm_words+0x3d8>
    a460: 2a1f03e0     	mov	w0, wzr
    a464: d65f03c0     	ret
    a468: 0e143c68     	mov	w8, v3.s[2]
    a46c: 5ac00908     	rev	w8, w8
    a470: b9401809     	ldr	w9, [x0, #0x18]
    a474: 6b09011f     	cmp	w8, w9
    a478: 54000062     	b.hs	0xa484 <hash_nonce_arm_words+0x3f4>
    a47c: 52800020     	mov	w0, #0x1                // =1
    a480: d65f03c0     	ret
    a484: 54000069     	b.ls	0xa490 <hash_nonce_arm_words+0x400>
    a488: 2a1f03e0     	mov	w0, wzr
    a48c: d65f03c0     	ret
    a490: 0e0c3c68     	mov	w8, v3.s[1]
    a494: 5ac00908     	rev	w8, w8
    a498: b9401409     	ldr	w9, [x0, #0x14]
    a49c: 6b09011f     	cmp	w8, w9
    a4a0: 54000062     	b.hs	0xa4ac <hash_nonce_arm_words+0x41c>
    a4a4: 52800020     	mov	w0, #0x1                // =1
    a4a8: d65f03c0     	ret
    a4ac: 54000069     	b.ls	0xa4b8 <hash_nonce_arm_words+0x428>
    a4b0: 2a1f03e0     	mov	w0, wzr
    a4b4: d65f03c0     	ret
    a4b8: 1e260068     	fmov	w8, s3
    a4bc: 5ac00908     	rev	w8, w8
    a4c0: b9401009     	ldr	w9, [x0, #0x10]
    a4c4: 6b09011f     	cmp	w8, w9
    a4c8: 54000062     	b.hs	0xa4d4 <hash_nonce_arm_words+0x444>
    a4cc: 52800020     	mov	w0, #0x1                // =1
    a4d0: d65f03c0     	ret
    a4d4: 54000069     	b.ls	0xa4e0 <hash_nonce_arm_words+0x450>
    a4d8: 2a1f03e0     	mov	w0, wzr
    a4dc: d65f03c0     	ret
    a4e0: 5e044022     	sha256h	q2, q1, v4.4s
    a4e4: 4ea08440     	add	v0.4s, v2.4s, v0.4s
    a4e8: 0e1c3c08     	mov	w8, v0.s[3]
    a4ec: 5ac00908     	rev	w8, w8
    a4f0: b9400c09     	ldr	w9, [x0, #0xc]
    a4f4: 6b09011f     	cmp	w8, w9
    a4f8: 54000062     	b.hs	0xa504 <hash_nonce_arm_words+0x474>
    a4fc: 52800020     	mov	w0, #0x1                // =1
    a500: d65f03c0     	ret
    a504: 54000069     	b.ls	0xa510 <hash_nonce_arm_words+0x480>
    a508: 2a1f03e0     	mov	w0, wzr
    a50c: d65f03c0     	ret
    a510: 0e143c08     	mov	w8, v0.s[2]
    a514: 5ac00908     	rev	w8, w8
    a518: b9400809     	ldr	w9, [x0, #0x8]
    a51c: 6b09011f     	cmp	w8, w9
    a520: 54000062     	b.hs	0xa52c <hash_nonce_arm_words+0x49c>
    a524: 52800020     	mov	w0, #0x1                // =1
    a528: d65f03c0     	ret
    a52c: 54000069     	b.ls	0xa538 <hash_nonce_arm_words+0x4a8>
    a530: 2a1f03e0     	mov	w0, wzr
    a534: d65f03c0     	ret
    a538: 0e0c3c08     	mov	w8, v0.s[1]
    a53c: 5ac00908     	rev	w8, w8
    a540: b9400409     	ldr	w9, [x0, #0x4]
    a544: 6b09011f     	cmp	w8, w9
    a548: 54000062     	b.hs	0xa554 <hash_nonce_arm_words+0x4c4>
    a54c: 52800020     	mov	w0, #0x1                // =1
    a550: d65f03c0     	ret
    a554: 54000069     	b.ls	0xa560 <hash_nonce_arm_words+0x4d0>
    a558: 2a1f03e0     	mov	w0, wzr
    a55c: d65f03c0     	ret
    a560: 1e260008     	fmov	w8, s0
    a564: 5ac00908     	rev	w8, w8
    a568: b9400009     	ldr	w9, [x0]
    a56c: 6b09011f     	cmp	w8, w9
    a570: 54000062     	b.hs	0xa57c <hash_nonce_arm_words+0x4ec>
    a574: 52800020     	mov	w0, #0x1                // =1
    a578: d65f03c0     	ret
    a57c: 1a9f87e0     	cset	w0, ls
    a580: d65f03c0     	ret

Disassembly of section .plt:

000000000000a590 <.plt>:
    a590: a9bf7bf0     	stp	x16, x30, [sp, #-0x10]!
    a594: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a598: f9449211     	ldr	x17, [x16, #0x920]
    a59c: 91248210     	add	x16, x16, #0x920
    a5a0: d61f0220     	br	x17
    a5a4: d503201f     	nop
    a5a8: d503201f     	nop
    a5ac: d503201f     	nop

000000000000a5b0 <__cxa_finalize@plt>:
    a5b0: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a5b4: f9449611     	ldr	x17, [x16, #0x928]
    a5b8: 9124a210     	add	x16, x16, #0x928
    a5bc: d61f0220     	br	x17

000000000000a5c0 <__cxa_atexit@plt>:
    a5c0: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a5c4: f9449a11     	ldr	x17, [x16, #0x930]
    a5c8: 9124c210     	add	x16, x16, #0x930
    a5cc: d61f0220     	br	x17

000000000000a5d0 <__register_atfork@plt>:
    a5d0: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a5d4: f9449e11     	ldr	x17, [x16, #0x938]
    a5d8: 9124e210     	add	x16, x16, #0x938
    a5dc: d61f0220     	br	x17

000000000000a5e0 <b_m_engine_create@plt>:
    a5e0: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a5e4: f944a211     	ldr	x17, [x16, #0x940]
    a5e8: 91250210     	add	x16, x16, #0x940
    a5ec: d61f0220     	br	x17

000000000000a5f0 <b_m_engine_destroy@plt>:
    a5f0: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a5f4: f944a611     	ldr	x17, [x16, #0x948]
    a5f8: 91252210     	add	x16, x16, #0x948
    a5fc: d61f0220     	br	x17

000000000000a600 <pthread_create@plt>:
    a600: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a604: f944aa11     	ldr	x17, [x16, #0x950]
    a608: 91254210     	add	x16, x16, #0x950
    a60c: d61f0220     	br	x17

000000000000a610 <pthread_join@plt>:
    a610: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a614: f944ae11     	ldr	x17, [x16, #0x958]
    a618: 91256210     	add	x16, x16, #0x958
    a61c: d61f0220     	br	x17

000000000000a620 <calloc@plt>:
    a620: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a624: f944b211     	ldr	x17, [x16, #0x960]
    a628: 91258210     	add	x16, x16, #0x960
    a62c: d61f0220     	br	x17

000000000000a630 <pthread_mutex_init@plt>:
    a630: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a634: f944b611     	ldr	x17, [x16, #0x968]
    a638: 9125a210     	add	x16, x16, #0x968
    a63c: d61f0220     	br	x17

000000000000a640 <pthread_cond_init@plt>:
    a640: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a644: f944ba11     	ldr	x17, [x16, #0x970]
    a648: 9125c210     	add	x16, x16, #0x970
    a64c: d61f0220     	br	x17

000000000000a650 <free@plt>:
    a650: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a654: f944be11     	ldr	x17, [x16, #0x978]
    a658: 9125e210     	add	x16, x16, #0x978
    a65c: d61f0220     	br	x17

000000000000a660 <pthread_cond_destroy@plt>:
    a660: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a664: f944c211     	ldr	x17, [x16, #0x980]
    a668: 91260210     	add	x16, x16, #0x980
    a66c: d61f0220     	br	x17

000000000000a670 <pthread_mutex_destroy@plt>:
    a670: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a674: f944c611     	ldr	x17, [x16, #0x988]
    a678: 91262210     	add	x16, x16, #0x988
    a67c: d61f0220     	br	x17

000000000000a680 <nanosleep@plt>:
    a680: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a684: f944ca11     	ldr	x17, [x16, #0x990]
    a688: 91264210     	add	x16, x16, #0x990
    a68c: d61f0220     	br	x17

000000000000a690 <pthread_cond_wait@plt>:
    a690: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a694: f944ce11     	ldr	x17, [x16, #0x998]
    a698: 91266210     	add	x16, x16, #0x998
    a69c: d61f0220     	br	x17

000000000000a6a0 <pthread_mutex_lock@plt>:
    a6a0: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a6a4: f944d211     	ldr	x17, [x16, #0x9a0]
    a6a8: 91268210     	add	x16, x16, #0x9a0
    a6ac: d61f0220     	br	x17

000000000000a6b0 <pthread_cond_broadcast@plt>:
    a6b0: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a6b4: f944d611     	ldr	x17, [x16, #0x9a8]
    a6b8: 9126a210     	add	x16, x16, #0x9a8
    a6bc: d61f0220     	br	x17

000000000000a6c0 <pthread_mutex_unlock@plt>:
    a6c0: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a6c4: f944da11     	ldr	x17, [x16, #0x9b0]
    a6c8: 9126c210     	add	x16, x16, #0x9b0
    a6cc: d61f0220     	br	x17

000000000000a6d0 <__system_property_get@plt>:
    a6d0: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a6d4: f944de11     	ldr	x17, [x16, #0x9b8]
    a6d8: 9126e210     	add	x16, x16, #0x9b8
    a6dc: d61f0220     	br	x17

000000000000a6e0 <getauxval@plt>:
    a6e0: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a6e4: f944e211     	ldr	x17, [x16, #0x9c0]
    a6e8: 91270210     	add	x16, x16, #0x9c0
    a6ec: d61f0220     	br	x17

000000000000a6f0 <memcpy@plt>:
    a6f0: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a6f4: f944e611     	ldr	x17, [x16, #0x9c8]
    a6f8: 91272210     	add	x16, x16, #0x9c8
    a6fc: d61f0220     	br	x17

000000000000a700 <memset@plt>:
    a700: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a704: f944ea11     	ldr	x17, [x16, #0x9d0]
    a708: 91274210     	add	x16, x16, #0x9d0
    a70c: d61f0220     	br	x17

000000000000a710 <__stack_chk_fail@plt>:
    a710: 90000030     	adrp	x16, 0xe000 <__stack_chk_fail@plt+0x38f0>
    a714: f944ee11     	ldr	x17, [x16, #0x9d8]
    a718: 91276210     	add	x16, x16, #0x9d8
    a71c: d61f0220     	br	x17
