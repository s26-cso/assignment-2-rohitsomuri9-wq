.section .data
print: .string "%d "           # format
newline: .string "\n"
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
mv x23, x11                 # x23 is used to store argv
addi x6, x10, -1            # x6 = number of elements (n)
addi sp, sp, -6000          # sp = sp - 6000
addi x20, sp, 0             # x20 = arr
addi x21, sp, 2000          # x21 = result
addi x22, sp, 4000          # x22 = stack
addi x7, x0, -1             # x7 = top = -1
addi x5, x0, 0              # x5 = i = 0
read_loop:
beq x5, x6, read_done       # if i == n
mv x11, x23                 # load argv
addi x9, x5, 1              # x9 = i+1
slli x9, x9, 3              # x9 = (i+1)*8
add x9, x11, x9             # x9 = argv[i+1]
ld x10, 0(x9)               # x10 = string
call atoi                   # convert string to integer
slli x9, x5, 2              # x9 = i*4
add x9, x20, x9             # x9 = arr+i
sw x10, 0(x9)               # arr[i] = x10
addi x5, x5, 1              # i = i+1
beq x0, x0, read_loop       # goto read_loop
read_done:
addi x5, x6, -1             # x5 = n-1
loop_i:
blt x5, x0, end             # if i < 0
slli x9, x5, 2              # x9 = i*4
add x9, x20, x9             # x9 = arr+i
lw x8, 0(x9)                # x8 = arr[i]
while:
blt x7, x0, done_while      # if top < 0
slli x9, x7, 2              # x9 = top*4
add x9, x22, x9             # x9 = stack+top
lw x12, 0(x9)               # x12 = index
slli x13, x12, 2            # x13 = index*4
add x13, x20, x13           # x13 = arr+index
lw x13, 0(x13)              # x13 = arr[index]
ble x13, x8, pop            # if <= pop
beq x0, x0, done_while      # else break
pop:
addi x7, x7, -1             # top = top-1
beq x0, x0, while           # goto while
done_while:
slli x9, x5, 2              # x9 = i*4
add x9, x21, x9             # x9 = result+i
blt x7, x0, no_elem         # if top < 0
slli x12, x7, 2             # x12 = top*4
add x12, x22, x12           # x12 = stack+top
lw x12, 0(x12)              # x12 = stack[top]
sw x12, 0(x9)               # result[i] = x12
beq x0, x0, push            # goto push
no_elem:
addi x12, x0, -1            # x12 = -1
sw x12, 0(x9)               # result[i] = -1
push:
addi x7, x7, 1              # top = top+1
slli x9, x7, 2              # x9 = top*4
add x9, x22, x9             # x9 = stack+top
sw x5, 0(x9)                # stack[top] = i
addi x5, x5, -1             # i = i-1
beq x0, x0, loop_i          # goto loop_i
end:
addi x5, x0, 0              # x5 = 0
print_loop:
beq x5, x6, finish          # if i == n
slli x9, x5, 2              # x9 = i*4
add x9, x21, x9             # x9 = result+i
lw x11, 0(x9)               # x11 = result[i]
la x10, print               # x10 = format
call printf                 # printf
addi x5, x5, 1              # i = i+1
beq x0, x0, print_loop      # goto print_loop
finish:
la x10, newline             # print newline
call printf
addi sp, sp, 6000           # sp = sp + 6000
ld x22, 8(sp)               # load x22
ld x21, 16(sp)              # load x21
ld x20, 24(sp)              # load x20
ld x11, 32(sp)              # load x11
ld x1, 40(sp)               # load x1
addi sp, sp, 48             # sp = sp + 48
addi x10, x0, 0             # x10 = 0
call exit                   # exit 
