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


.text
main: 
    daddi R1, R0, 31 # index for loop
    daddi R2, R0, 0 # index for the vectors

loop: 
    bne R1 R0 END
    l.d f1, v1(r2)
    l.d f2, v2(r2)
    l.d f3, v3(r2)

    j FORLOOP

FORLOOP:
    mul.d f4, f1, f1  # v1[i]*v1[i], produce f4

    sub.d f8, f5, f1  # v4[i]-v1[i], può essere eseguita perché dipende solo da f5

    sub.d f5, f4, f2  # v4[i] = f4 - f2, produce f5

    div.d f6, f5, f3  # f6 = f5 / v3[i], dipende da f5

    sub.d f7, f6, f2  # v5[i] = f6 - f2, dipende da f6

    mul.d f9, f8, f7  # f9 = f8 * f7, dipende da f8 e f7

STORE:
    s.d f5 v4[R2]
    s.d f7 v5[R2]
    s.d f9 v6[R2]

    daddi R2, R2, 1
    daddi R1, R1, -1
    j loop

END:
    HALT
