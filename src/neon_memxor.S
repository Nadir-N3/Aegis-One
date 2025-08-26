.text
.global memxor_neon
.type memxor_neon,%function
// void memxor_neon(uint8_t *dst, const uint8_t *src, unsigned long n)
// x0=dst, x1=src, x2=n
memxor_neon:
    cbz     x2, 3f

1:  cmp     x2, #64
    b.lo    2f

    // Vector path (64-byte chunks)
    ld1     {v0.16b, v1.16b, v2.16b, v3.16b}, [x0]          // load dst
    ld1     {v4.16b, v5.16b, v6.16b, v7.16b}, [x1], #64     // load src
    eor     v0.16b, v0.16b, v4.16b
    eor     v1.16b, v1.16b, v5.16b
    eor     v2.16b, v2.16b, v6.16b
    eor     v3.16b, v3.16b, v7.16b
    st1     {v0.16b, v1.16b, v2.16b, v3.16b}, [x0], #64

    sub     x2, x2, #64
    b       1b

2:  // Tail (bytewise)
    cbz     x2, 3f
4:
    ldrb    w3, [x0]
    ldrb    w4, [x1]
    eor     w3, w3, w4
    strb    w3, [x0], #1
    add     x1, x1, #1
    subs    x2, x2, #1
    b.ne    4b

3:
    ret
.size memxor_neon, .-memxor_neon
