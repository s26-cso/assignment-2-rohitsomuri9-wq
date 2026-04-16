.data
    format_str: .string "%d"
    space: .string " "
.text
.global main
.extern putchar

main:
    addi sp,sp,-56
    sd a0,0(sp)
    sd s1,8(sp)
    sd s2,16(sp)
    sd a1,24(sp)
    sd x1,32(sp)
    sd s0,40(sp)
    sd s3,48(sp)
    mv s0,a0
    addi s0,s0,-1

    li t1,4 
    mul t1,s0,t1
    mv a0,t1
    call malloc
    mv s1,a0

    li t1,4 
    mul t1,s0,t1
    mv a0,t1
    call malloc
    mv s2,a0

    ld a0,0(sp)

    addi t3,x0,0
    addi t4,s1,0
    addi t0,s2,0
    ld t5,24(sp)
    addi t5,t5,8

loop:
    bge t3,s0,start_nge

    li t1,-1
    sw t1,0(t0)
    addi t0,t0,4

    ld t2,0(t5)
    li t6,0
    li a5,0
    mv a2,t2

    lb a3,0(a2)
    li a4,45
    bne a3,a4,convert
    li a5,1
    addi a2,a2,1

convert:
    lb a3,0(a2)
    beq a3,x0,done

    addi a3,a3,-48
    li a4,10
    mul t6,t6,a4
    add t6,t6,a3

    addi a2,a2,1
    j convert

done:
    beq a5,x0,store_val
    neg t6,t6

store_val:
    sw t6,0(t4)

    addi t4,t4,4
    addi t3,t3,1
    addi t5,t5,8
    j loop

start_nge:
    li t1,4
    mul t1,s0,t1
    mv a0,t1
    call malloc
    mv s3,a0

    addi t0,s0,-1
    li t1,0

nge_outer_loop:
    blt t0,x0,print_results

    li t5,4
    mul t5,t5,t0
    add t6,s1,t5
    lw t2,0(t6)

nge_inner_loop:
    beq t1,x0,stack_empty

    addi t5,t1,-1
    slli t5,t5,2
    add t6,s3,t5
    lw t3,0(t6)

    slli t5,t3,2
    add t6,s1,t5
    lw t4,0(t6)

    blt t2,t4,found_nge

    addi t1,t1,-1
    j nge_inner_loop

stack_empty:
    li t4,-1
    j store_nge

found_nge:
    mv t4,t3

store_nge:
    slli t5,t0,2
    add t6,s2,t5
    sw t4,0(t6)

    slli t5,t1,2
    add t6,s3,t5
    sw t0,0(t6)

    addi t1,t1,1
    addi t0,t0,-1
    j nge_outer_loop

print_results:
    li t0,0
    mv s4,s2

print_loop:
    bge t0,s0,print_newline

    la a0,format_str
    lw a1,0(s4)

    addi sp,sp,-8
    sd t0,0(sp)
    call printf
    ld t0,0(sp)
    addi sp,sp,8

    addi t2,t0,1
    bge t2,s0,skip_space

    la a0,space
    addi sp,sp,-8
    sd t0,0(sp)
    call printf
    ld t0,0(sp)
    addi sp,sp,8

skip_space:
    addi s4,s4,4
    addi t0,t0,1
    j print_loop

print_newline:
    li a0,10           # newline char
    call putchar

exit:
    ld a0,0(sp)
    ld s1,8(sp)
    ld s2,16(sp)
    ld a1,24(sp)
    ld x1,32(sp)
    ld s0,40(sp)
    ld s3,48(sp)
    addi sp,sp,56

    li a0,0
    ret
