 .data
v1:    	.double		8.90, 9.12, 10.23, 11.34, 12.45, 13.56, 14.67, 58.56
		.double		15.78, 16.89, 17.90, 18.12, 19.23, 20.34, 21.45, 59.67
        .double     36.12, 37.23, 38.34, 39.45, 40.56, 41.67, 42.78, 62.90
		.double		43.89, 44.90, 45.12, 46.23, 47.34, 48.45, 49.56, 63.12  

v2:     .double		8.90, 9.12, 10.23, 11.34, 12.45, 13.56, 14.67, 58.56
		.double		15.78, 16.89, 17.90, 18.12, 19.23, 20.34, 21.45, 59.67
        .double     36.12, 37.23, 38.34, 39.45, 40.56, 41.67, 42.78, 62.90
		.double		43.89, 44.90, 45.12, 46.23, 47.34, 48.45, 49.56, 63.12  
   
v3:     .double		8.90, 9.12, 10.23, 11.34, 12.45, 13.56, 14.67, 58.56
		.double		15.78, 16.89, 17.90, 18.12, 19.23, 20.34, 21.45, 59.67
        .double     36.12, 37.23, 38.34, 39.45, 40.56, 41.67, 42.78, 62.90
		.double		43.89, 44.90, 45.12, 46.23, 47.34, 48.45, 49.56, 63.12  
     
v4:     .space 256
v5:     .space 256
v6:     .space 256

a:      .space 8
b:      .double 22.25

m:      .word   1

.text
main: 
    daddi R1, R0, 248   # 1 index for loop
    daddi R2, R0, -8    # 1
    daddi R3, R0, 31
    daddi R4, R0, 3

    ld R7, m(R0)        # load m
    l.d f8, b(R0)

loop: 
    beq R1, R2, END
    l.d f1, v1(R1)
    l.d f2, v2(R1)
    l.d f6, v3(R1)

    ddivu R5, R3, R4
    dmulu R6, R5, R4

    # if
    beq R6, R3, IFCOND  # check se è multiplo di 3

    # else
    j ELSECOND

IFCOND:
    dsllv R7, R7, R3    # shift a sx
    mtc1 R7, f3         # move to a fp reg
    cvt.d.l f3, f3

    div.d f4, f1, f3    # divido
    s.d f4, a(R0)       # salvo in a
    mfc1 R7, f4         # m = int a
    cvt.l.d f4, f4

    j SECONDLOOP

ELSECOND:
    mtc1 R7, f3         # move to a fp reg
    cvt.d.l f3, f3
    mul.d f4, f1, f3
    s.d f4, a(R0)       # salvo in a
    mfc1 R7, f4         # m = int a
    cvt.l.d f4, f4

    j SECONDLOOP

SECONDLOOP:
    mul.d f5, f4, f1
    sub.d f5, f5, f2
    s.d f5, v4(R1)

    div.d f7, f5, f6
    sub.d f7, f7, f8
    s.d f8, v5(R1)

    sub.d f9, f5, f1
    mul.d f9, f9, f8
    s.d f8, v6(R1)

    daddi R1, R1, -8
    daddi R3, R3, -1

    j loop 

END:
    HALT
