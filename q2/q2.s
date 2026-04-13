.section .data
print: .string "%ld "           # format
.section .text
.global main
.extern atoi
.extern printf
.extern exit
main:
addi sp, sp, -48            # sp = sp - 48
sd x1, 40(sp)               # save x1
sd x11, 32(sp)              # save argv
sd x20, 24(sp)              # save x20
sd x21, 16(sp)              # save x21
sd x22, 8(sp)               # save x22
addi x6, x10, -1            # x6 = n
addi sp, sp, -6000          # sp = sp - 6000
addi x20, sp, 0             # x20 = arr
addi x21, sp, 2000          # x21 = result
addi x22, sp, 4000          # x22 = stack
addi x7, x0, -1             # x7 = -1
addi x5, x0, 0              # x5 = 0
read_loop:
beq x5, x6, read_done       # if i == n
ld x11, 6032(sp)            # load argv
addi x9, x5, 1              # x9 = i+1
slli x9, x9, 3              # x9 = (i+1)*8
add x9, x11, x9             # x9 = argv[i+1]
ld x10, 0(x9)               # x10 = string
call atoi                   # atoi
slli x10, x10, 32           # shift left
srai x10, x10, 32           # shift right
slli x9, x5, 3              # x9 = i*8
add x9, x20, x9             # x9 = arr+i
sd x10, 0(x9)               # arr[i] = x10
addi x5, x5, 1              # i = i+1
beq x0, x0, read_loop       # goto read_loop
read_done:
addi x5, x6, -1             # x5 = n-1
loop_i:
blt x5, x0, end             # if i < 0
slli x9, x5, 3              # x9 = i*8
add x9, x20, x9             # x9 = arr+i
ld x8, 0(x9)                # x8 = arr[i]
while:
blt x7, x0, done_while      # if top < 0
slli x9, x7, 3              # x9 = top*8
add x9, x22, x9             # x9 = stack+top
ld x12, 0(x9)               # x12 = index
slli x13, x12, 3            # x13 = index*8
add x13, x20, x13           # x13 = arr+index
ld x13, 0(x13)              # x13 = arr[index]
ble x13, x8, pop            # if <=
beq x0, x0, done_while      # else break
pop:
addi x7, x7, -1             # top = top-1
beq x0, x0, while           # goto while
done_while:
slli x9, x5, 3              # x9 = i*8
add x9, x21, x9             # x9 = result+i
blt x7, x0, no_elem         # if top < 0
slli x12, x7, 3             # x12 = top*8
add x12, x22, x12           # x12 = stack+top
ld x12, 0(x12)              # x12 = stack[top]
sd x12, 0(x9)               # result[i] = x12
beq x0, x0, push            # goto push
no_elem:
addi x12, x0, -1            # x12 = -1
sd x12, 0(x9)               # result[i] = -1
push:
addi x7, x7, 1              # top = top+1
slli x9, x7, 3              # x9 = top*8
add x9, x22, x9             # x9 = stack+top
sd x5, 0(x9)                # stack[top] = i
addi x5, x5, -1             # i = i-1
beq x0, x0, loop_i          # goto loop_i
end:
addi x5, x0, 0              # x5 = 0
print_loop:
beq x5, x6, finish          # if i == n
slli x9, x5, 3              # x9 = i*8
add x9, x21, x9             # x9 = result+i
ld x11, 0(x9)               # x11 = result[i]
la x10, print               # x10 = format
call printf                 # printf
addi x5, x5, 1              # i = i+1
beq x0, x0, print_loop      # goto print_loop
finish:
addi sp, sp, 6000           # sp = sp + 6000
ld x22, 8(sp)               # load x22
ld x21, 16(sp)              # load x21
ld x20, 24(sp)              # load x20
ld x11, 32(sp)              # load x11
ld x1, 40(sp)               # load x1
addi sp, sp, 48             # sp = sp + 48
addi x10, x0, 0             # x10 = 0
call exit                   # exit
